#!/usr/bin/env fish

if not type -q certbot
    echo "You have to install certbot"
    exit 1
end

set CERTBOT_ARGS

function parse_eab_credentials
    set python (command -v python3 || command -v python)
    switch "$($python -V)"
        case 'Python 3*'
            # valid python version
        case '*'
            echo 'No python3 detected'
            exit 1
    end
    set pyprog "import sys, json; js = json.loads(sys.argv[1]); print(js['eab_kid']); print(js['eab_hmac_key']);"
    set eab_credentials (echo $argv[1] | env PYTHONIOENCODING=utf8 $python -c $pyprog)
    set ZEROSSL_EAB_KID (echo $eab_credentials[1])
    set ZEROSSL_EAB_HMAC_KEY (echo $eab_credentials[2])
    set CERTBOT_ARGS $CERTBOT_ARGS --eab-kid $ZEROSSL_EAB_KID --eab-hmac-key $ZEROSSL_EAB_HMAC_KEY --server "https://acme.zerossl.com/v2/DV90"
end

while [ (count $argv) -gt 0 ]
    switch $argv[1]
        case '--zerossl-api-key=*'
            set ZEROSSL_API_KEY (echo $argv[1] | sed 's/--zerossl-api-key=//')
        case '--zerossl-api-key' '-z'
            set ZEROSSL_API_KEY $argv[2]
            set argv $argv[1..-1]
        case '--zerossl-email=*'
            set ZEROSSL_EMAIL (echo $argv[1] | sed 's/--zerossl-email=//')
        case '--email' '--zerossl-email' '-m'
            set ZEROSSL_EMAIL $argv[2]
            set CERTBOT_ARGS $CERTBOT_ARGS -m $argv[2]
            set argv $argv[1..-1]
        case '*'
            set CERTBOT_ARGS $CERTBOT_ARGS $argv[1]
    end
    set argv $argv[2..-1]
end

if test -n "$ZEROSSL_API_KEY"
    parse_eab_credentials (curl -s -X POST "https://api.zerossl.com/acme/eab-credentials?access_key=$ZEROSSL_API_KEY")
else if test -n "$ZEROSSL_EMAIL"
    parse_eab_credentials (curl -s https://api.zerossl.com/acme/eab-credentials-email --data "email=$ZEROSSL_EMAIL")
end

echo certbot $CERTBOT_ARGS
certbot $CERTBOT_ARGS
