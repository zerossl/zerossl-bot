zerossl-bot
===========

このリポジトリはCertbotをZeroSSL ACME serverで使用するためのラッパースクリプトが含まれています。

導入
------------

1. `curl` と `certbot` をインストールしてください
3. 以下の手順でラッパースクリプトをインストールしてください
   1. Quick: 
      1. run `bash <(curl -s https://zerossl.com/get-zerosslbot.sh)`
      2. Done!
   2. Careful: 
      1. Run `curl -s https://zerossl.com/get-zerosslbot.sh > get-zerosslbot.sh`
      2. Inspect the file to see that it does what it is supposed to do
      3. Run `source get-zerosslbot.sh`
      
使い方
-----

To use the ZeroSSL ACME server instead of running `certbot` run `zerossl-bot`.
ZeroSSL ACMEサーバーを使うために`certbot`を`zerossl-bot`に置き換えて実行します。

### 例

```bash
sudo zerossl-bot certonly --standalone -m anton@example.com -d mydomain.example.com
```

```bash
sudo zerossl-bot --apache -m barbara@example.com -d myotherdomain.example.com
```

```bash
sudo zerossl-bot --apache -d mythirddomain.example.com --zerossl-api-key 1234567890abcdef1234567890abcdef
```

