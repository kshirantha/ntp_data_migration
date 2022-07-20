CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_m132_mkt_maker_grp_details
(
  M132_ID, M132_MARKET_MAKER_GRP_ID_M131, M132_EXCHANGE_ID_M01, M132_EXCHANGE_CODE_M01, 
  M132_SYMBOL_ID_M20, M132_SYMBOL_CODE_M20, M132_TRADER_ID, M132_CREATED_BY_ID_U17, 
  CREATED_BY_NAME, M132_CREATED_DATE, M132_MODIFIED_BY_ID_U17, MODIFIED_BY_NAME, 
  M132_MODIFIED_DATE
)
AS 
SELECT m132.m132_id,
       m132.m132_market_maker_grp_id_m131,
       m132.m132_exchange_id_m01,
       m132.m132_exchange_code_m01,
       m132.m132_symbol_id_m20,
       m132.m132_symbol_code_m20,
       m132.m132_trader_id,
       m132.m132_created_by_id_u17,
       u17_created_by.u17_full_name AS created_by_name,
       m132.m132_created_date,
       m132.m132_modified_by_id_u17,
       u17_modified_by.u17_full_name AS modified_by_name,
       m132.m132_modified_date
  FROM     m132_market_maker_grp_details m132
       LEFT JOIN
           u17_employee u17_created_by
           ON m132.m132_created_by_id_u17 = u17_created_by.u17_id
       LEFT JOIN u17_employee u17_modified_by
           ON m132.m132_modified_by_id_u17 = u17_modified_by.u17_id
/