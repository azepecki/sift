open Ast
open Sast

module StringMap = Map.Make(String)

(* type symbl_tbl = {symbols: StringMap ; parent: symbl_tbl} in *)

(* Semantic checking of the AST. Returns an SAST if successful,
   throws an exception if something is wrong.

   Check the core script logic, then check each function *)

let check_program (script: stmt list) (functions: func_def list) =

  let check_expr e =
    function
    | Literal l               -> (Int, SLiteral l)
    | FloatLit l              -> (Float, SFloatLit l)
    | BoolLit l               -> (Bool, SBoolLit l)
    | StrLit l                -> (String, SStrLit l)
    (*ARRAY LITERAL: FIND THE TYPE OF THE INNER EXPRESSIONS, AND CHECK THEY ARE ALL EQUAL, THEN USE*)
  (*| ArrayLit lst -> let checked_lst = List.map check_expr lst in
                      if THEY ALL HAVE SAME TYPE typ IN checked_lst 
                      then (Arr(typ), checked_lst) 
                      else raise (Failure "array expected expression of type {typ}")*)
  (*| ArrayAccess (a, ei)     -> let typ = GET TYPE OF ELEMENTS OF ARRAY in
                                 if ei IS NOT TYPE INT (ei is an expr so do check_expr ei)
                                 then Failure
                                 else SArrayAccess(typ, checked ei) *)
  (*| ArrayAssign (a, ei, ev) -> let typ = GET TYPE OF ELEMENTS OF ARRAY in
                                 if ei IS NOT TYPE INT (ei is an expr so do check_expr ei)
                                 then Failure
                                 else if TYPE OF ev IS NOT typ (use check_expr ev)
                                      then FAILURE 
                                      else SArrayAssign(typ, checked ei, checked ev) *)
  (*| Id var                -> (GET TYPE OF var FROM SYMBOL TABLE, SId var) *)
  (*| Binop (e1, op, e2)      -> USE check_expr e1, check_expr e2 TO GET THEIR TYPES (typ1, typ2)
                               IF NOT EQUAL THEN FAIL, ELSE, NOW CHECK IF THE OPERATION IS APPROPRIATE
                               IF NOT THEN FAIL, ELSE SBinop(checked e1, op, checked e2) 
                               
                               DO EXTRA WEIRD STUFF IF PIPE????*)
  (*| Unop (op, e)            -> GET TYPE OF e (check_expr e), check if it is appropriate to op. if so
                               then just SUnop(typ, checked e) *)
  | Call(fname, args) as call ->
    let fd = find_func fname in (*find function in symbol table*)
    let param_length = List.length fd.formals in (*get length of input parameters*)
    if List.length args != param_length then (* check if input parameters and input signature length equal*)
      raise (Failure ("expecting " ^ string_of_int param_length ^ (*if not, fail*)
                      " arguments in " ^ string_of_expr call))
    else let check_call (ft, _) e = (*i dont know what this is*)
           let (et, e') = check_expr e in
           let err = "illegal argument found " ^ string_of_typ et ^
                     " expected " ^ string_of_typ ft ^ " in " ^ string_of_expr e
           in (check_assign ft et err, e')
      in
      let args' = List.map2 check_call fd.formals args
      in (fd.rtyp, SCall(fname, args'))

 (* | Assign (s, e)   ->  GET TYPE OF IDENTIFIER FROM SYMBOL TABLE (typ)
                          FIND TYPE of e (etyp) BY USING check_expr e 
                          IF DIFFERENT, ERROR
                          ELSE (typ, SAssign(s, checked e)) *)
(* | Lambda (s, e) -> GET TYPE OF e (check_expr e), THEN _INFER_ TYPE OF s (WEIRD!) *)
(* | DeclAssign (typ, s, e)  -> LIKE Assign BUT WE ADD TO THE SYMBOL TABLE!!!! *)


  let check_bool_expr e =
    let (t, e') = check_expr e in
    match t with
    | Bool -> (t, e')
    |  _ -> raise (Failure ("expected Boolean expression in " ^ string_of_expr e))
  in

  (*
  let check_decl_expr e =
    let (t, e') = check_expr e in
    match e' with
    | Bool -> (t, e')
    |  _ -> raise (Failure ("expected Boolean expression in " ^ string_of_expr e))
  in
  *)

  let rec check_stmt_list  =
    function
    | [] -> []
    | Block sl :: sl'  -> check_stmt_list  (sl @ sl') (* Flatten blocks *)
    | s :: sl -> check_stmt s :: check_stmt_list sl
  (* Return a semantically-checked statement i.e. containing sexprs *)
  and check_stmt =
    function (* A block is correct if each statement is correct and nothing follows any Return statement.  Nested blocks are flattened. *)
    | Block sl            -> SBlock (check_stmt_list sl)
    | Expr e              -> SExpr (check_expr e)
    | IfElse(e, st1, st2) -> SIfElse(check_bool_expr e, check_stmt st1, check_stmt st2)
    | While(e, st)        -> SWhile(check_bool_expr e, check_stmt st)
    | For(e1, e2, e3, st) -> SFor(check_expr e1, check_expr e2, check_expr e3, check_stmt st)
    | Continue            -> SContinue
    | Break               -> SBreak
    (*RETURN ONLY MAKES SENSE IN FUNCTIONS!!!!!*)
  (*| Return e            -> let (t, e') = check_expr e in
                             if t = func.rtyp then SReturn (t, e')
                             else raise (Failure ("return gives " ^ string_of_typ t ^ " expected " ^
                                         string_of_typ func.rtyp ^ " in " ^ string_of_expr e)) *)