#!/bin/bash
cd /Users/sr320/Documents/GitHub/course-fish546-2025
while true; do
  clear
  echo "Recent Git Commits"
  git pull --quiet
  git log --oneline -n 10
  sleep 60
done