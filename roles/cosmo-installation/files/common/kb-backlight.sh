#!/bin/bash
FILE="$HOME/.config/kb-backlight-level"

if ! [ -f "$FILE" ]; then
    echo "$FILE doesn't exist, creating one."
    echo 40 > $FILE
fi

case "$1" in
    up) ;;
    down) ;;
    *)
        echo "Wrong argument supplied, must be up or down"
        exit 1 ;;
esac

CURRENT_VALUE=$(cat $FILE)

if ! [[ "$CURRENT_VALUE" =~ ^[0-9]+$ ]]; then
    echo "Wrong value in $FILE, reverting to OFF value."
    echo 40 > $FILE
    exit 2
fi

if [ $1 == "up" ]; then
    if (($CURRENT_VALUE < 45)); then
        VALUE=$(expr $CURRENT_VALUE + 1)
    else
        echo "Max brightness."
        exit 0
    fi
else
    if (($CURRENT_VALUE > 40)); then
        VALUE=$(expr $CURRENT_VALUE - 1)
    else
        echo "Zero brightness."
        exit 0
    fi
fi

echo $VALUE > /proc/aw9524_led_proc
echo $VALUE > $FILE

exit 0
