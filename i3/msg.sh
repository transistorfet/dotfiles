
CMD=`dmenu <<EOF
focus
move
resize
workspace
EOF`

i3-msg "$CMD"

