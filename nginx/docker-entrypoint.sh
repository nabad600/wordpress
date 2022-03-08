#!/bin/bash
set +x

if [ ! -e index.php ] && [ ! -e wp-includes/version.php ]; then
                echo >&2 "WordPress not found in $PWD - copying now..."
                tar cf - --one-file-system -C /app/wordpress . | tar xf -
                echo >&2 "Complete! WordPress has been successfully copied to $PWD"
fi

cp /app/default.conf /etc/nginx/conf.d/default.conf
rm -rf /var/preview
if [[ {USER_ID} -gt 0 ]] ;
then
    chown -R {USER_ID}:{GROUP_ID} /var/www
else
    chown -R nobody:nobody /var/www
fi
pkill -9 php
nginx -s reload

exec "$@"