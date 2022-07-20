CREATE OR REPLACE FUNCTION dfn_ntp.fn_get_latest_h01_date (
    p_h01_trading_acnt_id_u07    dfn_ntp.h01_holding_summary.h01_trading_acnt_id_u07%TYPE,
    p_h01_exchange_code_m01      dfn_ntp.h01_holding_summary.h01_exchange_code_m01%TYPE,
    p_h01_symbol_id_m20          dfn_ntp.h01_holding_summary.h01_symbol_id_m20%TYPE,
    p_h01_date                   dfn_ntp.h01_holding_summary.h01_date%TYPE,
    p_h01_custodian_id_m26       dfn_ntp.h01_holding_summary.h01_custodian_id_m26%TYPE)
    RETURN dfn_ntp.h01_holding_summary.h01_date%TYPE
AS
    l_date   h01_holding_summary.h01_date%TYPE;
    PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
    SELECT MAX (h01_date)
      INTO l_date
      FROM dfn_ntp.h01_holding_summary h01
     WHERE     h01.h01_trading_acnt_id_u07 = p_h01_trading_acnt_id_u07
           AND h01.h01_date <= p_h01_date
          -- AND h01.h01_exchange_code_m01 = p_h01_exchange_code_m01
           AND h01.h01_symbol_id_m20 = p_h01_symbol_id_m20
           AND h01.h01_custodian_id_m26 = p_h01_custodian_id_m26;

    RETURN l_date;
END;
/