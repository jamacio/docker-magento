#!/bin/bash

cd /magento

echo "######### APPLYING MAGENTO FOLDER PERMISSIONS (/VAR, /GENERATED, /PUB/STATIC)"
chmod -R 777 /magento/var
chmod -R 777 /magento/generated
chmod -R 777 /magento/pub/static

echo "!!!!!!!!!! MAGENTO READY !!!!!!!!!!"