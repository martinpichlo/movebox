#!/bin/sh

inbox="${1%/}"
outbox="${2%/}"

main() {
    if ! check_parameter; then
        return 1 #false
    fi
    read_folder
    watch_folder
}

check_parameter () {
    if ! [ -d "$inbox" ]; then
        echo "Path $inbox to inbox is not existing"
        return 1 #false
    fi

    if ! [ -d "$outbox" ]; then
        echo "Path $outbox to outbox is not existing"
        return 1 #false
    fi
    return 0 #true
}

read_folder () {
    find "$inbox" -maxdepth 1 -mindepth 1 | while read file
    do
        if is_file_written "$file"; then
             move_and_rename "$file"
        fi
    done
}

watch_folder () {
    inotifywait -mrq -e create -e moved_to --format %w%f $inbox | while read file
    do
        if is_file_written "$file"; then
             move_and_rename "$file"
        fi
    done
}

is_file_written () {
    file="$1"
    filename=$(basename $file)

    if [ "$filename" = "tmp.txt" ]; then
        echo "Ignored $filename in inbox"
        return 1 #false
    fi

    echo "Found $filename in inbox"
    filesize_old=-1
    while true; do
        filesize=$(stat -c %s "$file")
        if [ "$filesize" = "$filesize_old" ]; then
            break
        fi
        sleep 10 #some scaners needs more than 1 sec
        filesize_old="$filesize"
    done
    return 0 #true
}

move_and_rename () {
    file="$1"
    filename=$(basename $file)
    name=${filenamee%.*}
    suffix=${filename##*.}
   
    while true; do
        datetime="$(date +%Y%m%d_%H%M%S)"
        filename_new="SCN_$datetime.$suffix"
        file_new="$outbox/$filename_new"
        if [ ! -f $file_new ]; then
            break
        fi
    done
    echo "Moved to $filename_new in outbox"
    mv $file $file_new
}

main
