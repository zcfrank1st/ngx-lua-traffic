#! /bin/bash

cp traffic.*  /usr/local/openresty/nginx/

nginx -c traffic.conf -s reload
