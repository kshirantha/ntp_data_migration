/* Name	: eod_cash_trn_fee_bulk_update_ftb_b
Run on	: 08:10 PM
Interval	: FREQ=DAILY
Dependency	:  
Return Value	: pstat (1=success, 0=fail), pmsg -Exception if fail
Comment	: Fund Transfer Charges At 08:10 PM
*/



DECLARE
    pstat NUMBER (1);
    pmsg VARCHAR2 (4000);
BEGIN

    DFN_NTP.SP_JOB_SCHEDULAR_ACTION('EOD_CASH_TRN_FEE_BULK_UPDATE_FTB_B', pstat, pmsg);

    DBMS_OUTPUT.put_line ('pstat > ' || pstat || 'pmsg > ' || pmsg);

EXCEPTION
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.put_line ('Exception > ' || SQLERRM);

END;
/

