# FINAL REPORT: SIFT 

```
Anne Zepecki(Manager)
Lama Abdullah Rashed(Tester)
Jose Antonio Ramos(Language Guru)
Rishav Kumar (System Architect)
Suryanarayana Venkata Akella (System Architect)
```

<!-- vscode-markdown-toc -->
 1. [Introduction](#Introduction)
 2. [Language Tutorial](#LanguageTutorial)
 3. [Architectural Design](#ArchitecturalDesign)
 4. [Test Plan](#TestPlan)
 5. [Summary](#Summary)
<!-- vscode-markdown-toc-config
	numbering=true
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

##  1. <a name='Introduction'></a>Introduction

Sift is a programming language designed to optimize text processing and filtering for natural language processing (NLP) applications.
Sift draws inspiration from the elegance of C’s syntax while adding its own unique flair. This imperative language is designed for users with some programming experience as knowledge of C or a similar language will allow users to instantly recognize and understand the basic structure of Sift. However, it is the text-specific processing tools that make Sift stand out as the best language to use for NLP purposes; piping, filtering, and basic tokenization functionality give users the tools they need to seamlessly integrate Sift into their existing or future NLP workflows.

##  2. <a name='LanguageTutorial'></a>Language Tutorial

### Fundamentals 

**Data Types** 

Sift consists of several key primitive data types: `int`, `float`, `char`, `str`, `sym` and `bool`. Sift also includes an `arr` non-primitive data type that holds an array of non-primitive type `t` in `arr<t>`. 

**Identifiers** 

Variable declaration follows the following syntax: 

```js
int a = 3;
```

**Operators: Arithmetic**

The following arithmetic operators are available: `+`, `-`, `/`, `*`, and `%`. These operators function in the same way as they would in C. 

**Operators: Relational**

The following relational operators are available: `>`, `<`, `==`, `!=`, `<=`, `>=`. These operators function in the same way as they would in C. 

**Operators: Logical**

The following logical operators are available: `&&`, `||`, `!`. These operators function in the same way as they would in C. 

**Control Flow**

The following functionality for control flow is available: 
`if/else` blocks, `while` loops, `for` loops, `continue` keyword, `return` keyword, `break` keyword. 

**Function Calls**

In Sift, functions are declared with the keyword `def`. The function should have a name and a consequent block of code to be executed when the function is called.
A function can take zero, one or more arguments and return an expression of a certain type; the retuned type should be declared in the function header. 

**Syntax:**
```js
def list<(sym,int)> 
    get_frequencies(list<sym> tokens) {
    return ... ; 
}
```
```js
def hello() {
    print(“Hello World!”);
}
```

### Sift-Specific Functionality
 
**Pipe Operators**

There is also a pipe operator `|>` much like pipe in ocaml which applies a function to another.

#### Example Syntax

```js
str x = "hellopeople";
str s = f |> g |> x;
```

**Lambdas**

The `lambda` keyword is used to denote an anonymous function. 

`lambda x : x + 1;`

**Regular Expressions** 

**NLP Features** 


##  3. <a name='ArchitecturalDesign'></a>Architectural Design 

See architecture diagram. 

##  4. <a name='TestPlan'></a>Test Plan

### Source Programs 

**Fundamental Functionality** 

**Regex** 

**NLP Features**

### Automation

##  5. <a name='Summary'></a>Summary

### Breakdown of Work 

**Language Proposal**: Anne, Jose, Rishav, Lama, Surya
 

**LRM**: Anne, Rishav, Jose, Lama, Surya

**Scanner**: Anne, Rishav

**Parser**: Anne, Jose, Surya, Lama

**Semantics Checker**: Jose, Surya, Rishav

**IR Generation**: Jose, Surya, Rishav

**Tests**: Lama, Anne

**Final Report**: Anne

### Takeaways 

**Anne**

**Lama**

**Jose**

**Rishav**

**Surya** 



