/* Ocamlyacc parser for SIFT */
%{ 
  open Ast 
%}

/* Arithmetic Operators */
%token ADD SUBTRACT MULTIPLY DIVIDE MOD
/* Relational Operators */
%token EQ LEQ GT GEQ NEQ LT
/* Logical Operators */
%token AND OR NOT
/* Features */
%token PIPE PLACEHOLDER ANON
/* Paranthesis and Brackets */
%token LPAREN RPAREN LBRACE RBRACE LARROW RARROW LSQBRACE RSQBRACE
/* Delimiters */
%token COMMA SEMI COLON DOT
/* Assignment */
%token ASSIGN 
/* Keywords */
%token IF ELIF ELSE SWITCH CASE FOR WHILE CONTINUE BREAK DEFAULT LAMBDA DEFINE EXIT RETURN NULL TRUE FALSE
%token IMPORT LIST FROM PURE 
/* Primitive Data Types */
%token INT FLOAT CHAR SYMBOL STRING BOOL
/* Non-primitive Data Types */
%token ARRAY LIST TUPLE SET DICT
%token <int> INT_LITERAL
%token <float> FLOAT_LITERAL
%token <string> STRING_LITERAL
%token <bool> BLIT
%token <string> ID
%token EOF


%left SEMI
%nonassoc RSQBRACE RBRACE RARROW RPAREN
%nonassoc LSQBRACE LBRACE LARROW LPAREN
%nonassoc COLON
%nonassoc COMMA
%nonassoc NOELSE


%start program
%type <Ast.program> program

%right ASSIGN
%left PIPE
%right ANON
%left OR 
%left AND
%left EQ 
%left NEQ
%left GT 
%left GEQ 
%left LEQ 
%left LT
%left ADD SUBTRACT
%left MULTIPLY DIVIDE MOD
%right NOT

%%

/* add function declarations*/
program:
  decls EOF { $1}

decls:
   /* nothing */ { ([], [])               }
 | stmt decls { (($1 :: fst $2), snd $2) }
 | fdecl decls { (fst $2, ($1 :: snd $2)) }

/* int x */
vdecl:
  typ ID { ($1, $2) }

typ:
    INT             { Int   }
  | BOOL            { Bool  }
  | FLOAT           { Float }
  | STRING          { String }
  | ARRAY LT typ GT { Arr($3) }

/* fdecl */
fdecl:
  DEFINE vdecl LPAREN formals_opt RPAREN LBRACE stmt_list RBRACE
  {
    {
      rtyp=fst $2;
      fname=snd $2;
      formals=$4;
      body=$7
    }
  }

/* formals_opt */
formals_opt:
  /*nothing*/ { [] }
  | formals_list { $1 }

formals_list:
  vdecl { [$1] }
  | vdecl COMMA formals_list { $1::$3 }

stmt_list:
  /* nothing */ { [] }
  | stmt stmt_list  { $1::$2 }

stmt:
    expr SEMI                                        { Expr $1      }
  | LBRACE stmt_list RBRACE                          { Block $2 }
  /* if (condition) { block1} else {block2} */
  /* if (condition) stmt else stmt */
  | IF LPAREN expr RPAREN stmt ELSE stmt             { IfElse($3, $5, $7) }
  | WHILE LPAREN expr RPAREN stmt                    { While ($3, $5)  }
  | FOR LPAREN expr SEMI expr SEMI expr RPAREN stmt  { For ($3, $5, $7, $9) }
  | CONTINUE SEMI                                    { Continue }
  | BREAK SEMI                                       { Break }
  /* return (Should it ONLY be allowed in functions?) */
  | RETURN expr SEMI                                 { Return $2      }

pipeline:
  /* pipe */
  | anonymous                     { $1                  }
  | expr PIPE anonymous           { Binop($1, Pipe, $3) } 

anonymous:
  ID ANON expr                    { Lambda ($1, $3)}

expr:
  /* literals and id */
    INT_LITERAL         { Literal($1)            }
  | STRING_LITERAL      { StrLit($1)             }
  | FLOAT_LITERAL       { FloatLit($1)           }
  | BLIT                { BoolLit($1)            }
  | ID                  { Id($1)                 }
  /* PIPING AND LAMBDAS*/
  | pipeline            { $1                     }
  /* arithmetic operators */
  | expr ADD   expr     { Binop($1, Add,   $3)   }
  | expr SUBTRACT  expr { Binop($1, Sub,   $3)   }
  | expr MULTIPLY  expr { Binop($1, Sub,   $3)   }
  | expr DIVIDE    expr { Binop($1, Sub,   $3)   }
  | expr MOD       expr { Binop($1, Sub,   $3)   }
  /* relational operators */
  | expr EQ     expr    { Binop($1, Equal, $3)   }
  | expr NEQ    expr    { Binop($1, Neq, $3)     }
  | expr LT     expr    { Binop($1, Less,  $3)   }
  | expr GT     expr    { Binop($1, Less,  $3)   }
  | expr GEQ    expr    { Binop($1, Less,  $3)   }
  | expr LEQ    expr    { Binop($1, Less,  $3)   }
  /* logical operators */
  | expr AND    expr    { Binop($1, And,   $3)   }
  | expr OR     expr    { Binop($1, Or,    $3)   }
  | NOT expr            { Unop(Not, $2)          }
  /*assignment*/
  | ID ASSIGN expr      { Assign($1, $3)         }
  | typ ID ASSIGN expr  { DeclAssign($1, $2, $4) }
  | LPAREN expr RPAREN  { $2                     }
  /* call */
  | ID LPAREN args_opt RPAREN  { Call ($1, $3) }
  /* arrays! */
  | LSQBRACE args_opt RSQBRACE { ArrayLit($2) }
  | ID LSQBRACE expr RSQBRACE  { ArrayAccess($1, $3) }
  | ID LSQBRACE expr RSQBRACE ASSIGN expr  { ArrayAssign($1, $3, $6) }

/* args_opt*/
args_opt:
  /*nothing*/ { [] }
  | args { $1 }

args:
  expr  { [$1] }
  | expr COMMA args { $1::$3 }