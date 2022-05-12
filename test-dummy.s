	.text
	.file	"Sift"
	.globl	main                    # -- Begin function main
	.p2align	4, 0x90
	.type	main,@function
main:                                   # @main
	.cfi_startproc
# %bb.0:                                # %entry
	pushq	%rax
	.cfi_def_cfa_offset 16
	movl	$0, 4(%rsp)
	.p2align	4, 0x90
.LBB0_1:                                # %while
                                        # =>This Inner Loop Header: Depth=1
	cmpl	$14, 4(%rsp)
	jg	.LBB0_4
# %bb.2:                                # %while_body
                                        #   in Loop: Header=BB0_1 Depth=1
	movl	$1, %edi
	xorl	%eax, %eax
	callq	print_i@PLT
	cmpl	$1, 4(%rsp)
	jg	.LBB0_1
# %bb.3:                                # %if_end
                                        #   in Loop: Header=BB0_1 Depth=1
	movl	$3, %edi
	xorl	%eax, %eax
	callq	print_i@PLT
	incl	4(%rsp)
	jmp	.LBB0_1
.LBB0_4:                                # %while_end
	xorl	%eax, %eax
	popq	%rcx
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
	.cfi_endproc
                                        # -- End function
	.section	".note.GNU-stack","",@progbits
