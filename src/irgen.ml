(* Code generation: translate takes a semantically checked AST and
produces LLVM IR

LLVM tutorial: Make sure to read the OCaml version of the tutorial

http://llvm.org/docs/tutorial/index.html

Detailed documentation on the OCaml LLVM library:

http://llvm.moe/
http://llvm.moe/ocaml/

*)

module L = Llvm
module A = Ast
open Sast

module StringMap = Map.Make(String)

module HashtblString =
   struct 
    type t = string
    let equal = ( = )
    let hash = Hashtbl.hash
   end;;

module StringHash = Hashtbl.Make(HashtblString);;

exception Error of string

let translate (globals, functions) =
  let context = L.global_context () in
  let the_module = L.create_module context "Sift" in

  (* Get types from the context *)
  let i32_t      = L.i32_type    context
  and i8_t       = L.i8_type     context
  and str_t      = L.pointer_type (L.i8_type context)
  and i1_t       = L.i1_type     context
  and float_t    = L.double_type context
  and void_t     = L.void_type   context in

  let rec ltype_of_typ = function
      A.Int   -> i32_t
    | A.Bool  -> i1_t
    | A.Float -> float_t
    (*| A.Void  -> void_t*)
    | A.String -> str_t
    (* Arrays as list of strings *)
  in

  (* Done *)
  let string_concat_t : L.lltype =
    L.function_type str_t [| str_t; str_t |] in  
  let string_concat_func : L.llvalue =
    L.declare_function "str_add" string_concat_t the_module in
  
  (* Done *)
  let string_equality_t : L.lltype = 
    L.function_type i1_t [| str_t; str_t |] in
  let string_equality_func : L.llvalue =
    L.declare_function "str_eql" string_equality_t the_module in

  (* Done *)
  let len_t : L.lltype =
    L.function_type i32_t [| str_t |] in  
  let len_func : L.llvalue =
    L.declare_function "len" len_t the_module in

  (* Done *)
  let printf_t : L.lltype =
    L.var_arg_function_type i32_t [| L.pointer_type i8_t |] in
  let printf_func : L.llvalue =
    L.declare_function "printf" printf_t the_module in
  
  (* TODO: nlp tokenize, return type, list of strings *)
  let word_tokenize_t : L.lltype =
    L.function_type i32_t [| str_t |] in  
  let word_tokenize_func : L.llvalue =
    L.declare_function "word_tokenize" word_tokenize_t the_module in

  (* TODO: sent tokenize, return type, list of strings *)
  let sent_tokenize_t : L.lltype =
    L.function_type i32_t [| str_t |] in  
  let sent_tokenize_func : L.llvalue =
    L.declare_function "sent_tokenize" sent_tokenize_t the_module in

  (* TODO: regex, return type, list of strings *)
  let reg_match_t : L.lltype =
    L.function_type i32_t [| str_t; str_t |] in  
  let reg_match_func : L.llvalue =
    L.declare_function "reg_match" reg_match_t the_module in
  
  (* TODO: list of strings *)
  let reg_test_t : L.lltype =
    L.function_type i1_t [| str_t; str_t |] in  
  let reg_test_func : L.llvalue =
    L.declare_function "reg_test" reg_test_t the_module in
  
  (* TODO: match_indices, return type, list of indices *)
  let reg_match_indices_t : L.lltype =
    L.function_type i32_t [| str_t; str_t |] in  
  let reg_match_indices_func : L.llvalue =
    L.declare_function "match_indices" reg_match_indices_t the_module in

  (* Create a map of global variables after creating each *)
  let global_vars : L.llvalue StringMap.t =
    let global_var m (t, n) =
      let init = L.const_int (ltype_of_typ t) 0
      in StringMap.add n (L.define_global n init the_module) m in
    List.fold_left global_var StringMap.empty globals in

  (* Define each function (arguments and return type) so we can
     call it even before we've created its body *)
  let function_decls : (L.llvalue * sfunc_def) StringMap.t =
    let function_decl m fdecl =
      let name = fdecl.sfname
      and formal_types =
        Array.of_list (List.map (fun (t,_) -> ltype_of_typ t) fdecl.sformals)
      in let ftype = L.function_type (ltype_of_typ fdecl.srtyp) formal_types in
      StringMap.add name (L.define_function name ftype the_module, fdecl) m in
    List.fold_left function_decl StringMap.empty functions in
    
    (* Fill in the body of the given function *)
  let build_function_body fdecl =
    let (the_function, _) = StringMap.find fdecl.sfname function_decls in
    let builder = L.builder_at_end context (L.entry_block the_function) in
  
    let int_format_str = L.build_global_stringptr "%d\n" "fmt" builder in
  
    (* Construct the function's "locals": formal arguments and locally
        declared variables.  Allocate each on the stack, initialize their
        value, if appropriate, and remember their values in the "locals" map *)
    let local_vars =
      let add_formal m (t, n) p =
        L.set_value_name n p;
        let local = L.build_alloca (ltype_of_typ t) n builder in
        ignore (L.build_store p local builder);
        StringMap.add n local m
  
        (* Allocate space for any locally declared variables and add the
         * resulting registers to our map 
         build_alloc method is used to generate LLVM code.
         *)
        and add_local m (t, n) =
          let local_var = L.build_alloca (ltype_of_typ t) n builder
          (*
            We add the address of local variable n with m   
          *)
          in StringMap.add n local_var m
        in
  
      let formals = List.fold_left2 add_formal StringMap.empty fdecl.sformals
          (Array.to_list (L.params the_function)) in
      List.fold_left add_local formals fdecl.sformals
    in
  
    (* Return the value for a variable or formal argument.
        Check local names first, then global names
        
        We have separate maps for global and local variables
        *)
    let lookup n = try StringMap.find n local_vars
      with Not_found -> StringMap.find n global_vars
    in

    (* Construct code for an expression; return its value 
       
      For literals, the code is its value
      SId -> Expression can be a variable. If it is a variable, then we can lookup the symbol table
      to get the location of this variable and we will load the value stored.

    *)

    let rec build_expr builder ((_, e) : sexpr) = match e with
        SLiteral i  -> L.const_int i32_t i
      | SBoolLit b  -> L.const_int i1_t (if b then 1 else 0)
      | SId s       -> L.build_load (lookup s) s builder
      | SAssign (s, e) -> let e' = build_expr builder e in

        (*
          E.code ||
          e' -> e.addr

        *)
        ignore(L.build_store e' (lookup s) builder); e'
        (*
          e1' = e1.eddr
          e2' = e2.addr
          temp = e1.addr op e2.addr
           Then we use the llvm's operation to perform the respective
           binary operation
          *)
      | SBinop (e1, op, e2) ->
        let e1' = build_expr builder e1
        and e2' = build_expr builder e2 in
        (match op with
            A.Add     -> L.build_add
          | A.Sub     -> L.build_sub
          | A.And     -> L.build_and
          | A.Or      -> L.build_or
          | A.Equal   -> L.build_icmp L.Icmp.Eq
          | A.Neq     -> L.build_icmp L.Icmp.Ne
          | A.Less    -> L.build_icmp L.Icmp.Slt
        ) e1' e2' "tmp" builder
      | SCall ("print", [e]) ->
        L.build_call printf_func [| int_format_str ; (build_expr builder e) |]
          "printf" builder
      | SCall (f, args) ->
        let (fdef, fdecl) = StringMap.find f function_decls in
        let llargs = List.rev (List.map (build_expr builder) (List.rev args)) in
        let result = f ^ "_result" in
        L.build_call fdef (Array.of_list llargs) result builder
    in

    (* LLVM insists each basic block end with exactly one "terminator"
        instruction that transfers control.  This function runs "instr builder"
        if the current block does not already have a terminator.  Used,
        e.g., to handle the "fall off the end of the function" case. *)
    let add_terminal builder instr =
      match L.block_terminator (L.insertion_block builder) with
        Some _ -> ()
      | None -> ignore (instr builder) in
    (* Build the code for the given statement; return the builder for
       the statement's successor (i.e., the next instruction will be built
       after the one generated by this call) *)
    let rec build_stmt builder = function
       SBlock sl -> List.fold_left build_stmt builder sl  (* This will apply the builder statement to every statement *)
     | SExpr e -> ignore(build_expr builder e); builder (* We need the original builder value hence we discard the e.address returned by the expression*)
     | SReturn e -> 
       ignore(L.build_ret (build_expr builder e) builder); builder
     | SIfElse (predicate, then_stmt, else_stmt) ->
        let bool_val = build_expr builder predicate in

        let then_bb = L.append_block context "then" the_function in
        ignore (build_stmt (L.builder_at_end context then_bb) then_stmt);
        let else_bb = L.append_block context "else" the_function in
        ignore (build_stmt (L.builder_at_end context else_bb) else_stmt);

        let end_bb = L.append_block context "if_end" the_function in
        let build_br_end = L.build_br end_bb in (* partial function *)
        add_terminal (L.builder_at_end context then_bb) build_br_end;
        add_terminal (L.builder_at_end context else_bb) build_br_end;

        ignore(L.build_cond_br bool_val then_bb else_bb builder);
        L.builder_at_end context end_bb
      | SWhile (predicate, body) ->
        let while_bb = L.append_block context "while" the_function in
        let build_br_while = L.build_br while_bb in (* partial function *)
        ignore (build_br_while builder);
        let while_builder = L.builder_at_end context while_bb in
        let bool_val = build_expr while_builder predicate in

        let body_bb = L.append_block context "while_body" the_function in
        add_terminal (build_stmt (L.builder_at_end context body_bb) body) build_br_while;

        let end_bb = L.append_block context "while_end" the_function in

        ignore(L.build_cond_br bool_val body_bb end_bb while_builder);
        L.builder_at_end context end_bb
    in

    let func_builder = build_stmt builder (SBlock fdecl.sbody) in

    (* Add a return if the last block falls off the end *)
    add_terminal func_builder (L.build_ret (L.const_int i32_t 0))
  in

  List.iter build_function_body functions;
  the_module
