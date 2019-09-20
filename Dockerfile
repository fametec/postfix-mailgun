FROM centos:7

MAINTAINER eduardo@fametec.com.br

ENV MAILGUN_USER postmaster@xxxxxxxxxxxxxxxxxxx

ENV MAILGUN_PASS xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

ENV MAILGUN_RELAYHOST smtp.mailgun.org
# US = smtp.mailgun.org
# EU = smtp.eu.mailgun.org 


RUN yum -y install postfix cyrus-sasl-plain mailx


RUN { \
	echo ; \
	echo 'inet_interfaces = all' ; \
	echo '#Set the relayhost' ; \
	echo 'mydestination = localhost.localdomain, localhost' ; \
	echo 'relayhost = [MAILGUN_RELAYHOST]:587' ; \
	echo 'smtp_sasl_auth_enable = yes' ; \
	echo 'smtp_sasl_password_maps = static:MAILGUN_USER:MAILGUN_PASS' ; \
	echo 'smtp_sasl_security_options = noanonymous' ; \
	echo ; \
	echo '# TLS support' ; \
	echo 'smtp_tls_CAfile = /etc/pki/tls/certs/ca-bundle.crt' ; \
	echo 'smtp_tls_security_level = may' ; \
	echo 'smtpd_tls_security_level = may' ; \
	echo 'smtp_tls_note_starttls_offer = yes' ; \
	echo ; \
	echo 'smtp_cname_overrides_servername=no' ; \
	echo ; \
    } >> /etc/postfix/main.cf


RUN { \
        echo '#!/bin/bash' ; \
        echo ; \
        echo 'sed -i s/MAILGUN_USER/$MAILGUN_USER/g /etc/postfix/main.cf' ; \
        echo 'sed -i s/MAILGUN_PASS/$MAILGUN_PASS/g /etc/postfix/main.cf' ; \
        echo 'sed -i s/MAILGUN_RELAYHOST/$MAILGUN_RELAYHOST/g /etc/postfix/main.cf' ; \
	echo 'postfix start' ; \
        echo ; \
        echo 'while true; do' ;\
        echo '  mailq ' ; \
        echo '  sleep 10' ; \
        echo 'done' ; \
        echo ; \
    } > /entrypoint.sh && chmod +x /entrypoint.sh


EXPOSE 25

CMD [ "/entrypoint.sh" ]
