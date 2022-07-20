CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_m97_cash_txn_codes_base
(
    m97_id,
    m97_code,
    m97_description,
    m97_description_lang,
    m97_category,
    m97_b2b_enabled,
    m97_visible,
    m97_statement,
    m97_charge_type,
    m97_created_by_id_u17,
    m97_created_date,
    m97_modified_by_id_u17,
    m97_modified_date,
    m97_status_id_v01,
    m97_status_changed_by_id_u17,
    m97_status_changed_date,
    m97_txn_impact_type
)
AS
    SELECT a.m97_id,
           a.m97_code,
           a.m97_description,
           a.m97_description_lang,
           a.m97_category,
           a.m97_b2b_enabled,
           a.m97_visible,
           a.m97_statement,
           a.m97_charge_type,
           a.m97_created_by_id_u17,
           a.m97_created_date,
           a.m97_modified_by_id_u17,
           a.m97_modified_date,
           a.m97_status_id_v01,
           a.m97_status_changed_by_id_u17,
           a.m97_status_changed_date,
           m97_txn_impact_type
      FROM m97_transaction_codes a
     WHERE m97_txn_impact_type IN (1, 2);
/
