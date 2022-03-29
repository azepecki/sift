(* Abstract Syntax Tree and functions for printing it *)
open Ast 

type sexpr = typ * sx
and sx =
  SLiteral of int
| SFLit of string
| SBoolLit of bool
| SCharLit of char
| SStrLit of string
| SSymLit of string
| SArrayLit of sexpr list
| SArrAssign of string * sexpr * sexpr
| SArrLength of sexpr
| SArrayAccess of string * sexpr
| SId of string
| SBinop of sexpr * op * sexpr
| SUnop of uop * sexpr
| SSeq of sexpr * sexpr
| SAssign of string * sexpr
| SDeclAssn of typ * string * sexpr
| SCall of string * sexpr list
| SIncrement of string * sexpr 
| SDecrement of string * sexpr
| SNoexpr


type sstmt =
  SBlock of sstmt list
| SExpr of sexpr
| SIf of sexpr * sstmt * sstmt
| SFor of sexpr * sexpr * sexpr * sstmt
| SWhile of sexpr * sstmt
| SReturn of sexpr
| SContinue of sexpr
| SBreak of sexpr


(* func_def: ret_typ fname formals locals body *)
type sfunc_def = {
  srtyp: typ;
  sfname: string;
  sformals: bind list;
  slocals: bind list;
  sbody: sstmt list;
}

type program = sstmt list * bind list * sfunc_decl list

(* Pretty-printing functions *)

let rec string_of_sexpr (t, e) =
  "(" ^ string_of_typ t ^ " : " ^ (match e with
    SLiteral(l) -> string_of_int l
  | SFLit(l) -> l
  | SBoolLit(true) -> "true"
  | SBoolLit(false) -> "false"
  | SCharLit(c) -> String.make 1 c
  | SStrLit(s) -> s
  | SSymLit(s) -> s
  | SArrayDecl(t, s, e) -> "arr" ^ "<" string_of_typ t ^ ">" ^ " " ^  s ^ " = " ^ "[" ^ String.concat "," (List.map string_of_sexpr (List.rev e)) ^ "]"
  | SArrayLit(e) -> "[" ^ String.concat "," (List.map string_of_sexpr (List.rev e)) ^ "]"
  | SArrayAccess (s, e) ->  s ^ "[" ^ string_of_sexpr e ^ "]"
  | SArrAssign(s, e1, e2) -> s ^ "[" ^ string_of_sexpr e1 ^ "] = " ^ string_of_sexpr  e2
  | SId(s) -> s
  | SBinop(e1, o, e2) ->
     string_of_sexpr e1 ^ " " ^ string_of_op o ^ " " ^ string_of_sexpr e2
  | SAssign(v, e) -> v ^ " = " ^ string_of_sexpr e
  | SDeclAssn(t, s, e) -> string_of_typ t ^ " " ^ s ^ " = " ^ string_of_sexpr e 
  | SCall(f, el) ->
      f ^ "(" ^ String.concat ", " (List.map string_of_sexpr el) ^ ")"
  | SIncrement(v, e) -> v ^ "+= " ^ string_of_sexpr e
  | SDecrement(v, e) -> v ^ "-="  ^ string_of_sexpr e 
  | SNoexpr -> ""
          ) ^ ")"	

let rec string_of_sstmt = function
    Block(stmts) ->
      "{\n" ^ String.concat "" (List.map string_of_sstmt stmts) ^ "}\n"
  | Expr(expr) -> string_of_sexpr expr ^ ";\n";
  | Return(expr) -> "return " ^ string_of_sexpr expr ^ ";\n";
  | If(e, s, Block([])) -> "if (" ^ string_of_sexpr e ^ ")" ^ "{" ^ string_of_sstmt s ^ "};"
  | If(e, s1, s2) ->  "if (" ^ string_of_sexpr e ^ ")" ^ "{" ^
  string_of_sstmt s1 ^ "}" ^ "else" ^ "{" ^ string_of_sstmt s2 ^ "};"
  | If(e,e2 s1, s2,s3) ->  "if (" ^ string_of_sexpr e ^ ")" ^ "{\n" ^
  string_of_sstmt s1 ^ "\n}" ^ "elseif (" ^ string_of_sexpr e2 ^ ")" ^ "{\n" ^ string_of_sstmt s2 ^ "\n}"
       ^ "else {\n" ^ string_of_sstmt s3 "\n}"
  | For(e1, e2, e3, s) ->
      "for (" ^ string_of_sexpr e1  ^ " ; " ^ string_of_sexpr e2 ^ " ; " ^
      string_of_sexpr e3  ^ ") " ^ "{" string_of_sstmt s ^ "}"
  | While(e, s) -> "while (" ^ string_of_sexpr e ^ ") " ^ "{" ^ string_of_sstmt s ^ "}"
  | Contiune(s) -> string_of_sstmt  s
  | Break(s) ->  string_of_sstmt  s


let string_of_sfdecl fdecl =
  "def" ^ " " ^ string_of_typ fdecl.styp ^ " " ^
  fdecl.sfname ^ "(" String.concat ", " (List.map snd fdecl.sformals) ^
  ")\n{\n" ^
  String.concat "" (List.map string_of_vdecl fdecl.slocals) ^
  String.concat "" (List.map string_of_sstmt fdecl.sbody) ^
  "}\n"

let string_of_sprogram (vars, funcs) =
  "\n\nParsed program: \n\n" ^
  String.concat "" (List.map string_of_sstmt stmts) ^
  String.concat "" (List.map string_of_vdecl vars) ^ "\n" ^
  String.concat "\n" (List.map string_of_sfdecl funcs)
