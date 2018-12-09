#!/bin/bash

tar -xzf $1
mapfile -t arr < <(tar tf $1 | grep '\.txt')
counter=1
for i in `seq 0 $((${#arr[@]}-1))`; do
    while IFS=' ' read -r line || [[ -n "$line" ]] ; do
        first=${line:0:1}
        if [ "$first" == "#" ];
        then
            continue
        fi
        protocol=${line:0:5}
        if [ "$protocol" != "https" ];
        then
            continue
        fi
    if [ ! -d "assignments" ];
    then
        mkdir assignments
    fi
    temp="repo-"
    temp+=$counter
    
    git clone -q $line ./assignments/$temp &>/dev/null    
    
    if [ $? -eq 0 ];
    then
        counter=$(($counter+1))
        echo $line": Cloning OK"
    else
	echo $line": Cloning FAILED" >&2
    fi
    break
    done < ${arr[$i]}
done

for dir in "assignments"/* ; do
    temp=$dir
    temp+="/*"
    numOfdirs=$(find $temp -type d | wc -l)
    echo ${dir//"assignments/"/}":"
    echo "Number of directories: " $numOfdirs
    numOftxts=$(find $temp -name "*.txt" | wc -l)
    echo "Number of txt files: " $numOftxts
    numOffiles=$(find $temp -type f | wc -l)
    echo "Number of other files: " $(($numOffiles-$numOftxts))

    correct="$dir: dataA.txt more $dir/more: dataB.txt dataC.txt"
    current=$(ls -R $dir)
    correct=$(echo $correct)
    current=$(echo $current)
    if [ "$current" = "$correct" ];
    then
        echo "Directory structure is OK."
    else
        echo "Directory structure is NOT OK." >&2
    fi

done
