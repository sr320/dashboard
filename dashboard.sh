#!/bin/bash

#brew install figlet xmlstarlet


SESSION="labdash3"

# Kill any existing session
tmux kill-session -t $SESSION 2>/dev/null

# Start session
tmux new-session -d -s $SESSION

# Pane 1: htop system monitor
tmux send-keys -t $SESSION 'ssh sr320@raven.fish.washington.edu -t htop' C-m




# Pane 2: rss

# brew install xmlstarlet

tmux split-window -h -t $SESSION
tmux send-keys -t $SESSION.1 '
while true; do
  clear
  echo "Recent Posts from GeneFish RSS"
  echo "-------------------------------"
  curl -Ls https://genefish.wordpress.com/feed | \
    xmlstarlet sel -N content="http://purl.org/rss/1.0/modules/content/" \
                   -t -m "//item" -o "- " -v "title" -o "$'\n\n'" -n | head -n 20 
  sleep 60
done
' C-m

# Pane 3: Lab news feed
tmux split-window -v -t $SESSION.1
tmux send-keys -t $SESSION.2 'while true; do clear; figlet "Lab News"; echo; while IFS= read -r line; do echo "$line"; sleep 2; done < news.txt; done' C-m

# Focus back to top-left
tmux select-pane -t $SESSION.0

# Attach session
tmux attach-session -t $SESSION