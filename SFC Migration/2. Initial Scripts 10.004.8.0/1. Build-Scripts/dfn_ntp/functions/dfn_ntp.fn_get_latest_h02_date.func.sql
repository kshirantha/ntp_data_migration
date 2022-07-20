CREATE OR REPLACE FUNCTION dfn_ntp.fn_get_latest_h02_date (
    p_h02_cash_account_id_u06    dfn_ntp.h02_cash_account_summary.h02_cash_account_id_u06%TYPE,
    p_h02_date                   dfn_ntp.h02_cash_account_summary.h02_date%TYPE)
    RETURN dfn_ntp.h02_cash_account_summary.h02_date%TYPE
AS
    l_date   dfn_ntp.h02_cash_account_summary.h02_date%TYPE;
    PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
    SELECT MAX (h02_date)
      INTO l_date
      FROM dfn_ntp.h02_cash_account_summary
     WHERE     h02_cash_account_id_u06 = p_h02_cash_account_id_u06
           AND h02_date <= p_h02_date;

    RETURN l_date;
END;
/
/
