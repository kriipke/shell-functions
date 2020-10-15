#!/bin/sh

# Function to upload text/files/directories from the command line
#
# If file is a text file, it is uploaded to:
#       https://hastesbin.com
# If file is a binary file, it is uploaded to:
#       https://file.io
# If file is a directory, it is archived via tar and uploaded to:
#       https://file.io
# If file is a symlink, the link is followed and uploaded
# 

upload() {
    case "$#" in
    0 )
      text="$( cat )" ;;
    1 )
        case "$1" in
        -h | --help )
            echo '
Usage: $ upload FILE
       $ upload DIRECTORY
       $ echo "some text" | upload
       $ upload<Enter>
some 
text to
be uploaded
<Ctrl+d>'
            ;;
        *)
            file="$1"
            ;;  
        esac

        mime_type="$(file -b --mime-type "$1")"
        if [ "$mime_type" = 'inode/symlink' ]; then
            file="$(readlink "$file")"
            mime_type="$(file -b --mime-type "$file")"
        fi

        case "$mime_type" in
        text/* )
            text="$( cat "$file" )"
            unset file
            ;;
        inode/directory )
            if command -v tar >/dev/null 2>&1; then
                if [ -d "$file" ]; then
                    archive_path="/tmp/$( basename "$file" ).tar"
                    previous_working_dir="$(pwd)" \
                        && cd "$(dirname "$file")" || exit 1
                    tar  -cvf "$archive_path" "$(basename "$file")" \
                        && file="$archive_path"
                    cd "$previous_working_dir" || exit 1
                fi
            fi
            ;;
      esac
      ;;
    * )
        echo "Error: only one file at a time can be uploaded" ;;
    esac

    if [ -n "$file" ]; then
        duration="1m"
        upload_url="$( printf 'https://file.io?expires=%s' "$duration" )"
        url="$(curl -# -F "file=@$file" "$upload_url" \
            | cut -d, -f3 \
            | cut -b 8- \
            | tr -d \")"
    elif [ -n "$text" ]; then
        upload_url='https://hastebin.com/documents'
        file_uri="$(curl -# -X POST -s -d "$text" "$upload_url" \
            | cut -d: -f2 \
            | tr -d "[:punct:]")"
        url=$( printf 'https://hastebin.com/%s' "$file_uri")
        raw_url=$( printf 'https://hastebin.com/raw/%s' "$file_uri")
    else
        echo 'Upload script failed - neither $text nor $file defined'
    fi
    
    if command -v qrencode > /dev/null 2>&1; then
        qrencode -t ANSI -o - "$url"
    else
        echo Install qrencode to output QR code to link!
    fi

    printf "\n%s\n%s\n" \
        "${raw_url:+Regular: } $url" \
        "${raw_url:+Raw: } $raw_url"

    unset url raw_url file_uri upload_url \
        archive_path text file mime_type duration
}
