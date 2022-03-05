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

## NLP FEATURES 

## GRAMMAR