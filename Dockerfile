FROM centos:7

MAINTAINER eduardo@fametec.com.br

ENV MAILGUN_USER postmaster@xxxxxxxxxxxxxxxxxxx

ENV MAILGUN_PASS xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

RUN yum -y install postfix cyrus-sasl-plain mailx


RUN { \
	echo ; \
	echo '#Set the relayhost' ; \
	echo 'mydestination = localhost.localdomain, localhost' ; \
	echo 'relayhost = [smtp.mailgun.org]:587' ; \
	echo 'smtp_sasl_auth_enable = yes' ; \
	echo 'smtp_sasl_password_maps = static:'$MAILGUN_USER':'$MAILGUN_PASS ; \
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
	echo 'postfix start' ; \
	echo 'tail -f /var/log/maillog' ; \
	echo ; \
    } > /entrypoint.sh && chmod +x /entrypoint.sh

RUN ln -sf /dev/stdout /var/log/maillog

EXPOSE 25

CMD [ "/entrypoint.sh" ]
