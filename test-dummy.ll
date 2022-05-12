; ModuleID = 'Sift'
source_filename = "Sift"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

declare i8* @str_add(i8*, i8*)

declare i1 @str_eql(i8*, i8*)

declare i32 @len(i8*)

declare i32 @print_i(i32, ...)

declare i32 @print_d(double, ...)

declare i32 @print_s(i8*, ...)

declare i32 @print_b(i1, ...)

declare i8* @input(i32, ...)

declare i32 @output(i8*, ...)

declare i8** @word_tokenize(i8*)

declare i32 @reg_match(i8*, i8*)

declare i1 @reg_test(i8*, i8*)

declare i32 @match_indices(i8*, i8*)

declare double @get_jaro(i8*, i8*)

define i32 @main() {
entry:
  %i = alloca i32, align 4
  store i32 0, i32* %i, align 4
  br label %while

while:                                            ; preds = %if_end, %entry
  %i1 = load i32, i32* %i, align 4
  %tmp = icmp slt i32 %i1, 15
  br i1 %tmp, label %while_body, label %while_end

while_body:                                       ; preds = %while
  %print_i = call i32 (i32, ...) @print_i(i32 1)
  %i2 = load i32, i32* %i, align 4
  %tmp3 = icmp sgt i32 %i2, 1
  br i1 %tmp3, label %then, label %if_end

while_end:                                        ; preds = %while, %then
  ret i32 0

then:                                             ; preds = %while_body
  br label %while_end

if_end:                                           ; preds = %while_body
  %print_i4 = call i32 (i32, ...) @print_i(i32 3)
  %i5 = load i32, i32* %i, align 4
  %tmp6 = add i32 %i5, 1
  store i32 %tmp6, i32* %i, align 4
  br label %while
}
