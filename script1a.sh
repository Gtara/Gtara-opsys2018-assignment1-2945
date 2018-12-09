#!/bin/bash

while IFS=' ' read -r line || [[ -n "$line" ]]; do
    address="$line"
    first=${address:0:1}
    if [ "$first" == "#" ];
    then
        continue
    fi
    filename="${address////}"
    if [ -f "$filename.txt" ];
    then
        curl -s "$address" >> "$filename _2.txt" || echo $address "FAILED" >&2
        cmp --silent "$filename.txt" "$filename _2.txt" || echo $address
        rm "$filename.txt"
        mv "$filename _2.txt" "$filename.txt"
    else
        touch "$filename.txt"
        chmod +x "$filename.txt"
        curl -s "$address" >> "$filename.txt" && echo $address "INIT" || echo $address "FAILED" >&2
    fi
done < "$1"