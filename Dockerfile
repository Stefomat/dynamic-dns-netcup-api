FROM php:8.2.8-cli-alpine3.18

RUN apk add --no-cache tini=0.19.0-r1

COPY ./functions.php /opt/functions.php
COPY ./update.php /opt/update.php

COPY ./entrypoint.sh /opt/entrypoint.sh
RUN chmod 755 /opt/entrypoint.sh

ENTRYPOINT ["/opt/entrypoint.sh"]
CMD ["/sbin/tini", "--", "crond", "-f"]
