# Azure Service Bus Cmdlets #
A set of cmdlets targeted to assist Azure Service Bus management during the development or testing.
### Why do you need this? ###
- Avoid writing boiler plate code for Service Bus related operations such as to create NamespaceManager, QueueClient, Send and receive messages
- Pump huge number of message to Azure Service Bus queues either from collection or JSON text files

## Cmdlets ##

- *[Import-AzureSbAssembly](./asb/01.md)*.  Load Azure ServiceBus related .NET assemblies.
- *Initialize-AzureSbCredential*. Initialize ServiceBus access control credential.
- *Get-AzureSbNamespaceManager*. Creates new or returns existing NamespaceManager.
- *New-AzureSbQueue*. Creates new Windows Azure ServiceBus queue.
- *Get-AzureSbQueueDesc*. Returns QueueDescription of a ServiceBus queue.
- *Send-AzureSbMessage*. Sends a message to a ServiceBus queue.
- *Receive-AzureSbMessage*. Receives a message (peek and lock) from a ServiceBus queue.
- *Clear-AzureSbObjects*. Clear all script level ServiceBus related objects.

# Version History #
## Version 1.0 #
Cmdlets for Windows Azure Service Bus queue related operations.

### You Contribution ###
The Cmdlets can either be refactored or new cmdlets be added based on the developer usage.  Your feedbacks or contribution are highly appreciated.
Contact: udooz at hotmail dot com.