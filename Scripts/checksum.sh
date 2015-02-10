#!/bin/bash

os=`uname`

# MacOS X has md5 command
if [ "$os" = "Darwin" ]; then
	md5 logfile | awk '{print $4}'
fi
# Most Linux distros usually md5sum
if [ "$os" = "Linux" ]; then
	md5sum logfile | awk '{print $1}'
fi

# Solaris?
# AIX?

