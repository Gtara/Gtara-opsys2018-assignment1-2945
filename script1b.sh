#!/bin/bash

array=()
i=0
while IFS=' ' read -r line || [[ -n "$line" ]] ; do
    address="$line"
    first=${address:0:1}
    if [ "$first" == "#" ];
    then
        continue
    fi
    array[i]="$address"
    i=$((i+1))
done < "$1"

myFunc(){
    temp=${array[$1]}
    filename="${temp////}"
    if [ -f "$filename.txt" ];
    then
        curl -s "$temp" >> "$filename _2.txt" || echo $temp "FAILED" >&2
        cmp --silent "$filename.txt" "$filename _2.txt" || echo $temp
        rm "$filename.txt"
        mv "$filename _2.txt" "$filename.txt"
    else
        touch "$filename.txt"
        chmod +x "$filename.txt"
        curl -s "$temp" >> "$filename.txt" && echo $temp "INIT" || echo $temp "FAILED" >&2
    fi
}

for j in `seq 0 $((i-1))`; do
    myFunc $j &
done



