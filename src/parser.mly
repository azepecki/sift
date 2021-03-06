/* Ocamlyacc parser for SIFT */
%{ 
  open Ast 
%}

/* Arithmetic Operators */
%token ADD SUBTRACT MULTIPLY DIVIDE MOD
/* Relational Operators */
%token EQ LEQ GT GEQ NEQ LT EOL
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
%token IF ELIF ELSE SWITCH CASE DEFAULT FOR WHILE CONTINUE BREAK LAMBDA DEFINE EXIT RETURN NULL TRUE FALSE
%token IMPORT LIST FROM PURE 
/* Primitive Data Types */
%token INT FLOAT CHAR SYMBOL STRING BOOL
/* Non-primitive Data Types */
%token ARRAY LIST TUPLE SET DICT
%token FUNCTION
%token <int> INT_LITERAL
%token <float> FLOAT_LITERAL
%token <string> STRING_LITERAL
%token <bool> BLIT
%token <string> ID
%token STDIN STDOUT
%token INCREMENT DECREMENT
%token ADDASSIGN SUBASSIGN MULASSIGN DIVASSIGN
%token EOF


%left SEMI
%nonassoc RSQBRACE RBRACE RARROW RPAREN
%nonassoc LSQBRACE LBRACE LARROW LPAREN
%nonassoc COLON
%nonassoc COMMA
%nonassoc NOELSE


%start program
%type <Ast.program> program

%right ASSIGN SUBASSIGN ADDASSIGN MULASSIGN DIVASSIGN
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
%right INCREMENT DECREMENT

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
//   | FUNCTION LT typ_list GT  { Fun ($3) }

// typ_list:
//   | typ {[$1]}
//   | typ COMMA typ_list {$1 :: $3}

