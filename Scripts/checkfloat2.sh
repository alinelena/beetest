#!/bin/bash

tail -n 1 logfile | awk '{print $1}'
