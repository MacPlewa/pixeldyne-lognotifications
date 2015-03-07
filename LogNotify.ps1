<# 

LogNotify v0.8
https://github.com/pixeldyne/pixeldyne-lognotifications

Usage:

powershell -file LogNotify.ps1

If your security policy prevents running scripts:

powershell -file LogNotify.ps1 -ExecutionPolicy Bypass

Copyright (c) 2014-2015 Maciek 'Mac' Plewa (mac.plewa@pixeldyne.systems)
#>

# sample configuration for Gmail

$configuration = @{
    'TimePeriod'=24; # example: get messages for the past 24 hours - should be the same as the period your scheduled task runs at
    'EventTypes'="Warning,Error" # comma separated, available: Information,Warning,Error
    'EmailFrom'="example@gmail.com"; # address to send from, usually yours
    'EmailTo'="example@gmail.com"; # should probably be the same as the one above in a home environment
    'EmailSubject'="Event log notification for [machine] ([count] events)"; # [machine] and [count] are placeholders
	'SmtpHost'="smtp.example.com"; # mail server, e.g. smtp.gmail.com, smtp.live.com, etc.
	'SmtpPort'=587; # port number, usually 587 if gmail or outlook (hotmail) and using SSL
	'SmtpUser'="example@example.com"; # in most cases, same as EmailFrom
    'UseSSL'= $true;
	'SmtpPassword'="guest :)"; # note - password is stored in clear text!
    'SmptPasswordEncrypted'=""; # alternative - when you store the password encrypted (implemented in next version)
}

# we need to load the StringTemplate library first

$currentScriptDirectory = Get-Location

[Environment]::CurrentDirectory = $currentScriptDirectory

[System.IO.Directory]::SetCurrentDirectory($currentScriptDirectory.Path)
$loadLib = [System.Reflection.Assembly]::LoadFile($currentScriptDirectory.Path + '\antlr.runtime.dll')
$loadLib = [System.Reflection.Assembly]::LoadFile($currentScriptDirectory.Path + '\StringTemplate.dll')

$text = (Get-Content -Path Email.html | out-string)

$strTemplate = new-object Antlr.StringTemplate.StringTemplate($text)

# get the events between now and the number of hours configured and add to a simple array list

$logPeriod = new-timespan -hours $configuration.TimePeriod
$eventCount = 0

$logMessages = New-Object System.Collections.ArrayList

$eventTypes = $configuration.EventTypes.Split(",")

foreach ($eventType in $eventTypes)
{
    $events = get-eventlog -logname System -EntryType $eventType -after ((get-date) - $logPeriod)

    foreach ($event in $events) {
	    $void = $logMessages.Add($event)
    }
}

# fill the placeholders

$emailSubject = New-Object System.String($configuration.EmailSubject);
$emailSubject = $emailSubject.Replace("[machine]", $env:COMPUTERNAME).Replace("[count]", $logMessages.Count);

$strTemplate.SetAttribute("messages", $logMessages)
$strTemplate.SetAttribute("title", $emailSubject)

$emailBody = $strTemplate.ToString()

#create the email message

$smtpClient = New-Object Net.Mail.SmtpClient($configuration.SmtpHost, $configuration.SmtpPort) 
$smtpClient.EnableSsl = $configuration.UseSSL
$smtpClient.Credentials = New-Object System.Net.NetworkCredential($configuration.SmtpUser, $configuration.SmtpPassword)

$message = New-Object Net.Mail.MailMessage($configuration.EmailFrom, $configuration.EmailTo, $emailSubject, $emailBody)

$message.BodyEncoding = [System.Text.Encoding]::UTF8
$message.IsBodyHtml = $true
$message.DeliveryNotificationOptions = [System.Net.Mail.DeliveryNotificationOptions]::OnFailure

$smtpClient.Send($message);
