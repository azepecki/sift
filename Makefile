#	Makefile for Sift: Hello World
#	COMS W4115 PLT
#
#	Team:
#	Anne Zepecki            amz2145
#	Jose Antonio Ramos      jar2333
#	Lama Abdullah Rashed    lar2231
#	Suryanarayana V Akella  sa4084
#	Rishav Kumar            rk3142


.PHONY: all
all: sift.native

sift.native:
	opam  exec -- \
	ocamlbuild -I src -use-ocamlfind -pkgs llvm,llvm.analysis sift.native
	chmod 777 sift.native
	gcc -c ./src/c/sift_func.c ./src/c/similarity.c ./src/c/regex.cpp ./src/c/file_ops.c
	chmod 777 sift_func.o similarity.o regex.o

.PHONY: dummy
dummy: 
	./generate.sh ./tests/test-dummy.sf

.PHONY: test
test: all generate.sh test.sh
	./generate.sh ./tests/test-*.sf
	#./test.sh ./tests/test-*.sf
	#./generate.sh ./tests/fail-*.sf

.PHONY: clean
clean: cleandir
	rm -rf *.ll *.out *.s *.diff *.exe *.err
	rm -rf sift.native
	rm -rf _build
	rm -f *.o *.output sift_func.bc similarity.bc regex.bc file_ops.bc

cleandir :
	@if [ -d build ]; then make -C build clean; \
	else echo "build not exist"; fi
