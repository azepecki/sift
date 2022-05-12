# Path to the LLVM interpreter
LLI="lli"

# Path to the LLVM compiler
LLC="llc"

# Path to the C compiler
CC="cc"

# Path to the sift compiler.
SIFT="./sift.native"

globallog=testall.log
rm -f $globallog
globalerror=0

# Run <args>
# Report the command, run it, and report any errors
Run() {
    globalerror=0
    echo $* 1>&2
    eval $* || {
	SignalError "$1 failed on $*"
	globalerror=1
    }
    return
}

Compare() {
    globalerror=0
    generatedfiles="$generatedfiles $3"
    echo diff -b $1 $2 ">" $3 1>&2
    diff -b "$1" "$2" > "$3" 2>&1 || {
        SignalError "$1 differs"
        echo "FAILED $1 differs from $2" 1>&2
        globalerror=1
    }
}

Generate() {
    error=0
    basename=`echo $1 | sed 's/.*\\///
                             s/.sf//'`
    reffile=`echo $1 | sed 's/.sf$//'`
    basedir="`echo $1 | sed 's/\/[^\/]*$//'`/."

    echo -n "$basename..."

    echo 1>&2
    echo "###### Generating $basename.s" 1>&2

    Run "$SIFT" "./$1" ">" "${basename}.ll" &&
    Run "$LLC" "-relocation-model=pic" "${basename}.ll" ">" "${basename}.s" &&
    Run "$CC" "-o" "${basename}.exe" "${basename}.s" "sift_func.o" "similarity.o" "regex.o" &&
    Run "./${basename}.exe" > "${basename}.out" &&
    Compare ${basename}.out ${reffile}.out ${basename}.diff
    if [ $gloabalerror -eq 0 ] ; then
	    rm -f $generatedfiles
	echo "OK"
	echo "###### SUCCESS" 1>&2
    else
	echo "###### FAILED" 1>&2
	globalerror=$error
    fi
}

CheckFail() {
    error=0
    basename=`echo $1 | sed 's/.*\\///
                             s/.sf//'`
    reffile=`echo $1 | sed 's/.sf$//'`
    basedir="`echo $1 | sed 's/\/[^\/]*$//'`/."

    echo -n "$basename..."

    echo 1>&2
    echo "###### Testing $basename" 1>&2

    generatedfiles=""

    generatedfiles="$generatedfiles ${basename}.err ${basename}.diff" &&
    RunFail "$SIFT" "<" $1 "2>" "${basename}.err" ">>" $globallog &&
    Compare ${basename}.err ${reffile}.err ${basename}.diff

    # Report the status and clean up the generated files

    if [ $gloabalerror -eq 0 ] ; then
	    rm -f $generatedfiles
	echo "OK"
	echo "###### SUCCESS" 1>&2
    else
	echo "###### FAILED" 1>&2
	globalerror=$error
    fi
}

RunFail() {
    echo $* 1>&2
    eval $* && {
	SignalError "failed: $* did not report an error"
	return 1
    }
    return 0
}

if [ $# -ge 1 ]
then
    files=$@
else
    files="tests/test-*.sf tests/fail-*.sf"
fi

for file in $files
do
    case $file in
	*test-*)
	    Generate $file 2 >> $globallog
	    ;;
	*fail-*)
	    CheckFail $file 2 >> $globallog
	    ;;
	*)
	    echo "unknown file type $file"
	    globalerror=1
	    ;;
    esac
done
