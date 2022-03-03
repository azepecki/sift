# LANGUAGE REFERENCE MANUAL: SIFT

## LEXICAL CONVENTIONS

## TYPES

## OPERATORS 

## STATEMENTS & EXPRESSIONS

## MEMORY MANAGEMENT 

As a text processing language, memory management becomes a critical aspect. But unlike C, Sift has automatic memory management.
With our automatic memory management, it's faster to develop programs without being bothered about the low-level memory details. 
It also prevents the program from memory leaks and dangling pointers.

Sift uses generational garbage collection for automatic memory management. Sift supports three generation of in total. An object
moves into an older generation whenever it survives a garbage collection process on its current generation.

The garbage collector keeps track of all objects in the memory. When a new object is created, it starts its life in the first generation.
There is a predefined value for the theshold number of objects for each generation. If it exceeds that threshold, the garbage collector triggers
a collection process. For objects that survive this process, they are moved into the older generation.

### Using The Garbage Collector Module

Programmers can change this default behavior of Garbage collection depending upon their available resources and requirement of their program.

You can check the configured thresholds of your garbage collector with the get_threshold() method:

```
>>> import gc
>>> gc.get_threshold()
(1000, 300, 300)
```

By default, Sift has a threshold of 1000 objects for the first generation, 300 each for the second and third generation.

Check the number of objects in each generation with get_count() method:

```
>>> import gc
>>> gc.get_count()
(572, 222, 109)
```

In the above example, we have 572 objects of first generation, 222 objects of second generation and 109 objects of third generation.

Trigger the garbage collection process manually

```
>>> import gc
>>> gc.get_count()
(572, 222, 109)
>>> gc.collect()
```

User can set thresholds for triggering garbage collection by using the set_threshold() method in the gc module.

```
>>> import gc
>>> gc.get_threshold()
(1000, 300, 300)
>>> gc.set_threshold(2000, 30, 30)
>>> gc.get_threshold()
(2000, 30, 30)
```

Increasing the threshold will reduce the frequency at which the garbage collector runs. This will improve the
performance of your program but at the expense of keeping dead objects around longer.

## NLP FEATURES 

## GRAMMER