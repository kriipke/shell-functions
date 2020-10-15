#!/bin/sh

# Functions for easily working with files encrypted using PGP.

# Yeilds ASCII armored files,
# i.e ones with the following format:
#
#   -----BEGIN PGP MESSAGE-----
#   
#   hQEMAwAAAAAAAAAAAQgAkBaDV/Q2bUeH/GtNzEczpWMLLv/ftNWJ/ZnRjIG37OYd
#   ECrd/M4xWAM/kNyGvSpDinPc+Gxm6CynDL3BuYK8Lj/LeMWkZhu/zqihBi8uXp9V
#   DC90Ec2l445TvverRwuz7+OakS0qJ1r0cnJ1LyfHmW7BBqjzHv0YTk32YA00X0H6
#   ....
#   w3HQekfdT/5V3LAa9eE084s194c9g8OaxDvGrZte/PWQK6+syJe2DvyUu5iT6P8K
#   c378L1wsZbY/KkBmMiuKLUwyzNd1Hzk6kt35XmqqsvfJmLK6C1IcBze94shX+Ipz
#   42fJC1SRtm0Na+Bfkv1sEo3AZAHWcwyjI46vXx3bY/2pHhoUCrtLzHbtUjAsPplf
#   -----END PGP MESSAGE-----

encrypt () {
      gpg_id='l0xy@pm.me'
      output="$( printf '%s/%s.enc' "$(dirname "$1")" "$1" )"
      gpg --encrypt --armor --output "$output" -r "$gpg_id" "$1" \
            && echo "$1 -> $output"
}

decrypt () {
      output=$(echo "$1" | rev | cut -c16- | rev)
      gpg --decrypt --output "$output" "$1" \
            && echo "$1 -> $output"
}

# Usage: mkpass [LENGTH]
mkpass () {
    tr -dc 'A-Za-z0-9_' < /dev/urandom \
        | head -c "${1:-20}" \
        | xargs
}

