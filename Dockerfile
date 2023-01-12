FROM php:8-cli-alpine

RUN apk add --no-cache tini

COPY ./functions.php /opt/functions.php
COPY ./update.php /opt/update.php

COPY ./entrypoint.sh /opt/entrypoint.sh
RUN chmod 755 /opt/entrypoint.sh

ENTRYPOINT ["/opt/entrypoint.sh"]
CMD ["/sbin/tini", "--", "crond", "-f"]
