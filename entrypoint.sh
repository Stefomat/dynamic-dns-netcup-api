#!/bin/sh

# Ensure presence of all needed variables
[ -n "${CUSTOMERNR}" ] || { echo "CUSTOMERNR not given, exit."; exit 1; }
[ -n "${APIPASSWORD}" ] || { echo "APIPASSWORD not given, exit."; exit 1; }
[ -n "${APIKEY}" ] || { echo "APIKEY not given, exit."; exit 1; }
[ -n "${DOMAINLIST}" ] || { echo "DOMAINLIST not given, exit."; exit 1; }
[ -n "${USE_IPV4}" ] || { echo "USE_IPV4 not given, exit."; exit 1; }
[ -n "${USE_IPV6}" ] || { echo "USE_IPV6 not given, exit."; exit 1; }
[ -n "${CHANGE_TTL}" ] || { echo "CHANGE_TTL not given, exit."; exit 1; }

# Write crontab file from Docker env variable
echo "${CRONTAB:-*/5 * * * *}   /opt/update.php" > /etc/crontabs/root

# Write config.php config file from Docker env variables
cat <<EOF > /opt/config.php
<?php
define('CUSTOMERNR', '${CUSTOMERNR}');
define('APIPASSWORD', '${APIPASSWORD}');
define('APIKEY', '${APIKEY}');
define('DOMAINLIST', '${DOMAINLIST}');
define('USE_IPV4', ${USE_IPV4});
define('USE_IPV6', ${USE_IPV6});
define('CHANGE_TTL', ${CHANGE_TTL});
define('APIURL', 'https://ccp.netcup.net/run/webservice/servers/endpoint.php?JSON');
EOF

# Welcome message
echo "============================================="
echo " Starting cron..."
echo " Be patient for first command execution."
echo "============================================="

# Hand off to the CMD
exec "$@"
