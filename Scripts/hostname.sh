#!/bin/bash
head -n 1 logfile|awk '{print $4}'
