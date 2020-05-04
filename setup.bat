@ECHO OFF
:: BatchGotAdmin
:-------------------------------------
REM  --> Check for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params = %*:"=""
    echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
:--------------------------------------
ECHO Automated setup of Cygwin64 for C/C++
ECHO https://github.com/CharlesBarone/cygwin64-auto-install

ECHO.
ECHO.

SETLOCAL

cd %~dp0

SET MIRROR=http://cygwin.mirrors.pair.com/
SET DIR=%CD%
SET ROOT=C:\cygwin64

SET PACKAGES=binutils,binutils-debuginfo,gcc-core,gcc-g++,gdb,gdb-debuginfo,make,make-debuginfo,wget,tar,gawk,bzip2,subversion

ECHO Installing Cygwin64 with Default Packages
START /WAIT setup.exe --quiet-mode --no-desktop --download --local-install --no-verify -s %MIRROR% -l "%DIR%" -R "%ROOT%"

ECHO.
ECHO Installing C/C++ Related Packages for Cygwin64
START /WAIT setup.exe -q -d -D -L -X -s %MIRROR% -l "%DIR%" -R "%ROOT%" -P %PACKAGES%

ECHO.
ECHO Finished Installing Cygwin64 Packages!

ENDLOCAL

ECHO.
ECHO Finished Installation and Setup of Cygwin64!
ECHO Feel free to delete this bat file, setup.exe, along with the directory generated in the same directory as this bat file!

PAUSE
EXIT /B 0