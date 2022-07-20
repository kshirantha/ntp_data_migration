CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_m142_corp_hold_adjustment
(
    m142_id,
    m142_cust_corp_act_id_m141,
    m142_type,
    m142_exchange_id_m01,
    m142_exchange_code_m01,
    m142_symbol_id_m20,
    m142_symbol_code_m20,
    m142_from_ratio,
    m142_to_ratio,
    ratio,
    m142_old_par_value,
    m142_new_par_value,
    par_value_ratio,
    m142_narration,
    m142_adj_mode,
    m142_impact_quantity,
    symbol_name,
    instrument_type,
    isin_code,
    last_trade_price,
    currency,
    adj_type,
    adj_mode
)
AS
    SELECT m142.m142_id,
           m142.m142_cust_corp_act_id_m141,
           m142.m142_type,
           m142.m142_exchange_id_m01,
           m142.m142_exchange_code_m01,
           m142.m142_symbol_id_m20,
           m142.m142_symbol_code_m20,
           m142.m142_from_ratio,
           m142.m142_to_ratio,
           m142.m142_from_ratio || ':' || m142.m142_to_ratio AS ratio,
           m142.m142_old_par_value,
           m142.m142_new_par_value,
           m142.m142_old_par_value || ':' || m142.m142_new_par_value
               AS par_value_ratio,
           m142.m142_narration,
           m142.m142_adj_mode,
           m142.m142_impact_quantity,
           m20.m20_short_description AS symbol_name,
           m20.m20_instrument_type_code_v09 AS instrument_type,
           m20.m20_isincode AS isin_code,
           m20.m20_lasttradeprice AS last_trade_price,
           m20.m20_currency_code_m03 AS currency,
           CASE
               WHEN m142_type = 1 THEN 'Base Symbol Holdings Adjustment'
               WHEN m142_type = 2 THEN 'Symbol Holdings Payment'
           END
               AS adj_type,
           CASE
               WHEN m142_adj_mode = 1 THEN 'Pay'
               WHEN m142_adj_mode = 2 THEN 'Deduct'
           END
               AS adj_mode
      FROM m142_corp_act_hold_adjustments m142
           JOIN m20_symbol m20 ON m142.m142_symbol_id_m20 = m20.m20_id
/