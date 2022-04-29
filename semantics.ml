open Ast
open Sast

module StringMap = Map.Make(String);;

type symbol_table = (Ast.typ StringMap.t) list;; (* Basically a linked list of string maps*)

(* Semantic checking of the AST. Returns an SAST if successful,
   throws an exception if something is wrong.

   Check the core script logic, then check each function *)

let check_program (script: stmt list) (functions: func_def list) =

  let rec check_stmt_list (symbol_table: Ast.typ StringMap.t) =
    function
    | [] -> []
    | Block sl :: sl'  -> check_stmt_list symbol_table (sl @ sl') (* Flatten blocks *)
    | s :: sl -> check_stmt symbol_table s :: check_stmt_list symbol_table sl
  (* Return a semantically-checked statement i.e. containing sexprs *)
  and check_stmt (symbol_table: Ast.typ StringMap.t) =
  (* A block is correct if each statement is correct and nothing follows any Return statement.  
    Nested blocks are flattened. 
  
    CHECKS are applied to ensure that expressions are of a certain type in certain statements, 
    AND symbol table is always passed in and then the updated symbol table returned *)

    let rec check_expr (symbol_table: Ast.typ StringMap.t) e : sexpr =

      let check_type_expr (symbol_table: Ast.typ StringMap.t) e (t : Ast.typ) =
        let e' = check_expr symbol_table e in
        if (fst e') = Int
        then e'
        else raise (Failure ("Expression of type " ^ (Ast.string_of_typ t)  ^ " expected"))
      in
    
      let check_int_expr (symbol_table: Ast.typ StringMap.t) e = 
        check_type_expr symbol_table e Int
      in
    
      let check_bool_expr (symbol_table: Ast.typ StringMap.t) e = 
        check_type_expr symbol_table e Bool
      in
  
      match e with
      | Literal l               -> (Int, SLiteral l)
      | FloatLit l              -> (Float, SFloatLit l)
      | BoolLit l               -> (Bool, SBoolLit l)
      | StrLit l                -> (String, SStrLit l)
      (*ARRAY LITERAL: FIND THE TYPE OF THE INNER EXPRESSIONS, AND CHECK THEY ARE ALL EQUAL, THEN USE*)
      | ArrayLit lst -> let checked_lst = List.map (check_expr symbol_table) lst in
                        let typ = fst (List.hd checked_lst ) in
                        if List.for_all (fun x -> (=) typ (fst x) ) checked_lst 
                        then (Arr(typ), SArrayLit checked_lst) 
                        else raise (Failure ("Array literal expected only expressions of type " ^ Ast.string_of_typ typ) )
      (* ARRAY ACCESS: FIND TYPE OF ARRAY IN SYMBOL TABLE (if not there, error) *)
      | ArrayAccess (a, e_i)  ->  if StringMap.mem a symbol_table
                                  then let a_typ = StringMap.find a symbol_table in
                                      match a_typ with
                                      | Arr(typ) -> (typ, SArrayAccess (a, check_int_expr symbol_table e_i) )
                                      (* | String indexing *)
                                      | _ -> raise (Failure ("Tried indexing a non-array variable"))
                                  else raise (Failure ("Variable " ^ a ^ " not in scope"))
  
      | ArrayAssign (a, e_i, e_v)  -> if StringMap.mem a symbol_table
                                      then let a_typ = StringMap.find a symbol_table in
                                        match a_typ with
                                        | Arr(typ) -> let checked_e_v = check_expr symbol_table e_v in
                                                        let v_type = (fst checked_e_v) in
                                                        if v_type = typ
                                                        then (typ, SArrayAssign(a, check_int_expr symbol_table e_i, checked_e_v))
                                                        else raise (Failure ("Expression of type " ^ Ast.string_of_typ v_type ^ 
                                                                    " cannot be assigned to array entry of type " ^ Ast.string_of_typ typ))
                                      (*| String indexing *)
                                        | _ -> raise (Failure "Tried indexing a non-array variable")
                                      else raise (Failure "Array variable not in scope")
      | Id var               -> if StringMap.mem var symbol_table
                                then (StringMap.find var symbol_table, SId var)
                                else raise (Failure ("Variable " ^ var ^ " not in scope"))
        
      | Binop (e1, op, e2)     -> let e1' = check_expr symbol_table e1 
                                and e2' = check_expr symbol_table e2 in
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
      | Unop (op, e)         -> let e' = check_expr symbol_table e in
                                let typ = fst e' in
                                (
                                match op with
                                | Not | Neg when typ = Bool -> (Bool, SUnop(op, e'))
                                | _ -> raise (Failure ("Invalid operation " ^ Ast.string_of_uop op ^ 
                                              " with argument type " ^ Ast.string_of_typ typ) )
                                )
  
      | Assign (s, e) ->  if StringMap.mem s symbol_table
                          then  let typ = StringMap.find s symbol_table in
                                let e' = check_expr symbol_table e in
                                let v_type = (fst e') in
                                if v_type = typ
                                then (typ, SAssign(s, e'))
                                else raise (Failure ("Expression of type " ^ Ast.string_of_typ v_type ^ 
                                            " cannot be assigned to variable of type " ^ Ast.string_of_typ typ))
                          else raise (Failure ("Variable not in scope"))
         (* | Declare (typ, s) -> *)
      (* | DeclAssign (typ, s, e) -> if StringMap.mem a symbol_table (* OH this is strange, how do i differentiate new scopes vs same scope overwriting?*)
                                then let typ = StringMap.find a symbol_table in
                                  let e' = check_expr symbol_table e in
                                  let v_type = (fst e') in
                                  if v_type = typ
                                  then (typ, SAssign(a, e'))
                                  else raise (Failure ("Expression of type " ^ Ast.string_of_typ v_type ^ 
                                              " cannot be assigned to variable of type " ^ Ast.string_of_typ typ))
                                else raise (Failure ("Variable not in scope"))
  
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
                                in (fd.rtyp, SCall(fname, args')) *)
  (* | Lambda (s, e) -> GET TYPE OF e (check_expr e), THEN _INFER_ TYPE OF s (WEIRD!) *)
    in

    (* repeated ugh *)
    let check_type_expr (symbol_table: Ast.typ StringMap.t) e (t : Ast.typ) =
      let e' = check_expr symbol_table e in
      if (fst e') = Int
      then e'
      else raise (Failure ("Expression of type " ^ (Ast.string_of_typ t)  ^ " expected"))
    in
  
    let check_int_expr (symbol_table: Ast.typ StringMap.t) e = 
      check_type_expr symbol_table e Int
    in
    
    let check_bool_expr (symbol_table: Ast.typ StringMap.t) e = 
      check_type_expr symbol_table e Bool
    in

    function  (*each of these has to be a mess of lets *)
    | Block sl            -> SBlock (check_stmt_list symbol_table sl)
    | Expr e              -> SExpr (check_expr symbol_table e)
    | IfElse(e, st1, st2) -> SIfElse(check_expr symbol_table e, check_stmt symbol_table st1, check_stmt symbol_table st2) (*check that exprs are of a certain kind*)
    | While(e, st)        -> SWhile(check_bool_expr symbol_table e, check_stmt symbol_table st) (*check that exprs are of a certain kind*)
    | For(e1, e2, e3, st) -> SFor(check_expr symbol_table e1, check_bool_expr symbol_table e2, check_expr symbol_table e3, check_stmt symbol_table st) (*check that exprs are of a certain kind*)
    | Continue            -> SContinue
    | Break               -> SBreak
    (*RETURN ONLY MAKES SENSE IN FUNCTIONS (check that scope depth > 2)*)
  (*| Return e            -> let (t, e') = check_expr e in
                             if t = func.rtyp then SReturn (t, e')
                             else raise (Failure ("return gives " ^ string_of_typ t ^ " expected " ^
                                         string_of_typ func.rtyp ^ " in " ^ string_of_expr e)) *)
    in 0