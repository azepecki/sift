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

(* Symbol Table: stores addresses of all variables *)

(* Basically a linked list of string maps*)
type symbol_table = (L.llvalue StringMap.t) list;; 

(* Declares a new variable in current scope *)
(* int x; *)
let add (id : string) (addr : L.llvalue) (table : symbol_table) : symbol_table =
  match table with
  | current_scope :: tl -> (StringMap.add id addr current_scope) :: tl
  | [] -> [StringMap.empty]

(* Tries finding in current scope, if fails then goes up in symbol table *)
(* x; *)
let rec lookup (id : string) (table : symbol_table) : L.llvalue = 
  match table with 
  | []     -> raise Not_found
  | h :: t -> if StringMap.mem id h
              then StringMap.find id h
              else lookup id t

(* Adds a new scope *)
let add_scope (table : symbol_table) : symbol_table = 
  StringMap.empty :: table

let new_table : symbol_table =
  [StringMap.empty]

exception Error of string

let translate (script, functions) =
  let context = L.global_context () in
  let the_module = L.create_module context "Sift" in

  L.set_data_layout "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128" the_module ;

  (* Get types from the context *)
  let i32_t      = L.i32_type    context
  and str_t      = L.pointer_type (L.i8_type context)
  and i1_t       = L.i1_type     context
  and float_t    = L.double_type context
