#!/bin/bash

dir=./

working_dir="$(realpath "$dir")"

rm -rf "$working_dir/../output_dir"
mkdir "$working_dir/../output_dir"

a=()
s=()
n=()
while read file; do
    a+=("$file")
done < <(find . -type f -iname '*.pdf')

for (( i = 0; i < ${#a[@]}; i++ )); do
    foo=$(pdfinfo "${a[i]}" | grep Pages | awk '{print $2}')
    # echo "${a[i]}" $foo
    s+=($foo)
    n+=($i)
done

for (( i = 0; i < ${#a[@]}; i++ )); do
    for (( j = i+1; j < ${#a[@]}; j++ )); do
        x=$(stat --printf="%s" "${a[${n[$i]}]}")
        y=$(stat --printf="%s" "${a[${n[$j]}]}")
        [[ $x -gt $y ]] && { tmp=${n[$i]}; n[$i]=${n[$j]}; n[$j]=$tmp; }
    done
done

# echo ""

cnt=0
for i in ${n[@]}; do
    if [[ ${s[$i]} -ge $1 ]]; then
        cnt=$(($cnt+1))
        cp "${a[$i]}" "$working_dir/../output_dir/$cnt.pdf"
        # x=$(stat --printf="%s" "${a[$i]}")
        # echo "${a[$i]}" ${s[$i]} $x
    fi
done