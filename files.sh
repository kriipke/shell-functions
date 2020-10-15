#!/bin/sh

# Usage: trspaces [--dry-run] [FILE]
#        trspaces [--dry-run] DIR/* 
# 
# Without any arguments it will translate spaces to
# the _ (underscore) character forevery file in the
# current directory, otherwise it will assume each
# argument is a file

trspaces() {
    if [ "$1" = '--dry-run' ]; then
        DRY_RUN=1
        shift
    fi
    for FILENAME in ${@:-*}; do
        N_WORDS=$(echo $FILENAME | wc -w)
        NEW_FILENAME="$( echo $FILENAME | tr ' ' _ )"
        if [ $N_WORDS -gt 1 ]; then
            ${DRY_RUN:+echo} mv ${DRY_RUN:+\"}$FILENAME${DRY_RUN:+\"} $NEW_FILENAME
        fi
    done
    unset DRY_RUN FILENAME NEW_FILENAME N_WORDS
}

