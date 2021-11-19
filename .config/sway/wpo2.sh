#!/usr/bin/bash
WORKSPACES_CURRENT=`swaymsg -t get_workspaces | jq '.[]|"focused=\(.focused) name=\(.name) output=\(.output) visible=\(.visible)"' | grep "focused=true"`
OUTPUT_CURRENT=`awk -v var="$WORKSPACES_CURRENT" 'BEGIN{split(var, a);split(a[3], b, "=");print b[2];}'`
WORKSPACE_CURRENT_NAME=`awk -v var="$WORKSPACES_CURRENT" 'BEGIN{split(var, a);split(a[2], b, "=");print b[2]}'`

WORKSPACES_NEW=`swaymsg -t get_workspaces | jq '.[]|"focused=\(.focused) name=\(.name) output=\(.output) visible=\(.visible)"' | grep "name=$1"`
#OUTPUT_NEW=`echo $WORKSPACES_NEW | awk '{print $3}' | awk -F'=' '{print $2}'`
OUTPUT_NEW=`awk -v var="$WORKSPACES_NEW" 'BEGIN{split(var, a);split(a[3], output, "=");print output[2]}'`
#VISIBLE_NEW=`echo $WORKSPACES_NEW | awk '{print $4}' | awk -F'=' '{print $2}' | awk -F'\"' '{print $1}'`
VISIBLE_NEW=`awk -v var="$WORKSPACES_NEW" 'BEGIN{split(var, a);split(a[4], visible, "=");split(visible[2], visible, "\"");print visible[1]}'`
#FOCUSED_NEW=`echo $WORKSPACES_NEW | awk '{print $1}' | awk -F'=' '{print $2}'`
FOCUSED_NEW=`awk -v var="$WORKSPACES_NEW" 'BEGIN{split(var, a);split(a[1], focused, "=");print focused[2]}'`

if [[ "$2" = "move" ]]; then
    swaymsg move container workspace $1
    if [[ -z $3 ]]; then 
	exit
    fi
fi

if [[ "$FOCUSED_NEW" != "true"  ]]; then
    if [[ "$VISIBLE_NEW" != "true" ]]; then
	swayws move $1 $OUTPUT_CURRENT && swayws focus $1
    else
	if [[ "" = "$WORKSPACES_NEW" ]]; then
	    swayws focus "$1"
	else
	    swayws move "$WORKSPACE_CURRENT_NAME" "$OUTPUT_NEW" ; swayws move "$1" "$OUTPUT_CURRENT" ; swayws focus $1
	fi
    fi
fi
