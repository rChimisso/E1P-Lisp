# E1P-Lisp 2022

## Description
Simple Lisp library to parse strings into URIs.
#

## Library interface
This library provides 2 functions and a class.

The URI class should be instantiated only through uri-parse to ensure the URI
respects the grammar restraints.  
The class also provides reader functions for each URI part, prefixed with
"uri-" and then the name of the part, for example to get the value of the URI
Scheme, uri-scheme shall be used.

uri-parse, the parser, takes care of parsing any given string and
instantiating the matching URI.

uri-display print out the given URI on any given stream, defaulting to the
standard one when no stream is provided.  
It's important to note that uri-display does NOT check for URI validity.
#

## How to use
It's just necessary to load the file ['uri-parse.lisp'].  
This file will compile and load each internal module of this library.  
After two functions will be available:

- uri-parse takes in input a string to parse and will return a uri-object if
the parsing succeeds, nil otherwise.  
If the string to parse is ambiguous multiple URI objects will be returned.
Special characters in the string will be converted into their respective octets.

- uri-display prints a uri-object into a human friendly way.
An uri-object is also automatically printed using uri-display.
#

## Parsing infos
The parsing is based on a simplified version of [RFC-3986].

It's based on the following case-insensitive productions:
- uri ::=  
	"news" ':' [host]  
	| ("tel" | "fax") ':' [userinfo]  
	| "mailto" ':' [userinfo ['@' host]]  
	| "zos" ':' [authority] ['/' zosPath ['?' query] ['#' fragment]]  
	| ("http" | "https") ':' [authority] ['/' \[path] ['?' query] ['#' fragment]]  
	| scheme ':' [host]  
	| scheme ':' [userinfo ['@' host]]  
	| scheme ':' [authority] ['/' \[path] ['?' query] ['#' fragment]]
- scheme ::= identifier+  
	("news", "tel", "fax", "mailto", "zos", "http" and "https" are excluded)
- authority ::= "//" [userinfo '@'] host [':' port]
- userinfo ::= identifier+
- host ::= hostIdentifier+ ('.' hostIdentifier+)*
- port ::= digit+  
	(Defaults to 80 when not specified)
- path ::= identifier+ ('/' identifier+)*
- zosPath ::= id44 ['(' id8 ')']
- id44 ::= alpha alnum* ('.' alnum+)*  
	(Can be at most 44 characters long)
- id8 ::= alpha alnum*  
	(Can be at most 8 characters long)
- query ::= queryCharacter+
- fragment ::= character+  
#### Where:
- 'character' is any ASCII character between 31 and 127 (both excluded) and
without '\'.
- 'queryCharacter' is as 'character' but without '#'.
- 'hostIdentifier' is as 'queryCharacter' but without  '/', '?', '#', '@',
and ':'.
- 'identifier' is as 'hostIdentifier' but without '.'.
- 'digit' is any ASCII numeric character.
- 'alpha' is any ASCII alphabetic character.
- 'alnum' is any ASCII alphanumeric character.
#

## Mechanisms behind
The whole project uses a custom made utility module ([utils]) to
recognize to which character class a given character belongs to and to convert
values from list of characters to URI values with octets.  
Then a general mechanism to parse was needed, so the class
[gen-machine] was created as an abstraction of almost all the machines.  
After a machine for each URI part was created, inheriting from [gen-machine]
and adding a specialized parse method.  
An exception to this is the Path where two machines were created, [path] and
[zpath], with the latter being specific for the zos Path.  
A couple more machines were needed to combine some of the most basic machines
into more complex ones with the result of the parsing exposed differently.  
Finally with [uri] and [amb] (for ambiguous) machines, the highest level
machines, all the previous machines are combined and the special Scheme
syntaxes are checked. In particular [amb] machine is specialized on ambiguous
strings.  
All of this is used in the library [interface] that exposes the URI class,
uri-parse and uri-display.  
The file [uri-parse] is just a System Definition Facility, Another System
Definition Facility if you will, to compile and load all the library packages
in the right order and all at once.

[RFC-3986]: https://datatracker.ietf.org/doc/html/rfc3986
['uri-parse.lisp']: ./uri-parse.lisp
[utils]: ./utils.lisp
[gen-machine]: ./gen-machine.lisp
[path]: ./path.lisp
[zpath]: ./zpath.lisp
[uri]: ./uri.lisp
[amb]: ./amb.lisp
[interface]: ./interface.lisp
[uri-parse]: ./uri-parse.lisp
