# LANGUAGE REFERENCE MANUAL: SIFT

## LEXICAL CONVENTIONS

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
### Arithmetic Operators
The binary arithmetic operators are `+, -, *, /, % `.
Integer division truncates any fractional part.
The binary `+` and `-` operators have the same precedence, which is lower than the
precedence of `*`,`/`,`%` . Arithmetic operators associate left to right.

```
int x = 5 * (16 - 6);
```

### Assignment Operators
The operator `=` assigns an expression to a variable. It assigns value on right of operator to the left.

### Example Syntax

```
int x = 5;
```

### Comaparision Operators
The relational operators are `<`, `<=`, `>`, `>=` . They all have the same precedence. 

### Pipe Operator

There is also a pipe operator much like pipe in ocaml which applies a function to another.

### Example Syntax

```
string x = "hellopeople"
string s = f |> g |> x
```

### Example Syntax

```
bool x = (1 == 1);
```

### Logical Operators
The logical operators are `&&`, `||`, `!`.

### Example Syntax

```
if(x == y || x == z)

if(x == y && x == z)

if(!x)
```

## Statements & Expressions
### Variable Declaration 
In sift, variables are declared by stating their data types followed by variable name and initializer expression. The scope of a variable is its lifetime in the program. 

**Syntax:**

`int x = 5;`

`str client = “David”;`

### Literal expressions
A literal expression is a literal(int,str,sym,..etc) followed by a semicolon. 

**Syntax:**

`"hello,world!";`<br />
`2;`<br />
`2.1;`<br />
`'a';`<br />
`true;`

### List expressions 
A list expression can contain zero "empty" or more values; the values are placed in a comma-separated list inside brackets. The values inside the list should have the same data type. 

**Syntax:**

`list<str> x = [];`<br />
`list<str> x = ["hello", " world "];`<br />
`list<int> x = [1,2,3];`

### Array expressions 
An array expression can contain zero "empty" or more values; the values are placed in a comma-separated list inside brackets. The values inside the list should have the same data type with a fixed size.  

**Syntax:**

`arr<str> x = [];`<br />
`arr<str> x = ["hello", " world "];`<br />
`arr<int> x = [1,2,3];`

### Dictionary expressions
A dictionary expression contains a series of keys and values enclosed in curly brackets. A colon is used to separate the key and value, and a comma is used to separate key and value pairs. Keys cannot be duplicated; the duplicated keys will be overwritten. 

**Syntax:**

```
dict<str, str> x = 
{
"1":“hello”,
"2":“world”
}; 
```
### Set expressions
A set expression is written by enclosing zero or more elements in parentheses; with a comma that separates the elements. 
The elements inside the list should have the same data type, in no particular order. Sets cannot contain duplicate elements. 

**Syntax:**

`set<str> x = ("hello", " world ");`<br />
`set<str> x = ( );`

### Tuple expressions
A tuple expression contains elements from different data types. The tuple can contain zero elements "empty" or many elements.

**Syntax:** 

`tup test = (1,’a’,”abc”)`

### Control flow 
#### Conditions and If Statements:

**If/else**

The **if** statement takes a conditional expression and executes the consequent block - enclosed in curly brackets -  if the expression evaluates to true. The **if** statement can have an optional **else** section that executes its consequent block if the conditional expression evaluates to false. 
The **else if** can add another condition to evaluate; if the conditional expression is true, the consequent block will get executed. And the optional **else** statement will be skipped. If the **else if** conditional expression evaluates to false, then the optional else section get executed. 
The statement in each block must evaluate to the same unit type. 
 
**Syntax:** 
```
if (condition 1)
{
 // block of code to be executed if condition1 is true 
} 
else if (condition2) 
{
  // block of code to be executed if condition1 is false and condition2 is True
} 
else
{
  // block of code to be executed if the condition1 is false and condition2 is false
}
```

**Switch**

To specify many alternatives, we use **switch**. 
**switch** takes an expression inside parentheses, and compares the value of the expression with the values of each case, if there is a match, the associated block of code is executed. If there is no case match, the switch runs the **default** section "if any". 
In **switch**, each **case** keyword is followed by a label/value to be matched to, and a colon followed by a code block to be excuted if the case label matches the expression value. 

**Syntax:** 
```
switch (expression){
case constant1: // statements;
      break;
case constant2:// statements;
      break;
default:
      // default statements;
}
```
#### For loops 
In Sift for loops are used to loop through arrays. A loop takes three statements separated by a semicolon. The first statement is the initialization statement, the second statement is a test expression, and the third statement is an update statement. In each iteration, the test expression is tested; if it's evaluated to true, the consequent block get executed, and the update expression is updated. However, if it's evaluated to false, the for loop is terminated.

