#!/bin/bash

a=$1 b=$2

echo "script name:$0 \ntotal args passed:$#"

if [ $a -eq $b ]
then
   echo "a is equal to b"
elif [ $a -gt $b ]
then
   echo "a is greater than b"
else # [ $a -lt $b ]
#then
  echo "a is less than b"
#else
#   echo "None of the condition met"
fi
