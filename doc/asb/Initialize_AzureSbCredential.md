# Initialize-AzureSbCredential #
Initialize Azure Service Bus Credential

Syntax: `Initialize-AzureSbCredential [[-cred] <PSObject>]`

### Parameters ###

-cred <PSObject>     
  
        Required?                    false

        Position?                    1

### Example 1 ###

```powershell
$cred = [psobject] @{
        issuer = "owner"
		secret = "xxxxx"
		ns = "mysb"
		path =""
	}
Initialize-AzureSbCredential -cred $cred
```

----------

[Main](../AzureServiceBus.md)