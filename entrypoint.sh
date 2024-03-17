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

# Add more options to config.php
echo "define('IPV4_ADDRESS_URL', ${IPV4_ADDRESS_URL:-https://get-ipv4.steck.cc});" >> /opt/config.php
echo "define('IPV4_ADDRESS_URL_FALLBACK', ${IPV4_ADDRESS_URL_FALLBACK:-https://4.ipwho.de/ip});" >> /opt/config.php
echo "define('IPV6_ADDRESS_URL', ${IPV6_ADDRESS_URL:-https://get-ipv6.steck.cc});" >> /opt/config.php
echo "define('IPV6_ADDRESS_URL_FALLBACK', ${IPV6_ADDRESS_URL_FALLBACK:-https://6.ipwho.de/ip});" >> /opt/config.php

# Welcome message
echo "============================================="
echo " Starting cron..."
echo " Be patient for first command execution."
echo "============================================="

# Hand off to the CMD
exec "$@"
