# setup user env
FPM_POOL_CONF="/opt/docker/etc/php/fpm/pool.d/application.conf"

## Setup container uid
if [[ -n "$FPM_UID" ]]; then
       echo "Setting php-fpm user to $FPM_UID"
       go-replace --mode=line --regex \
           -s '^[\s;]*user[\s]*='  -r "user = $FPM_UID" \
           -s '^[\s;]*group[\s]*=' -r "group = $FPM_UID" \
           --path=/opt/docker/etc/php/fpm/ \
           --path-pattern='*.conf'
fi
