#!/bin/bash


ZEROSSLBOT_SCRIPT_LOCATION=${ZEROSSLBOT_SCRIPT_LOCATION-"https://zerossl.com/zerossl-bot.sh"}

function install_zerosslbot()
{
    curl -s "$ZEROSSLBOT_SCRIPT_LOCATION" > /tmp/zerossl-bot
    sudo bash <<EOF
        mkdir -p /usr/local/bin && \
        mv /tmp/zerossl-bot /usr/local/bin/zerossl-bot && \
        chmod +x /usr/local/bin/zerossl-bot
EOF
}

install_zerosslbot
