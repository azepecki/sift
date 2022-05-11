#	Makefile for Sift: Hello World
#	COMS W4115 PLT
#
#	Team:
#	Anne Zepecki            amz2145
#	Jose Antonio Ramos      jar2333
#	Lama Abdullah Rashed    lar2231
#	Suryanarayana V Akella  sa4084
#	Rishav Kumar            rk3142

# default:
# 	ocamlbuild run.native

# run:
# 	./run.native

# clean: 
# 	rm -f run.native
# 	rm -r _build


# .PHONY: test
# test: all generate.sh test.sh
# 	./generate.sh ./tests/*-test/test-*.tl
# 	./test.sh ./tests/*-test/test-*.tl
# 	./generate.sh ./tests/fails/fail-*.tl

.PHONY: all
all: sift.native

sift.native:
	opam config exec -- \
	ocamlbuild -I src -use-ocamlfind sift.native

.PHONY: clean
clean: cleandir
	rm -rf *.ll *.out *.s *.diff *.exe *.err
	rm -rf sift.native
	rm -rf _build
	rm -rf pe.o

cleandir :
	@if [ -d build ]; then make -C build clean; \
	else echo "build not exist"; fi
