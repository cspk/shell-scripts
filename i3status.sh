#!/bin/sh

i3status | while :
do
	read line

	VOL=`echo $line | cut -d '|' -f 1`
	DATE=`echo $line | cut -d '|' -f 2`
	LANG="`xkblayout-state print %s`"

	MPD_STATUS="`mpc status | sed '1d;3d'`"
	MPD_CURRENT="`mpc current`"
	MPD_RC=$?
	MPD_STATE="`echo "$MPD_STATUS" | grep -Eo '\[.*\]' | tr -d "[]"`"
	MPD_TIME="`echo "$MPD_STATUS" | awk '{ print $3 }'`"
	MPD_TRACKS="`echo "$MPD_STATUS" | awk '{ print $2 }' | tr -d '#'`"
	if [ $MPD_RC -eq 1 ]; then
		MPD="mpd not running |"
	elif [ -z "$MPD_STATE" ]; then
		MPD=""
	elif [ "$MPD_STATE" = "paused" ]; then
		MPD="[paused] `mpc current` ($MPD_TIME) [$MPD_TRACKS] |"
	else
		MPD="[playing] `mpc current` ($MPD_TIME) [$MPD_TRACKS] |"
	fi

	echo "$MPD $VOL| $LANG |$DATE " || exit 1
done
