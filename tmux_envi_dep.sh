#/bin/bash
cd $1

DIR=$1
PDFDIR="~/${DIR}pdf/"
SESSION="Typst Envi"
WINDOW1="Editor"
WINDOW2="Visor"
NAME=$(basename $DIR) 

# Borrar la sesión 'Typst Envi'
tmux kill-session -t "$SESSION"

#Crear la nueva sesión 'Typst Envi'
tmux new-session -d -s "$SESSION" -c "$DIR"
tmux renamew -t "$SESSION:0" "$WINDOW1"

# Abrir el .typ principan el el panel 0
tmux send-keys -t "$SESSION:$WINDOW1.0" "cd $PDFDIR" C-m
tmux send-keys -t "$SESSION:$WINDOW1.0" "nvim $NAME.typ" C-m

# Crear el panel 1
tmux splitw -t "$SESSION:$WINDOW1.0" -v -l 1

# Ejecutar comando 'watch'
tmux send-keys -t "$SESSION:$WINDOW1.1" "typst watch $PDFDIR$NAME.typ" C-m

if [ $# -eq 2 ]; then
	if [ "$2" = "-p"  ]; then
		# Visualizar 'plantilla.typ'
		tmux splitw -t "$SESSION:$WINDOW1.0" -h 
		tmux send-keys -t "$SESSION:$WINDOW1.1" "cd $PDFDIR" C-m
		tmux send-keys -t "$SESSION:$WINDOW1.1" "nvim plantilla.typ" C-m
	fi
fi

# Crear la ventana 1 'Visor'
tmux neww -S -t "$SESSION" -n "$WINDOW2" -c "$DIR"

# Visualizar el PDF con 'zathura'
tmux send-keys -t "$SESSION:$WINDOW2" "zathura $PDFDIR$NAME.pdf &" C-m C-l

# Volver a la ventana 1
tmux selectw -t "$SESSION:$WINDOW1"

# Conectarse a la sesión 'Typst Envi'
tmux attach-session -t "$SESSION"
