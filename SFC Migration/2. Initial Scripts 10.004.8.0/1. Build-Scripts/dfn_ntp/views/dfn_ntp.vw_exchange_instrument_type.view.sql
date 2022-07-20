CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_exchange_instrument_type
(
    m125_id,
    m125_exchange_code_m01,
    m125_exchange_id_m01,
    m125_institute_id_m02,
    m125_instrument_type_id_v09,
    m125_min_broker_commission,
    m125_is_online,
    dma_online,
    m125_created_by_id_u17,
    m125_created_date,
    m125_modified_by_id_u17,
    m125_modified_date,
    m125_is_subscription_allowed,
    subscription_allowed,
    m125_allow_sell_unsettle_hold,
    sell_unsettled_holdings,
    exchange_instrument_type,
    m125_board_code_m54,
    m125_board_id_m54
)
AS
    SELECT m125.m125_id,
           m125.m125_exchange_code_m01,
           m125.m125_exchange_id_m01,
           m01.m01_institute_id_m02 AS m125_institute_id_m02,
           m125.m125_instrument_type_id_v09,
           m125.m125_min_broker_commission,
           m125.m125_is_online,
           CASE m125.m125_is_online WHEN 0 THEN 'No' WHEN 1 THEN 'Yes' END
               AS dma_online,
           m125.m125_created_by_id_u17,
           m125.m125_created_date,
           m125.m125_modified_by_id_u17,
           m125.m125_modified_date,
           m125.m125_is_subscription_allowed,
           CASE m125.m125_is_subscription_allowed
               WHEN 0 THEN 'No'
               WHEN 1 THEN 'Yes'
           END
               AS subscription_allowed,
           m125.m125_allow_sell_unsettle_hold,
           CASE m125.m125_allow_sell_unsettle_hold
               WHEN 0 THEN 'No'
               WHEN 1 THEN 'Yes'
           END
               AS sell_unsettled_holdings,
           v09.v09_description AS exchange_instrument_type,
           m125.m125_board_code_m54,
           m125.m125_board_id_m54
      FROM m125_exchange_instrument_type m125
           INNER JOIN m01_exchanges m01
               ON m125.m125_exchange_id_m01 = m01.m01_id
           LEFT JOIN v09_instrument_types v09
               ON m125.m125_instrument_type_id_v09 = v09.v09_id
/