up:
	mkdir -p magento
	docker-compose -f docker-compose.yml down && docker-compose -f docker-compose.yml up -d --remove-orphans

watch:
	mkdir -p magento
	docker-compose -f docker-compose.yml down && docker-compose -f docker-compose.yml up --remove-orphans	

stop:
	docker-compose -f docker-compose.yml stop

down:
	docker-compose -f docker-compose.yml down -v	
	
build:
	mkdir -p magento
	docker-compose -f docker-compose.yml down && docker-compose -f docker-compose.yml up -d --build --remove-orphans



mysql-bash:
	docker exec -it magento-mysql bash

elasticsearch-bash:
	docker exec -it magento-elasticsearch bash

redis-clear:
	docker exec -it magento-redis sh -c 'exec redis-cli FLUSHALL'



# Magento commands
magento-bash:
	docker exec -it magento-app bash

magento-restore-db:
	docker exec -i magento-mysql sh -c 'exec mysql -u"root" -p"root" magento' < $(filter-out $@,$(MAKECMDGOALS))

magento-composer:
	docker exec -it magento-app sh -c 'php -d memory=-1 ../composer.phar $(filter-out $@,$(MAKECMDGOALS))'

magento-download:
	docker exec -it magento-app sh -c 'php -d memory=-1 ../composer.phar create-project --repository-url=https://repo.magento.com/ magento/project-community-edition .'

magento-install:
	docker exec -i magento-mysql sh -c 'exec mysql -u"root" -p"root"  -e "create database  IF NOT EXISTS magento"'
	docker exec -it magento-app sh -c 'php -f bin/magento setup:install --base-url=$$MAGENTO_DOMAIN --base-url-secure=$$MAGENTO_DOMAIN_SECURE --use-secure=$$MAGENTO_USE_SECURE --db-host=magento-mysql --db-name=magento --db-user=root --db-password=root --admin-firstname=$$MAGENTO_ADMIN_FIRSTNAME --admin-lastname=$$MAGENTO_ADMIN_LASTNAME --admin-email=$$MAGENTO_ADMIN_EMAIL --admin-user=$$MAGENTO_ADMIN_USER --admin-password=$$MAGENTO_ADMIN_PASSWORD --language=$$MAGENTO_LANGUAGE --currency=$$MAGENTO_CURRENCY --timezone=$$MAGENTO_TIMEZONE --backend-frontname="$$MAGENTO_ADMIN_URL" --use-rewrites=1 --search-engine=elasticsearch7 --elasticsearch-host=magento-elasticsearch --elasticsearch-port=9200 && php bin/magento setup:config:set --cache-backend=redis --cache-backend-redis-server=magento-redis --cache-backend-redis-port=6379 --cache-backend-redis-db=0 && php bin/magento setup:config:set --page-cache=redis --page-cache-redis-server=magento-redis --page-cache-redis-port=6379 --page-cache-redis-db=1 && php bin/magento setup:config:set --session-save=redis --session-save-redis-host=magento-redis --session-save-redis-port=6379 --session-save-redis-log-level=4 --session-save-redis-db=2 && chmod -R 777 ./app'
	docker exec -it magento-app sh -c 'php -d memory=-1 ../composer.phar install'
	docker exec -it magento-app sh -c 'rm -rf pub/static/*; rm -rf /var/di/ /var/generation/ var/view_preprocessed/ var/cache/ var/page_cache/ var/di/ var/generation/*;php bin/magento setup:upgrade; php bin/magento cache:flush; php bin/magento cache:clean; php bin/magento setup:static-content:deploy $$MAGENTO_LANGUAGE -f; php bin/magento setup:di:compile; php bin/magento cache:flush; php bin/magento cache:clean; php bin/magento index:reindex; chmod -R 777 var; chmod -R 777 generated; chmod -R 777 pub/static'

magento-clear:
	docker exec -i magento-app sh -c 'cd /magento && rm -rf pub/static/*; rm -rf /var/di/ /var/generation/ var/view_preprocessed/ var/cache/ var/page_cache/ var/di/ var/generation/*;php bin/magento setup:upgrade; php bin/magento cache:flush; php bin/magento cache:clean; php bin/magento setup:static-content:deploy $$MAGENTO_LANGUAGE -f; php bin/magento setup:di:compile; php bin/magento cache:flush; php bin/magento cache:clean; php bin/magento index:reindex; chmod -R 777 var; chmod -R 777 generated; chmod -R 777 pub/static'	