/* fdecl */
fdecl:
  | DEFINE vdecl LPAREN formals_opt RPAREN LBRACE stmt_list RBRACE
  {
    {
      rtyp=fst $2;
      fname=snd $2;
      formals= $4;
      body= $7
    }
  }
  | DEFINE vdecl LPAREN formals_opt RPAREN ANON expr SEMI
  {
    {
      rtyp=fst $2;
      fname=snd $2;
      formals= $4;
      body= [Return $7]
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
  | open_stmt           {$1}
  | closed_stmt    {$1}

open_stmt: 
    IF LPAREN expr RPAREN stmt                        { If($3, $5) }
  | IF LPAREN expr RPAREN closed_stmt ELSE open_stmt  { IfElse($3, $5, $7) }
  | WHILE LPAREN expr RPAREN open_stmt                { While ($3, $5)  }
  | FOR LPAREN stmt expr SEMI expr RPAREN open_stmt   { For ($3, $4, $6, $8) }
  | SWITCH expr COLON switch_cases                    { 
                                                        let rec build_switch cases = 
                                                        match cases with
                                                        | [default_stmt] -> snd default_stmt 
                                                        | hd::tl -> IfElse(Binop($2, Equal, fst hd), snd hd, build_switch tl)
                                                        | _ -> raise (Failure ("Parse error: no cases in switch"))
                                                        in
                                                        build_switch $4
                                                      } 
  // | LBRACE stmt_list RBRACE                          { Block $2 }

closed_stmt: 
  non_if_stmt {$1}
  | IF LPAREN expr RPAREN closed_stmt ELSE closed_stmt { IfElse($3, $5, $7) }
  | WHILE LPAREN expr RPAREN closed_stmt               { While ($3, $5)  }
  | FOR LPAREN stmt expr SEMI expr RPAREN closed_stmt  { For ($3, $4, $6, $8) }
  // 

non_if_stmt:
  | LBRACE stmt_list RBRACE                          { Block $2 }
  | expr SEMI                                        { Expr $1      }
  | CONTINUE SEMI                                    { Continue }
  | BREAK SEMI                                       { Break }
  /* return (ONLY allowed in functions) */
  | RETURN expr SEMI                                 { Return $2      }
  /* declaration */
  | typ ID SEMI                                      { Declare ($1, $2)       }
  /* declaration + assignment */
  | typ ID ASSIGN expr SEMI                          { DeclAssign($1, $2, $4) }

switch_cases:
  | DEFAULT COLON stmt                          {[(BoolLit(true), $3)]}
  | CASE expr COLON stmt switch_cases {($2, $4) :: $5}

expr:
  /* nesting */
   LPAREN expr RPAREN  { $2                     }
  /* literals and id */
  | INT_LITERAL         { Literal($1)            }
  | STRING_LITERAL      { StrLit($1)             }
  | FLOAT_LITERAL       { FloatLit($1)           }
  | BLIT                { BoolLit($1)            }
  | ID                  { Id($1)                 }
  /* arithmetic operators */
  | expr ADD   expr     { Binop($1, Add,   $3)   }
  | expr SUBTRACT  expr { Binop($1, Sub,   $3)   }
  | expr MULTIPLY  expr { Binop($1, Mul,   $3)   }
  | expr DIVIDE    expr { Binop($1, Div,   $3)   }
  | expr MOD       expr { Binop($1, Mod,   $3)   }
  /* relational operators */
  | expr EQ     expr    { Binop($1, Equal, $3)   }
  | expr NEQ    expr    { Binop($1, Neq, $3)     }
  | expr LT     expr    { Binop($1, Less,  $3)   }
  | expr GT     expr    { Binop($1, Greater,  $3)   }
  | expr GEQ    expr    { Binop($1, Geq,  $3)   }
  | expr LEQ    expr    { Binop($1, Leq,  $3)   }
  /* logical operators */
  | expr AND    expr    { Binop($1, And,   $3)   }
  | expr OR     expr    { Binop($1, Or,    $3)   }
  | NOT expr            { Unop(Not, $2)          }
  | SUBTRACT expr       { Unop(Neg, $2)          }
  /* assignment */
  | ID ASSIGN expr      { Assign($1, $3)         }
  | ID ADDASSIGN expr   { Assign($1, Binop(Id($1), Add, $3))}
  | ID SUBASSIGN expr   { Assign($1, Binop(Id($1), Sub, $3))}
  | ID MULASSIGN expr   { Assign($1, Binop(Id($1), Mul, $3))}
  | ID DIVASSIGN expr   { Assign($1, Binop(Id($1), Div, $3))}
  | ID INCREMENT        { Assign($1, Binop(Id($1), Add, Literal(1)))}
  | ID DECREMENT        { Assign($1, Binop(Id($1), Sub, Literal(1)))}

  /* id call */
  | ID LPAREN args_opt RPAREN  { Call ($1, $3)   }
  | STDIN                      { Stdin(Literal(0))}
  | STDIN LPAREN expr RPAREN   { Stdin($3) }
  | STDOUT LPAREN expr RPAREN  { Stdout($3) }

  /* arrays! */
  | LSQBRACE args_opt RSQBRACE { ArrayLit($2) }
  | ID LSQBRACE expr RSQBRACE  { ArrayAccess($1, $3) }
  | ID LSQBRACE expr RSQBRACE ASSIGN expr  { ArrayAssign($1, $3, $6) }

  /* PIPING (alternate id call)*/
  | piping              { $1 }

piping:
  /* PIPING (alternate id call)*/
    expr PIPE ID LPAREN args_opt RPAREN  { Call ($3, $1::$5) }
  | expr PIPE ID                         { Call ($3, [$1]) }
  | expr PIPE STDIN                      { Stdout($1) }
  | expr PIPE STDOUT                     { Stdout($1) }

/* args_opt*/
args_opt:
  /*nothing*/ { [] }
  | args { $1 }

args:
  expr  { [$1] }
  | expr COMMA args { $1::$3 }