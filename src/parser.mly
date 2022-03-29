/* Ocamlyacc parser for SIFT */
%{ 
  open Ast 
%}

/* Arithmetic Operators */
%token ADD SUBTRACT MULTIPLY DIVIDE MOD
/* Relational Operators */
%token EQ LEQ GT GEQ NEQ LT
/* Logical Operators */
%token AND OR NOT XOR
/* Paranthesis and Brackets */
%token LPAREN RPAREN LBRACE RBRACE LARROW RARROW LSQBRACE RSQBRACE
/* Delimiters */
%token COMMA SEMICOLON COLON DOT
/* Assignment */
%token ASSIGN 
/* Features */
%token PIPE
/* Keywords */
%token IF ELIF ELSE SWITCH CASE FOR WHILE CONTINUE BREAK DEFAULT LAMBDA DEFINE EXIT RETURN NULL TRUE FALSE
%token IMPORT LIST FROM PURE 
/* Primitive Data Types */
%token INT FLOAT CHAR SYMBOL STRING BOOL
/* Non-primitive Data Types */
%token ARRAY LIST TUPLE SET DICT
%token <int> INT_LITERAL
%token <float> FLOAT_LITERAL
%token <bool> BLIT
%token <string> ID
%token EOF


%left SEMICOLON
%nonassoc RSQBRACE RBRACE RARROW RPAREN
%nonassoc LSQBRACE LBRACE LARROW LPAREN
%nonassoc COLON
%nonassoc COMMA
%nonassoc NOELSE
%left RETURN
%right ASSIGN
%left OR AND
%left EQ NEQ
%left GT GEQ LEQ LT
%left ADD SUBTRACT
%left MULTIPLY DIVIDE MOD
%right NOT

%start program
%type <Ast.program> program

%%

/* add function declarations*/
program:
  decls EOF { $1}

decls:
   /* nothing */ { ([], [])               }
 | vdecl SEMI decls { (($1 :: fst $3), snd $3) }
 | fdecl decls { (fst $2, ($1 :: snd $2)) }

vdecl_list:
  /*nothing*/ { [] }
  | vdecl SEMI vdecl_list  {  $1 :: $3 }

/* int x */
vdecl:
  typ ID { ($1, $2) }


typ:
    INT   { Int   }
  | BOOL  { Bool  }
  | STRING { String }
  | SYMBOL { Symbol }
  | FLOAT { Float }
  | CHAR { Char }
  | ARRAY { Array } (* Does this belong here? *)

/* fdecl */
fdecl:
  vdecl LPAREN formals_opt RPAREN LBRACE vdecl_list stmt_list RBRACE
  {
    {
      rtyp=fst $1;
      fname=snd $1;
      formals=$3;
      locals=$6;
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
    expr SEMI                               { Expr $1      }
  | LBRACE stmt_list RBRACE                 { Block $2 }
  /* if (condition) { block1} else {block2} */
  /* if (condition) stmt else stmt */
  | IF LPAREN expr RPAREN stmt ELSE stmt    { If($3, $5, $7) }
  /* While loop */
  | WHILE LPAREN expr RPAREN stmt           { While ($3, $5)  }
  /* return */
  | RETURN expr SEMI                        { Return $2      }

expr:
    LITERAL          { Literal($1)            }
  | BLIT             { BoolLit($1)            }
  | ID               { Id($1)                 }
  | expr ADD   expr { Binop($1, Add,   $3)   }
  | expr SUBTRACT  expr { Binop($1, Sub,   $3)   }
  | expr MULTIPLY expr { Binop($1, Multiply,    $3)}
  | expr DIVIDE expr { Binop($1, Divide,    $3)}
  | expr MOD expr {Binop($1, Mod,    $3)      }
  | expr PIPE expr {Binop($1, Pipe, $3)       }
  | expr EQ     expr { Binop($1, Equal, $3)   }
  | expr NEQ    expr { Binop($1, Neq, $3)     }
  | expr LT     expr { Binop($1, Less,  $3)   }
  | expr GT     expr { Binop($1, Greater, $3) }
  | expr LEQ    expr { Binop($1, Leq,    $3)  }
  | expr GEQ expr { Binop($1, Geq,    $3)     }
  | expr AND    expr { Binop($1, And,   $3)   }
  | expr OR     expr { Binop($1, Or,    $3)   }
  | NOT expr        {Binop(Not, $2)           }
  | expr XOR expr { Binop($1, Xor, $2)        }
  | ID ASSIGN expr   { Assign($1, $3)         }
  | LPAREN expr RPAREN { $2                   }
  /* call */
  | ID LPAREN args_opt RPAREN { Call ($1, $3)  }

/* args_opt*/
args_opt:
  /*nothing*/ { [] }
  | args { $1 }

args:
  expr  { [$1] }
  | expr COMMA args { $1::$3 }

/***
Expressions that still need to be added: 
- arrays [ list of literals ];
- arr<typ> 

***/ 