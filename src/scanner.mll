(* Ocamllex scanner for Sift *)

{ open Parser }

let digit = ['0' - '9']
let digits = digit+
let exponent = ['e' 'E'] ['+' '-']? digits

rule token = parse
  [' ' '\t' '\r' '\n'] { token lexbuf } (* Whitespace *)
| "/*"     { comment lexbuf }           (* Comments *)
(* parentheses and brackets *)
| '(' { LPAREN }
| ')' { RPAREN }
| '{' { LBRACE }
| '}' { RBRACE }
| '[' { LSQBRACE }
| ']' { RSQBRACE }
| '<' { LARROW }
| '>' { RARROW }

(* arithmetic operators *)
| '+' { ADD }
| '-' { SUBTRACT }
| '*' { MULTIPLY }
| '/' { DIVIDE }
| '^' { POWER }
| "%" { MOD }

(* relational operators *)
| "==" { EQ }
| ">=" { GEQ }
| '>' { GT }
| "<=" { LEQ }
| '<' { LT }
| "!=" { NEQ }

(* delimiters *)
| ',' { COMMA }
| ':' { COLON }
| ';' { SEMICOLON }
| '.' { DOT }

(* assignment *)
| "=" { ASSIGN }

(* pipe *)
| "|>" { PIPE }

(* logical operators *)
| "&&" { AND }
| "||" { OR }
| '!' { NOT }
| '^' { XOR }
(* Keywords *)
| "if" { IF }
| "elif" { ELIF }
| "else" { ELSE }
| "switch" { SWITCH }
| "case" { CASE }
| "for" { FOR }
| "while" { WHILE }
| "continue" { CONTINUE }
| "break" { BREAK }
| "return" { RETURN }
| "default" { DEFAULT }
| "lambda" { LAMBDA }
| "def" { DEFINE }
| "exit" { EXIT }
| "return" { RETURN }
| "null" { NULL }
| "import" { IMPORT }
| "from" { FROM }
| "list" { LIST }
| "tup" { TUP }
| "dict" { DICT }
| "pure" { PURE }
| "arr" { ARR }
| "set" { SET}
| "int" { INT }
| "float" { FLOAT }
| "bool" { BOOL }
| "str" { STRING }
| "sym" { SYMBOL }

(* identifiers and literals *)
| digits as lit { INT_LITERAL(int_of_string lit) }
| ['a'-'z''A'-'Z']['a'-'z''A'-'Z''0'-'9''_']* as id { ID(id) }
| ('"'[^'"''\\']*('\\'_[^'"''\\']*)*'"') as str { STRING_LITERAL(String.sub str 1 (String.length str - 2)) }
| (digits '.' digit* exponent? | digits exponent | '.' digits exponent?) as lit { FLOAT_LITERAL(float_of_string lit) }
| eof { EOF }

(* handle illegal character*)
| _ as ch {raise (Failure("illegal character " ^ Char.escaped ch))}
and comment_line = parse
 '#' { tokenize lexbuf }
| _ { comment_line lexbuf }

and comment_block = parse
 "*/" { tokenize lexbuf }
| _ { comment_block lexbuf }
