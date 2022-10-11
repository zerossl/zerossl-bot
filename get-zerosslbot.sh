#!/bin/bash


ZEROSSLBOT_SCRIPT_LOCATION=${ZEROSSLBOT_SCRIPT_LOCATION-"https://github.com/zerossl/zerossl-bot/raw/master/zerossl-bot.sh"}

function install_zerosslbot()
{
    sudo bash <<EOF
        mkdir -p /usr/local/bin
        wget -qO - "$ZEROSSLBOT_SCRIPT_LOCATION" > /usr/local/bin/zerossl-bot
        chmod +x /usr/local/bin/zerossl-bot
EOF
}

install_zerosslbot
