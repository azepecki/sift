# Language Reference Manual: Sift

## Lexical Conventions

### Tokens
Sift includes five types of tokens: keywords, identifiers, literals, operators, and separators. Separators (blanks, tabs, newlines, and comments) are typically ignored except to separate tokens. 

Separators are defined as follows: 
```
' ' /* This is a single space */
'\t' /* This is a horizontal tab */
'\r' /* This is a carriage return */
'\n' /* This is a newline */
```

Comments begin with `/*` and close with `*/`; they cannot be nested and may not appear within literals. Like whitespaces, comments are ignored. 
```
/* This is an example of a comment */
```

### Identifiers

Identifiers are composed of a sequence of letters, digits, and the `_` punctuation. The first character of any identifier must be in the range [a-z A-Z] (cannot be a digit). Upper and lowercase letters are distinct. Identifiers may not have the same value as a keyword. 

```
/* Below see the regex pattern for valid identifiers */
['a' - 'z'] | ['A' - 'Z'] | ['0' - '9'] | '_'
```

### Keywords

Keywords are identifiers with specific use and meaning within Sift and may not be used except for their intended defined use. 

See list of keywords: 
```
bool
char
int
float
str
sym
if
else
from
import
def
list
return
map
pure
set
arr
dict
for
while
switch
case
break
continue
lambda
```

### Literals
There are several types of literals that may be defined in Sift. 

**int Literal**

An int literal is a sequence of digits from `['0'-'9']+`.

**float Literal**

A float literal includes an int component, a decimal point (`'.'`) a fractional component, and an optional `'E'` with an int exponent. All int and fractional components are digits in `['0'-'9']`. 

Thus a float is defined as `['0'-'9']+['.']['0'-'9']+`

**bool Literal**

A bool literal can hold two possible sequences of characters -- `true` or `false`. 

**char Literal**

A char literal is a single character surrounded by single quotation marks. Special chars are represented with a backslash escape sequence preceding the character. 

A char can be any valid ASCII character. 

**str Literal**

A str literal is a sequence of chars surrounded by double quotes. The valid set includes anything that can be represented as a char literal. 

**sym literal**

A sym literal is a sequence of chars surrounded by double quotes. The valid set includes anything that can be represented as a char literal. 

### Operators

Operators are elements reserved for use by Sift and cannot be used for any purposes other than their reserved purpose. Please refer to the Operators and the Expressions sections for more details. 

**Assignment**: `=`

**Equivalence**: `==, !=, <, >, <=, =>`

**Arithmetic**: `+, -, *, /, %`

**Logical**: `&&, ||, !`

**Special Functionality**: `|`


### Separators

Separators are elements reserved for use by Sift and cannot be used for any purposes other than their reserved purpose. They indicate separation between tokens. As mentioned above, whitespace is also considered a valid separator. 

```
.
,
:
;
(
)
[
]
{
}
```

## Types

### Primitive Data Types

**bool**

bool stores either true or false values

`bool x = true;`

**char**

char stores one character in 8 bits. Signified by single quotation marks. 

`char x = 'a'; `

**int**

int type stores whole number value in 32 bits

`int x = 4;`

**float**

float type stores fractional number value in 32 bits

**str**

str type stores a sequence of chars in UTF-8 format. Signified by double quotation marks. str types are **mutable**. 

`str x = "sift";`

**sym**

sym type stores a sequence of chars in UTF-8 format. Signified by double quotation marks. sym types are **immutable**. 

`sym x = "sift";`

### Non-Primitive Data Types

**arr**

arr type stores a fixed-size array that contains a decalared primitive or non-primitive data type as its elements. 

`arr<int> test = [1, 2, 3];`

**list**

list type stores a doubly-linked list that can change size dynamically. list elements are a declared primitive or non-primitve data type. 

`list<sym> test = ["test1", "test2", "test3"];`

**set**

set type stores an unordered collection of declared primitive or non-primitive elements. A set may not contain duplicate elements. 

`set<int> = (1, 2);`

**dict**

dict type stores a mapping of one declared primitive or non-primitive data-type to any other declared primitive or non-primitive data types. The `key` values of a dict are a set (and therefore may not contain duplicates). 

`dict<str, str> = {"k1": "v1", "k2": "v2"}`


### Type Qualifiers

**pure** 

The `pure` keyword is used to denote that a function is pure (defined as a function that returns the same output type(s) as input type(s) and does not cause any side effects). 

`def pure f1(int x):`

**lambda**

The `lambda` keyword is used to denote an anonymous function. 

`lambda x : x + 1;`

### Type Cast

For safety reasons, Sift does not do any implicit type cast. Explicit type cast is supported using `(type)` in front of the variable that should be cast. 

```
str a = "test";
sym b = (sym) a;
```

## Operators 

## Statements & Expressions

## Garbage Collection 

## NLP Features 

## Grammar