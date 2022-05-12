# FINAL REPORT: SIFT 

```
Anne Zepecki (Manager)
Lama Abdullah Rashed (Tester)
Jose Antonio Ramos (Language Guru)
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

Sift files are signified with the `.sf` suffix.

### Fundamentals 

**Data Types** 

Sift consists of several key primitive data types: `int`, `float`, `char`, `str`, and `bool`. Sift also includes an `arr` non-primitive data type that holds an array of non-primitive type `t` in `arr<t>`. 

__For strings, we also implemented additional string operations since Sift is a language meant for text-processing__. 

Example usage with `str_add`: 

```js
str a = "ap";
str b = "ple";
str c = str_add(a, b);
c |> <out>;
```

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
def arr<(str,int)> 
    get_frequencies(arr<str> tokens) {
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

There is a pipe operator `|>` much like pipe in unix which applies an output of an expression to another expression. Refer to the below test case:

#### Example Syntax

```js
def int func(int a, int b, int c, int d) {
    return a + b + c + d;
}

def int main() {
   print((2 |> func(6, 4, 9)));
   return 0;
}
```
In the above example, 2 is provided as an input to the function func that has only three arguments. This operation can be used for pipelining the various string operations.

**Lambdas**

The `lambda` keyword is used to denote an anonymous function. 

```js 
lambda x : x + 1;
```

**Regular Expressions** 

We have implemented built-in regex functionality as a part of Sift based on Thompson's NFA expressions(https://swtch.com/~rsc/regexp/). There are three regex functionalities supported in test.

```
bool reg_test(string, regex);
arr<str> reg_match(string, regex);
arr<int> reg_match_indices(string, regex);
```

The reg_test method checks if the string matches the given regex expression with the string provided.

The reg_match method checks for all the instances where the regex expression matches with the string provided. It returns an array of all the words that match with the given regex expression.

The reg_match_indices method checks for all the instances where the regex expression matches with the string provided. It returns an array of starting indices of all the text that match with the given regex expression.


**NLP Features** 

We have two nlp functions currently supported
```
word_tokenize
get_jaro
```

The word_tokenize method returns an array of strings separated by space.
The get_jaro method calculates the similarity between two strings.(https://rosettacode.org/wiki/Jaro_similarity). The higher the value of jaro_similarity, more similar the two sentences are.

See example usage of `word_tokenize`:

```js
str big_line = "Lorem ipsum dolor sit amet";
arr<str> tokenized_version = word_tokenize(big_line);
for(int i=0; i < len(tokenized_version); i++) {
    print(tokenized_version[i]);
}

Output:
["Lorem", "ipsum", "dolor", "sit", "amet"]
```

##  3. <a name='ArchitecturalDesign'></a>Architectural Design 

### SCANNER

_Relevant files_: `scanner.mll`

The scanner file takes a Sift source program and translates the stream of characters into a stream of tokens for identifiers, keywords, operators, literals, etc. At this stage, any whitespace and comments are discarded from the stream of tokens.
The scanner is implemented in Ocamllex, and uses regular expressions for scanning string literals, identifiers, digits and other language constructs. If a token is not identified by the scanner, it will throw an error. The tokens processed by the scanner are passed to the parser for the next step in the pipeline.

### PARSER AND AST

_Relevant files_: `parser.mly` and `ast.ml`

The parser accepts the tokens generated by the scanner and creates an abstract syntax tree (AST) with the grammar provided in `parser.mly`. The parser enforces a Context Free Grammar (CFG) consisting of productions and their precedence. The parser also defines the entry point of the program. The parser is written in Ocamlyacc. If the syntax of the program is incorrect, then the parser throws a `Stdlib.parse_error`.

The AST defines the token syntax tree and includes binary and unary operators, primitive data types, expression, and constructs of the language.

### SEMANTICS

_Relevant files_: `sast.ml` and `semantics.ml`

The semantic checker converts the AST into a semantically checked syntax tree (SAST). The semantic analysis process performs validation like ensuring that variables are declared and have been declared with valid values. It  maintains the scope of the variables and functions using a symbol table (as Sift is a statically type language). The SAST also validates whether the built-in C functions were provided the correct types or not. Once the semantic checks are completed, an SAST is generated and passed as an input to the IR Generator.

### IR GENERATION

The IR generator takes an SAST and outputs LLVM code. We use ocaml llvm's library to map expression to LLVM accepted data types. 

### BUILT-IN LIBRARIES

We have a set on built-in libraries for string operations, regex and nlp-functionalities. We compile them while creating build for llvm and then use them

##  4. <a name='TestPlan'></a>Test Plan

### 4.1 <a name='Example Sift Programs'></a>Test Plan

The following are two programs written in sift demonstrate the different text processing application that developers can do using sift.

### Source Programs 

**Most similar strings** 

The below program checks the similarity of two strings(shark, jellyfish) to a string(smellyfish). The program uses the nlp functionality, get_jaro, to calculate the similarity between the two strings. Then the value obtained is used to make the decision. The function also demonstrate the use of pipe features which in this case is used to concatenate strings to form an output string.



Sift Source Program:

```
def str get_result_string(str a, str b, str c) {
	str result = str_add(a, " is more similar to ") |> str_add(b) |> str_add(" than ") |> str_add(c);
	return result;
}