**Syntax:** 
```

for (statement1; statement2; statement3)
{
    // statements inside the body of loop
}
```
#### While 

While loop evaluates the conditional value inside the parentheses, if it's evaluated to true, the consequent block gets executed. The conditional value is tested again; if it's evaluated to false the while loop is terminated; otherwise, the consequent block gets executed again. 

```
while (condition) 
{
  // code block to be executed
} 
```

#### Break & Continue

**break** and **continue** expressions are used in loops to alter control flow.
**break** is used to terminate the execution of a block of code. And the **continue** expression terminates the current iteration and cause the next iteration of the loop to run.

#### Function Calls 

In Sift, functions are declared with the keyword **def**. The function should have a name and a consequent block of code to be executed when the function is called.
A function can take zero, one or more arguments and return an expression of a certain type; the retuned type should be declared in the function header. 

**Syntax:**
```
def list<(sym,int)> get_frequencies(list<sym> tokens) {
return ... ; 
}
```
```
def hello() {
print(“Hello World!”);
}
```


## MEMORY MANAGEMENT 

As a text processing language, memory management is critical in Sift. This is why, unlike a language like C, Sift includes automatic memory management as a language feature.
With our automatic memory management, it's faster to develop programs without being bothered about the low-level memory details. 
It also prevents the program from memory leaks and dangling pointers.

Sift uses generational garbage collection for automatic memory management and supports three generation. An object
moves into an older generation whenever it survives a garbage collection process on its current generation.

The garbage collector keeps track of all objects in the memory. When a new object is created, it starts its life in the first generation.
There is a predefined value for the theshold number of objects for each generation. If it exceeds that threshold, the garbage collector triggers
a collection process. For objects that survive this process, they are moved into the older generation.

### Using The Garbage Collector Module

Garbage collection is available to Sift users in the form of an importable module gc with a specific set of functionality.
Programmers can change this default behavior of Garbage collection depending upon their available resources and requirement of their program.

You can check the configured thresholds of your garbage collector with the get_threshold() method:

```
>>> import gc
>>> gc.get_threshold();
(1000, 300, 300)
```

By default, Sift has a threshold of 1000 objects for the first generation and 300 each for the second and third generations.

Check the number of objects in each generation with get_count() method:

```
>>> import gc
>>> gc.get_count();
(572, 222, 109)
```

In the above example, we have 572 objects of first generation, 222 objects of second generation and 109 objects of third generation.

Trigger the garbage collection process manually

```
>>> import gc
>>> gc.get_count();
(572, 222, 109)
>>> gc.collect();
```

User can set thresholds for triggering garbage collection by using the set_threshold() method in the gc module.

```
>>> import gc
>>> gc.get_threshold();
(1000, 300, 300)
>>> gc.set_threshold(2000, 30, 30);
>>> gc.get_threshold();
(2000, 30, 30)
```

Increasing the threshold will reduce the frequency at which the garbage collector runs. This will improve the
performance of your program but at the expense of keeping dead objects around longer.

## REGULAR EXPRESSIONS

For general text processing, Sift provides a module for working with regular expressions. When combined with filtering, pattern matching is a powerful tool
for working with text data. To utilize regular expressions, users must import the ```regex``` module.

```js
>>> import regex;
```

Regular expressions must be contained within a  ```str```, then passed to the methods contained in the ```regex``` module.

### REGULAR EXPRESSION SYNTAX
We utilize the word "string" in this subsection to refer to a sequence of characters. We follow the regex syntax definition layed out by Russ Cox in _Regular Expression Matching Can Be Simple And Fast_: https://swtch.com/~rsc/regexp/regexp1.html

Whenever a string _v_ is in the language defined by some regular expression _e_, we say that _e matches v_. 

The syntax for regular expressions is defined as such:

