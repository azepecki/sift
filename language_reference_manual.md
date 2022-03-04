# Language Reference Manual: Sift

## Lexical Conventions

## Types

## Operators 
### Arithmetic Operators
The binary arithmetic operators are +, -, *, /, % .
Integer division truncates any fractional part.
The binary + and - operators have the same precedence, which is lower than the
precedence of *, /, % . Arithmetic operators associate left to right.

### Grammar

```
expr:
expr PLUS expr  }
| expr MINUS expr }
| expr TIMES expr }
| expr DIVIDE expr }
| expr MODULO expr }
```

### Example Syntax

```
int x = 5 * (16 - 6);
```

### Assignment Operators
The operator = assigns an expression to a variable. It assigns value on right of operator to the left.

### Example Syntax

```
int x = 5;
```

### Comaparision Operators
The relational operators are <, <=, >, >= . They all have the same precedence. 

### Grammar

```
expr:
expr EQ expr 
| expr NEQ expr 
| expr LT expr  
| expr LEQ expr  
| expr GT expr  
| expr GEQ expr 
```

### Example Syntax

```
bool x = (1 == 1);
```

### Logical Operators
The logical operators are and, or, not.

### Grammar

```
expr:
expr AND expr 
| expr OR expr 
| NOT expr  
```

### Example Syntax

```
if(x == y or x == z)
```

## Statements & Expressions

## Garbage Collection 

## NLP Features 

## Grammar