def int main() {

	str smellyfish = "SMELLYFISH";
	str jellyfish = "JELLYFISH";
	str apple = "SHARK";

	float smelly_apple = get_jaro(smellyfish, apple);
	float smelly_jelly = get_jaro(smellyfish, jellyfish);

	if (smelly_apple > smelly_jelly) {
		print(get_result_string(apple, smellyfish, jellyfish));
	} else {
		print(get_result_string(jellyfish, smellyfish, apple));
	}
	
    return 0;
}

```

LLVM Target Program:

```
; ModuleID = 'Sift'
source_filename = "Sift"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

@str_literal = private unnamed_addr constant [7 x i8] c" than \00", align 1
@str_literal.1 = private unnamed_addr constant [21 x i8] c" is more similar to \00", align 1
@str_literal.2 = private unnamed_addr constant [11 x i8] c"SMELLYFISH\00", align 1
@str_literal.3 = private unnamed_addr constant [10 x i8] c"JELLYFISH\00", align 1
@str_literal.4 = private unnamed_addr constant [6 x i8] c"SHARK\00", align 1

declare i8* @str_add(i8*, i8*)

declare i1 @str_eql(i8*, i8*)

declare i32 @len(i8*)

declare i32 @print_i(i32, ...)

declare i32 @print_d(double, ...)

declare i32 @print_s(i8*, ...)

declare i32 @print_b(i1, ...)

declare i8* @input(i32, ...)

declare i32 @output(i8*, ...)

declare i32 @word_tokenize(i8*)

declare i32 @reg_match(i8*, i8*)

declare i1 @reg_test(i8*, i8*)

declare i32 @match_indices(i8*, i8*)

declare double @get_jaro(i8*, i8*)

define i8* @get_result_string(i8* %a, i8* %b, i8* %c) {
entry:
  %a1 = alloca i8*
  store i8* %a, i8** %a1
  %b2 = alloca i8*
  store i8* %b, i8** %b2
  %c3 = alloca i8*
  store i8* %c, i8** %c3
  %c4 = load i8*, i8** %c3
  %b5 = load i8*, i8** %b2
  %a6 = load i8*, i8** %a1
  %str_add = call i8* @str_add(i8* %a6, i8* getelementptr inbounds ([21 x i8], [21 x i8]* @str_literal.1, i32 0, i32 0))
  %str_add7 = call i8* @str_add(i8* %str_add, i8* %b5)
  %str_add8 = call i8* @str_add(i8* %str_add7, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @str_literal, i32 0, i32 0))
  %result = call i8* @str_add(i8* %str_add8, i8* %c4)
  %result10 = alloca i8*
  store i8* %result, i8** %result10
  %result11 = load i8*, i8** %result10
  ret i8* %result11
}

