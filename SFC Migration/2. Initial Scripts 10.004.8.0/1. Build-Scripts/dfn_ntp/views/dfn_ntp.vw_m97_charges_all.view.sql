CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_m97_charges_all
(
    m97_id,
    m97_code,
    m97_description,
    m97_description_lang,
    m97_category,
    m97_category_desc,
    m97_b2b_enabled,
    m97_b2b_enabled_desc,
    m97_visible,
    m97_visible_desc,
    m97_statement,
    m97_statement_desc,
    m97_charge_type,
    m97_charge_type_desc,
    m97_created_by_id_u17,
    u17_created_by,
    m97_created_date,
    m97_modified_by_id_u17,
    u17_modified_by,
    m97_modified_date,
    m97_status_id_v01,
    v01_description,
    m97_status_changed_by_id_u17,
    u17_status_changed_by,
    m97_status_changed_date,
    m97_txn_impact_type
)
AS
    SELECT m97.m97_id,
           m97.m97_code,
           m97.m97_description,
           m97.m97_description_lang,
           m97.m97_category,
           DECODE (m97.m97_category,  1, 'Charge',  2, 'Refund')
               AS m97_category_desc,
           m97.m97_b2b_enabled,
           DECODE (m97.m97_b2b_enabled, 1, 'Yes', 'No')
               AS m97_b2b_enabled_desc,
           m97.m97_visible,
           DECODE (m97.m97_visible, 1, 'Yes', 'No') AS m97_visible_desc,
           m97.m97_statement,
           DECODE (m97.m97_statement, 1, 'Yes', 'No') AS m97_statement_desc,
           m97.m97_charge_type,
           DECODE (m97.m97_charge_type,
                   0, 'None',
                   1, 'Broker Only',
                   2, 'Exchange and Broker Both',
                   3, 'Interest Charge')
               AS m97_charge_type_desc,
           m97.m97_created_by_id_u17,
           u17_created.u17_full_name AS u17_created_by,
           m97.m97_created_date,
           m97.m97_modified_by_id_u17,
           u17_modified.u17_full_name AS u17_modified_by,
           m97.m97_modified_date,
           m97.m97_status_id_v01,
           status_list.v01_description,
           m97.m97_status_changed_by_id_u17,
           u17_status_changed.u17_full_name AS u17_status_changed_by,
           m97.m97_status_changed_date,
           m97.m97_txn_impact_type
      FROM m97_transaction_codes m97
           JOIN u17_employee u17_created
               ON m97.m97_created_by_id_u17 = u17_created.u17_id
           JOIN vw_status_list status_list
               ON m97.m97_status_id_v01 = status_list.v01_id
           LEFT JOIN u17_employee u17_modified
               ON m97.m97_modified_by_id_u17 = u17_modified.u17_id
           LEFT JOIN u17_employee u17_status_changed
               ON m97.m97_status_changed_by_id_u17 =
                      u17_status_changed.u17_id
/