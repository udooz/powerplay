# Calculate Windows Azure Container Size #
A set of cmdlets used to get Windows Azure Storage Blob container details and also enable to calculate the total size of the container

## Cmdlets ##

- *[Calculate-ContainerSize]*.  Calculate a blob container size from its metadata xml.
- *[Receive-BlobContainerDetails]*. Download the metadata xml for a blob container.

### Example 1 ###

```powershell

$containerNames = @("a", "b")

$accountName = "account-name"

$accountKey = "account-key"

$totalsize = 0

$containerNames | foreach { 

	$totalSize += Calculate-ContainerSize -xmlContent 
		(Receive-BlobContainerDetails -accountName $accountName -accountKey $accountKey -containerName $_)
}

Write-Host $totalsize

```

# Version History #
## Version 1.0 #
Created

### Your Contribution ###
Your contribution twoards refactoring the existing parts or new cmdlets are highly appreciated.

*Contact: udooz at hotmail dot com*.