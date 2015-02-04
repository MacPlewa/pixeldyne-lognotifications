<# 
Usage:

powershell -file LogNotify.ps1

If your security policy prevents running scripts:

powershell -file LogNotify.ps1 -ExecutionPolicy Bypass

Copyright (c) 2014-2015 Maciek 'Mac' Plewa (http://pixeldyne.org)
#>

# sample configuration for Gmail

$configuration = @{
    'TimePeriod'=24; # get messages for the past 24 hours
    'EmailFrom'="example@gmail.com";
    'EmailTo'="example@gmail.com";
    'EmailSubject'="Event log notification for [machine] ([count] events)"; # [machine] and [count] are placeholders
	'SmtpHost'="smtp.gmail.com";
	'SmtpPort'=587;
	'SmtpUser'="example@gmail.com";
	'SmtpPassword'="password"; # note - password is stored in clear text
}

$currentScriptDirectory = Get-Location

[Environment]::CurrentDirectory = $currentScriptDirectory

[System.IO.Directory]::SetCurrentDirectory($currentScriptDirectory.Path)
$loadLib = [System.Reflection.Assembly]::LoadFile($currentScriptDirectory.Path + '\antlr.runtime.dll')
$loadLib = [System.Reflection.Assembly]::LoadFile($currentScriptDirectory.Path + '\StringTemplate.dll')

$text = (Get-Content -Path Email.html | out-string)

$strTemplate = new-object Antlr.StringTemplate.StringTemplate($text)

$logPeriod = new-timespan -hours $configuration.TimePeriod
$eventCount = 0

$events = get-eventlog -logname System -EntryType Error -after ((get-date) - $logPeriod)

$logMessages = New-Object System.Collections.ArrayList

foreach ($event in $events) {
	$void = $logMessages.Add($event)
}

$configuration.EmailSubject = $configuration.EmailSubject -replace "[machine]", $env:COMPUTERNAME
$configuration.EmailSubject = $configuration.EmailSubject -replace "[count]", $logMessages.Count

$strTemplate.SetAttribute("messages", $logMessages);
$strTemplate.SetAttribute("title", $configuration.EmailSubject);

$emailBody = $strTemplate.ToString()

$smtpClient = New-Object Net.Mail.SmtpClient($configuration.SmtpHost, $configuration.SmtpPort) 
$smtpClient.EnableSsl = $true 
$smtpClient.Credentials = New-Object System.Net.NetworkCredential($configuration.SmtpUser, $configuration.SmtpPassword); 

$message = New-Object Net.Mail.MailMessage($configuration.EmailFrom, $configuration.EmailTo, "Log messages", $emailBody)

$message.BodyEncoding = [System.Text.Encoding]::UTF8
$message.IsBodyHtml = $true
$message.DeliveryNotificationOptions = [System.Net.Mail.DeliveryNotificationOptions]::OnFailure

$smtpClient.Send($message);