define i32 @main() {
entry:
  %smellyfish = alloca i8*
  store i8* getelementptr inbounds ([11 x i8], [11 x i8]* @str_literal.2, i32 0, i32 0), i8** %smellyfish
  %jellyfish = alloca i8*
  store i8* getelementptr inbounds ([10 x i8], [10 x i8]* @str_literal.3, i32 0, i32 0), i8** %jellyfish
  %apple = alloca i8*
  store i8* getelementptr inbounds ([6 x i8], [6 x i8]* @str_literal.4, i32 0, i32 0), i8** %apple
  %apple1 = load i8*, i8** %apple
  %smellyfish2 = load i8*, i8** %smellyfish
  %smelly_apple = call double @get_jaro(i8* %smellyfish2, i8* %apple1)
  %smelly_apple3 = alloca double
  store double %smelly_apple, double* %smelly_apple3
  %jellyfish4 = load i8*, i8** %jellyfish
  %smellyfish5 = load i8*, i8** %smellyfish
  %smelly_jelly = call double @get_jaro(i8* %smellyfish5, i8* %jellyfish4)
  %smelly_jelly6 = alloca double
  store double %smelly_jelly, double* %smelly_jelly6
  %smelly_apple7 = load double, double* %smelly_apple3
  %smelly_jelly8 = load double, double* %smelly_jelly6
  %tmp = fcmp ogt double %smelly_apple7, %smelly_jelly8
  br i1 %tmp, label %then, label %else

then:                                             ; preds = %entry
  %jellyfish9 = load i8*, i8** %jellyfish
  %smellyfish10 = load i8*, i8** %smellyfish
  %apple11 = load i8*, i8** %apple
  %get_result_string_result = call i8* @get_result_string(i8* %apple11, i8* %smellyfish10, i8* %jellyfish9)
  %print_s = call i32 (i8*, ...) @print_s(i8* %get_result_string_result)
  br label %if_end

else:                                             ; preds = %entry
  %apple12 = load i8*, i8** %apple
  %smellyfish13 = load i8*, i8** %smellyfish
  %jellyfish14 = load i8*, i8** %jellyfish
  %get_result_string_result15 = call i8* @get_result_string(i8* %jellyfish14, i8* %smellyfish13, i8* %apple12)
  %print_s16 = call i32 (i8*, ...) @print_s(i8* %get_result_string_result15)
  br label %if_end

if_end:                                           ; preds = %else, %then
  ret i32 0
}

```



**SQL Syntax Flavor** 

The idea of pipe was to give functions a flavor of declarative sql syntax. The below example demonstrates the use of pipe operator as a where clause. In the example, we use two sentences, matched against the same regular expression. You can visualize it as running select value from xyz where column like (regex). The output of this is then give to the print() function. If you look carefully, print function doesn't take any argument. It's argument is the output produced by the function called. 
This functionality will be very helpful in association with word_tokenize(nlp function). It will give the developers power to match regular expression for the entire sentence and then pass that to the next stage of their pipeline.

Sift Source Program:

```

def str search_if_present(str str1, str regex) {
        str return_val = "";
	if (reg_test(str1, regex)) {
		return_val = str1;
	}
        return return_val;
}

def int main() {

	str regex = "(w|m)i*ld";
	str string1 = "The wiiiiiiiiiild wild cat lived in a mild climate.";
	str string2 = "My name is Anthony Gonsalves.";

	search_if_present(string1, regex) |> print(); 
	search_if_present(string2, regex) |> print();
	
	return 0;

}
```
LLVM Target Program:

```
; ModuleID = 'Sift'
source_filename = "Sift"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

@str_literal = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@str_literal.1 = private unnamed_addr constant [10 x i8] c"(w|m)i*ld\00", align 1
@str_literal.2 = private unnamed_addr constant [52 x i8] c"The wiiiiiiiiiild wild cat lived in a mild climate.\00", align 1
@str_literal.3 = private unnamed_addr constant [30 x i8] c"My name is Anthony Gonsalves.\00", align 1

declare i8* @str_add(i8*, i8*)

declare i1 @str_eql(i8*, i8*)

declare i32 @len_s(i8*)

declare i32 @len_arr_s(i8**)

declare i32 @len_arr_i(i32*)

declare i32 @len_arr_d(double*)

declare i32 @len_arr_b(i1*)

declare i32 @print_i(i32, ...)

declare i32 @print_d(double, ...)

declare i32 @print_s(i8*, ...)

declare i32 @print_b(i1, ...)

