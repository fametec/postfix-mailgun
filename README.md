# RUN

    docker run --rm -d --name postfix -e MAILGUN_USER=postmaster@domain -e MAILGUN_PASS=xxxxxxxxx fametec/postfix 

# DOCKER-COMPOSER

    version: '3.2'
    #
    ### Services
    #
    services:
    #
    # MAILGUN
    #
      relay:
        build: .
        image: fametec/postfix-mailgun:latest
        restart: unless-stopped
        container_name: relay
        ports:
         - "30025:25"
        environment:
         MAILGUN_USER: postmaster@XXXXXXXXXXXXXXXX
         MAILGUN_PASS: XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
