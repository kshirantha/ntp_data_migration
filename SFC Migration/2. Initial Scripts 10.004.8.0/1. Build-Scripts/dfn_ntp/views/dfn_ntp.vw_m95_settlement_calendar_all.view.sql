CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_m95_settlement_calendar_all
(
    m95_id,
    m95_settlement_name,
    m95_exchange_id_m01,
    exchange,
    m95_instrument_type_id_v09,
    instrument_type,
    m95_customer_settl_group_m35,
    settlement_group,
    m95_symbol_settle_category_v11,
    symbol_settlement_category,
    m95_default_buy_tplus,
    m95_default_sell_tplus,
    m95_default_buy_tplus_h,
    m95_default_sell_tplus_h,
    m95_settlement_year,
    m95_institution_id_m02,
    m95_board_code_m54,
    m54_id
)
AS
    SELECT m95.m95_id,
           m95.m95_settlement_name,
           m95.m95_exchange_id_m01,
           m01.m01_description AS exchange,
           m95.m95_instrument_type_id_v09,
           v09.v09_description AS instrument_type,
           m95.m95_customer_settl_group_m35,
           m35.m35_description AS settlement_group,
           m95.m95_symbol_settle_category_v11,
           v11.v11_description AS symbol_settlement_category,
           m95.m95_default_buy_tplus,
           m95.m95_default_sell_tplus,
           m95.m95_default_buy_tplus_h,
           m95.m95_default_sell_tplus_h,
           m95.m95_settlement_year,
           m95.m95_institution_id_m02,
           m95.m95_board_code_m54,
           m54.m54_id
      FROM m95_settlement_calendar_config m95
           JOIN m01_exchanges m01
               ON m95.m95_exchange_id_m01 = m01.m01_id
           LEFT JOIN v09_instrument_types v09
               ON m95.m95_instrument_type_id_v09 = v09.v09_id
           JOIN m35_customer_settl_group m35
               ON m95.m95_customer_settl_group_m35 = m35.m35_id
           JOIN v11_symbol_settle_category v11
               ON m95.m95_symbol_settle_category_v11 = v11.v11_id
           LEFT JOIN m54_boards m54
               ON     m95.m95_board_code_m54 = m54.m54_code
                  AND m95.m95_exchange_id_m01 = m54.m54_exchange_id_m01
/