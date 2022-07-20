CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_u28_employee_exchanges
(
    u28_id,
    u28_exchange_code_m01,
    u28_exchange_id_m01,
    u28_employee_id_u17,
    u28_created_by_id_u17,
    u28_created_date,
    u28_modified_by_id_u17,
    u28_modified_date,
    u28_status_id_v01,
    u28_status_changed_by_id_u17,
    u28_status_changed_date,
    u28_dealer_exchange_code,
    u28_price_subscribed,
    u28_market_id_m29,
    m29_market_code
)
AS
    SELECT u28.u28_id,
           u28.u28_exchange_code_m01,
           u28.u28_exchange_id_m01,
           u28_employee_id_u17,
           u28.u28_created_by_id_u17,
           u28_created_date,
           u28.u28_modified_by_id_u17,
           u28_modified_date,
           u28.u28_status_id_v01,
           u28_status_changed_by_id_u17,
           u28.u28_status_changed_date,
           u28_dealer_exchange_code,
           u28.u28_price_subscribed,
           u28_market_id_m29,
           m29.m29_market_code
      FROM u28_employee_exchanges u28
           JOIN m29_markets m29 ON u28.u28_market_id_m29 = m29.m29_id
/