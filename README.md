# PowershellAzureCronBlobUploader
Powershell script that uploads files to Blob storage &amp; optionally deletes uploaded files

# Environment variables needed
| Variable name | Example value | Description |
| ------------- | ------------- | ------------- |
| SKIP_DIRECTORIES | `*something*;anotherSomething*;/data/somesubfolder` | Folders which you want to skip uploading. Wildcards are permitted. This is an optional parameter. |
| UPLOAD_CRON_EXPRESSION | `*/2 * * * *` | The CRON expression in which frequency to run the script. |
| STORAGE_ACCOUNT_NAME | `mystorageaccount` | The Azure StorageAccountname. |
| STORAGE_ACCOUNT_KEY | `mOIUoumoimUOImuoyb9696d93q8m9+asd+1f==` | This accesskey can be found in your storage account under "Access keys". |
| BLOB_CONTAINER_NAME | `mydata` | The Blob container name to use. |
| GRACE_PERIOD_IN_SECONDS | `3600` | Files newer than this grace period will be skipped (both for uploading & deleting). This is usefull for when files are still in use when the upload starts. |
| DELETE_ON_SUCCESSFUL_UPLOAD | `1` | Deletes the local file after upload if 1 (Choose either `1` (true) or `0` (false)). |

# How to use
1. Make sure you filled all the above environment variables.
2. The data to be uploaded should be mounted at /data inside the container.

## Example
```
docker run --name=myuploader -e UPLOAD_CRON_EXPRESSION='*/2 * * * *' -e STORAGE_ACCOUNT_NAME="mystorageaccount" -e STORAGE_ACCOUNT_KEY="mOIUoumoimUOImuoyb9696d93q8m9+asd+1f==" -e BLOB_CONTAINER_NAME="mydata" -e GRACE_PERIOD_IN_SECONDS=3600 -e DELETE_ON_SUCCESSFUL_UPLOAD=1 -v /some/data/path/on/host:/data -d robhofmann/powershellazurecronblobuploader
```
