@echo off
REM ############################################################################
REM #
REM # Filename      : pingTest.bat
REM # About         : This script will accept a comma separted list of names and
REM #                 IPs, ping them, and then save the result in a logfile.
REM #                 If the ping is sucessful it will also run tracert.
REM # Useage        : pingTest.bat
REM # Input         : ipList.csv
REM #                 target_srv,target_ip
REM # Author        : Chris Helmkamp
REM # Modified      : 2017-10-17
REM #
REM ############################################################################

Echo Starting pingTest... 
echo.
Set InputFile=ipList.csv
echo Reading from %InputFile%
echo.

REM
REM Get some date formats to use
REM
for /f "tokens=2 delims==" %%a in ('wmic OS Get localdatetime /value') do set "dt=%%a"
set "YY=%dt:~2,2%" & set "YYYY=%dt:~0,4%" & set "MM=%dt:~4,2%" & set "DD=%dt:~6,2%"
set "HH=%dt:~8,2%" & set "Min=%dt:~10,2%" & set "Sec=%dt:~12,2%"

set "datestamp=%YYYY%%MM%%DD%" & set "timestamp=%HH%%Min%%Sec%"
rem set "fullstamp=%YYYY%-%MM%-%DD%_%HH%:%Min%:%Sec%"
set "fullstamp=%YYYY%-%MM%-%DD%_%HH%.%Min%"

REM Get the computer name to put in the logfile
FOR /F "usebackq" %%i IN (`hostname`) DO SET compname=%%i

set pinglog=%fullstamp%_%compname%_PingResult.csv
set tracelog=%fullstamp%_%compname%_TraceResult.txt

echo target_srv,target_ip,status>>%pinglog%

FOR /F "tokens=1-2* delims=," %%A IN (%InputFile%) DO (
	ping -n 2 %%B | find "TTL=" > NUL
	if ERRORLEVEL 1 (
		echo %%A,%%B,fail
		echo %%A,%%B,fail>>%pinglog%
	) else if ERRORLEVEL 0 (
		tracert -h 10 -4 -d -w 2 %%B>>%tracelog%
		echo %%A,%%B,success
		echo %%A,%%B,success>>%pinglog%
	)
	
)
echo.
echo Ping results in %pinglog%
echo.
echo Traceroute results in %tracelog%
echo.
pause