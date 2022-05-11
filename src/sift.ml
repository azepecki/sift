(* Top-level of the SIFT compiler: scan & parse the input,
   check the resulting AST and generate an SAST from it, generate LLVM IR,
   and dump the module *)

   type action = Ast | Sast | LLVM_IR | Compile
   let () = 
     let action = ref Compile in
     let set_action a () = action := a in
     let speclist = [
       ("-a", Arg.Unit (set_action Ast), "Print the AST");
       ("-s", Arg.Unit (set_action Sast), "Print the SAST");
       ("-l", Arg.Unit (set_action LLVM_IR), "Print the generated LLVM IR");
       ("-c", Arg.Unit (set_action Compile),
         "Check and print the generated LLVM IR (default)");
     ] in
     let usage_msg = "usage: ./sift.native [-a|-s|-l|-c] [file.sf]" in
     let channel = ref stdin in
     Arg.parse speclist (fun filename -> channel := open_in filename) usage_msg;
     let lexbuf = Lexing.from_channel !channel in
     let (script, functions) = Parser.program Scanner.token lexbuf in
     match !action with
     | Ast -> print_string (Ast.string_of_program (script, functions))
     | _ -> let (sscript, sfunctions) = Semantics.check_program script functions in
       match !action with
         Ast   -> ()
       | Sast    -> print_string (Sast.string_of_sprogram (sscript, sfunctions))
       | LLVM_IR -> print_string (Llvm.string_of_llmodule (Irgen.translate (sscript, sfunctions)))
       | Compile -> let m = Irgen.translate (sscript, sfunctions) in
                    let sift_functions = Llvm_irreader.parse_ir (Llvm.global_context ()) (Llvm.MemoryBuffer.of_file "./c/sift_func.ll") in
                    Llvm_linker.link_modules' m sift_functions;
                    Llvm_analysis.assert_valid_module m;
                    print_string (Llvm.string_of_llmodule m)
   
