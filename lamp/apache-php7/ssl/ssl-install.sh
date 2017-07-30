#!/bin/bash
DOMAINES=$@

if [ -z "$DOMAINES" ]; then

	echo "DOMAINES is empty"

else

	echo "DOMAINES are $DOMAINES"

	/opt/letsencrypt/letsencrypt-auto --noninteractive --apache --standalone certonly --renew-by-default --preferred-challenges tls-sni --email q.tshaimanga@gmail.com --agree-tos --d quentintshaimanga.fr
	/usr/sbin/service apache2 reload

	# for DOMAINE in $DOMAINES;
	# do
		# /opt/letsencrypt/letsencrypt-auto --apache -m q.tshaimanga@gmail.com --agree-tos true -d $DOMAINE
		#
		# ssl-renewal $DOMAINE
		# crontab -e 0 3 * * 1 /usr/local/sbin/ssl-renewal $DOMAINE >> /var/log/ssl-renewal.log

	# 	echo "$DOMAINE added"
	# done

fi
