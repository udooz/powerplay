$aurl = "http://techsmithrecovery.blob.core.windows.net/b-1106121155-60bab9df-b1c2-4af9-a67b-463a119e3a6c?restype=container&comp=list&include=snapshots%2Cuncommittedblobs%2Cmetadata&timeout=90"
$aaccountName = "techsmithrecovery"
$aaccountKey = "A+OrshMSfR6RDT58SjxmMcO9mIA+wq9jwmz8wvEs/ZXzo2B+gXd9MT09zNNOyDeN4R+2P3Gf8Opk8+speBNwww=="

function GenerateAuthString
{
	param(
		 [string]$url
		,[string]$accountName
		,[string]$accountKey
		,[string]$utcTime
	) 
	
		
	$uri = New-Object System.Uri -ArgumentList $url
	
	$authString =   "GET$([char]10)$([char]10)$([char]10)$([char]10)$([char]10)$([char]10)$([char]10)$([char]10)$([char]10)$([char]10)$([char]10)$([char]10)"
	$authString += "x-ms-date:" + $utcTime + "$([char]10)"
	$authString += "x-ms-version:2011-08-18" + "$([char]10)"
	$authString += "/" + $accountName + $uri.AbsolutePath + "$([char]10)"
	$authString += "comp:list$([char]10)"
	$authString += "include:snapshots,uncommittedblobs,metadata$([char]10)"	
	$authString += "restype:container$([char]10)"
	$authString += "timeout:90"
	
	$dataToMac = [System.Text.Encoding]::UTF8.GetBytes($authString)

	$accountKeyBytes = [System.Convert]::FromBase64String($accountKey)

	$hmac = new-object System.Security.Cryptography.HMACSHA256((,$accountKeyBytes))
	[System.Convert]::ToBase64String($hmac.ComputeHash($dataToMac))
}

function DoBlobGetRequest
{
	param(		 
		 [string]$accountName
		,[string]$accountKey 
		,[string]$containerName
	)
	
	$resourcePath = $containerName + "?restype=container&comp=list&include=snapshots%2Cuncommittedblobs%2Cmetadata&timeout=90"
	
	$url = "http://" + $accountName + ".blob.core.windows.net/" + $resourcePath
	$timeNow = [System.DateTime]::UtcNow.ToString("R")

	$authHeader = GenerateAuthString -utcTime $timeNow -url $url -accountName $accountName -accountKey $accountKey
	
	[System.Net.HttpWebRequest] $request = [System.Net.WebRequest]::Create($url)
	$request.Method = "GET"
	$request.Headers.Add("x-ms-version", "2011-08-18")
	$request.Headers.Add("x-ms-date", $timeNow);
	$request.Headers.Add("Authorization", "SharedKey " + $accountName + ":" + $authHeader);
	[System.Net.HttpWebResponse] $response = $request.GetResponse();
	if($response.StatusCode -eq [System.Net.HttpStatusCode]::OK)
	{
		$sreader = New-Object System.IO.StreamReader -ArgumentList $response.GetResponseStream()
		return $sreader.ReadToEnd()
		$sreader.Close()
	}
	return ""
}

function ContainerSize
{
	param(		 
		 [string]$xmlContent
	)
	
	$size = 0
	
	if($xmlContent -ne "")
	{
		$xmlContent = $xmlContent.Replace("Content-Length", "ContentLength")
		[xml] $xml = $xmlContent
		$xml.EnumerationResults.Blobs.Blob | foreach {
			$size += [int] $_.Properties.ContentLength
		}
	}
	return $size
}

$content = DoBlobGetRequest -accountName $aaccountName -accountKey $aaccountKey -containerName "b-1107121510-ab59b106-c664-48a7-ad46-47f247e06287"

ContainerSize($content)