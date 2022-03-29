(* Abstract Syntax Tree and functions for printing it *)

type operator = Add | Sub | Mul | Div | Mod | Equal | Neq | Less |
 Leq | Greater | Geq | And | Or | Pipe 

type uop = Neg | Not

type typ = Int | Float | Bool | Char | String | Sym | Arr of (typ * int)

(* int x: name binding *)
type bind = typ * string

type expr =
  Literal of int
| FLit of string
| BoolLit of bool
| CharLit of char
| StrLit of string
| SymLit of string
| ArrayLit of expr list
| ArrAssign of string * expr * expr
| ArrLength of expr
| ArrayAccess of string * expr
| Id of string
| Binop of expr * op * expr
| Unop of uop * expr
| Seq of expr * expr
| Assign of string * expr
| DeclAssn of typ * string * expr
| Call of string * expr list
| Increment of string * expr 
| Decrement of string * expr
| Noexpr


type stmt =
  Block of stmt list
| Expr of expr
| If of expr * stmt * stmt
| For of expr * expr * expr * stmt
| While of expr * stmt
| Return of expr
| Continue of expr
| Break of expr


(* func_def: ret_typ fname formals locals body *)
type func_def = {
  rtyp: typ;
  fname: string;
  formals: bind list;
  locals: bind list;
  body: stmt list;
}

type program = stmt list * bind list * func_decl list

(* Pretty-printing functions *)

let string_of_op = function
    Add -> "+"
  | Sub -> "-"
  | Mul -> "*"
  | Div -> "/"
  | Mod -> "%"
  | Equal -> "=="
  | Neq -> "!="
  | Less -> "<"
  | Leq -> "<="
  | Greater -> ">"
  | Geq -> "=>"
  | And -> "&&"
  | Or -> "||"
  | Pipe -> "|>"

let string_of_uop = function
    Neg -> "-"
  | Not -> "!"


let rec string_of_typ = function
  Int -> "int"
| Float -> "float"
| Bool -> "bool"
| Char -> "char"
| String -> "str"
| Sym -> "sym"
| Arr(t, _) -> string_of_typ t ^ "[]"


let rec string_of_expr = function
    Literal(l) -> string_of_int l
  | FLit(l) -> l
  | BoolLit(true) -> "true"
  | BoolLit(false) -> "false"
  | CharLit(c) -> c
  | StrLit(s) -> s
  | SymLit(s) -> s
  | ArrayDecl(t, s, e) -> "arr" ^ "<" string_of_typ t ^ ">" ^ " " ^  s ^ " = " ^ "[" ^ String.concat "," (List.map string_of_expr (List.rev e)) ^ "]"
  | ArrayLit(e) -> "[" ^ String.concat "," (List.map string_of_expr (List.rev e)) ^ "]"
  | ArrayAccess (s, e) ->  s ^ "[" ^ string_of_expr e ^ "]"
  | ArrAssign(s, e1, e2) -> s ^ "[" ^ string_of_expr e1 ^ "] = " ^ string_of_expr  e2
  | Id(s) -> s
  | Binop(e1, o, e2) ->
      string_of_expr e1 ^ " " ^ string_of_op o ^ " " ^ string_of_expr e2
  | Assign(v, e) -> v ^ " = " ^ string_of_expr e
  | DeclAssn(t, s, e) -> string_of_typ t ^ " " ^ s ^ " = " ^ string_of_expr e 
  | Call(f, el) ->
      f ^ "(" ^ String.concat ", " (List.map string_of_expr el) ^ ")"
  | Increment(v, e) -> v ^ "+= " ^ string_of_expr e
  | Decrement(v, e) -> v ^ "-="  ^ string_of_expr e 
  | Noexpr -> ""

let rec string_of_stmt = function
    Block(stmts) ->
      "{\n" ^ String.concat "" (List.map string_of_stmt stmts) ^ "}\n"
  | Expr(expr) -> string_of_expr expr ^ ";\n";
  | Return(expr) -> "return " ^ string_of_expr expr ^ ";\n";
  | If(e, s, Block([])) -> "if (" ^ string_of_expr e ^ ")" ^ "{" ^ string_of_stmt s ^ "};"
  | If(e, s1, s2) ->  "if (" ^ string_of_expr e ^ ")" ^ "{" ^
      string_of_stmt s1 ^ "}" ^ "else" ^ "{" ^ string_of_stmt s2 ^ "};"
  | If(e,e2 s1, s2,s3) ->  "if (" ^ string_of_expr e ^ ")" ^ "{\n" ^
      string_of_stmt s1 ^ "\n}" ^ "elseif (" ^ string_of_expr e2 ^ ")" ^ "{\n" ^ string_of_stmt s2 ^ "\n}"
       ^ "else {\n" ^ string_of_stmt s3 "\n}"
  | For(e1, e2, e3, s) ->
      "for (" ^ string_of_expr e1  ^ " ; " ^ string_of_expr e2 ^ " ; " ^
      string_of_expr e3  ^ ") " ^ "{" string_of_stmt s ^ "}"
  | While(e, s) -> "while (" ^ string_of_expr e ^ ") " ^ "{" ^ string_of_stmt s ^ "}"
  | Contiune(s) -> string_of_stmt  s
  | Break(s) ->  string_of_stmt  s


let string_of_vdecl (t, id) = string_of_typ t ^ " " ^ id ^ ";\n"

let string_of_fdecl fdecl =
  "def" ^ " " ^ string_of_typ fdecl.typ ^ " " ^
  fdecl.fname ^ "(" String.concat ", " (List.map snd fdecl.formals) ^
  ")\n{\n" ^
  String.concat "" (List.map string_of_vdecl fdecl.locals) ^
  String.concat "" (List.map string_of_stmt fdecl.body) ^
  "}\n"

let string_of_program (vars, funcs) =
  "\n\nParsed program: \n\n" ^
  String.concat "" (List.map string_of_stmt stmts) ^
  String.concat "" (List.map string_of_vdecl vars) ^ "\n" ^
  String.concat "\n" (List.map string_of_fdecl funcs)
