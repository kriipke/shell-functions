#!/bin/sh

get_glyph_hex() {
	# for use with printf
	eval printf "\$$1" \
		| xxd -i \
		| sed -E 's/(, )?0/\\/g' \
		| tr -d '[:space:]'
}


date_time() {
	# format used:
	# Wednesday Sep 30, 6:09 PM
	DATE="$( date +%A\ %b\ %d )"
	TIME="$( date  +%I:%m\ %p | sed 's/^0*//' )"
	printf '%s, %s' "$DATE" "$TIME"
}

wifi_vpn_icons() {
	ICON_WIFI=' '
		ICON_VPN_ON=' '
		ICON_VPN_OFF=' '
		if command -v nmcli >/dev/null 2>&1; then
			while read line; do
			CONN_TYPE=$( echo "$line" | cut -d: -f3 )
			if [ "$CONN_TYPE" = '802-11-wireless' ]; then
				WIFI_STATUS="$ICON_WIFI"
			fi
			if [ "$CONN_TYPE" = 'tun' ]; then
				VPN_STATUS="$ICON_VPN_ON"
			else
				VPN_STATUS="$ICON_VPN_OFF"
			fi
				done < <( nmcli -t con show --active ) 
				printf '%s%s' "$WIFI_STATUS" "$VPN_STATUS"
			else
				printf 'Error: nmcli not found.'
		fi
}

load_stats() {
	UPTIME="$( uptime -p )"
	AVG_LOAD="$( uptime | sed 's/.*,//' )"
	printf '%s @ %s' "$UPTIME" "$AVG_LOAD"
}

ip_geolocation() {
	curl -sSL https://freegeoip.app/json \
		| jq -c '[.ip, .city, .country_name] | @tsv'  \
		| xargs -0 printf  \
		| tr  -d  \"  \
		| awk '{ printf("%s  (%s, %s)", $1, $2, $3); }'
}
