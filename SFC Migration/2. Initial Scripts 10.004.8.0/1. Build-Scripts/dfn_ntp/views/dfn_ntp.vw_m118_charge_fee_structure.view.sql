CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_m118_charge_fee_structure
(
    m118_id,
    m118_currency_id_m03,
    m118_currency_code_m03,
    m118_exchange_id_m01,
    m118_exchange_code_m01,
    m118_charge_code_m97,
    fee_type_description,
    m118_broker_fee,
    m118_exchange_fee,
    m118_broker_vat,
    m118_exchange_vat,
    m97_charge_type,
    m97_code,
    m97_category,
    m118_group_id_m117,
    m118_interest_rate
)
AS
    (SELECT m118.m118_id,
            m118.m118_currency_id_m03,
            m118.m118_currency_code_m03,
            m118.m118_exchange_id_m01,
            m118.m118_exchange_code_m01,
            m118.m118_charge_code_m97,
            m97.m97_description AS fee_type_description,
            m118.m118_broker_fee,
            m118.m118_exchange_fee,
            m118.m118_broker_vat,
            m118.m118_exchange_vat,
            m97.m97_charge_type,
            m97.m97_code,
            m97.m97_category,
            m118.m118_group_id_m117,
            m118.m118_interest_rate
     FROM vw_m97_cash_txn_codes_base m97, m118_charge_fee_structure m118
     WHERE m118.m118_charge_code_m97 = m97.m97_code)
/