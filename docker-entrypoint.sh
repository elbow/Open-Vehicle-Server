#!/bin/bash
MYSQL_USER="${MYSQL_USER:-""}"
MYSQL_PASSWORD="${MYSQL_PASSWORD:-""}"
MYSQL_DATABASE="${MYSQL_DATABASE:-"openvehicles"}"

if [ ! -f /app/conf/ovms_server.conf ]; then \
    { \
        echo '[db]'; \
        echo "path=DBI:mysql:database=${MYSQL_DATABASE};host=mysql"; \
        echo "user=${MYSQL_USER}"; \
        echo "pass=${MYSQL_PASSWORD}"; \
        echo 'pw_encode=drupal_password($password)'; \
        echo ''; \
	echo '[plugins]'; \
	echo 'load=<<EOT'; \
	echo 'VECE'; \
	echo 'DbDBI'; \
	echo 'ApiV2'; \
	echo 'Push'; \
	echo 'PushAPNS'; \
	echo 'PushGCM'; \
	echo 'PushMAIL'; \
	echo 'ApiHttp'; \
	echo 'ApiHttpCore'; \
	echo 'ApiHttpMqapi'; \
	echo 'EOT'; \
	echo ''; \
        echo '[log]'; \
        echo 'level=info'; \
        echo 'history=86400'; \
        echo ''; \
        echo '[push]'; \
        echo 'history=2592000'; \
        echo ''; \
        echo '[server]'; \
        echo 'timeout_app=1200'; \
        echo 'timeout_car=960'; \
        echo 'timeout_svr=3600'; \
        echo 'timeout_api=300'; \
        echo ''; \
        echo '[mail]'; \
        echo 'enabled=0'; \
        echo 'interval=10'; \
        echo 'sender=ovmsnotifications@daviesfam.org'; \
        echo ''; \
        echo '[gcm]'; \
        echo 'apikey=<your GCM API key, see README>'; \
    } > /app/conf/ovms_server.conf; \
fi

cat /cert/privkey.pem /cert/fullchain.pem >/app/conf/ovms_server.pem
chmod 0600 /app/conf/ovms_server.pem

IGNORE='exec perl /app/ovms_server.pl >>/var/log/ovms_server.log 2>&1'
exec perl /app/ovms_server.pl
