
DEST_FILES=$(find . -type f -not -name '.' -not -name '..' -not -path '*/.git*' -not -path '*/vim/bundle/*' -not -name "*.txt" -not -name "*.sh" -not -name "*.gz")

for DEST in $DEST_FILES; do
	SRC=$(echo $DEST | sed 's/\.\//~\//')
	SRC="${SRC/#\~/$HOME}"
	diff -q $DEST $(realpath $SRC)
	diff $DEST $(realpath $SRC)
done

