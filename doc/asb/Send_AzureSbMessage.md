## Send-AzureSbMessage ##
Send a brokered message to a service bus queue

Syntax: 
```powershell
      
      Send-AzureSbMessage [-path] <String>  #queue name
      
        [[-bodyJson] <String>] #JSONified body object
      
        [[-stubBodyObj] <Object>]  #a stub (empty) object of the required body Type
        
        [[-msgLabel] <String>] #message label 
        
        [[-msgId] <String>] #message ID 
        
        [[-replyTo] <String>]
        
        [[-replyToSessionId] <String>] 
        
        [[-sessionId] <String>] 
        
        [[-to] <String>] 
        
        [[-ttl] <TimeSpan>] # time to live
        
        [[-msgProps] <Hashtable>]  # message properties
        
        [-forceNewQClient] # create new QueueClient
        
        [-ignoreJson] # don't expect JSON, instead use stub object itself which should containt values
      
```
      
### Example 1 ###
```powershell
C:\PS>#create a CLR type in powershell
    
    
    Add-Type -TypeDefinition @"
    public class Person
    {
        public Person() {}
        public string Name {get;set;}
    }
    "@
    
    #if body content from JSON
    Send-AzureSbMessage -path "myq" -bodyJson "{'Name':'Sheik'}" -stubBodyObj $(New-Object Person)
    
    #if body content within stub body object
    $p = New-Object Person
    $p.Name = "Sheik"
    Send-AzureSbMessage -path "myq" -stubBodyObj $p

```

### Example 2 ###

```powershell
 C:\PS># JSON based message sending helpful for pumbing large number of messages to test your queue.
    
    
    # For example, you have JSONified person object in set of files.  To send these JSON content as a message body (actually AzureServiceBus cmdlet convert it into Person object internally),
    # One JSON file content could be
    #{"Name":"Sheik"}
    #{"Name":"Bravo"}
    #{"Name":"Zune"}
    #{"Name":"Mario"}
    #{"Name":"Haleem"}
    # NOTE:  Every JSONified object should be in one single line
    
    $p = New-Object Person #stub object
    
    dir *.json | Get-Content | ForEach { Send-AzureSbMessage -path "personq" -bodyJson $_ -stubBodyObj $p}

```
