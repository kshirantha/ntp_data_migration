CREATE OR REPLACE PROCEDURE dfn_ntp.sp_arc_set_h01_prepare_archive (
    pdate IN DATE)
IS
BEGIN
    FOR i IN (  SELECT h01_trading_acnt_id_u07,
                       h01_exchange_code_m01,
                       h01_symbol_id_m20,
                       MAX (h01_date) AS h01_date,
                       h01_custodian_id_m26
                  FROM h01_holding_summary
                 WHERE h01_date <= TRUNC (pdate) + 0.99999
              GROUP BY h01_trading_acnt_id_u07,
                       h01_exchange_code_m01,
                       h01_symbol_id_m20,
                       h01_custodian_id_m26)
    LOOP
        UPDATE h01_holding_summary
           SET h01_is_archive_ready = 1
         WHERE     h01_trading_acnt_id_u07 = i.h01_trading_acnt_id_u07
               AND h01_exchange_code_m01 = i.h01_exchange_code_m01
               AND h01_symbol_id_m20 = i.h01_symbol_id_m20
               AND h01_custodian_id_m26 = i.h01_custodian_id_m26
               AND h01_date < i.h01_date;
    END LOOP;
END;
/