#!/usr/bin/env bash

source "$(dirname $0)/../twitposter.conf"
AT_ID_FILE="$PARENT_DIR/var/at_id"

schedTweet() {
    local T
    let "T=$RANDOM%($ELAPSE_MAX-$ELAPSE_MIN+1) + $ELAPSE_MIN"
    # The path to the script is fed in via stdout instead of -f because there
    # were some problems resolving a relative directory name withing trytweet.sh.
    echo "$PARENT_DIR/bash/trytweet.sh" | at -M now + $T min 2>&1 | tee -a $LOG_FILE | awk '/job/ {print $2}' > $AT_ID_FILE
    if [ $? -ne 0 ] || [ -z $(cat $AT_ID_FILE) ]
    then
	echo "$PARENT_DIR/bash/timer.sh: could not start at job" >> $LOG_FILE 2>&1
	return 1
    fi
    echo "$PARENT_DIR/bash/timer.sh: at job scheduled to run in $T minutes" >> $LOG_FILE 2>&1
    
    return 0
}
