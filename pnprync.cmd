
@echo off & cls & title ParnovyPrync

:menu_only
if %~1 == --menu (
	goto :menu
) else (
	goto :commands
)
:: https://www.coursera.org/articles/computer-forensics

:menu
cls
echo                ___                              ___                   
echo               / _ \___ ________  ___ _  ____ __/ _ \______ _____  ____
echo              / ___/ _ `/ __/ _ \/ _ \ ^|/ / // / ___/ __/ // / _ \/ __/
echo             /_/   \_,_/_/ /_//_/\___/___/\_, /_/  /_/  \_, /_//_/\__/ 
echo                                         /___/         /___/           
echo.
echo                             [1] Tools
echo.
echo                             [2] Settings
echo.
choice /c 12 /n >nul
if errorlevel 2 goto :settings
if errorlevel 1 goto :tools
echo Wrong input
pause >nul
goto :menu

:settings
cls
echo settings
pause
goto :menu

:tools
cls
echo                ___                              ___                   
echo               / _ \___ ________  ___ _  ____ __/ _ \______ _____  ____
echo              / ___/ _ `/ __/ _ \/ _ \ ^|/ / // / ___/ __/ // / _ \/ __/
echo             /_/   \_,_/_/ /_//_/\___/___/\_, /_/  /_/  \_, /_//_/\__/ 
echo                                         /___/         /___/           
echo.
echo                             [1] IP Adress
choice /c 1 /n >nul
if errorlevel 1 goto :ip_adress


:ip_adress
cls
echo                ___                              ___                   
echo               / _ \___ ________  ___ _  ____ __/ _ \______ _____  ____
echo              / ___/ _ `/ __/ _ \/ _ \ ^|/ / // / ___/ __/ // / _ \/ __/
echo             /_/   \_,_/_/ /_//_/\___/___/\_, /_/  /_/  \_, /_//_/\__/ 
echo                                         /___/         /___/           
echo.
echo                             [1] Reverse IP Lookup
echo                             [2] Port Scanner
echo.
echo                             [3] Trace DNS
echo                             [4] Trace MAC

choice /c 1234 /n >nul
if errorlevel 4 goto :trace_mac
if errorlevel 3 goto :trace_dns
if errorlevel 2 goto :port_scanner
if errorlevel 1 goto :reverse_ip_lookup


:trace_mac
cls
title Trace MAC
echo Provide valid IP Adress
set /p ip=">>"
ping -w 1 %ip% >nul
for /f "tokens=2 delims= " %%a in ('arp -a ^| find "%ip%"') do set macaddr=%%a
for /f "usebackq delims=" %%I in (`powershell "\"%macaddr%\".toUpper()"`) do set "upper=%%~I"
cls
echo.
echo Mac Address: %upper%
echo.
pause >nul
goto :menu

:trace_dns
title Trace DNS
cls
echo Provide valid IP Adress
set /p ip=">>"
cls
for /f "tokens=2 delims= " %%a in ('nslookup %ip% ^| find "Name"') do set dns=%%a
echo.
echo Domain Name: %dns%
echo.
pause >nul
goto :menu
:port_scanner
cls
echo.
echo This might take some time..
echo.
echo Provide valid IP:
set /p valid_ip=">>"
cls
nmap -p80 -script http-sql-injection %valid_ip% > http_ip.txt
cls
nmap -p80 -script http-unsafe-output-escaping %valid_ip% >> http_ip.txt
nmap -Pn -script=dns-brute %valid_ip% >> http_ip.txt
cls
echo [1/2] HTTP check: http_ip.txt
timeout /t 3 >nul
nmap %valid_ip% -sV -version-all -A > port_scan.txt
nmap %valid_ip% -p- >> port_scan.txt
cls
echo [2/2] Scanner done.
echo 1. HTTP check: http_ip.txt
echo 2. Port check: port_scan.txt
pause >nul
goto :tools

:reverse_ip_lookup
cls
echo Provide valid IP ^& ,ipinfo, Auth Token
set /p valid_ip=">>"
set /p valid_auth_ipinfo_token=">>"
cls
set file_number=%random%
curl ipinfo.io/%valid_ip%?token=%valid_auth_ipinfo_token% >> ipinfo%file_number%.txt
nslookup %valid_ip% >> np%file_number%.txt
ping %valid_ip% >> pg%file_number%.txt
cls
echo 1 file : ipinfo.txt
echo 2 file : np.txt
echo 3 file : pg.txt
pause >nul
goto :menu



