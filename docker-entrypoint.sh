#!/bin/bash

DSPACE_CONFIG=/opt/dspace/config/dspace.cfg

if [ ! -z "$DSPACE_HOSTNAME" ]; then
    sed -i -e s/dspace\.hostname\\\s=\\\s.*/dspace.hostname\ =\ $DSPACE_HOSTNAME/ $DSPACE_CONFIG
fi

if [ ! -z "$DSPACE_NAME" ]; then
    sed -i -e s/dspace.name\\\s=\\\s.*/dspace.name\ =\ $DSPACE_NAME/ $DSPACE_CONFIG
fi

if [ ! -z "$DSPACE_LANG" ]; then
    sed -i -e s/default.language\\\s=\\\s.*/default.language\ =\ $DSPACE_LANG/ $DSPACE_CONFIG
fi

if [ -z "$DSPACE_DB_NAME" ]; then
    DSPACE_DB_NAME="dspace"
fi

if [ ! -z "$DSPACE_DB_HOSTNAME" ]; then
    db_host="jdbc:postgresql:\\/\\/$DSPACE_DB_HOSTNAME:5432\\/$DSPACE_DB_NAME"
    sed -i -e s/db\.url\\\s=\\\sjdbc:postgresql:\\/\\/localhost:5432\\/dspace/db\.url\ =\ $db_host/ $DSPACE_CONFIG
else
    echo "The Postgresql server should NOT sit on the same server as DSpace. Please specify the hostname of the Postgresql DB server."
    exit 1
fi

if [ ! -z "$DSPACE_DB_USER" ]; then
    sed -i -e s/db.username\\\s=\\\s.*/db.username\ =\ $DSPACE_DB_USER/ $DSPACE_CONFIG
fi

if [ ! -z "$DSPACE_DB_PASSWORD" ]; then
    sed -i -e s/db.password\\\s=\\\s.*/db.password\ =\ $DSPACE_DB_PASSWORD/ $DSPACE_CONFIG
fi

if [ ! -z "$DSPACE_MAIL_SERVER_NAME" ]; then
    sed -i -e s/mail.server\\\s=\\\s.*/mail.server\ =\ $DSPACE_MAIL_SERVER_NAME/ $DSPACE_CONFIG
fi

if [ ! -z "$DSPACE_MAIL_SERVER_POST" ]; then
    sed -i -e s/mail.server.port\\\s=\\\s25/mail.server.port\ =\ $DSPACE_MAIL_SERVER_PORT/ $DSPACE_CONFIG
fi

if [ ! -z "$DSPACE_MAIL_SERVER_USER" ]; then
    sed -i -e s/mail.server.username\\\s=/mail.server.username\ =\ $DSPACE_MAIL_SERVER_USER/ $DSPACE_CONFIG
fi

if [ ! -z "$DSPACE_MAIL_SERVER_PASSWORD" ]; then
    sed -i -e s/mail.server.password\\\s=/mail.server.password\ =\ $DSPACE_MAIL_SERVER_PASSWORD/ $DSPACE_CONFIG
fi

if [ ! -z "$DSPACE_MAIL_FROM" ]; then
    sed -i -e s/mail.from.address\\\s=\\\s.*/mail.from.address\ =\ $DSPACE_MAIL_FROM/ $DSPACE_CONFIG

    # default unset mail addresses to mail from (if set)
    if [ -z "$DSPACE_MAIL_FEEDBACK" ]; then
        DSPACE_MAIL_FEEDBACK=$DSPACE_MAIL_FROM
    fi

    if [ -z "$DSPACE_MAIL_ADMIN" ]; then
        DSPACE_MAIL_ADMIN=$DSPACE_MAIL_FROM
    fi

    if [ -z "$DSPACE_MAIL_ALERT" ]; then
        DSPACE_MAIL_ALERT=$DSPACE_MAIL_FROM
    fi

    if [ -z "$DSPACE_MAIL_REGISTRATION" ]; then
        DSPACE_MAIL_REGISTRATION=$DSPACE_MAIL_FROM
    fi

    if [ -z "$DSPACE_MAIL_HELPDESK" ]; then
        DSPACE_MAIL_HELPDESK=$DSPACE_MAIL_FROM
    fi
fi

if [ ! -z "$DSPACE_MAIL_FEEDBACK" ]; then
    sed -i -e s/feedback.recipient\\\s=\\\s.*/feedback.recipient\ =\ $DSPACE_MAIL_FEEDBACK/ $DSPACE_CONFIG
fi

if [ ! -z "$DSPACE_MAIL_ADMIN" ]; then
    sed -i -e s/mail.admin\\\s=\\\s.*/mail.admin\ =\ $DSPACE_MAIL_ADMIN/ $DSPACE_CONFIG
fi

if [ ! -z "$DSPACE_MAIL_ALERT" ]; then
    sed -i -e s/alert.recipient\\\s=\\\s.*/alert.recipient\ =\ $DSPACE_MAIL_ALERT/ $DSPACE_CONFIG
fi

if [ ! -z "$DSPACE_MAIL_REGISTRATION" ]; then
    sed -i -e s/alert.recipient\\\s=\\\s.*/alert.recipient\ =\ $DSPACE_MAIL_REGISTRATION/ $DSPACE_CONFIG
fi

if [ ! -z "$DSPACE_MAIL_HELPDESK" ]; then
    sed -i -e s/mail.helpdesk\\\s=\\\s.*/mail.helpdesk\ =\ $DSPACE_MAIL_HELPDESK/ $DSPACE_CONFIG
fi

if [ ! -z "$DSPACE_DOI_USER" ]; then
    sed -i -e s/identifier.doi.user\\\s=\\\s.*/identifier.doi.user\ =\ $DSPACE_DOI_USER/ $DSPACE_CONFIG
fi

if [ ! -z "$DSPACE_DOI_PASSWORD" ]; then
    sed -i -e s/identifier.doi.password\\\s=\\\s.*/identifier.doi.password\ =\ $DSPACE_DOI_PASSWORD/ $DSPACE_CONFIG
fi

if [ ! -z "$DSPACE_DOI_PREFIX" ]; then
    sed -i -e s/identifier.doi.prefix\\\s=\\\s.*/identifier.doi.prefix\ =\ $DSPACE_DOI_PASSWORD/ $DSPACE_CONFIG
fi

if [ ! -z "$DSPACE_DOI_PREFIX" ]; then
    sed -i -e s/identifier.doi.namespaceseparator\\\s=\\\s.*/identifier.doi.namespaceseparator\ =\ $DSPACE_DOI_NS_SEPARATOR/ $DSPACE_CONFIG
fi

# if prefix is not set then the admin probably wants the handle url to match the domain.
if [ ! -z "$DSPACE_HANDLE_PREFIX" ]; then
    sed -i -e s/handle.canonical.url\\\s=\\\s.*/handle.canonical.url\ =\ \${dspace.url}/ $DSPACE_CONFIG
else
    sed -i -e s/handle.canonical.prefix\\\s=\\\s.*/handle.canonical.prefix\ =\ $DSPACE_HANDLE_PREFIX/ $DSPACE_CONFIG
fi

cat $DSPACE_CONFIG

exec "$@"
