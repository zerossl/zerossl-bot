#!/usr/bin/env fish

function install_zerosslbot
    # Copy the zerossl_bot.fish script to /usr/local/bin
    sudo cp ./zerossl_bot.fish /usr/local/bin/zerossl-bot
    # Make the script executable
    sudo chmod +x /usr/local/bin/zerossl-bot
end

# Call the function to install the script
install_zerosslbot
