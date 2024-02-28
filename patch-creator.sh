#/bin/bash

if [[ "$1" == "" ]]; then
    echo "Usage: ./patch-creator.sh project project.mod [output_path]"
    exit
fi

# check output path
if [[ "$3" != "" ]]; then
    PATCH_OUTPUT="$3/"
fi

# diff project
diff -uNr "$1" "$2" > ./test.patch

# split patch 
csplit ./test.patch /diff/ -s -z {"*"} -f patch-name -b "%02d.patch"
rm -rf ./test.patch

# rename patch file
for i in $(ls patch-name*); do
    PATCH_NAME=$(grep $i -e "diff" | sed -e s#'^.*mod\/'#''#g -e s#'\/'#'-'#g -e s#'$'#'\.patch'#g)
    mv "$i" "$PATCH_OUTPUT$PATCH_NAME"
done