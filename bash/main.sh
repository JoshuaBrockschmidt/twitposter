#!/usr/bin/env bash

# WARNING: No error checking is done. This script assumes the files/directories it needs
# to be readable/writable are so. Make sure the Makefile is ran to create the
# 'var' directory and such.

# Get parent directory.
DIR=$(dirname $0)

source "$DIR/../twitposter.conf"
source "$PARENT_DIR/bash/timer.sh"
STATUS_FILE="$PARENT_DIR/var/status"

if [ ! -e $STATUS_FILE ]
then
   # Initialize status file
    echo 0 &> $STATUS_FILE
fi

status() {
    echo $(cat $STATUS_FILE)
}

start() {
    if [ $(status) -ne 0 ]
    then
	echo "Already running"
	return
    fi

    schedTweet
    echo 1 &> $STATUS_FILE
    echo "Started"
    echo "Started" >> $LOG_FILE 2>&1
}

stop() {
    if [ $(status) -eq 0 ]
    then
	echo "Not running"
	return
    fi
    if [ -e $AT_ID_FILE ]
    then
	atrm $(cat $AT_ID_FILE)
	rm $AT_ID_FILE
    fi
    echo 0 &> $STATUS_FILE
    echo "Stopped"
    echo "Stopped" >> $LOG_FILE 2>&1
}

case "$1" in
    start)
	start
	;;
    stop)
	stop
	;;
    restart)
	stop
	start
	;;
    status)
	if [ $(status) -eq 0 ]
	then
	    echo "Not running"
	else
	    echo "Running"
	fi
	;;
    *)
	echo "Usage: $0 {start|stop|restart|status}"
	exit 1
	;;
esac
