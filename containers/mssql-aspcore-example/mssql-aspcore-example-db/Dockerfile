FROM microsoft/mssql-server-linux:latest

COPY . /

RUN chmod +x /db-init.sh
CMD /bin/bash ./entrypoint.sh