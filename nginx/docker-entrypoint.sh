#!/bin/bash
set +x

if [ ! -e index.php ] && [ ! -e wp-includes/version.php ]; then
                echo >&2 "WordPress not found in $PWD - copying now..."
                tar cf - --one-file-system -C /app/wordpress . | tar xf -
                echo >&2 "Complete! WordPress has been successfully copied to $PWD"
fi
if [[ ! -f "wp-config.php" ]] ;
then
    echo "wp-config.php file not found"
    cp wp-config-sample.php wp-config.php
else
    echo "wp-config.php file exit"
fi
cp /app/default.conf /etc/nginx/conf.d/default.conf
rm -rf /var/preview
if [[ {USER_ID} -gt 0 ]] ;
then
    chown -R {USER_ID}:{GROUP_ID} /var/www
else
    chown -R nobody:nobody /var/www/storage
fi
pkill -9 php
nginx -s reload

exec "$@"