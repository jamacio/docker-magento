#!/bin/bash

./opt/docker/bin/service.d/php-fpm.d/10-fpm-init.sh

echo "######### APPLYING MAGENTO FOLDER PERMISSIONS (/VAR, /GENERATED, /PUB/STATIC)"
chmod -R 777 /magento/var
chmod -R 777 /magento/generated
chmod -R 777 /magento/pub/static

cd /magento

echo "######### CHECKING MAGENTO DB STATUS #########"
db_status_message=$(php -dmemory_limit=-1 bin/magento setup:db:status --no-ansi)
if [[ ${db_status_message:0:3} == "All" ]];
then
    echo "######### SKIPPING MAGENTO SETUP:UPGRADE (No Changes detected) #########"
else
    echo "######### RUNNING MAGENTO SETUP:UPGRADE #########"
    php -dmemory_limit=-1 bin/magento setup:upgrade --keep-generated
fi

echo "######### RUNNING MAGENTO SETUP:DI:COMPILE #########"
php -dmemory_limit=-1 bin/magento setup:di:compile

echo "######### RUNNING MAGENTO SETUP:STATIC-CONTENT:DEPLOY #########"
php -dmemory_limit=-1 bin/magento setup:static-content:deploy -j 4 --symlink-locale -t Magento/backend pt_BR en_US

echo "######### RUNNING MAGENTO CRON:INSTALL #########"
php -dmemory_limit=-1 bin/magento cron:install

echo "######### EXECUTING REINDEXER #########"
bin/magento indexer:reindex

echo "######### EXECUTING CASH FLUSH #########"
bin/magento cache:flush


