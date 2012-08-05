## New-AzureSbQueue ##

Creates a new Windows Azure Service Bus Queue

Syntax:  

```powershell
New-AzureSbQueue [-qname] <String> # Queue name
  [[-defTtl] <TimeSpan>]  #default time to live
  [[-duplDetectHisTimeWindow] <TimeSpan>] # Duplicate detection history time window
  [[-batch] <Boolean>] # batch supported
  [[-deadLettringRequired] <Boolean>] # require dead letter
  [[-lockDuration] <TimeSpan>] 
  [[-maxDelvCount] <Int32>] # maximum delivery count
  [[-maxQSize] <Int64>] 
  [[-detectDupl] <Boolean>]   # detect duplicate
```
Returns     `Microsoft.ServiceBus.Messaging.QueueDescription`
Parameters:

```powershell
-qname <String>
        Queue name
        
        Required?                    true
        Position?                    1
        Default value                
        Accept pipeline input?       false
        Accept wildcard characters?  
        
    -defTtl <TimeSpan>
        Default time to live.  Default: 922337203685 seconds as like in portal.
        
        Required?                    false
        Position?                    2
        Default value                
        Accept pipeline input?       false
        Accept wildcard characters?  
        
    -duplDetectHisTimeWindow <TimeSpan>
        Depulicate detect history time window.  Default: 600 seconds as like in portal.
        
        Required?                    false
        Position?                    3
        Default value                
        Accept pipeline input?       false
        Accept wildcard characters?  
        
    -batch <Boolean>
        Enable batch.  Default: false
        
        Required?                    false
        Position?                    4
        Default value                
        Accept pipeline input?       false
        Accept wildcard characters?  
        
    -deadLettringRequired <Boolean>
        This require dead lettering.
        
        Required?                    false
        Position?                    5
        Default value                
        Accept pipeline input?       false
        Accept wildcard characters?  
        
    -lockDuration <TimeSpan>
        Duration of locking.
        
        Required?                    false
        Position?                    6
        Default value                
        Accept pipeline input?       false
        Accept wildcard characters?  
        
    -maxDelvCount <Int32>
        Maximum delivery count
        
        Required?                    false
        Position?                    7
        Default value                
        Accept pipeline input?       false
        Accept wildcard characters?  
        
    -maxQSize <Int64>
        Maximum queue size
        
        Required?                    false
        Position?                    8
        Default value                
        Accept pipeline input?       false
        Accept wildcard characters?  
        
    -detectDupl <Boolean>
        Should detect duplicate message
        
        Required?                    false
        Position?                    9
        Default value                
        Accept pipeline input?       false
        Accept wildcard characters?  
        
    -sessionRequired <Boolean>
        Session required
        
        Required?                    false
        Position?                    10
        Default value                
        Accept pipeline input?       false
        Accept wildcard characters?  

```
