# E1P-Lisp 2022

## Description
Simple Lisp library to parse strings into URIs.
#

## Library interface
This library provides 3 functions: 1 parser and 2 utilities.

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

- uri-parse needs a string to parse and will return a uri-object if the parsing
succeeds, nil otherwise.  
A successfully instantiated uri-object will also expose readers for each URI
part, prefixed with "uri-", e.g. (uri-scheme uri-obj) to print the Scheme of
uri-obj.

- uri-display just print a uri-object into a human friendly way.
An uri-object is also automatically printed using uri-display.
#

## Parsing infos
The parsing is based on a simplified version of [RFC-3986].

It's based on the following case-insensitive productions:
- uri ::=  
	"news" ':' [host]  
	| ("tel" | "fax") ':' [userinfo]  
	| "mailto" ':' [userinfo ['@' host]]  
	| "zos" ':' [authority] ['/' [zosPath] ['?' query] ['#' fragment]]  
	| ("http" | "https") ':' [authority] ['/' [path] ['?' query] ['#' fragment]]  
	| scheme ':' [host]  
	| scheme ':' [userinfo ['@' host]]  
	| scheme ':' [authority] ['/' [path] ['?' query] ['#' fragment]]
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
- 'character' is any ASCII character between 32 and 127 (both excluded) and
without '"', '%', '<', '>', '\', '^', '`'. '{', '|' and '}'.
- 'queryCharacter' is as 'character' but without '#'.
- 'hostIdentifier' is as 'queryCharacter' but without  '/', '?', '#', '@',
and ':'.
- 'identifier' is as 'hostIdentifier' but without '.'.
- 'digit' is any ASCII numeric character.
- 'alpha' is any ASCII alphabetic character.
- 'alnum' is any ASCII alphanumeric character.
#

## Mechanisms behind


[RFC-3986]: https://datatracker.ietf.org/doc/html/rfc3986
['uri-parse.lisp']: ./uri-parse.lisp
[charUtils]: ./charUtils.lisp
