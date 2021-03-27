#!/bin/bash
inbox="$INBOX"
echo "$INBOX"
test() {
    echo "hallo"
    true
}

test "hallo"
echo $?
