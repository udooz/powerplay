## Receive-AzureSbMessage ##

Peek and pick up a message from the given queue.  Returns a key-value of BrokeredMessage and its Body in the key names "msg" and "body" respectively.

Syntax: `Receive-AzureSbMessage [-path] <String> [[-stubBodyObj] <Object>] [-forceNewQClient]`

### Example 1 ###

```powershell
C:\PS>$p = New-Object Person #stub object
    
    
    $pr = Receive-AzureSbMessage -path "personq" -stubBodyObj $p
    Write-Host $pr.msg
    Write-Host $pr.body
```

### Example 2 ###
```powershell
C:\PS>#to receive "n" number of messages from the queue
    
    
    # here n = 6
    1..6 | ForEach { $pr = Receive-AzureSbMessage -path "personq" -stubBodyObj $p; Write-Host $pr.body.Name}
```

[Main](../AzureServiceBus.md)