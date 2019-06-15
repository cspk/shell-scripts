#!/bin/bash

DATE="`LANG=en_US.UTF-8 date +'%a %b %d %H:%M:%S'`"
LANG="`xkblayout-state print %s`"

VOL_STRING="`amixer get Master | grep % | sed '2d'`"
VOL_PERCENT="`echo "$VOL_STRING" | grep -Eo '[0-9]{1,3}\%' | tr -d \%`"

VOL_STATE="`echo "$VOL_STRING" | grep -Eo "(\[on\]|\[off\])" | tr -d []`"
if [ "$VOL_STATE" = "off" ]; then
	VOL_CHAR="🔇"
else
	if [ `expr $VOL_PERCENT \> 40` = "1" ]; then
		VOL_CHAR="🔊"
	elif [ `expr $VOL_PERCENT \< 20` = "1" ]; then
		VOL_CHAR="🔈"
	else
		VOL_CHAR="🔉"
	fi
fi

VOL="$VOL_CHAR $VOL_PERCENT%"

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
	MPD="⏸ $MPD_CURRENT ($MPD_TIME) [$MPD_TRACKS] |"
else
	MPD="⯈ $MPD_CURRENT ($MPD_TIME) [$MPD_TRACKS] |"
fi

echo "$MPD $VOL | $LANG | $DATE"
