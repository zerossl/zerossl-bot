#!/bin/bash


ZEROSSLBOT_SCRIPT_LOCATION=${ZEROSSLBOT_SCRIPT_LOCATION-"https://raw.githubusercontent.com/digitalsparky/zerossl-bot/master/zerossl-bot.sh"}

function install_zerosslbot()
{
    sudo bash <<EOF
        curl -s "$ZEROSSLBOT_SCRIPT_LOCATION" > /tmp/zerossl-bot && \
        mkdir -p /usr/local/bin
        mv /tmp/zerossl-bot /usr/local/bin/zerossl-bot && \
        chmod +x /usr/local/bin/zerossl-bot
EOF
}

install_zerosslbot
