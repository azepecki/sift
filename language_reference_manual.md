# Language Reference Manual: Sift

## Lexical Conventions

## Types

## Operators 

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

## Garbage Collection 

## NLP Features 

## Grammar
