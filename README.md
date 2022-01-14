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
It's just necessary to compile and load the file ['uri-parse.lisp'].  
This file will in turn compile and load each internal module of this library.  
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
#

## Code statistics
Total : 17 files,  708 codes, 31 comments, 29 blanks, all 768 lines

### Languages
| language | files | code | comment | blank | total |
| :--- | ---: | ---: | ---: | ---: | ---: |
| Common Lisp | 16 | 611 | 31 | 16 | 658 |
| Markdown | 1 | 97 | 0 | 13 | 110 |

### Directories
| path | files | code | comment | blank | total |
| :--- | ---: | ---: | ---: | ---: | ---: |
| . | 17 | 708 | 31 | 29 | 768 |

### Files
| filename | language | code | comment | blank | total |
| :--- | :--- | ---: | ---: | ---: | ---: |
| [README.md](/README.md) | Markdown | 97 | 0 | 13 | 110 |
| [amb.lisp](/amb.lisp) | Common Lisp | 38 | 1 | 1 | 40 |
| [authority.lisp](/authority.lisp) | Common Lisp | 48 | 1 | 1 | 50 |
| [fragment.lisp](/fragment.lisp) | Common Lisp | 18 | 1 | 1 | 20 |
| [gen-machine.lisp](/gen-machine.lisp) | Common Lisp | 41 | 1 | 1 | 43 |
| [host.lisp](/host.lisp) | Common Lisp | 21 | 1 | 1 | 23 |
| [interface.lisp](/interface.lisp) | Common Lisp | 103 | 1 | 1 | 105 |
| [mailto.lisp](/mailto.lisp) | Common Lisp | 31 | 1 | 1 | 33 |
| [path.lisp](/path.lisp) | Common Lisp | 23 | 1 | 1 | 25 |
| [port.lisp](/port.lisp) | Common Lisp | 23 | 1 | 1 | 25 |
| [query.lisp](/query.lisp) | Common Lisp | 20 | 1 | 1 | 22 |
| [scheme.lisp](/scheme.lisp) | Common Lisp | 16 | 1 | 1 | 18 |
| [uri-parse.lisp](/uri-parse.lisp) | Common Lisp | 30 | 16 | 1 | 47 |
| [uri.lisp](/uri.lisp) | Common Lisp | 105 | 1 | 1 | 107 |
| [userinfo.lisp](/userinfo.lisp) | Common Lisp | 18 | 1 | 1 | 20 |
| [utils.lisp](/utils.lisp) | Common Lisp | 39 | 1 | 1 | 41 |
| [zpath.lisp](/zpath.lisp) | Common Lisp | 37 | 1 | 1 | 39 |

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
