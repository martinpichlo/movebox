#!/bin/sh

#import enviroment variables
INBOX="$INBOX"
OUTBOX="$OUTBOX"

watch_folder () {
    
    inotifywait -mrq -e create -e moved_to --format %w%f $INBOX | while read FILE
    do
        if wait_for_file "$FILE"; then
             move_and_rename "$FILE" "$OUTBOX"
        fi
    done
}

wait_for_file () {

    FILE="$1"
    FILENAME=$(basename $FILE)

    if [ "$FILENAME" = "tmp.txt" ]; then
        echo "Ignored $FILENAME in inbox"
        return 1 #false
    fi

    echo "Found $FILENAME in inbox"
    FILESIZE_OLD=-1
    while [ true ] ; do
        FILESIZE=$(stat -c %s "$FILE")
        if [ "$FILESIZE" = "$FILESIZE_OLD" ]; then
            break
        fi
        sleep 5 #some scaners needs more than 1 sec
        FILESIZE_OLD="$FILESIZE"
    done
    return 0 #true

}

move_and_rename () {

    FILE="$1"
    FILENAME=$(basename $FILE)
    NAME=${FILENAMEe%.*}
    SUFFIX=${FILENAME##*.}

    
    while [ true ] ; do
        DATETIME="$(date +%Y-%m-%d_%H-%M-%S)"
        FILENAME_NEW="SCN_$DATETIME.$SUFFIX"
        FILE_NEW="$OUTBOX/$FILENAME_NEW"
        if [ ! -f $FILE_NEW ]; then
            break
        fi
    done
    echo "Moved to $FILENAME_NEW in outbox"
    mv $FILE $FILE_NEW

}

watch_folder

