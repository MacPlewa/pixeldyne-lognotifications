pixeldyne-lognotifications
==========================

Simple but highly configurable PowerShell script that notifies you by email about any Windows errors on scheduled basis. When setup, it will send you a summary of all errors that have been logged in a given time period (default is 24 hours). I wrote this script because I did not want to run the System Center on my home PCs and tablets, but at the same time I wanted an early warning functionality - to tell me of potential issues with disks, network, drivers, etc.

You can configure it to run on specific days or every day using the Task Scheduler, and the mail functionality can be configured for GMail, Hotmail, Exchange or pretty much any other mail service (example configurations provided for GMail, Hotmail/Outlook). It does not require you to run your own email server.

I've tried to keep it as simple as possible, with a focus on extensibility and customisation. The actual logic is implemented using .NET classes and the email template processing is handled by the powerful StringTemplate library. 

That means you have full control over how the emails look and how much information is included, and by modifying the easy to use script you can also get events from other sources such as Security, DNS, etc.

The script was developed and tested with PowerShell version 4, it might or not work with earlier versions. Tested on Windows 7 and 8. If you run into any issues with permissions, please read https://technet.microsoft.com/library/hh847748.aspx.

Setup and Configuration
=======================

Uncompress the zip file from github to a folder on your disk, e.g. "C:\Tools\" (it'll add a new folder "pixeldyne-lognotifications-master"

Open LogNotify.ps1 in your favourite editor and look at the $configuration. You need to configure your email address and provider details first. If you use GMail, Hotmail/Outlook - examples are provided in the file. For other servers, just find the SMTP server details and optionally configure these parameters:

- EventTypes:	comma separated, available: Error,Warning,Information,FailureAudit,SuccessAudit
- EventLogs:	comma separated, available: Application,System,Security
- TimePeriod:	time in hours, e.g. 24 to get messages for the past 24 hours - should be the same as the period your scheduled task runs at

Setup your scheduled task:

1. From Start screen: type schedule tasks and press ENTER; alternatively go to Control Panel->Administrative Tools->Task Scheduler
2. Create a new task (basic)
3. Trigger: daily (every 24 hours)
4. Choose action: Start a program
5. Set the parameters: 
	Program/Script: powershell
	Add arguments:	-file LogNotify.ps1
	Start in:		C:\Tools\pixeldyne-lognotifications-master (the folder where the files were extracted to)
6. Once created, open properties and select Run whether this user is logged on or not

Usage (Command line)
====================

powershell -file LogNotify.ps1

If your security policy prevents running scripts (see https://technet.microsoft.com/library/hh847748.aspx):

powershell -file LogNotify.ps1 -ExecutionPolicy Bypass

Further Customisation
=====================

Sample email template is provided; all possible attributes will be documented in the next releases.

Licence
=======

Since it derives a lot of its functionality from StringTemplate (http://www.stringtemplate.org/) I'm releasing it under the same BSD license so that you're free to use and modify it any way you wish.

--

pixeldyne-lognotifications is Copyright (c) 2014-2015 Maciek 'Mac' Plewa (mac.plewa@pixeldyne.systems)

--

StringTemplate: The BSD License

Copyright (c) 2012 Terence Parr
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
Neither the name of the author nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
