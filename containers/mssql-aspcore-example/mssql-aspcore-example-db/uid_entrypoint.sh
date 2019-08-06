#!/bin/bash
myuser=$(whoami 2> /dev/null)
if [ "" = "$myuser" ]; then
    if [ -w /etc/passwd ]; then
        echo "${USER_NAME:-mssql}:x:$(id -u):0:${USER_NAME:-mssql} mssql:${HOME}:/sbin/nologin" >> /etc/passwd
    else
        >&2 echo "Could not write to /etc/passwd. Container will run as unnamed user."
    fi
fi
exec "$@"