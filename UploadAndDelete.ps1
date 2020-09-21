[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)]
    [String] $uploadRootDirectory,

    [Parameter(Mandatory=$true)]
    [string] $storageAccountName,

    [Parameter(Mandatory=$true)]
    [string] $storageAccountKey,

    [Parameter(Mandatory=$true)]
    [string] $containerName,

    [Parameter(Mandatory=$false)]
    [int] $gracePeriodInSeconds = 0,

    [Parameter(Mandatory=$true)]
    [bool] $deleteOnSuccessfulUpload
)

function UploadDirectory($uploadRootDirectory, $directory, $storageContext, $containerName, $gracePeriodInSeconds)
{
    $subDirectories = Get-ChildItem -Path $directory -Directory
    foreach ($subDirectory in $subDirectories) {
        #Write-Host $subDirectory
        UploadDirectory -uploadRootDirectory $uploadRootDirectory -directory $subDirectory -storageContext $storageContext -containerName $containerName
    }

    $files = Get-ChildItem -Path $directory -File | Where-Object {$_.Lastwritetime -lt (Get-date).AddSeconds($gracePeriodInSeconds * -1)}
    foreach ($file in $files) {
        $relativePath = $file.Directory | Resolve-Path -Relative
        $blobFilename = Join-Path $relativePath $file.Name
        Write-Host "Uploading $file"
        $uploadResult = Set-AzStorageBlobContent -File $file -Container $containerName -Blob $blobFilename -Context $storageContext -Force

        if($uploadResult)
        {
            Write-Host "Uploaded $file"
            if($deleteOnSuccessfulUpload)
            {
                Write-Host "Deleting $file"
                try{
                    $file.Delete();
                    Write-Host "Deleted $file"
                }
                catch
                {
                    Write-Error "Deleting failed for file $file"
                }
            }
        }
        else
        {
            Write-Error "Something went wrong uploading $file"
        }
    }
}


$storageContext = New-AzStorageContext -storageAccountName $storageAccountName -storageAccountKey $storageAccountKey
Set-Location $uploadRootDirectory
UploadDirectory -uploadRootDirectory $uploadRootDirectory -directory $uploadRootDirectory -storageContext $storageContext -containerName $containerName -gracePeriodInSeconds $gracePeriodInSeconds
