#!/bin/bash

dir=/var/www/app

if [ ! -d "$dir" ]
then
	echo "Failed to find dir:$dir..."
	exit 1
fi

if [ ! -n "$(pgrep nginx)" ]
then
	echo "Nginx is not runnig..."
	exit 2
fi

echo "Server healthy!"
exit 0