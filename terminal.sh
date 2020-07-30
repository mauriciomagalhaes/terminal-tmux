#!/bin/bash
#
TRACEROUTEIP=''

SESSION=${SESSION:='Ipbx'}

SESSIONEXISTS=$(tmux list-sessions | grep $SESSION)

echo ""
echo "Não existe sessões, aguarde ..."
echo ""

if [ "$SESSIONEXISTS" = "" ]
then
        echo ""
        echo "Não existe sessões, aguarde ..."
        echo ""

        tmux new-session -d -s $SESSION

        tmux rename-window 'Terminal SIP'

        tmux split-window -v

        tmux select-pane -t 0
        tmux split-window -h
        tmux resize-pane -L 30
        tmux resize-pane -U 10

        tmux select-pane -t 2
        tmux split-window -v

        tmux select-pane -t 3
        tmux resize-pane -U 5
        tmux split-window -v

        #
        tmux select-pane -t 0
        tmux send-key "mtr $TRACEROUTEIP" C-m
        #
        tmux select-pane -t 1
        tmux send-key "watch -n 1 'rasterisk -x "'"sip show channels"'" | grep ACK'" C-m
        #
        tmux select-pane -t 2
        tmux send-key "watch -n 1 'rasterisk -x "'"sip show channelstats"'"'" C-m
        #
        tmux select-pane -t 4
        tmux send-key "watch -n 1 -t 'rasterisk -x "'"core show channels concise"'"'" C-m
        #tmux send-key "watch -n 1 'rasterisk -x "'"core show channels concise"'" | grep -v sms'" C-m

        tmux select-pane -t 3
        tmux send-key "watch -n 1 -c 'rasterisk -x "'"queue show"'"'" C-m

        tmux new-window -t $SESSION:1 -n 'Shell'
        tmux select-window -p
        tmux select-pane -t 0
        tmux attach
fi

tmux attach-session -t $SESSION
tmux select-pane -t 0

