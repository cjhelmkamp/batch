@echo off
SETLOCAL EnableDelayedExpansion
echo.
REM put your VPN connection name here
set myvpn="VPN NAME"
REM List of networks
set netList=192.168.0.0 192.168.1.0 192.168.2.0 10.1.1.0 10.1.2.0 10.1.3.0  

ipconfig | find /i %myvpn% > nul 2>&1

if %ERRORLEVEL% == 0 (
    
	echo "VPN connected. Adding routes..."
REM *
REM Change the vpn subnet its looking for
REM *  
	FOR /F "TOKENS=2 DELIMS=:" %%A IN ('IPCONFIG ^| FIND "IPv4 Address" ^| FIND "192.168.69."') DO (
		SET IP=%%A
		set GW=!IP:~1!
		)
	echo Gateway: !GW!
	
	FOR /F %%i in ('netsh interface ipv4 show interface ^| find "AHIMA VPN"') do set ifnum=%%i
	echo If Num: !ifnum!
	
	for %%b in (%netList%) do (
		route add %%b mask 255.255.255.0 !GW! if !ifnum! > nul 2>&1
	)
) else if %ERRORLEVEL% == 1 (

    echo "VPN not connected."
    echo.
	exit
    rem rasdial %myvpn% %myuser% %mypass%
    rem runas.exe /user:%winadmin% /savedcred "route add %network% mask %mask% %gateway%"
)
echo.
echo Done. 
exit