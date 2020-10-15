#!/bin/sh

# Queries man page for usage of a particual option/switch

# Usage: explain command [-]SWITCH
# e.g. explain cut -f
explain() {
	CMD="$1" && shift
	printf "\n%s:\n"  "$CMD"

	while [ "$#" -gt 0 ]; do
		ARG="$1"
		case $ARG in
			--* )
				RE="^\\\\s*(-.|.)?,?\\\\s*?${ARG}\\\\s"
				;;
			-* | ? )
				RE="^\\\\s*${ARG},*\\\\s"
				;;
		esac

		man "$CMD" \
			| col -bx \
			| sed -r '/^([A-Z]+\s)+/d' \
			| awk -v re="$RE" '
			BEGIN { 
				RS=""
				FS="\n"
				OFS="\n"
			}
			{ 
				if ( $0 ~ re ) 
					{ printf "%s\n\n", $0 }
			}'

	shift
	done
}
