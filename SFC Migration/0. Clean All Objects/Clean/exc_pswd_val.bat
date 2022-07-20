cd pswd_val

type nul > log.run.password_validation

IF %str2%==N/A goto Result1True

:Result1False
echo ------------ & echo USER LOGIN - %str2:~0,8%
sqlplus %str2%@%1 @master.sql
goto Step2 

:Result1True
@echo off
echo DFN_ALGO-Login Not Available>> log.run.password_validation

:Step2
IF %str3%==N/A goto Result2True

:Result2False
echo ------------ & echo USER LOGIN - %str3:~0,7%
sqlplus %str3%@%1 @master.sql
goto Step3

:Result2True
@echo off
echo DFN_ARC-Login Not Available>> log.run.password_validation

:Step3
IF %str4%==N/A goto Result3True

:Result3False
echo ------------ & echo USER LOGIN - %str4:~0,7%
sqlplus %str4%@%1 @master.sql
goto Step4

:Result3True
@echo off
echo DFN_NTP-Login Not Available>> log.run.password_validation

:Step4
IF %str5%==N/A goto Result4True

:Result4False
echo ------------ & echo USER LOGIN - %str5:~0,7%
sqlplus %str5%@%1 @master.sql
goto Step5

:Result4True
@echo off
echo DFN_MIG-Login Not Available>> log.run.password_validation

:Step5
IF %str6%==N/A goto Result5True

:Result5False
echo ------------ & echo USER LOGIN - %str6:~0,9%
sqlplus %str6%@%1 @master.sql
goto Step6

:Result5True
@echo off
echo DFN_PRICE-Login Not Available>> log.run.password_validation

:Step6
IF %str7%==N/A goto Result6True

:Result6False
echo ------------ & echo USER LOGIN - %str7:~0,7%
sqlplus %str7%@%1 @master.sql
goto Step7

:Result6True
@echo off
echo DFN_CSM-Login Not Available>> log.run.password_validation



:Step7
@echo off & setlocal 
 
set strval1=invalid
set strval2=invalid
set strval3=invalid
set strval4=invalid
set strval5=invalid
set strval6=invalid
set validation=
set strval= 
For /F "tokens=1*" %%i in (log.run.password_validation) do call :doSomething "%%i"

cd ..

REM  IF %strval1%==Successful ( IF %strval2%==Successful ( IF %strval3%==Successful ( IF %strval4%==Successful ( IF %strval5%==Successful ( IF %strval6%==Successful (call execute %str1%  %str2%  %str3%  %str4% %str5% %str6% %str7% )))))) ELSE (echo ------------ & echo Invalid Username and password, Please refer above output)
 IF %strval1%==Successful IF %strval2%==Successful IF %strval3%==Successful IF %strval4%==Successful IF %strval5%==Successful IF %strval6%==Successful goto ResultTrue
 
:ResultFalse
echo ------------ & echo Invalid Username and password, Please refer above output
goto Done

:ResultTrue
call execute %str1% %str2% %str3%  %str4% %str5% %str6% %str7%

PAUSE
EXIT

:Done
PAUSE
EXIT
 
goto :eof 

:doSomething 
rem echo.
rem echo Password_Validating "%~1" ...
Set "strval=%~1" 


 If %strval:~0,8%==DFN_ALGO  set "strval1=Successful"
 If %strval:~0,7%==DFN_ARC  set "strval2=Successful"
 If %strval:~0,7%==DFN_NTP  set "strval3=Successful"
 If %strval:~0,7%==DFN_MIG  set "strval4=Successful"
 If %strval:~0,9%==DFN_PRICE  set "strval5=Successful"
 If %strval:~0,7%==DFN_CSM  set "strval6=Successful"
 
 rem echo %strval1% %strval2% %strval3% %strval4% %strval5%
 
 
goto :eof 

REM cd ..\

