#!/bin/bash
while true; do
  clear
  figlet "Lab News"
  echo
  while IFS= read -r line; do
    echo "$line"
    sleep 2
  done < /Users/sr320/Desktop/rstudio.txt
done