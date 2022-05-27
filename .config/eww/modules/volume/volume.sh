#!/bin/sh

killed=false
for pid in $(pidof -x volume.sh); do
    if [ $pid != $$ ]; then
        kill -9 $pid
        killed=true
    fi
done >/dev/null

if ! $killed; then
    eww update volume-hidden=true
    eww open volume
fi

eww update volume-level=$(pamixer --get-volume)
eww update volume-muted=$(pamixer --get-mute)
eww update volume-hidden=false
sleep 2
eww update volume-hidden=true
sleep 1
eww close volume
unset killed
