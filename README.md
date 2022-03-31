# sift
COMSW 4115 Spring 2022


```
Anne Zepecki(Manager)
Lama Abdullah Rashed(Tester)
Jose Antonio Ramos(Language Guru)
Suryanarayana Venkata Akella (System Architect)
Rishav Kumar (System Architect)

```
The current version compiles scanner.mll, parser.mly and ast.ml

## TO COMPILE
make

## TO RUN THE BUILD
make run

## CLEAN THE PREVIOUS BUILD
make clean

# Features Supported:

### Primitive Datatypes:

1. Int
2. Bool
3. Float
4. String

### Non-primitive datatypes:
1. Array of Int 
2. Array of Bool
3. Array of Float
4. Array of String

### Loops and Conditionals

1. If
2. If Else
3. For
4. While
5. Continue
6. Break

### Function definitions

### Binary Operators

1. Add
2. Subtract
3. Multiplication
4. Division
5. Modulo
6. Equal
5. Not Equal
6. Less
7. Less than Equals
8. Greater
9. Greater than Equal
10. And
11. Or
12. Pipe

### Features in Progress

* Nested array indexing (ast, parser)
* Standalone if statement (dangling if: parser)
* Allow only assignment in the first slot of a for loop (parser or semantics?)
* Allow only boolean in the second slot of for loop and slot of while loop (parser or semantics?)
* Allow return statement only inside functions (parser or semantics?)
* Allow continue/break only in while/for/if/else (parser or semantics?)