in

  let rec ltype_of_typ = function
      A.Int   -> i32_t
    | A.Bool  -> i1_t
    | A.Float -> float_t
    | A.String -> str_t
    | A.Fun(hd::tl) -> 
      let formal_types = Array.of_list (List.map (fun t -> ltype_of_typ t) tl)
      and return_type = ltype_of_typ hd
      in 
      L.pointer_type (L.function_type return_type formal_types )
    (* ARRAYS (only depth 1 for now) *)
    | A.Arr(A.Int)    -> L.pointer_type i32_t
    | A.Arr(A.Bool)   -> L.pointer_type i1_t
    | A.Arr(A.Float)  -> L.pointer_type float_t
    | A.Arr(A.String) -> L.pointer_type str_t
    | _ -> i1_t (* garbage, just to make ocaml shut up for now (nested arrays, fun[]) *)

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

  (* ALL LENS *)
  let len_s_t : L.lltype =
    L.function_type i32_t [| str_t |] in  
  let len_s_func : L.llvalue =
    L.declare_function "len_s" len_s_t the_module in

  (* ALL LENS FOR ARRAYS *)
  let len_arr_s_t : L.lltype =
    L.function_type i32_t [| L.pointer_type str_t |] in  
  let len_arr_s_func : L.llvalue =
    L.declare_function "len_arr_s" len_arr_s_t the_module in

  let len_arr_i_t : L.lltype =
    L.function_type i32_t [| L.pointer_type i32_t |] in  
  let len_arr_i_func : L.llvalue =
    L.declare_function "len_arr_i" len_arr_i_t the_module in

  let len_arr_d_t : L.lltype =
    L.function_type i32_t [| L.pointer_type float_t |] in  
  let len_arr_d_func : L.llvalue =
    L.declare_function "len_arr_d" len_arr_d_t the_module in

  let len_arr_b_t : L.lltype =
    L.function_type i32_t [| L.pointer_type i1_t |] in  
  let len_arr_b_func : L.llvalue =
    L.declare_function "len_arr_b" len_arr_b_t the_module in

  (* ALL PRINTS! none for arrays, those are handled by calling to_string and invoking print_s *)
  let print_i_t : L.lltype =
    L.var_arg_function_type i32_t [| i32_t |] in
  let print_i_func : L.llvalue =
    L.declare_function "print_i" print_i_t the_module in

  let print_d_t : L.lltype =
    L.var_arg_function_type i32_t [| float_t |] in
  let print_d_func : L.llvalue =
    L.declare_function "print_d" print_d_t the_module in

  let print_s_t : L.lltype =
    L.var_arg_function_type i32_t [| str_t |] in
  let print_s_func : L.llvalue =
    L.declare_function "print_s" print_s_t the_module in

  let print_b_t : L.lltype =
    L.var_arg_function_type i32_t [| i1_t |] in
  let print_b_func : L.llvalue =
    L.declare_function "print_b" print_b_t the_module in

  (* Done *)
  let input_t : L.lltype =
    L.var_arg_function_type str_t [| i32_t |] in
  let input_func : L.llvalue =
    L.declare_function "input" input_t the_module in
  
  (* Done *)
  let output_t : L.lltype =
    L.var_arg_function_type i32_t [| str_t |] in
  let output_func : L.llvalue =
    L.declare_function "output" output_t the_module in
  
  (* TODO: nlp tokenize, return type, list of strings *)
  let word_tokenize_t : L.lltype =
    L.function_type (L.pointer_type str_t) [| str_t |] in  
  let word_tokenize_func : L.llvalue =
    L.declare_function "word_tokenize" word_tokenize_t the_module in

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
    L.declare_function "reg_match_indices" reg_match_indices_t the_module in
  
  let get_jaro_t : L.lltype =
    L.function_type float_t [| str_t; str_t |] in  
  let get_jaro_func : L.llvalue =
    L.declare_function "get_jaro" get_jaro_t the_module in

  (* Define each function (arguments and return type) so we can
     call it even before we've created its body 
     These are GLOBAL 
     Map : name -> (llvm address, func_def) *)
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
  
    (* Construct the function's "locals": formal arguments. Allocate each on the stack, 
    initialize their value and remember their values in the "locals" map *)
    let local_vars =
      let add_formal (table : symbol_table) (typ, name) param = 
        (* Sets name of the param value *)
        L.set_value_name name param; 
        (* Allocates var of correct type with given name, returns address *)
        (* Can we cheat here by using L.type_of? (since semantic analysis succeeded?) *)
        let local = L.build_alloca (ltype_of_typ typ) name builder in 
        (* Stores param value in allocated address *)
        ignore (L.build_store param local builder);
        (* Add the (name, address) pair to symbol_table *)
        add name local table
      in 
      let formals = List.fold_left2 add_formal new_table fdecl.sformals
          (Array.to_list (L.params the_function)) 
      in
      formals
    in

    (* Construct code for an expression; return its value 
       
      For literals, the code is its value
      SId -> Expression can be a variable. If it is a variable, then we can lookup the symbol table
      to get the location of this variable and we will load the value stored.

    *)

    let rec build_expr table builder ((typ, e) : sexpr) = 
      match e with
      | SLiteral i  ->   L.const_int i32_t i
      | SBoolLit b  ->   L.const_int i1_t (if b then 1 else 0)
      | SFloatLit d  ->  L.const_float float_t d
      | SArrayLit lst ->  let Arr(sub_typ) = typ in
                          L.const_array (ltype_of_typ sub_typ) (Array.of_list (List.map (build_expr table builder) lst))
      | SStrLit s    -> L.build_global_stringptr s "str_literal" builder
      | SId name    ->  
        (try 
        let addr = lookup name table in 
        (* load whatever is in addr to named variable *)
        L.build_load addr name builder (* I imagine it returns name.addr *)
        with Not_found -> 
          let (v, fdef) = StringMap.find name function_decls 
          in
          v (* return the function address *)
        ) 

      | SAssign (s, e) -> let e' = build_expr table builder e in

        ignore(L.build_store e' (lookup s table) builder); 
        e'

      | SBinop (e1, op, e2) ->
        let (t1, _) = e1 in
        let e1' = build_expr table builder e1
        and e2' = build_expr table builder e2 in
        (match op with

          (* Array concat fucntion *)
          (* | A.Add when (match typ1 with Arr(s) -> true | _ -> false) -> *)

          | A.Add when t1=String   -> (fun a b c d -> L.build_call string_concat_func   [| a ; b |] "str_add" d)
          | A.Equal when t1=String -> (fun a b c d -> L.build_call string_equality_func [| a ; b |] "str_eql" d)

          | A.Add   when t1=Int   -> L.build_add
          | A.Sub   when t1=Int   -> L.build_sub
          | A.Mul   when t1=Int   -> L.build_mul
          | A.Div   when t1=Int   -> L.build_sdiv
          | A.Mod   when t1=Int   -> L.build_srem

          | A.Add   when t1=Float -> L.build_fadd
          | A.Sub   when t1=Float -> L.build_fsub
          | A.Mul   when t1=Float -> L.build_fmul
          | A.Div   when t1=Float -> L.build_fdiv

          | A.Equal when t1=Int || t1=Bool  -> L.build_icmp L.Icmp.Eq
          | A.Neq   when t1=Int || t1=Bool  -> L.build_icmp L.Icmp.Ne

          | A.Less  when t1=Int    -> L.build_icmp L.Icmp.Slt
          | A.Leq   when t1=Int    -> L.build_icmp L.Icmp.Sle
          | A.Greater when t1=Int  -> L.build_icmp L.Icmp.Sgt
          | A.Geq  when t1=Int     -> L.build_icmp L.Icmp.Sge

          | A.And   when t1=Bool  -> L.build_and
          | A.Or    when t1=Bool  -> L.build_or

          | A.Equal when t1=Float    -> L.build_fcmp L.Fcmp.Oeq
          | A.Neq   when t1=Float    -> L.build_fcmp L.Fcmp.One
          | A.Less  when t1=Float    -> L.build_fcmp L.Fcmp.Olt
          | A.Leq   when t1=Float    -> L.build_fcmp L.Fcmp.Ole
          | A.Greater when t1=Float  -> L.build_fcmp L.Fcmp.Ogt
          | A.Geq  when t1=Float     -> L.build_fcmp L.Fcmp.Oge

          (* | _ -> raise (Failure "not implemented") *)

        ) e1' e2' "tmp" builder
        | SUnop (op, e) ->
          let e' = build_expr table builder e in
          (match op with
            | A.Not -> L.build_not
            | A.Neg -> L.build_neg
          ) e' "tmp" builder

        | SStdin(e) -> L.build_call input_func [| (build_expr table builder e) |] "input" builder  
        | SStdout(e) -> L.build_call output_func [| (build_expr table builder e) |] "output" builder  


      (* | SArrayAccess(s, e) ->  *)

      (* 
        PRE-BUILT FUNCTIONS!
        On all these calls, do not confuse the name with which they invoked
        with the name that they have in the C file (though they may be the same ) 
      *)

      | SCall ("print", [(typ, _) as e]) ->
            (
            match typ with
            | Int    -> L.build_call print_i_func [| build_expr table builder e |] "print_i" builder 
            | Float  -> L.build_call print_d_func [| build_expr table builder e |] "print_d" builder 
            | String -> L.build_call print_s_func [| build_expr table builder e |] "print_s" builder 
            | Bool   -> L.build_call print_b_func [| build_expr table builder e |] "print_b" builder
            | Arr(sub_typ) -> raise (Failure ("print with argument of type " ^ Ast.string_of_typ typ ^ " not implemented"))
            | _ -> raise (Failure ("print with argument of type " ^ Ast.string_of_typ typ ^ " not implemented"))
            )

        | SCall ("len", [(typ, _) as e]) ->
            (
            match typ with
            | String        -> L.build_call len_s_func     [| build_expr table builder e |] "len_s" builder 
            | Arr(Int)      -> L.build_call len_arr_i_func [| build_expr table builder e |] "len_arr_i" builder 
            | Arr(Float)    -> L.build_call len_arr_d_func [| build_expr table builder e |] "len_arr_d" builder 
            | Arr(String)   -> L.build_call len_arr_s_func [| build_expr table builder e |] "len_arr_s" builder 
            | Arr(Float)    -> L.build_call len_arr_b_func [| build_expr table builder e |] "len_arr_b" builder 
            | _ -> raise (Failure ("len with argument of type " ^ (Ast.string_of_typ typ) ^ " not implemented"))
            )
    
      | SCall ("str_add", [e1 ; e2]) ->
         L.build_call string_concat_func [| (build_expr table builder e1) ; (build_expr table builder e2) |] "str_add" builder       
      | SCall ("str_eql", [e1 ; e2]) ->
         L.build_call string_equality_func [| (build_expr table builder e1) ; (build_expr table builder e2) |] "str_eql" builder 
      | SCall ("reg_test", [e1 ; e2]) ->
          L.build_call reg_test_func [| (build_expr table builder e1) ; (build_expr table builder e2) |] "reg_test" builder 
      | SCall ("reg_match", [e1 ; e2]) ->
        L.build_call reg_match_func [| (build_expr table builder e1) ; (build_expr table builder e2) |] "reg_match" builder 
      | SCall ("reg_match_indices", [e1 ; e2]) ->
        L.build_call reg_match_indices_func [| (build_expr table builder e1) ; (build_expr table builder e2) |] "reg_match_indices" builder 
      | SCall ("get_jaro", [e1 ; e2]) ->
        L.build_call get_jaro_func [| (build_expr table builder e1) ; (build_expr table builder e2) |] "get_jaro" builder 
      | SCall ("word_tokenize", [e]) ->
        L.build_call word_tokenize_func [| (build_expr table builder e) |] "word_tokenize" builder 

      (* General Call *)
      | SCall (f, args) ->
        (
        try 
        let addr = lookup f table in 
        let llargs = List.rev (List.map (build_expr table builder) (List.rev args)) in
        let result = f ^ "_result" in
        L.build_call addr (Array.of_list llargs) result builder
        with Not_found ->
        let (fdef, _) = StringMap.find f function_decls in
        let llargs = List.rev (List.map (build_expr table builder) (List.rev args)) in
        let result = f ^ "_result" in
        L.build_call fdef (Array.of_list llargs) result builder
        )

      
      | _ -> raise (Error "arrays not implemented") 
     

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
    let rec build_stmt table builder loop stmt : L.llbuilder * symbol_table * (L.llbasicblock * L.llbasicblock) option = 
      
      match stmt with
     (* This will apply the builder statement to every statement *)
     | SBlock sl -> 
      let accumulate (b,t, _) stmt = build_stmt t b loop stmt 
      in
      let (new_builder, new_table, new_loop) = List.fold_left (accumulate) (builder, add_scope table, loop) sl in
      (new_builder, table, loop)
      
     | SExpr e -> ignore(build_expr table builder e); 
     (* We need the original builder value hence we discard the e.address returned by the expression*)
     (builder, table, loop)

     | SReturn e -> 
       ignore(L.build_ret (build_expr table builder e) builder); 
       (builder, table, loop)

     | SIfElse (predicate, then_stmt, else_stmt) ->
        let bool_val = build_expr table builder predicate in

        let then_bb = L.append_block context "then" the_function in
        ignore (build_stmt table (L.builder_at_end context then_bb) loop then_stmt);
        let else_bb = L.append_block context "else" the_function in
        ignore (build_stmt table (L.builder_at_end context else_bb) loop else_stmt);

        let end_bb = L.append_block context "if_end" the_function in
        let build_br_end = L.build_br end_bb in (* partial function *)
        add_terminal (L.builder_at_end context then_bb) build_br_end;
        add_terminal (L.builder_at_end context else_bb) build_br_end;

        ignore(L.build_cond_br bool_val then_bb else_bb builder);
        (L.builder_at_end context end_bb, table, loop)

      | SWhile (predicate, body) ->
        let while_bb = L.append_block context "while" the_function in

        let build_br_while = L.build_br while_bb in (* partial function *)

        ignore (build_br_while builder);


        let while_builder = L.builder_at_end context while_bb in
        let bool_val = build_expr table while_builder predicate in

        let body_bb = L.append_block context "while_body" the_function in

        let end_bb = L.append_block context "while_end" the_function in

        let (new_builder, _, _) = build_stmt table (L.builder_at_end context body_bb) (Some(while_bb, end_bb)) body in
        add_terminal (new_builder) build_br_while;

        ignore(L.build_cond_br bool_val body_bb end_bb while_builder);
        (L.builder_at_end context end_bb, table, None)

      | SContinue -> 
        (match loop with 
        | Some(while_bb, _) -> ignore(L.build_br while_bb builder); (builder, table, loop)
        | None -> (builder, table, loop) 
        ) 

      | SBreak -> 
        (match loop with 
        | Some(_, end_bb) -> ignore(L.build_br end_bb builder); (builder, table, loop)
        | None -> (builder, table, loop) 
        ) 
  
      | SFor (declr, predicate, inc, body) -> 
        (match body with
        | SBlock(lst) -> build_stmt table builder loop (SBlock([declr ; SWhile(predicate, SBlock(lst @ [SExpr(inc)]))]))
        | _           -> build_stmt table builder loop (SBlock([declr ; SWhile(predicate, SBlock(body :: [SExpr(inc)]))]))
        )

      | SIf (predicate, then_stmt) -> 
        let bool_val = build_expr table builder predicate in

        let then_bb = L.append_block context "then" the_function in
        ignore (build_stmt table (L.builder_at_end context then_bb) loop then_stmt);

        let end_bb = L.append_block context "if_end" the_function in
        let build_br_end = L.build_br end_bb in (* partial function *)
        add_terminal (L.builder_at_end context then_bb) build_br_end;

        ignore(L.build_cond_br bool_val then_bb end_bb builder);
        (L.builder_at_end context end_bb, table, loop)

      | SDeclare (typ, name) -> 
        (* Allocates var of correct type with given name, address discarded *)
        let local = L.build_alloca (ltype_of_typ typ) name builder in
        (* Add the (name, address) pair to symbol_table *)
        (builder, add name local table, loop)

      | SDeclAssign (typ, name, e) -> 
        let e' = build_expr table builder e in
        (* Sets name of the e' value *)
        L.set_value_name name e'; 
        (* Allocates var of correct type with given name, address discarded *)
        let local = L.build_alloca (ltype_of_typ typ) name builder in
        (* Stores the value in e' (e.address) at allocated address *)
        ignore (L.build_store e' local builder);
        (* Add the (name, address) pair to symbol_table *)
        (builder, add name local table, loop)
    in

    let (func_builder, _, _) = build_stmt local_vars builder None (SBlock fdecl.sbody) in

    (* Add a return if the last block falls off the end *)
    add_terminal func_builder (L.build_ret (L.const_int i32_t 0))
  in

  (* let main = {srtyp = Int; sfname = "main"; sformals = []; sbody = script} in
  List.iter build_function_body (main :: functions); *)
  List.iter build_function_body (functions);
  the_module