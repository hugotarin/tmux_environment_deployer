#/bin/bash
cd $1

DIR=$1
SESSION="Typst Envi"
WINDOW1='Editor'
WINDOW2="Visor"
NAME=$(basename $DIR) 

tmux new-session -d -s "$SESSION" -c "$DIR"
tmux renamew -t "$SESSION:0" "$WINDOW1"

tmux splitw -v -l 10
tmux splitw -h -l 100

tmux neww -S -t "$SESSION" -n "$WINDOW2" -c "$DIR"

zathura $DIR/pdf/$NAME.pdf &

tmux attach-session -t "$SESSION"
