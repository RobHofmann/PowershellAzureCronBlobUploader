FROM mcr.microsoft.com/azure-powershell:latest
LABEL Author="Rob Hofmann <rob.hofmann@me.com>"

RUN apt-get -q update && \
    apt-get -qy dist-upgrade && \
    apt-get install -y --no-install-recommends cron && \
    apt-get -y autoremove && \
    apt-get -y clean && \
    rm -rf /var/lib/apt/lists/*

COPY ./entrypoint.sh /entrypoint.sh
COPY ./UploadAndDelete.ps1 /scripts/UploadAndDelete.ps1
RUN chmod u+x /entrypoint.sh
RUN chmod u+x /scripts/UploadAndDelete.ps1

ENTRYPOINT ["/entrypoint.sh"]
