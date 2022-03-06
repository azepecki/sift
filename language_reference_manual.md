# LANGUAGE REFERENCE MANUAL: SIFT

## LEXICAL CONVENTIONS

## TYPES

## Operators 
### Arithmetic Operators
The binary arithmetic operators are `+, -, *, /, % `.
Integer division truncates any fractional part.
The binary `+` and `-` operators have the same precedence, which is lower than the
precedence of `*`,`/`,`%` . Arithmetic operators associate left to right.

### Example Syntax

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
string s = f | g | x
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

## STATEMENTS & EXPRESSIONS

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



## GRAMMAR