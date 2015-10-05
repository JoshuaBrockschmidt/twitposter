#!/usr/bin/env bash

source "$(dirname $0)/../twitposter.conf"

for t in $(seq 1 $TRY_LIMIT)
do
    # Retry if Tweet command or posttotwitter have a bad exit status.
    TWEET=$($TWEET_CMD 2> $LOG_FILE)
    if [ $? -ne 0 ]
    then
	continue
    fi

    $PARENT_DIR/bin/posttotwitter "$TWEET" 2>&1 | tee -a $LOG_FILE
    if [ $? -ne 0 ]
    then
	continue
    fi

    echo "$PARENT_DIR/bash/trytweet.sh: \
tweet successfully posted: \"$TWEET\"" 2>&1 | tee -a $LOG_FILE
    break
done

if [ $t -eq $TRY_LIMIT ]
then
    echo "$PARENT_DIR/bash/trytweet.sh: \
could not post tweet: \"$TWEET\"" 2>&1 | tee -a $LOG_FILE
fi

# Schedule next Tweet
source "$PARENT_DIR/bash/timer.sh"
schedTweet
