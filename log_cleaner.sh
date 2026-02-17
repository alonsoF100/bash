#!/bin/bash

log_dir="/test"

if [ ! -d "$log_dir" ]
then
echo "DIR: $log_dir is not a dir or dont exists..."
exit 1
fi

for file in "$log_dir"/*.log
do
if [ -f "$file" ]
then
filesize=$(stat -c%s "$file")
if [ $filesize -gt 104857600 ]
then
gzip "$file"
echo "Name: $file compressed"
else
echo "Name: $file is to small, skip..."
fi
fi
done
exit 0