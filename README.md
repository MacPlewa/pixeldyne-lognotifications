pixeldyne-lognotifications
==========================

Simple but highly configurable PowerShell script that notifies you by email about any Windows errors on scheduled basis. When setup, it will send you a summary of all errors that have been logged in a given time period (default is 24 hours).

You can configure it to run on specific days or every day using the Task Scheduler and the mail functionality can be configured for GMail, Hotmail, Exchange or pretty much any other mail service (default configuration example is for GMail, but more example configs will be provided).

I've tried to keep it as simple as possible, with a focus on extensibility. The actual logic is implemented using .NET classes and the email template processing is handled by the powerful StringTemplate library. 

That means you have full control over how the emails look and how much information is included, and by modifying the easy to use script you can also get events from other sources such as Security, DNS, etc.

The script was developed and tested with PowerShell version 4, it might not work with earlier versions.

Configuration
=============

You need to configure your email address and provider details first. If you use Hotmail, just find out their SMTP addresses, and so on.

Usage
=====

powershell -file LogNotify.ps1

If your security policy prevents running scripts:

powershell -file LogNotify.ps1 -ExecutionPolicy Bypass

Licence
=======

Since it derives a lot of its functionality from StringTemplate (http://www.stringtemplate.org/) I'm releasing it under the same BSD license so that you're free to use and modify it any way you wish.

pixeldyne-lognotifications is copyright (c) 2014-2015 Maciek 'Mac' Plewa (mac.plewa@pixeldyne.systems)

[The BSD License]
Copyright (c) 2012 Terence Parr
All rights reserved.
Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
Neither the name of the author nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