* The simplest regular expression is a single character. A single-character regular expression matches itself. 
There are meta-characters which do not match themselves: ```*+?()|```. To match a metacharacter, escape it with the backslash character ```\```.
* Two regular expressions may be _alternated_ or _concatenated_ to form a new regular expression: 
if _e<sub>1</sub>_ matches _s_ and _e<sub>2</sub>_ matches _t_, then _e<sub>1</sub>|e<sub>2</sub>_ matches _s_ or _t_, and _e<sub>1</sub>e<sub>2</sub>_ matches _st_. 
*  The metacharacters ```*```, ```+```, and ```?``` are repetition operators: _e*_ matches a sequence of zero or more strings, each of which match _e_; _e+_ matches one or more; _e?_ matches zero or one.

The operator precedence, from weakest to strongest binding: 
1. alternation 
2. concatenation
3. repetition operators 

Explicit parentheses can be used to force different meanings,

### REGULAR EXPRESSION MODULE

There are a few methods provided to match regular expressions with strings:

#### **1. match**

The ```match``` method gets all the substrings in the input ```str``` or ```sym``` that match a given regular expression.a given regular expression. They are returned in a ```list```:

There is a ```str``` variant and a ```sym``` variant:

* **list\<str\> match(str regular_expression, str text)**

```js
>>> import regex;
>>> str expr = "(w|m)i*ld"
>>> str text = "The wiiiiiiiiiild wild cat lived in a mild climate.";
>>> regex.match(expr, text);
["wiiiiiiiiiild", "wild", "mild"]
```

* **list\<sym\> match(str regular_expression, sym text)**

```js
>>> import regex;
>>> str expr = "(w|m)i*ld"
>>> sym text = "The wiiiiiiiiiild wild cat lived in a mild climate.";
>>> regex.match(expr, text);
["wiiiiiiiiiild", "wild", "mild"]
```

#### **2. test**

The ```test``` method checks if a substring exists in the input ```str``` or ```sym``` that matches a given regular expression. Returns a ```bool```.

There is a ```str``` variant and a ```sym``` variant:

* **bool test(str regular_expression, str text)**

```js
>>> import regex;
>>> str expr = "h(i|ello)"
>>> str hello_text = "hello";
>>> regex.test(expr, hello_text);
true
>>> str ello_text = "ello";
>>> regex.test(expr, ello_text);
false
>>> str hi_text = "hihihihihihihi";
>>> regex.test(expr, hi_text);
true
```

* **bool test(str regular_expression, sym text)**

```js
>>> import regex;
>>> str expr = "h(i|ello)"
>>> sym hello_text = "hello";
>>> regex.test(expr, hello_text);
true
>>> sym ello_text = "ello";
>>> regex.test(expr, ello_text);
false
>>> sym hi_text = "hihihihihihihi";
>>> regex.test(expr, hi_text);
true
```

#### **3. match_indices**

The ```match_indices``` method gets all the leading indeces of the substrings in the input ```str``` or ```sym``` that match a given regular expression. They are returned in a ```list```:

There is a ```str``` variant and a ```sym``` variant:

* **list\<int\> match_indices(str regular_expression, str text)**

```js
>>> import regex;
>>> str expr = "(w|m)i*ld"
>>> str text = "The wiiiiiiiiiild wild cat lived in a mild climate.";
>>> regex.match_indices(expr, text);
[4, 18, 38]
```

* **list\<int\> match_indices(str regular_expression, sym text)**

```js
>>> import regex;
>>> str expr = "(w|m)i*ld"
>>> sym text = "The wiiiiiiiiiild wild cat lived in a mild climate.";
>>> regex.match_indices(expr, text);
[4, 18, 38]
```

## NLP FEATURES 

As a text processing language, Sift provides some Natural Language Processing (NLP) functionality to aid in processing natural language text data.
To access nlp functionality, users must import the ```nlp``` module. 

```js
>>> import nlp;
```

The module provides methods for performing nlp tasks.

### TOKENIZATION

Methods are provided for performing tokenization at different levels of natural language.

#### **1. word_tokenize** 

The ```word_tokenize``` method is provided for tokenizing input text at the word level. 

There is a ```str``` variant and a ```sym``` variant:

* **list\<str\> word_tokenize(str text)**

```js
>>> import nlp;
>>> str text = "Hello world! How are we doing today?";
>>> nlp.word_tokenize(text);
["Hello", "world", "!", "How", "are", "we", "doing", "today", "?"]
```

* **list\<sym\> word_tokenize(sym text)**

```js
>>> import nlp;
>>> sym text = "Hello world! How are we doing today?";
>>> nlp.word_tokenize(text);
["Hello", "world", "!", "How", "are", "we", "doing", "today", "?"]
```

#### **2. sent_tokenize** 

The ```sent_tokenize``` method is provided for tokenizing input text at the sentence level. 

There is a ```str``` variant and a ```sym``` variant:

* **list\<str\> sent_tokenize(str text)**

```js
>>> import nlp;
>>> str text = "Hello world! How are we doing today?";
>>> nlp.sent_tokenize(text);
["Hello world!", "How are we doing today?"]
```

* **list\<sym\> sent_tokenize(sym text)**

```js
>>> import nlp;
>>> sym text = "Hello world! How are we doing today?";
>>> nlp.sent_tokenize(text);
["Hello world!", "How are we doing today?"]
```