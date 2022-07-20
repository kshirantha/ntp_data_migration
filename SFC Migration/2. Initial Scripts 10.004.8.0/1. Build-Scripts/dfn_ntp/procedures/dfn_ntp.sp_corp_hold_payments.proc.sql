CREATE OR REPLACE PROCEDURE dfn_ntp.sp_corp_hold_payments (
    p_view         OUT SYS_REFCURSOR,
    prows          OUT NUMBER,
    pm141_id           NUMBER,
    pinstitution       NUMBER)
IS
    lcount    NUMBER;
    lformat   VARCHAR (100);
BEGIN
    OPEN p_view FOR
        SELECT m142.m142_id,
               m142.m142_cust_corp_act_id_m141,
               m142.m142_type,
               m142.m142_exchange_id_m01,
               m142.m142_exchange_code_m01,
               m142.m142_symbol_id_m20,
               m142.m142_symbol_code_m20,
               m142.m142_from_ratio,
               m142.m142_to_ratio,
               m142.m142_old_par_value,
               m142.m142_new_par_value,
               m142.m142_narration,
               m142.m142_adj_mode,
               m142.m142_impact_quantity,
               m20.m20_short_description AS symbol_name,
               m20.m20_instrument_type_code_v09 AS instrument_type,
               m20.m20_isincode AS isin_code,
               m20.m20_lasttradeprice AS last_trade_price,
               m20.m20_currency_code_m03 AS currency
          FROM m142_corp_act_hold_adjustments m142
               JOIN m20_symbol m20 ON m142.m142_symbol_id_m20 = m20.m20_id
         WHERE m142.m142_cust_corp_act_id_m141 = pm141_id AND m142_type = 2;
END;
/