declare i8* @input(i32, ...)

declare i32 @output(i8*, ...)

declare i8** @word_tokenize(i8*)

declare i32 @reg_match(i8*, i8*)

declare i1 @reg_test(i8*, i8*)

declare i32 @reg_match_indices(i8*, i8*)

declare double @get_jaro(i8*, i8*)

define i8* @search_if_present(i8* %str1, i8* %regex) {
entry:
  %str11 = alloca i8*
  store i8* %str1, i8** %str11
  %regex2 = alloca i8*
  store i8* %regex, i8** %regex2
  %return_val = alloca i8*
  store i8* getelementptr inbounds ([1 x i8], [1 x i8]* @str_literal, i32 0, i32 0), i8** %return_val
  %regex3 = load i8*, i8** %regex2
  %str14 = load i8*, i8** %str11
  %reg_test = call i1 @reg_test(i8* %str14, i8* %regex3)
  br i1 %reg_test, label %then, label %if_end

then:                                             ; preds = %entry
  %str15 = load i8*, i8** %str11
  store i8* %str15, i8** %return_val
  br label %if_end

if_end:                                           ; preds = %entry, %then
  %return_val6 = load i8*, i8** %return_val
  ret i8* %return_val6
}

define i32 @main() {
entry:
  %regex = alloca i8*
  store i8* getelementptr inbounds ([10 x i8], [10 x i8]* @str_literal.1, i32 0, i32 0), i8** %regex
  %string1 = alloca i8*
  store i8* getelementptr inbounds ([52 x i8], [52 x i8]* @str_literal.2, i32 0, i32 0), i8** %string1
  %string2 = alloca i8*
  store i8* getelementptr inbounds ([30 x i8], [30 x i8]* @str_literal.3, i32 0, i32 0), i8** %string2
  %regex1 = load i8*, i8** %regex
  %string12 = load i8*, i8** %string1
  %search_if_present_result = call i8* @search_if_present(i8* %string12, i8* %regex1)
  %print_s = call i32 (i8*, ...) @print_s(i8* %search_if_present_result)
  %regex3 = load i8*, i8** %regex
  %string24 = load i8*, i8** %string2
  %search_if_present_result5 = call i8* @search_if_present(i8* %string24, i8* %regex3)
  %print_s6 = call i32 (i8*, ...) @print_s(i8* %search_if_present_result5)
  ret i32 0
}
```

### Automation

In our `Makefile`, we have a target `make test` that runs an entire test suite that consists of tests for all of the major features of Sift. We compare the output of running each test with the expected `.out` file for that particular test to determine whether the test has passed or failed. 

##  5. <a name='Summary'></a>Summary

### Breakdown of Work

**Project Proposal** 

_Implemented by_: Anne, José, Rishav, Surya, Lama

**Language Reference Manual**

_Implemented by_: Anne, José, Surya, Rishav, Lama

**Scanner**

_Implemented by_: Rishav, José, Lama, Anne, Surya 

**Parser and AST**

_Implemented by_: José, Lama, Rishav, Anne, Surya 

**Semantics**

_Implemented by_: José and Lama

**IR Generation**

_Implemented by_: José, Lama, and Rishav

**Built-In Libraries**

_Implemented by_: Rishav and Surya

**Tests**

_Implemented by_: Rishav, Lama, Anne, Surya, José

**Final Report**

_Implemented by_: Anne, Rishav

### Takeaways 

**Anne**

My most important takeaway from the project was probably in gaining the understanding of how all the pieces of compiling a language come together. I thought that I understood well from the lectures, but I think it was a different experience actually working on the implementation and having to understand all the different minor details of a language and the way that it's implemented can make a really big difference. I think that it really stressed the importance of design more generally, but also specifically in the case of programming languages. I definitely gained more of an appreciation for the coding languages I use in my day-to-day life and the beauty of how they were implemented. 

**Lama**

**Jose**

**Rishav**

**Surya** 


### Advice

The biggest piece of advice would be to try to implement each stage as soon as the relevant lecture is covered. We definitely found it useful to have for the most part completed the scanner/parser by the Hello World milestone. Working on things in stages makes it so that the work can build on top of each stage. 