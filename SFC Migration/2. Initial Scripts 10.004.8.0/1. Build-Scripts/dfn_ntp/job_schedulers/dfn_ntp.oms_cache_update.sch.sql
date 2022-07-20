/* Name	: oms_cache_update
Run on	: 2:45 AM
Interval	: FREQ=DAILY
Dependency	:  
Return Value	: pstat (1=success, 0=fail), pmsg -Exception if fail
Comment	: refresh oms cache At 2.45 AM
*/



DECLARE
    pstat NUMBER (1);
    pmsg VARCHAR2 (4000);
BEGIN

    DFN_NTP.SP_JOB_SCHEDULAR_ACTION('OMS_CACHE_UPDATE', pstat, pmsg);

    DBMS_OUTPUT.put_line ('pstat > ' || pstat || 'pmsg > ' || pmsg);

EXCEPTION
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.put_line ('Exception > ' || SQLERRM);

END;
/

