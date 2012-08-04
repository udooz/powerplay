# Initialize-AzureSbCredential #
Initialize Azure Service Bus Credential

Syntax: `Initialize-AzureSbCredential [[-cred] <PSObject>] [<CommonParameters>]`

### Parameters ###

-cred <PSObject>     
  
        Required?                    false
<<<<<<< HEAD

        Position?                    1

        Default value                

        Accept pipeline input?       false

=======
        
        Position?                    1
        
        Default value                
        
        Accept pipeline input?       false
        
>>>>>>> 3741704aa559f43f37bd36bdfc653de5086b0746
        Accept wildcard characters?  

### Example ###

<<<<<<< HEAD
```
$cred = [psobject] @{
	issuer = "owner"
=======
```powershell
$cred = [psobject] @{
        issuer = "owner"
>>>>>>> 3741704aa559f43f37bd36bdfc653de5086b0746
		secret = "xxxxx"
		ns = "mysb"
		path =""
	}
Initialize-AzureSbCredential -cred $cred
```

----------

[Main](../AzureServiceBus.md)