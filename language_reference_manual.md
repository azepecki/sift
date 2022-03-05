# LANGUAGE REFERENCE MANUAL: SIFT

## Introduction

Sift is a programming language designed to optimize text processing and filtering for natural language processing (NLP) applications. \par
Sift draws inspiration from the elegance of C’s syntax while adding its own unique flair. This imperative language is designed for users with some programming experience as knowledge of C or a similar language will allow users to instantly recognize and understand the basic structure of Sift. However, it is the text-specific processing tools that make Sift stand out as the best language to use for NLP purposes; piping, filtering, and basic tokenization functionality give users the tools they need to seamlessly integrate Sift into their existing or future NLP workflows.

## Lexical Conventions

## Types

## Operators 
### Multiplicative Operators

The multiplicative operators are `*, /, % ` and group from left to right.

#### expression * expression

The binary * operator indicates multiplication. If both operands are int or char, the result is int; if one is
int or char and one float, the former is converted to float, and the result is float; if both
are float, the result is float. No other combinations are allowed.

```
int x = 10;
int y = 8;
int z = x * y;
```

#### expression / expression
The binary / operator indicates division. The same type considerations as for multiplication apply.

```
int x = 10;
int y = 8;
int z = x / y;
```

#### expression % expression
The binary % operator yields the remainder from the division of the first expression by the second. Both operands
must be int or char, and the result is int. In the current implementation, the remainder has the same sign as the
dividend.

```
int x = 10;
int y = 8;
int z = x % y;
```

### Additive Operators

The additive operators + and − group left-to-right.

#### expression + expression

The result is the sum of the expressions. If both operands are int or char, the result is int. If both are float, the result is float. If one is char or int and one is float, the former is converted to
float and the result is float.
No other type combinations are allowed.

```
int x = 10;
int y = 8;
int z = x + y;
```

#### expression - expression
The result is the difference of the operands. If both operands are int, char, or float, the same type
considerations as for + apply.

```
int x = 10;
int y = 8;
int z = x + y;
```

### Assignment Operators

#### lvalue = expression
The operator `=` assigns an expression to a variable. It assigns value on right of operator to the left.
The value of the expression replaces that of the object referred to by the lvalue. The operands need not have the
same type, but both must be int, char, float.

```
int x = 5;
```

#### lvalue =+ expression

```
int x = 5;
int y =+ x;
```

#### lvalue =− expression

```
int x = 5;
int y =- x;
```

#### lvalue =* expression

```
int x = 5;
int y =* x;
```

#### lvalue =/ expression

```
int x = 5;
int y =/ x;
```

#### lvalue =% expression

```
int x = 5;
int y =% x;
```

The behavior of an expression of the form ‘‘E1 =op E2’’ may be inferred by taking it as equivalent to
‘‘E1 = E1 op E2’’; however, E1 is evaluated only once.

### Relational Operators
The relational operators are `<`, `<=`, `>`, `>=` . They all have the same precedence. They group from left to right.

#### expression < expression

```
bool less = 5 < 6;
```
#### expression > expression

```
bool greater = 5 > 6;
```

#### expression <= expression

```
bool less_than_equal = 5 < 6;
```

#### expression >= expression

```
bool greater_than_equal = 5 < 6;
```

The operators < (less than), > (greater than), <= (less than or equal to) and >= (greater than or equal to) all yield 0
if the specified relation is false and 1 if it is true. Operand conversion is exactly the same as for the + operator.

### Pipe Operator

There is also a pipe operator much like pipe in ocaml which applies a function to another.

### Example Syntax

```
str x = "hellopeople";
str s = f | g | x;
```

### Equality Operators

#### expression == expression

```
str hello = "hello";
str world = "world";
bool i_am_false = hello == world;
```
#### expression != expression

The == (equal to) and the != (not equal to) operators are exactly analogous to the relational operators except for
their lower precedence. (Thus `a<b == c<d` is 1 whenever a<b and c<d have the same truth-value).

### Example Syntax

```
str hello = "hello";
str world = "world";
bool i_am_true = hello != world;
```

### Logical Operators
The logical operators are `&&`, `||`, `!`.

#### expression && expression
The && operator returns 1 if both its operands are non-zero, 0 otherwise. && guarantees left-to-right
evaluation; moreover the second operand is not evaluated if the first operand is 0.
The operands need not have the same type, but each must have one of the fundamental types.

```
int x = 5;
int y = 5;
int z = 5;

bool i_am_true = (x == y && x == z);
```

#### expression || expression

The || operator returns 1 if either of its operands is non-zero, and 0 otherwise. , || guarantees left-to-right
evaluation; moreover, the second operand is not evaluated if the value of the first operand is non-zero.
The operands need not have the same type, but each must have one of the fundamental types.

```
int x = 5;
int y = 5;
int z = 10;

bool i_am_true = (x == y || x == z);
```

#### !expression

The ! operator returns 1 if operand is zero, and 0 otherwise.

```
bool i_am_true = true;
bool i_am_false = !i_am_true;
```

## Statements & Expressions

## Memory Management 

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

## NLP Features