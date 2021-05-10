#!/bin/bash

if (($#==2)); then
    dir=$1
    inp=$2
elif (($#==1)); then
    dir=./
    inp=$1
else
    echo "Give directory name (optional) and input file name"
    exit
fi

if [[ ! -f "$inp" ]]; then
    echo "File not found!"
    exit
fi

# # ara=(where nol pattern)
# # for var in ${ara[@]}; do
# for var in where nol pattern; do
#   read -r $var
# done < "$inp"
{ read -r where; read nol; read -r pattern; } < "$inp"

if [[ $where == begin ]]; then
    cmd=head
else
    cmd=tail
fi

working_dir="$(realpath "$dir")"

# Avoid cd inside a shell script, then you will have to replace all variables having .
# Must use working_dir instead dir in following lines, otherwise will have corner case of /home vs /home/
rm -r "$working_dir/../output_dir"
mkdir "$working_dir/../output_dir"
touch "$working_dir/../output.csv"

echo "File Path,Line Number,Line Containing Searched String" > "$working_dir/../output.csv"

cntMatch=0

while read file; do
    if ! file "$file" | grep -q text; then
        continue
    fi
    tmp="$($cmd -n $nol "$file" | grep -in "$pattern")"
    code=$?
    if (($code==0)); then
        cntMatch=$(($cntMatch+1))
        numoflines=$(grep -c "^" "$file")

        while read line; do
            lineno="$(echo "$line" | cut -f1 -d:)"
            if [[ $numoflines -gt $nol ]]; then
                lineno=$(($lineno+($numoflines-$nol)))
            fi
            line="$(echo "$line" | cut -f2 -d:)"
            echo "\"$file\",$lineno,\"$line\"" >> "$working_dir/../output.csv"  # \" surrounding to prevent new column with , in it
        done <<< "$tmp"

        lineno="$(echo "$tmp" | $cmd -n 1 | cut -f1 -d:)"
        if [[ $numoflines -gt $nol ]]; then
            lineno=$(($lineno+($numoflines-$nol)))
        fi

        relativeFile="$(realpath --relative-to="$dir" "$file")"
        relativeDirectory="${relativeFile%/*}"
        if [[ "$relativeDirectory" != "$relativeFile" ]]; then
            o="$(echo "$relativeDirectory" | sed -e "s|/|.|g")."
        else
            o=""
        fi

        filename="${file##*/}"
        basename="${filename%.*}"
        extension="${filename##*.}"
        o="$o${basename}_$lineno"
        if [[ "$extension" != "$filename" ]]; then
            o="$o.$extension"
        fi

        # echo "$working_dir/../output_dir/$o"
        cp "$file" "$working_dir/../output_dir/$o"
    fi
done < <(find "$dir" -readable -type f -exec grep -Il . {} \;)
# Pipelines create subshell, which doesn't preserve anything, hence I converted pipeline to process substitution
# for x in y can't handle blanks in variable

echo $cntMatch