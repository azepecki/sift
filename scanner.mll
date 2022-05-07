(* Ocamllex scanner for Sift *)

{ open Parser }

let digit = ['0' - '9']
let letter = ['a'-'z''A'-'Z']
let digits = digit+
let exponent = ['e' 'E'] ['+' '-']? digits

rule token = parse
  [' ' '\t' '\r' '\n'] { token lexbuf } (* Whitespace *)
(* parentheses and brackets *)
| '(' { LPAREN }
| ')' { RPAREN }
| '{' { LBRACE }
| '}' { RBRACE }
| '[' { LSQBRACE }
| ']' { RSQBRACE }

(* arithmetic operators *)
| '+' { ADD }
| '-' { SUBTRACT }
| '*' { MULTIPLY }
| '/' { DIVIDE }
| "%" { MOD }

(* relational operators *)
| "==" { EQ }
| ">=" { GEQ }
| '>'  { GT }
| "<=" { LEQ }
| '<'  { LT }
| "!=" { NEQ }

(* delimiters *)
| ',' { COMMA }
| ':' { COLON }
| ';' { SEMI }
| '.' { DOT }

(* assignment *)
| "=" { ASSIGN }
| "++" { INCREMENT }
| "--" { DECREMENT }

(* pipe *)
| "|>" { PIPE }
| "$"  { PLACEHOLDER }

(* anonymous function *)
| "=>" { ANON }

(* logical operators *)
| "&&" { AND }
| "||" { OR }
| '!'  { NOT }

(* data structures *)
| "arr"      { ARRAY }
| "tup"      { TUPLE }
| "list"     { LIST }
| "dict"     { DICT }
| "set"      { SET}

(* Keywords *)
| "if"       { IF }
| "elif"     { ELIF }
| "else"     { ELSE }
| "switch"   { SWITCH }
| "case"     { CASE }
| "for"      { FOR }
| "while"    { WHILE }
| "continue" { CONTINUE }
| "break"    { BREAK }
| "return"   { RETURN }
| "default"  { DEFAULT }
| "lambda"   { LAMBDA }
| "def"      { DEFINE }
| "exit"     { EXIT }
| "return"   { RETURN }
| "null"     { NULL }
| "import"   { IMPORT }
| "from"     { FROM }
| "pure"     { PURE }
| "int"      { INT }
| "float"    { FLOAT }
| "bool"     { BOOL }
| "str"      { STRING }
| "sym"      { SYMBOL }

(* identifiers and literals *)
| "true"                                { BLIT(true)  }
| "false"                               { BLIT(false) }
| digits as lit                         { INT_LITERAL(int_of_string lit) }
| '"' [ ^ '"' ]* '"' as lit             { STRING_LITERAL(if (String.length lit) = 2 then "" else String.sub lit (1) (String.length lit-2))} 
| (digits '.' digit* exponent? 
    | digits exponent 
    | '.' digits exponent?) as lit      { FLOAT_LITERAL(float_of_string lit) }
| letter (letter | digit | '_')* as id  { ID(id) }
| eof { EOF }
