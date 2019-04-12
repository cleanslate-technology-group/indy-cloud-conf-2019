#!/bin/bash

mv /tmp/index.html /var/www/html/index.html

# make sure nginx is started
service nginx start
