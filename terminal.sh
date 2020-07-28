#!/bin/bash
#
TRACEROUTEIP='177.85.70.242'

SESSION=${SESSION:='Ipbx'}

SESSIONEXISTS=$(tmux list-sessions | grep $SESSION)

echo ""
echo "Não existe sessões, aguarde ..."
echo ""

if [ "$SESSIONEXISTS" = "" ]
then
        tmux new-session -d -s $SESSION

        tmux rename-window 'Terminal SIP'

        tmux split-window -v

        tmux select-pane -t 0
        tmux split-window -h
        tmux resize-pane -L 30
        tmux resize-pane -U 4

        tmux select-pane -t 2
        tmux split-window -v

        tmux select-pane -t 3
        #tmux split-window -h
        #tmux resize-pane -L 40

        #
        tmux select-pane -t 0
        tmux send-key "mtr <IP>" C-m
        #
        tmux select-pane -t 1
        tmux send-key "watch -n 1 -t 'rasterisk -x "'"sip show channels"'" | grep ACK'" C-m
        #
        tmux select-pane -t 2
        tmux send-key "watch -n 1 -t 'rasterisk -x "'"sip show channelstats"'"'" C-m
        #
        tmux select-pane -t 3
        tmux send-key "watch -n 1 -t \"rasterisk -x 'core show channels concise'\"" C-m

        tmux new-window -t $SESSION:1 -n 'Shell'
        tmux select-window -p
        tmux select-pane -t 0
        tmux attach
fi
tmux attach-session -t $SESSION

