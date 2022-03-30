(* Abstract Syntax Tree and functions for printing it *)

type op = Add | Sub | Mul | Div | Mod | Equal | Neq | Less |
 Leq | Greater | Geq | And | Or | Pipe 

type uop = Neg | Not

type typ = Int | Float | Bool | Char | String | Sym | Arr of typ

(* int x: name binding *)
type bind = typ * string

type expr =
  Literal of int
| FloatLit of float
| BoolLit of bool
| CharLit of char
| StrLit of string
| SymLit of string
| ArrayLit of expr list
| ArrayAccess of string * expr
| ArrayAssign of string * expr * expr
| Id of string
| Binop of expr * op * expr
| Unop of uop * expr
| Assign of string * expr
| Lambda of string * expr
| DeclAssign of typ * string * expr
| Call of string * expr list
(* | Increment of string * expr 
| Decrement of string * expr *)
(* | Noexpr *)


type stmt =
  Block of stmt list
| Expr of expr
| If of expr * stmt
| IfElse of expr * stmt * stmt
| For of expr * expr * expr * stmt
| While of expr * stmt
| Return of expr
| Continue
| Break


(* func_def: ret_typ fname formals locals body *)
type func_def = {
  rtyp: typ;
  fname: string;
  formals: bind list;
  body: stmt list;
}

type program = stmt list * func_def list

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
| Arr(t) -> string_of_typ t ^ "[]"


let rec string_of_expr = function
    Literal(l) -> string_of_int l
  | FloatLit(l) -> string_of_float l
  | BoolLit(true) -> "true"
  | BoolLit(false) -> "false"
  | CharLit(c) -> String.make 1 c
  | StrLit(s) -> s
  | SymLit(s) -> s (* List.rev e below ? *)
  | ArrayLit(e) -> "[" ^ String.concat "," (List.map string_of_expr (List.rev e)) ^ "]"
  | ArrayAccess (s, e) ->  s ^ "[" ^ string_of_expr e ^ "]"
  | ArrayAssign(s, e1, e2) -> s ^ "[" ^ string_of_expr e1 ^ "] = " ^ string_of_expr  e2
  | Id(s) -> s
  | Binop(e1, o, e2) ->
      string_of_expr e1 ^ " " ^ string_of_op o ^ " " ^ string_of_expr e2
  | Unop(op, e) -> string_of_uop op ^ " " ^ string_of_expr e
  | Assign(v, e) -> v ^ " = " ^ string_of_expr e
  | Lambda(v, e) -> v ^ " => " ^ string_of_expr e
  | DeclAssign(t, s, e) -> string_of_typ t ^ " " ^ s ^ " = " ^ string_of_expr e
  | Call(f, el) ->
      f ^ "(" ^ String.concat ", " (List.map string_of_expr el) ^ ")"
  (* | Increment(v, e) -> v ^ "+= " ^ string_of_expr e
  | Decrement(v, e) -> v ^ "-="  ^ string_of_expr e 
  | Noexpr -> "" *)

let rec string_of_stmt = function
    Block(stmts) ->
      "{\n" ^ String.concat "" (List.map string_of_stmt stmts) ^ "}\n"
  | Expr(expr) -> string_of_expr expr ^ ";\n";
  | Return(expr) -> "return " ^ string_of_expr expr ^ ";\n";
  | If(e, s) -> "if (" ^ string_of_expr e ^ ")"  ^ string_of_stmt s ^ ";"
  | IfElse(e, s1, s2) ->  "if (" ^ string_of_expr e ^ ")"  ^
      string_of_stmt s1  ^ "else"  ^ string_of_stmt s2 ^ ";"
  | For(e1, e2, e3, s) ->
      "for (" ^ string_of_expr e1  ^ " ; " ^ string_of_expr e2 ^ " ; " ^
      string_of_expr e3  ^ ") " ^ "{" ^ string_of_stmt s ^ "}"
  | While(e, s) -> "while (" ^ string_of_expr e ^ ") " ^ "{" ^ string_of_stmt s ^ "}"
  | Continue -> "continue;\n"
  | Break ->  "break;\n"


let string_of_vdecl (t, id) = string_of_typ t ^ " " ^ id ^ ";\n"

let string_of_fdecl fdecl =
  "def" ^ " " ^ string_of_typ fdecl.rtyp ^ " " ^
  fdecl.fname ^ "(" ^ String.concat ", " (List.map snd fdecl.formals) ^
  ")\n{\n" ^
  String.concat "" (List.map string_of_stmt fdecl.body) ^
  "}\n"

let string_of_program (statements, funcs) =
    "\n\nParsed program: \n\n" ^
    String.concat "" (List.map string_of_stmt statements) ^ "\n" ^
    String.concat "\n" (List.map string_of_fdecl funcs)

