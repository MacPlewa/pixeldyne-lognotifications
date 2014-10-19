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

Since it derives a lot of its functionality from StringTemplate I'm releasing it under the same BSD license so that you're free to use and modify it any way you wish.
