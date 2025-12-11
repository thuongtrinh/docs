#!/bin/sh
#set -o errexit
deploy=/apps/app-service

cd /tmp
ls -al

dzdo mv -f /tmp/app-service.war $deploy
dzdo chmod -R 755 $deploy
dzdo chown -R jboss:jboss $deploy

cd $deploy 
ls -al

dzdo systemctl restart app-service.service
sleep 10
dzdo systemctl status app-service.service
