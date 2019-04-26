FROM mcr.microsoft.com/mssql/server:latest

COPY ./SampleDB.bak /var/opt/mssql/data/SampleDB.bak

CMD ["/opt/mssql/bin/sqlservr"]