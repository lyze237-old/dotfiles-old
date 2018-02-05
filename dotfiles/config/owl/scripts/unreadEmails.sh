#!/bin/bash

maildir=$(echo ~/.Mail/mailbox)

maxUnread=0

for dir in $(ls $maildir) ; do
    fullDir=$(echo $maildir/$dir/new)
    
    if [ -d "$fullDir" ] ; then
        unreadInDir=$(find $fullDir -maxdepth 1 -type f | wc -l)
        maxUnread=$(($maxUnread + $unreadInDir))
    fi
done

if [ $maxUnread -eq 0 ] ; then
    echo $3
else
    echo $1 $maxUnread $2
fi
