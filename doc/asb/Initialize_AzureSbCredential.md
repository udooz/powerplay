# Initialize-AzureSbCredential #
Initialize Azure Service Bus Credential

Syntax: `Initialize-AzureSbCredential [[-cred] <PSObject>] [<CommonParameters>]`

### Parameters ###

-cred <PSObject>       
        Required?                    false
        Position?                    1
        Default value                
        Accept pipeline input?       false
        Accept wildcard characters?  

### Example ###

```
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