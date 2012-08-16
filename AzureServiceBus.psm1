# **************** Azure Service Bus Powershell Module *************
# Author: M Sheik Uduman Ali
# http://udooz.net/blog
# udooz@hotmail.com
# Revision: 1
# ******************************************************************

Add-Type -AssemblyName "System.Web.Extensions"

function Import-AzureSbAssembly 
{
	<#
		.SYNOPSIS
		Import Microsoft Service Bus assemblies.
		
		.PARAMETER azureSdkPath
		Azure SDK Path. If not specified, default SDK v1.7 path has been taken.
	#>
	param(
		[string]$azureSdkPath = "C:\Program Files\Microsoft SDKs\Windows Azure\.NET SDK\2012-06\ref\"	
	)    
	if(!$azureSdkPath.EndsWith("\")) {$azureSdkPath = $azureSdkPath + "\"}
    $sbAssemblyName = "Microsoft.ServiceBus.dll"
    $sbAsmPath = $azureSdkPath + $sbAssemblyName
	
	if(Test-Path -Path $sbAsmPath)
	{
		[Reflection.Assembly]::LoadFile($sbAsmPath) | Out-Null
		Write-Host "Service bus assembly loaded successfully"
	}else 
	{
		Write-Error "Service bus assembly not found at $sbAsmPath"
	}
}

$script:sbNsmgr = $null
$script:sbCred = $null

function Initialize-AzureSbCredential
{
	<#
    .SYNOPSIS
    Initialize Azure Service Bus Credential
	
	.EXAMPLE
	$cred = [psobject] @{
		issuer = "owner"
		secret = "xxxxx"
		ns = "mysb"
		path =""
	}
	Initialize-AzureSbCredential -cred $cred
	#>
	
	param (
		[ValidateNotNull()]
		[psobject]$cred
	)
	$script:sbCred = $cred
	$script:sbNsmgr = $null
}

function Get-AzureSbNamespaceManager
{
	<#
    .SYNOPSIS
    Creates or gets already created instance of Azure Service Bus NamespaceManager.
	
	.DESCRIPTION
	A script level instance maintained after the first instantiation of NamespaceManager.
	
	.PARAMETER forceNew Force to create new NamespaceManager instance
	
	.EXAMPLE
	Get-AzureSbNamespaceManager
	#>
	
	param (
		[switch] $forceNew
	)
	if(!$script:sbCred) 
	{
		Write-Error "Initialize Service Bus credential using Initialize-AzureSbCredential"
		return
	}
	if(!$script:sbNsmgr -or $forceNew) 
	{
		$tp = Get-AzureSbTokenProvider
		$uri = Get-AzureSbUri
		$script:sbNsmgr = New-Object -TypeName Microsoft.ServiceBus.NamespaceManager -ArgumentList $uri, $tp
	}
	$script:sbNsmgr
}

function Get-AzureSbTokenProvider
{
	[Microsoft.ServiceBus.TokenProvider]::CreateSharedSecretTokenProvider($script:sbCred.issuer, $script:sbCred.secret)
}

function Get-AzureSbUri
{
	[Microsoft.ServiceBus.ServiceBusEnvironment]::CreateServiceUri('sb', $script:sbCred.ns, $script:sbCred.path)
}

function New-AzureSbQueue
{
    <#
    .Synopsis
    Creates a new Windows Azure Service Bus Queue
	
	.Description
	This cmdlet sets some default values so that you do not need to specify all.
    
    .Parameter qname
    Queue name
	
	.Parameter defTtl
	Default time to live.  Default: 922337203685 seconds as like in portal.
	
	.Parameter duplDetectHisTimeWindow
	Depulicate detect history time window.  Default: 600 seconds as like in portal.
	
	.Parameter batch
	Enable batch.  Default: false
	
	.Parameter deadLettringRequired
	This require dead lettering.
	
	.Parameter lockDuration
	Duration of locking.
	
	.Parameter maxDelvCount
	Maximum delivery count
	
	.Parameter maxQSize
	Maximum queue size
	
	.Parameter detectDupl
	Should detect duplicate message
	
	.Parameter sessionRequired
	Session required
	
	.OUTPUTS
	Microsoft.ServiceBus.Messaging.QueueDescription
	#>
	
	param (
		[Parameter(Mandatory=$true)]
		[string]$qname,
		[TimeSpan]$defTtl = [TimeSpan]::FromSeconds(922337203685),
		[TimeSpan]$duplDetectHisTimeWindow = [TimeSpan]::FromSeconds(600),
		[bool]$batch = $false,
		[bool]$deadLettringRequired = $true,		
		[TimeSpan]$lockDuration = [TimeSpan]::FromMinutes(5),
		[int]$maxDelvCount = 3,
		[long]$maxQSize = 1024,
		[bool]$detectDupl = $true,
		[bool]$sessionRequired = $false
	)
	begin {	
		if(!$script:sbCred)
		{
			Write-Error "Initialize Service Bus credential using Initialize-AzureSbCredential"
			return
		}
		if(!$script:sbNsmgr) {Get-AzureSbNamespaceManager}
	}
	
	process {
		if(!$script:sbNsmgr.QueueExists($qname)) 
		{
			$qdesc = New-Object -TypeName Microsoft.ServiceBus.Messaging.QueueDescription -ArgumentList $qname	
			$qdesc.DefaultMessageTimeToLive = $defTtl;$qdesc.DuplicateDetectionHistoryTimeWindow=$duplDetectHisTimeWindow
			$qdesc.EnableBatchedOperations = $batch; $qdesc.EnableDeadLetteringOnMessageExpiration = $deadLettringRequired
			$qdesc.LockDuration = $lockDuration; $qdesc.MaxDeliveryCount=$maxDelvCount
			$qdesc.MaxSizeInMegabytes = $maxQSize; $qdesc.RequiresDuplicateDetection=$detectDupl			
			$qdesc.RequiresSession = $sessionRequired
			
			$rqdesc = $script:sbNsmgr.CreateQueue($qdesc)
			
			Write-Host "Queue $qname created"
		}else 
		{		
			Write-Host "$qname already exists"
		}
	}
	
	end { $rqdesc }		
}

function Get-AzureSbQueueDesc 
{
	<#
		.SYNOPSIS
		Gets Service Bus QueueDescription for a queue
		
		.OUTPUTS
		Microsoft.ServiceBus.Messaging.QueueDescription
	#>
	
	param (
		[Parameter(Mandatory=$true)]
		[ValidateNotNullOrEmpty()]
		[string]$qname
	)	
	if(!$script:sbNsmgr) {Get-AzureSbNamespaceManager}
	$script:sbNsmgr.GetQueue($qname)
}

$script:sbQSClient = $null

function Send-AzureSbMessage
{
	<#
		.SYNOPSIS
		Send a brokered message to a service bus queue
		
		.PARAMETER path
		Queue name with path
		
		.PARAMETER bodyJson
		JSONified string which is the body of the message
		
		.PARAMETER stubBodyObj
		Stub of the message body.
		
		.PARAMETER msgLabel
		Message label
		
		.PARAMETER msgId
		Message Id
		
		.PARAMETER replyTo
		Reply to a requeue
		
		.PARAMETER replyToSessionId
		Reply to a session Id
		
		.PARAMETER sessionId
		Session Id
		
		.PARAMETER to
		To address
		
		.PARAMETER ttl
		Time to live for the message
		
		.PARAMETER msgProps
		Message properties
		
		.PARAMETER forceNewQClient
		Instead of existing queue client, force to create new one
		
		.PARAMETER $ignoreJson
		Ignores JSON, instead use stubBodyObj for the body content
		
		.EXAMPLE
		#create a CLR type in powershell
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
		
		.EXAMPLE
		# JSON based message sending helpful for pumbing large number of messages to test your queue.
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
	#>
	param(
		[Parameter(Mandatory=$true)]
		[string]$path,
		[Parameter(ValueFromPipeline=$true)]
		[string]$bodyJson,
		$stubBodyObj,
		[string]$msgLabel,
		[string]$msgId,
		[string]$replyTo,
		[string]$replyToSessionId,
		[string]$sessionId,
		[string]$to,
		[TimeSpan]$ttl,
		[hashtable]$msgProps,
		[switch]$forceNewQClient,
		[switch]$ignoreJson
	)
	if(!$script:sbQSClient -or $forceNewQClient)
	{
		$tp = Get-AzureSbTokenProvider -cred $cred
		$uri = Get-AzureSbUri -cred $cred
		$script:sbQSClient = [Microsoft.ServiceBus.Messaging.MessagingFactory]::Create($uri, $tp).CreateQueueClient($path)
	}
	if(!$ignoreJson) 
	{
		$stubBodyObj = ConvertFrom-Json -json $bodyJson -stubObj $stubBodyObj
	}
	
	$msg = New-Object Microsoft.ServiceBus.Messaging.BrokeredMessage -ArgumentList $stubBodyObj
	
	if($msgLabel){$msg.Label = $msgLabel}
	if($msgId){$msg.MessageId = $msgId}
	if($replyTo) {$msg.ReplyTo = $replyTo}
	if($replyToSessionId) {$msg.ReplyToSessionId = $replyToSessionId}
	if($sessionId) {$msg.SessionId = $sessionId}
	if($to) {$msg.To = $to}
	if($ttl) {$msg.TimeToLive = $ttl}
	if($msgProps) {$msg.Properties = $msgProps}
	
	try {
		$script:sbQSClient.Send($msg)
	}catch {
		Write-Error $Error[0]
	}finally {
		return $msg
	}
}

$script:sbQRClient = $null

function Receive-AzureSbMessage
{
	<#
		.SYNOPSIS
		Peek and lock the message from the given queue
		
		.PARAMETER path
		Queue name with path
		
		.PARAMETER stubBodyObj
		Stub of the message body.
		
		.PARAMETER forceNewQClient
		Instead of existing queue client, force to create new one
		
		.PARAMETER $skipBodyProcess
		Skip body parsing
		
		.OUTPUTS
		Returns a key-value of BrokeredMessage and its Body in the key names "msg" and "body" respectively
		
		.EXAMPLE
		$p = New-Object Person #stub object
		$pr = Receive-AzureSbMessage -path "personq" -stubBodyObj $p
		Write-Host $pr.msg
		Write-Host $pr.body
		
		.EXAMPLE
		#to receive "n" number of messages from the queue
		# here n = 6
		1..6 | ForEach { $pr = Receive-AzureSbMessage -path "personq" -stubBodyObj $p; Write-Host $pr.body.Name}
	#>
	param(
		[Parameter(Mandatory=$true)]
		[string]$path,
		$stubBodyObj,
		[switch]$forceNewQClient,
		[switch]$skipBodyProcess
	)
	if(!$script:sbQRClient -or $forceNewQClient)
	{
		$tp = Get-AzureSbTokenProvider -cred $cred
		$uri = Get-AzureSbUri -cred $cred
		$script:sbQRClient = [Microsoft.ServiceBus.Messaging.MessagingFactory]::Create($uri, $tp).CreateQueueClient($path, [Microsoft.ServiceBus.Messaging.ReceiveMode]::PeekLock)
	}
	
	$msg = $null
	
	try {
		$msg = $script:sbQRClient.Receive()				
	}catch {
		Write-Error $Error
	}finally {
		if($msg) { 
			$msg.Complete() 
			$body = $null
			if(!$skipBodyProcess)
			{
				$mi = $msg.GetType().GetMethods() | Where {$_.Name -like 'GetBody' -and ($_.GetParameters().Length -eq 0)} | Select
				$body = $mi.MakeGenericMethod($stubBodyObj.GetType()).Invoke($msg, $null)
			}
			return @{msg=$msg;body=$body}
		}
	}
}

function Clear-AzureSbObjects
{
	<#
		.SYNOPSIS
		Clears Azure Service Bus queue clients, NamespaceManager and other script level objects
	#>
	$script:sbCred = $null
	$script:sbNsmgr = $null
	$script:sbQRClient = $null
	$script:sbQSClient = $null
}

function ConvertFrom-Json
{
	param(		
		[string]$json,		
		$stubObj
	)
	
	$jss = New-Object System.Web.Script.Serialization.JavaScriptSerializer
	$retObj = $jss.Deserialize($json, $stubObj.GetType())
	$retObj
}