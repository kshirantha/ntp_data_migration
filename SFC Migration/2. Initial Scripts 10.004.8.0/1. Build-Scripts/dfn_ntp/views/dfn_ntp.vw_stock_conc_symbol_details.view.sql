CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_stock_conc_symbol_details
(
    m76_id,
    m76_stock_conc_grp_id_m75,
    m76_symbol_code_m20,
    m76_symbol_id_m20,
    m76_percentage,
    m76_sell_allowed,
    m76_buy_allowed,
    m76_exchange_id_m01,
    m76_exchange_code_m01,
    m76_created_by_id_u17,
    created_by_full_name,
    m76_created_date,
    m76_modified_by_id_u17,
    modified_by_full_name,
    m76_modified_date
)
AS
    SELECT a.m76_id,
           a.m76_stock_conc_grp_id_m75,
           a.m76_symbol_code_m20,
           a.m76_symbol_id_m20,
           a.m76_percentage,
           a.m76_sell_allowed,
           a.m76_buy_allowed,
           a.m76_exchange_id_m01,
           a.m76_exchange_code_m01,
           a.m76_created_by_id_u17,
           u17_created_by.u17_full_name AS created_by_full_name,
           a.m76_created_date,
           a.m76_modified_by_id_u17,
           u17_modified_by.u17_full_name AS modified_by_full_name,
           a.m76_modified_date
      FROM m76_stock_conc_symbol_details a
           LEFT JOIN u17_employee u17_created_by
               ON a.m76_created_by_id_u17 = u17_created_by.u17_id
           LEFT JOIN u17_employee u17_modified_by
               ON a.m76_modified_by_id_u17 = u17_modified_by.u17_id
/