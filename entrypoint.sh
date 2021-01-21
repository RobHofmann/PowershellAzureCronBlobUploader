#!/bin/bash

# Make sure CRON is being setup
if [[ -n "$UPLOAD_CRON_EXPRESSION" ]]; then
  ln -sf /proc/$$/fd/1 /var/log/stdout
  service cron start
	if [[ -n "$UPLOAD_CRON_EXPRESSION" ]]; then
        echo "$UPLOAD_CRON_EXPRESSION pwsh /scripts/UploadAndDelete.ps1 -uploadRootDirectory '/data' -skipDirectories "$SKIP_DIRECTORIES" -storageAccountName "$STORAGE_ACCOUNT_NAME" -storageAccountKey "$STORAGE_ACCOUNT_KEY" -containerName "$BLOB_CONTAINER_NAME" -gracePeriodInSeconds $GRACE_PERIOD_IN_SECONDS -deleteOnSuccessfulUpload $DELETE_ON_SUCCESSFUL_UPLOAD >/var/log/stdout 2>&1" > /etc/crontab
	fi
	crontab /etc/crontab
fi

# Tail to let the container run
tail -f /dev/null