FROM mcr.microsoft.com/mssql/server:latest AS BUILD
ENV ACCEPT_EULA=Y
ENV SA_PASSWORD=yourStrong(!)Password

WORKDIR /var/opt/mssql/backup
COPY Chinook.bak .

RUN /opt/mssql/bin/sqlservr --accept-eula  & sleep 15 \
    && /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P "yourStrong(!)Password" -Q "RESTORE DATABASE [Chinook] FROM DISK = '/var/opt/mssql/backup/Chinook.bak' WITH MOVE 'Chinook' TO '/var/opt/mssql/data/Chinook.mdf', MOVE 'Chinook_log' TO '/var/opt/mssql/data/Chinook_log.ldf'" \
    && pkill sqlservr   

FROM mcr.microsoft.com/mssql/server:latest AS release
ENV ACCEPT_EULA=Y
COPY --from=build /var/opt/mssql/data /var/opt/mssql/data