#!/bin/bash -x
set -e

. config.rc

sed -e "s/LDAP_SERVER/${LDAP_SERVER}/g" httpd/vhost.conf.templ > httpd/vhost.conf
sed -i "s/LDAP_ROOT_DN/${LDAP_ACCOUNTBASE}/g" httpd/vhost.conf

# Create Apache volume.
docker volume create --name ${APACHE_VOLUME}

docker run  \
  --name ${APACHE_NAME} \
  --detach \
  --net ${CI_NETWORK} \
  -p 80:80 \
  -v ${PWD}/httpd/httpd.conf:/usr/local/apache2/conf/httpd.conf \
  -v ${PWD}/httpd/vhost.conf:/usr/local/apache2/conf/vhost.conf \
  -v ${APACHE_VOLUME}:/usr/local/apache2/www \
  httpd

