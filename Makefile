#	Makefile for Sift: Hello World
#	COMS W4115 PLT
#
#	Team:
#	Anne Zepecki            amz2145
#	Jose Antonio Ramos      jar2333
#	Lama Abdullah Rashed    lar2231
#	Suryanarayana V Akella  sa4084
#	Rishav Kumar            rk3142

default:
	ocamlbuild run.native

run:
	./run.native

clean: 
	rm -f run.native
	rm -r _build
