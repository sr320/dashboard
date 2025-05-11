#!/bin/bash

#brew install figlet xmlstarlet

SESSION="labdash3"

# Kill any existing session
tmux kill-session -t $SESSION 2>/dev/null

# Start session
tmux new-session -d -s $SESSION

# Pane 1: htop system monitor
tmux send-keys -t $SESSION 'ssh sr320@raven.fish.washington.edu -t htop' C-m

# Pane 2: Lab news feed (now on the right)
tmux split-window -h -t $SESSION
tmux send-keys -t $SESSION.1 'while true; do clear; figlet "Lab News"; echo; while IFS= read -r line; do echo "$line"; sleep 2; done < news.txt; done' C-m

# Pane 3: RSS feed (now on the bottom)
tmux split-window -v -t $SESSION.1
tmux send-keys -t $SESSION.2 '
while true; do
  clear
  echo "Recent Posts from GeneFish RSS"
  echo "-------------------------------"
  curl -Ls https://genefish.wordpress.com/feed | \
    xmlstarlet sel -N content="http://purl.org/rss/1.0/modules/content/" \
                   -t -m "//item" -o "- " -v "title" -o "$'\n\n'" -n | head -n 10 
  sleep 60
done
' C-m

# Pane 4: GitHub activity feed
tmux split-window -v -t $SESSION.2
tmux send-keys -t $SESSION.3 'while true; do clear; echo "Recent GitHub Activity - org: RobertsLab"; echo "------------------------------------------"; curl -s https://api.github.com/orgs/RobertsLab/events | jq -r ".[] | \"- [\" + (.created_at | split(\"T\")[0]) + \"] \" + .type + \" by \" + .actor.login + \" on \" + .repo.name" | head -n 10; sleep 60; done' C-m

# Focus back to top-left
tmux select-pane -t $SESSION.0

# Attach session
tmux attach-session -t $SESSION