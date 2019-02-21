@echo off
REM ############################################################################
REM #
REM # Filename      : AZroutesTask.bat
REM # About         : This script will create a scheduled task that tells 
REM #                 Windows to add an event listener based task that looks for 
REM #                 events to our "Pav Azure VPN" connection and if it sees them, 
REM #				  it runs our PowerShell script.
REM # Useage        : AZroutesTask.bat
REM # Author        : Chris Helmkamp
REM # Modified      : 2019-02-21
REM # Referance		: https://dzone.com/articles/deconstructing-azure-point
REM #
REM ############################################################################

schtasks /create /F /TN "Pav Azure VPN" /TR "Powershell.exe -NonInteractive -command \\192.168.20.5\NETLOGON\UpdateRouteTableForAzureVPN.ps1" /SC ONEVENT /EC Application /MO "*[System[(Level=4 or Level=0) and (EventID=20225)]] and *[EventData[Data='Pav Azure VPN']] "
