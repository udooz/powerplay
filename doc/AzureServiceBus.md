# Azure Service Bus Cmdlets #
A set of cmdlets targeted to assist Azure Service Bus management during the development and testing.
### Why do you need this? ###
- Avoid writing boiler plate code for Service Bus related operations such as to create NamespaceManager, QueueClient, Send and receive messages
- To pump huge number of message to Azure Service Bus queues either from object collection or from JSON text files for testing

## Cmdlets ##

- *[Import-AzureSbAssembly](./asb/Import_AzureSbAssembly.md)*.  Load Azure ServiceBus related .NET assemblies.
- *[Initialize-AzureSbCredential](./asb/Initialize_AzureSbCredential.md)*. Initialize ServiceBus access control credential.
- *[Get-AzureSbNamespaceManager](./asb/Get_AzureSbNamespaceManager.md)*. Creates new or returns existing NamespaceManager.
- *[New-AzureSbQueue](./asb/New_AzureSbQueue.md)*. Creates new Windows Azure ServiceBus queue.
- *[Get-AzureSbQueueDesc](./asb/Get_AzureSbQueueDesc.md)*. Returns QueueDescription of a ServiceBus queue.
- *[Send-AzureSbMessage](./asb/Send_AzureSbMessage.md)*. Sends a message to a ServiceBus queue.
- *[Receive-AzureSbMessage](./asb/Receive_AzureSbMessage.md)*. Receives a message (peek and lock) from a ServiceBus queue.
- *[Clear-AzureSbObjects](./asb/Clear_AzureSbObjects.md)*. Clear all script level ServiceBus related objects.

# Version History #
## Version 1.0 #
Cmdlets for Windows Azure Service Bus queue related operations.

### Your Contribution ###
Your contribution twoards refactoring the existing parts or new cmdlets are highly appreciated.

*Contact: udooz at hotmail dot com*.