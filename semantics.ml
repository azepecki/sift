open Ast
open Sast

module StringMap = Map.Make(String);;

(* Custom symbol table implementation (linked list of string maps for scoping!) *)

type symbol_table = (Ast.typ StringMap.t) list;; (* Basically a linked list of string maps*)

(* Declares a new variable in current scope *)
(* int x; *)
let add (id : string) (t : Ast.typ) (table : symbol_table) : symbol_table =
  (* let current_scope :: tl = table in *)
  match table with
  | current_scope :: tl ->
  if StringMap.mem id current_scope
  then raise (Failure ("Variable " ^ (id)  ^ " already declared in current scope."))
  else (StringMap.add id t current_scope) :: tl
  | _ -> raise (Failure ("No scopes."))

(* Tries finding in current scope, if fails then goes up in symbol table *)
(* x; *)
let rec find (id : string) (table : symbol_table) : Ast.typ = 
  match table with 
  | []     -> raise (Failure ("Variable " ^ (id)  ^ " not in scope."))
  | h :: t -> if StringMap.mem id h
              then StringMap.find id h
              else find id t

(* Adds a new scope *)
let add_scope (table : symbol_table) : symbol_table = 
  StringMap.empty :: table

let new_table : symbol_table =
  [StringMap.empty]

let new_table_from_formals formals : symbol_table =
    [List.fold_left (fun x y -> StringMap.add (snd y) (fst y) x ) StringMap.empty formals ]

(* Removes most recent scope
let remove_scope (_ :: prev : symbol_table) : symbol_table = 
  prev *)

(* let check_script_scope (table : symbol_table) (s : Sast.sstmt) (statement : string): Sast.sstmt = 
  match table with
  | [_] -> raise (Failure ("Cannot do " ^ statement ^ " in global scope"))
  | _   -> s *)
  
