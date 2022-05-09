(* Abstract Syntax Tree and functions for printing it *)
open Ast 

type sexpr = typ * sx

and sx =
  SLiteral of int
| SFloatLit of float
| SBoolLit of bool
(* | SCharLit of char *)
| SStrLit of string
(* | SSymLit of string *)
| SArrayLit of sexpr list
| SArrayAccess of string * sexpr
| SArrayAssign of string * sexpr * sexpr
| SId of string
| SBinop of sexpr * op * sexpr
| SUnop of uop * sexpr
| SAssign of string * sexpr

| SCall of string * sexpr list
(* | SLambda of string list * sexpr *)
(* | SIncrement of string * sexpr 
| SDecrement of string * sexpr
| SNoexpr *)


type sstmt =
  SBlock of sstmt list
| SExpr of sexpr
| SIf of sexpr * sstmt
| SIfElse of sexpr * sstmt * sstmt
| SFor of sstmt * sexpr * sexpr * sstmt
| SWhile of sexpr * sstmt
| SReturn of sexpr
| SContinue 
| SBreak 
| SDeclare of typ * string
| SDeclAssign of typ * string * sexpr


(* func_def: ret_typ fname formals locals body *)
type sfunc_def = {
  srtyp: typ;
  sfname: string;
  sformals: bind list;
  sbody: sstmt list;
}

type program = sstmt list * sfunc_def list

(* Pretty-printing functions *)

let rec string_of_sexpr (t, e) =
  "(" ^ string_of_typ t ^ " : " ^ 
  (
  match e with
  | SLiteral(l) -> string_of_int l
  | SFloatLit(l) -> string_of_float l
  | SBoolLit(true) -> "true"
  | SBoolLit(false) -> "false"
  (* | SCharLit(c) -> String.make 1 c *)
  | SStrLit(s) -> s
  (* | SSymLit(s) -> s *)
  | SArrayLit(e) -> "[" ^ String.concat "," (List.map string_of_sexpr (List.rev e)) ^ "]"
  | SArrayAccess (s, e) ->  s ^ "[" ^ string_of_sexpr e ^ "]"
  | SArrayAssign(s, e1, e2) -> s ^ "[" ^ string_of_sexpr e1 ^ "] = " ^ string_of_sexpr  e2
  | SId(s) -> s
  | SBinop(e1, o, e2) ->
     string_of_sexpr e1 ^ " " ^ string_of_op o ^ " " ^ string_of_sexpr e2
  | SUnop(op, e) -> string_of_uop op ^ " " ^ string_of_sexpr e
  | SAssign(v, e) -> v ^ " = " ^ string_of_sexpr e
  (* | SLambda(v, e) -> "( " ^ (List.hd v) ^ " ) => " ^ string_of_sexpr e *)
  | SCall(f, el) -> f ^ "(" ^ String.concat ", " (List.map string_of_sexpr el) ^ ")"
  )
  ^ ")"

let rec string_of_sstmt = function
    SBlock(stmts) ->
      "{\n" ^ String.concat "" (List.map string_of_sstmt stmts) ^ "}\n"
  | SExpr(expr) -> string_of_sexpr expr ^ ";\n";
  | SReturn(expr) -> "return " ^ string_of_sexpr expr ^ ";\n";
  | SIf(e, s) -> "if (" ^ string_of_sexpr e ^ ")"  ^ string_of_sstmt s ^ ";"
  | SIfElse(e, s1, s2) ->  "if (" ^ string_of_sexpr e ^ ")"  ^
      string_of_sstmt s1  ^ "else"  ^ string_of_sstmt s2 ^ ";"
  | SFor(e1, e2, e3, s) -> let decl = string_of_sstmt e1 in
       "for (" ^ String.sub decl 0 ((String.length decl) - 2)  ^ "; " 
       ^ string_of_sexpr e2 ^ " ; " ^
      string_of_sexpr e3  ^ ") " ^ "{" ^ string_of_sstmt s ^ "}"
  | SWhile(e, s) -> "while (" ^ string_of_sexpr e ^ ") "  ^ string_of_sstmt s 
  | SContinue -> "continue;\n"
  | SBreak ->  "break;\n"
  | SDeclare(t, s) -> string_of_typ t ^ " " ^ s ^ ";\n"
  | SDeclAssign(t, s, e) -> string_of_typ t ^ " " ^ s ^ " = " ^ string_of_sexpr e ^ ";\n"


let string_of_sfdecl fdecl =
  "def" ^ " " ^ string_of_typ fdecl.srtyp ^ " " ^
  fdecl.sfname ^ "(" ^ String.concat ", " (List.map snd fdecl.sformals) ^
  ")\n{\n" ^
  String.concat "" (List.map string_of_sstmt fdecl.sbody) ^
  "}\n"

let string_of_sprogram (statements, funcs) =
  "\n\nParsed program: \n\n" ^
  String.concat "" (List.map string_of_sstmt statements) ^ "\n" ^
  String.concat "\n" (List.map string_of_sfdecl funcs)
