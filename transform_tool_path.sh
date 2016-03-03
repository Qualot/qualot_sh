#!/bin/sh

# NC_output.sh
# without calibrate endmill size
# This shell script filters output of pycam

# how to use
if [ $# -ne 1 ]; then
    echo "usage: transform_tool_path.sh filename"
    exit 1
fi

filename="$1"

# default IFS is return
IFS='
'

ln=0

#NC commands that can be applied to NC-5 in machine shop JSK
table="G0\|G1\|G02\|G3\|G04\|G17\|G18\|G19\|G50\|G51\|G80\|G81\|G85\|G89\|G83\|G90\|G91\|G92\|G98\|G99\|F\|M0\|M2\|M3\|M5"

#read per line and output with line number
while read -r line; do
    ln=`expr $ln + 1`
    if echo "$line" | grep -q ";\|T"; then
        printf ''
        else
        _IFS="$IFS"
        IFS="("
        set -- $line
        block_before_kakko="$1"
        IFS="$_IFS"

        first=`echo $block_before_kakko | cut -c 1`

        if [ $first = 'G' ]; then
            if echo "$block_before_kakko" | grep -q "$table"; then
                printf '%s\n' "$block_before_kakko"
            else
                printf ''

            fi
        else
                printf '%s\n' "$block_before_kakko" 
        fi
    fi
done < "$filename"