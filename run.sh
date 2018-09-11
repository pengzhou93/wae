#!/bin/bash

debug_str="import pydevd;pydevd.settrace('localhost', port=8081, stdoutToServer=True, stderrToServer=True)"
# pydevd module path
export PYTHONPATH=/home/shhs/Desktop/user/soft/pycharm-2018.1.4/debug-eggs/python2

insert_debug_string()
{
    file=$1
    line=$2
    debug_string=$3

    value=`sed -n ${line}p "$file"`

    if [ "$value" != "$debug_string" ]
    then
    echo "++Insert $debug_string in line_${line}++"

    sed "${line}s/^/\n/" -i $file
    sed -i "${line}s:^:${debug_string}:" "$file"
    fi
}

delete_debug_string()
{
    file=$1
    line=$2
    debug_string=$3

    value=`sed -n ${line}p "$file"`
    if [ "$value" = "$debug_string" ]
    then
    echo "--Delete $debug_string in line_${line}--"
    sed "${line}d" -i "$file"
    fi
}

# python2.7 tf_1_6
source $HOME/anaconda3/bin/activate python2
export LD_LIBRARY_PATH=/usr/local/cudnn-9.0-v7/lib64:/usr/local/cuda-9.0/lib64:$LD_LIBRARY_PATH

if [ "$1" = 'download_mnist_data.py' ]
then
#   ./run.sh download_mnist_data.py
    python download_mnist_data.py

elif [ "$1" = "run.py" ]
then
#    ./run.sh "run.py" debug

    file="run.py"
    line=1
    if [ $2 = debug ]
    then
        insert_debug_string "$file" $line "$debug_str"
        python "$file" --exp=mnist
        delete_debug_string "$file" $line "$debug_str"

    else
        python $file --exp=mnist
    fi

else
    echo NoParameter
fi