let check_program (script: stmt list) (functions: func_def list) =

  let find_func fname = 
    match (List.find_opt (fun x -> x.fname = fname) functions) with
    | Some (fd) -> fd
    | None -> raise (Failure ("Function " ^ fname ^ " not defined"))
    in

  let rec check_expr (table: symbol_table) e : sexpr =
    
    let check_int_expr (table: symbol_table) e = 
      let e' = check_expr table e in
      if (fst e') = Int
      then e'
      else raise (Failure ("Expression of type int expected"))
    in

    match e with
    | Id var               -> (find var table, SId var)
    | Literal l               -> (Int, SLiteral l)
    | FloatLit l              -> (Float, SFloatLit l)
    | BoolLit l               -> (Bool, SBoolLit l)
    | StrLit l                -> (String, SStrLit l)
    (*ARRAY LITERAL: FIND THE TYPE OF THE INNER EXPRESSIONS, AND CHECK THEY ARE ALL EQUAL, THEN USE*)
    | ArrayLit lst -> let checked_lst = List.map (check_expr table) lst in
                      let typ = fst (List.hd checked_lst ) in
                      if List.for_all (fun x -> (=) typ (fst x) ) checked_lst 
                      then (Arr(typ), SArrayLit checked_lst) 
                      else raise (Failure ("Array literal expected only expressions of type " ^ Ast.string_of_typ typ) )
    (* ARRAY ACCESS: FIND TYPE OF ARRAY IN SYMBOL TABLE (if not there, error) *)
    | ArrayAccess (a, e_i)  ->  let a_typ = find a table in
                                (
                                match a_typ with
                                | Arr(typ) -> (typ, SArrayAccess (a, check_int_expr table e_i) )
                                | _ -> raise (Failure ("Tried indexing a non-array variable"))
                                (* | String indexing *)
                                )

    | ArrayAssign (a, e_i, e_v)  ->   let a_typ = find a table in
                                      (
                                      match a_typ with
                                      | Arr(typ) -> let (v_type, _ ) as e_v' = check_expr table e_v in
                                                    if v_type = typ
                                                    then (typ, SArrayAssign(a, check_int_expr table e_i, e_v'))
                                                    else raise (Failure ("Expression of type " ^ Ast.string_of_typ v_type ^ 
                                                                " cannot be assigned to array entry of type " ^ Ast.string_of_typ typ))
                                      | _ -> raise (Failure "Tried indexing a non-array variable")
                                      )
    | Binop (e1, op, e2)   -> let e1' = check_expr table e1 
                              and e2' = check_expr table e2 in
                              let typ1 = fst e1' 
                              and typ2 = fst e2' in
                              if typ1 = typ2 (* types must be equal in all binops SBinop(checked e1, op, checked e2) *)
                              then match op with
                                  | Add when typ1 = String                                   -> (String, SBinop(e1', op, e2'))
                                  (* List/Array concat: Add when typ1 = Arr -> (String, SBinop(e1', op, e2')) *)
                                  | Add | Sub | Mul | Div | Mod when typ1 = Int              -> (Int,    SBinop(e1', op, e2'))  
                                  | Add | Sub | Mul | Div when typ1 = Float                  -> (Float,  SBinop(e1', op, e2'))  
                                  | Equal | Neq | Less | Leq | Greater | Geq when typ1 = Int -> (Bool,   SBinop(e1', op, e2')) 
                                  | And | Or when typ1 = Bool                                -> (Bool,   SBinop(e1', op, e2'))  
                                  | _ -> raise (Failure ("Invalid operation " ^ Ast.string_of_op op ^ 
                                                " with argument types " ^ Ast.string_of_typ typ1 ^ 
                                                ", " ^ Ast.string_of_typ typ2) )
                              else raise (Failure ("Types not equal: " ^ Ast.string_of_typ typ1 ^ 
                                          ", " ^ Ast.string_of_typ typ2))
    | Unop (op, e)         -> let e' = check_expr table e in
                              let typ = fst e' in
                              (
                              match op with
                              | Not | Neg when typ = Bool -> (Bool, SUnop(op, e'))
                              | _ -> raise (Failure ("Invalid operation " ^ Ast.string_of_uop op ^ " with argument type " ^ Ast.string_of_typ typ) )
                              )

    | Assign (s, e) ->  let typ = find s table in
                        let e' = check_expr table e in
                        let v_type = (fst e') in
                        if v_type = typ
                        then (typ, SAssign(s, e'))
                        else raise (Failure ("Expression of type " ^ Ast.string_of_typ v_type ^ " cannot be assigned to variable of type " ^ Ast.string_of_typ typ))
    | Call(fname, args) as call ->
                            let fd = find_func fname in (*find function in symbol table*)
                            let param_length = List.length fd.formals in (*get length of input parameters*)
                            if List.length args != param_length then (* check if input parameters and input signature length equal*)
                              raise (Failure ("Expecting " ^ string_of_int param_length ^ (*if not, fail*)
                                              " arguments in " ^ string_of_expr call))
                            else  let check_call (ft, _) e = (*oooh, basically checks to see that function type equals arg type. Lol *)
                                    let (et, e') = check_expr table e in
                                    if ft = et
                                    then (et, e')
                                    else raise ( Failure ("Illegal argument found " ^ string_of_typ et ^
                                             ", expected " ^ string_of_typ ft ^ " in " ^ string_of_expr e))
                                  in
                                  let args' = List.map2 check_call fd.formals args (* Calls check_call on each (formal, arg) pair *)
                                  in (fd.rtyp, SCall(fname, args'))  
(* | Lambda (s, e) -> GET TYPE OF e (check_expr e), THEN _INFER_ TYPE OF s (WEIRD!) *)
  in

  let check_bool_expr (table: symbol_table) e : sexpr = 
    let e' = check_expr table e in
    if (fst e') = Bool
    then e'
    else raise (Failure ("Expression of type bool expected"))
  in

  let rec check_stmt_list (table: symbol_table) (func : Ast.func_def option) (lst : Ast.stmt list) : Sast.sstmt list =
    match lst with
    | [] -> []
    | s :: sl  -> let (s', updated_table) = check_stmt table s func in
                  s' :: (check_stmt_list updated_table func sl )
  (* Return a semantically-checked statement i.e. containing sexprs *)
  and check_stmt (table: symbol_table) (s : Ast.stmt) (func : Ast.func_def option): sstmt * symbol_table =
  (* Statements may follow a return (though we issue a warning if so) 
  
    CHECKS are applied to ensure that expressions are of a certain type in certain statements, 
    AND symbol table is always passed in and then the updated symbol table returned *)
    


    match s with                (*add new scope to table for this block, return old scope though*)
    | Block sl            -> (SBlock (check_stmt_list (add_scope table) func sl), table)
    | Expr e              -> (SExpr (check_expr table e), table)
    | IfElse(e, st1, st2) -> (SIfElse(check_bool_expr table e, fst (check_stmt table st1 func), fst (check_stmt table st2 func)), table)
    | If(e, st)          -> (SIf(check_bool_expr table e, fst (check_stmt table st func)), table)
    | While(e, st)        -> (SWhile(check_bool_expr table e, fst (check_stmt table st func)), table) 
    (* This for loop thing requires extra thought and care. Check that stmt is DeclAssign, add it to table, check that e2 is boolean *)
    | For(DeclAssign(typ, a, e) as e1, e2, e3, st) -> 
      let updated_table = add a typ table in
      (SFor(fst (check_stmt table e1 func), check_bool_expr updated_table e2, check_expr updated_table e3, fst (check_stmt updated_table st func)) , table)
    | For(_, _, _, _)     -> raise (Failure ("First statement in for loop must be assignment"))
    | Continue            -> (SContinue, table) (* Add proper checks!!! *)
    | Break               -> (SBreak , table) (* Add proper checks!!! *)
    | Return e            -> let (t, e') = check_expr table e in
                            (
                             match func with 
                             | Some (f_def) when t = f_def.rtyp -> (SReturn (t, e'), table)
                             | Some(f_def) -> raise (Failure ("Return gives " ^ string_of_typ t ^ " expected " ^
                                         string_of_typ f_def.rtyp ^ " in " ^ string_of_expr e)) 
                             | None -> raise (Failure ("Cannot do return in global scope") )
                            )
   
    | Declare (typ, s) ->  (SDeclare(typ, s), add s typ table)
    | DeclAssign (typ, s, e) -> 
        let updated_table = add s typ table in
        let e' = check_expr table e in (* does not use updated table because any var in e must exist beforehand *)
        let v_type = (fst e') in
        if v_type = typ
        then (SDeclAssign(typ, s, e'), updated_table)
        else raise (Failure ("Expression of type " ^ Ast.string_of_typ v_type ^ 
                    " cannot be assigned to variable of type " ^ Ast.string_of_typ typ))
    in 


    let rec check_return_stmt_list (lst : Ast.stmt list) =
      match lst with
      | [] -> false
      | hd::tl -> (
                  let hd_returns = check_return_stmt hd in
                  match tl with
                  | [] when hd_returns -> true 
                  | _ when hd_returns -> let () = Printf.eprintf "Warning: code after a return statement in some block\n" in true
                  | _ -> check_return_stmt_list tl
                  )
    and check_return_stmt (s : Ast.stmt) =
      match s with
      | Block sl -> check_return_stmt_list sl
      | Return _ -> true
      | IfElse(_, st1, st2) -> check_return_stmt st1 && check_return_stmt st2
      | If(_, st)           -> check_return_stmt st (* Supposed to also check if the condition is always true, ehhh *)
      | While(_, st)        -> check_return_stmt st (* Supposed to also check if the condition is always true, ehhh *)
      | For(_, _, _, st)    -> check_return_stmt st
      | _ -> false
    in
    let check_return_function (func : Ast.func_def) =
      check_return_stmt_list func.body
    in

    let check_func f = 
      if check_return_function f 
      then
      {
      srtyp = f.rtyp;
      sfname = f.fname;
      sformals = f.formals;
      sbody = check_stmt_list (new_table_from_formals f.formals) (Some(f)) f.body;
      }
      else raise (Failure ("Not all code paths return"))
    
    in

    let check_functions functions = 
      List.map (check_func) functions
    
    in

    let check_script script = 
      check_stmt_list (new_table) (None) script

    in
    
    let sscript = check_script script
    and sfunctions = check_functions functions
    in
    (sscript, sfunctions)