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

    # Clear log.
    printf "" > $LOG_FILE

    if [ $ELAPSE_MIN -lt 1 ]
    then
	echo "$0: ELAPSE_MIN must be greater than 1" | tee -a $LOG_FILE
	exit 1
    elif [ $ELAPSE_MAX -lt $ELAPSE_MIN ]
    then
	echo "$0: ELAPSE_MAX must be greater than or equal to ELAPSE_MIN" | tee -a $LOG_FILE
	exit 1
    fi

    schedTweet
    if [ $? -ne 0 ]
    then
	echo "$0: could not start at job"
	exit 1
    fi

    echo 1 &> $STATUS_FILE
    echo "Started" | tee -a $LOG_FILE
}

stop() {
    if [ $(status) -eq 0 ]
    then
	echo "Not running"
	return
    fi

    if [ -e $AT_ID_FILE ]
    then
	local AT_ID=$(cat $AT_ID_FILE)
	if [ -n "$AT_ID" ]
	then
	   atrm $AT_ID
	   rm $AT_ID_FILE
	fi
    fi
    echo 0 &> $STATUS_FILE
    echo "Stopped" | tee -a $LOG_FILE
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
