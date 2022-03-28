(* Semantically-checked  Abstract Syntax Tree and functions for printing it *)
open Ast

type sbind = typ * string

type sexpr =
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
| SSeq of sexpr * sexpr
| SAssign of string * sexpr
| SDeclAssn of typ * string * sexpr
| SCall of string * sexpr list
| SNoexpr


type sstmt =
  SBlock of sstmt list
| SExpr of sexpr
| SIf of sexpr * sstmt * sstmt
| SFor of sexpr * sexpr * sexpr * sstmt
| SWhile of sexpr * sstmt
| SReturn of sstmt
| SContinue of sstmt


(* func_def: ret_typ fname formals locals body *)
type sfunc_def = {
  srtyp: typ;
  sfname: string;
  sformals: sbind list;
  slocals: sbind list;
  sbody: stmt list;
}

type sprogram = sstmt list * sbind list * sfunc_decl list



(* Pretty-printing functions *)


let rec string_of_sexpr (t,e)= 
  "(" ^ string_of_typ t ^ " : " ^ ( match w with 
    SLiteral(l) -> string_of_int l
  | SFLit(l) -> l
  | SBoolLit(true) -> "true"
  | SBoolLit(false) -> "false"
  | SCharLit(c) -> c
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
    SBlock(stmts) ->
      "{\n" ^ String.concat "" (List.map string_of_sstmt stmts) ^ "}\n"
  | SExpr(expr) -> string_of_sexpr expr ^ ";\n";
  | SReturn(expr) -> "return " ^ string_of_sexpr expr ^ ";\n";
  | SIf(e, s, Block([])) -> "if (" ^ string_of_sexpr e ^ ")" ^ "{" ^ string_of_sstmt s ^ "};"
  | SIf(e, s1, s2) ->  "if (" ^ string_of_sexpr e ^ ")" ^ "{" ^
  string_of_sstmt s1 ^ "}" ^ "else" ^ "{" ^ string_of_sstmt s2 ^ "};"
  | SFor(e1, e2, e3, s) ->
      "for (" ^ string_of_sexpr e1  ^ " ; " ^ string_of_sexpr e2 ^ " ; " ^
      string_of_sexpr e3  ^ ") " ^ "{" string_of_sstmt s ^ "};"
  | SWhile(e, s) -> "while (" ^ string_of_sexpr e ^ ") " ^ "{" ^ string_of_sstmt s ^ "};"
  | SContiune(s) -> string_of_sstmt  s
  | SBreak(s) ->  string_of_sstmt  s


let string_of_sfdecl fdecl =
  "def" ^ " " ^ "<" ^ string_of_typ fdecl.srtyp ^ ">" ^ " " ^
  fdecl.sfname ^ "(" String.concat ", " (List.map snd fdecl.sformals) ^
  ")\n{\n" ^
  String.concat "" (List.map string_of_vdecl fdecl.slocals) ^
  String.concat "" (List.map string_of_sstmt fdecl.sbody) ^
  "};\n"


let string_of_sprogram (vars, funcs) =
  "\n\nParsed program: \n\n" ^
  String.concat "" (List.map string_of_vdecl vars) ^ "\n" ^
  String.concat "\n" (List.map string_of_sfdecl funcs)
