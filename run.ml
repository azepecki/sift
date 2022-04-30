open Ast
open Sast
open Semantics


let (v, f) = Parser.program Scanner.token (Lexing.from_channel stdin);;

print_endline (Ast.string_of_program (v, f));;
print_endline (Sast.string_of_sprogram (check_program v f));;
