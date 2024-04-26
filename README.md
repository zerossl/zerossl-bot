zerossl-bot
===========

This repository contains a wrapper script that makes it easier to use 
Electronic Frontier Foundation's (EFF's) Certbot with the ZeroSSL ACME server

Installation
------------

1. Install the operating system packages for `curl`, `certbot` and `python3`.
2. Install the ZeroSSL wrapper script
   1. Quick: 
      1. run `bash <(wget -q -O - https://github.com/zerossl/zerossl-bot/raw/master/get-zerosslbot.sh)`
      2. Done!
   2. Careful: 
      1. Run `wget -q -O - https://github.com/zerossl/zerossl-bot/raw/master/get-zerosslbot.sh > get-zerosslbot.sh`
      2. Inspect the file to see that it does what it is supposed to do
      3. Run `source get-zerosslbot.sh`
      
Usage
-----

To use the ZeroSSL ACME server instead of running `certbot` run `zerossl-bot`.

**Important Note:** You should use the `--zerossl-api-key` argument in order to make sure you get a ZeroSSL certificate instead of an Let's Encrypt certificate.

### Examples

```bash
sudo zerossl-bot certonly --standalone -m anton@example.com -d mydomain.example.com
```

```bash
sudo zerossl-bot --apache -m barbara@example.com -d myotherdomain.example.com
```

```bash
sudo zerossl-bot --apache -d mythirddomain.example.com --zerossl-api-key 1234567890abcdef1234567890abcdef
```

```bash
sudo zerossl-bot certonly --dns-cloudflare --dns-cloudflare-credentials /root/.secrets/cloudflare-api-token \
                          --dns-cloudflare-propagation-seconds 60 -d fourth.example.com \
                          --zerossl-api-key=1234567890abcdef1234567890abcdef
```

Recommendations
----

Ensure correct ACME server URL is used (--server flag):

```
 --server https://acme.zerossl.com/v2/DV90
```


Known issues
-----

There have been issues reported with certbot interactive prompt causing certificates of Let's Encrypt instead of ZeroSSL being issued. It is recommended to hand over parameters directly using the documented flags.
