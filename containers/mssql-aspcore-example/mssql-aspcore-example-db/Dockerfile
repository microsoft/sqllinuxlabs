FROM mcr.microsoft.com/mssql/rhel/server:2019-CTP3.2

COPY . /

# Update permissions to enable non-root user
#
RUN mkdir -p /var/opt/mssql
RUN chmod -R 770 /var/opt/mssql
RUN chgrp -R 0 /var/opt/mssql
RUN chmod -R g=u /etc/passwd
# Move Entrypoing script from /tmp
#
RUN mv uid_entrypoint.sh /opt/mssql/bin/uid_entrypoint.sh
RUN chmod g+x /opt/mssql/bin/uid_entrypoint.sh
RUN chmod +x /db-init.sh

# Set an arbitrary UID so the container is non-root
USER 10001
ENTRYPOINT ["/opt/mssql/bin/uid_entrypoint.sh"]

CMD /bin/bash ./entrypoint.sh