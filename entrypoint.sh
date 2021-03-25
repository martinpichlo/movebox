#!/bin/sh

#get enviroment variables
inbox="$INBOX"
outbox="$OUTBOX"

inotifywait -mrq -e create --format %w%f $inbox | while read FILE
do
    filename=$(basename $FILE)
    echo "Found $filename in inbox"
    while [ true ] ; do
        filesize=$(ls -ld $FILE)
        if [ "$filesize" = "$filesize_old" ]; then
            break
        fi
        sleep 1
        filesize_old="$filesize"
    done
    
    name=${filename%.*}
    suffix=${filename##*.}

    while [ true ] ; do
        datetime="$(date +%Y-%m-%d_%H-%M-%S)"
        filename_new="SCN_$datetime.$suffix"
        FILE_NEW="$outbox/$filename_new"
        if [ ! -f $FILE_NEW ]; then
            break
        fi
    done
    echo "Moved to $filename_new in outbox"
    mv $FILE $FILE_NEW

done
