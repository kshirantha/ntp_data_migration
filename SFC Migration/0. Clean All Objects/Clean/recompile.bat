IF %str4%==N/A goto Result1True

:Result1False
sqlplus %str4%@%1 @COMALL.sql
goto Step2 

:Result1True
echo DFN_NTP-Login Not Available

:Step2
IF %str3%==N/A goto Result2True

:Result2False
sqlplus %str3%@%1 @COMALL.sql
goto Step3

:Result2True
echo DFN_ARC-Login Not Available

:Step3
IF %str2%==N/A goto Result3True

:Result3False
sqlplus %str2%@%1 @COMALL.sql
goto Step4

:Result3True
echo DFN_ALGO-Login Not Available

:Step4
IF %str5%==N/A goto Result4True

:Result4False
sqlplus %str5%@%1 @COMALL.sql
goto Step5

:Result4True
echo DFN_MIG-Login Not Available

:Step5
IF %str6%==N/A goto Result5True

:Result5False
sqlplus %str6%@%1 @COMALL.sql
goto Step6

:Result5True
echo DFN_PRICE-Login Not Available

:Step6
IF %str7%==N/A goto Result6True

:Result6False
sqlplus %str7%@%1 @COMALL.sql
goto Step7

:Result6True
echo DFN_CSM-Login Not Available



:Step7
echo SUMMARY GENERATE PROCESS STARTING

