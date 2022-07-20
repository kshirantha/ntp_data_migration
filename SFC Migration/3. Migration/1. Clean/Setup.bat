@echo off & setlocal 
 
set str1= 
set str2=
set str3=
set str4=
set str5=
set str6=
set str7=
set str= 
For /F "tokens=1*" %%i in (..\..\Parameters.dat) do call :doSomething "%%i"

rem echo.
REM echo %str1% %str2% %str3% %str4% %str5% %str6% %str7%

call exc_pswd_val %str1%  %str2%  %str3%  %str4% %str5% %str6% %str7%
REM call execute %str1%  %str2%  %str3%  %str4% %str5% %str6% %str7%

goto :eof 

:doSomething 
echo.
echo Password_Validating "%~1" ...
Set "Str=%~1"  
rem echo %str%

REM echo %str:~0,11% %str:~12%

 If %str:~0,11%==DFN_DB_CONN  set "str1=%str:~12%"
 If %str:~0,11%==DFN_ALG_PWD  set "str2=%str:~12%"
 If %str:~0,11%==DFN_ARC_PWD  set "str3=%str:~12%"
 If %str:~0,11%==DFN_NTP_PWD  set "str4=%str:~12%"
 If %str:~0,11%==DFN_MIG_PWD  set "str5=%str:~12%"
 If %str:~0,11%==DFN_PRC_PWD  set "str6=%str:~12%"
 If %str:~0,11%==DFN_CSM_PWD  set "str7=%str:~12%"

REM echo %str1% %str2% %str3% %str4% %str5% %str6% %str7%
goto :eof 

