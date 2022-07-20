CREATE OR REPLACE VIEW dfn_ntp.vw_institution_txn_codes
(
    m98_id,
    m98_transaction_code_id_m97,
    m98_transaction_code_m97,
    m98_txn_code_description_m97,
    m98_b2b_enabled,
    m98_b2b_enabled_desc,
    m98_statement,
    m98_statement_desc,
    m98_institution_id_m02,
    m98_created_by_id_u17,
    u17_created_by,
    m98_created_date,
    m98_modified_by_id_u17,
    u17_modified_by,
    m98_modified_date,
    m98_status_id_v01,
    v01_description,
    m98_status_changed_by_id_u17,
    u17_status_changed_by,
    m98_status_changed_date
)
AS
    SELECT m98.m98_id,
           m98.m98_transaction_code_id_m97,
           m98.m98_transaction_code_m97,
           m98.m98_txn_code_description_m97,
           m98.m98_b2b_enabled,
           DECODE (m98.m98_b2b_enabled, 1, 'Yes', 'No')
               AS m98_b2b_enabled_desc,
           m98.m98_statement,
           DECODE (m98.m98_statement, 1, 'Yes', 'No') AS m98_statement_desc,
           m98.m98_institution_id_m02,
           m98.m98_created_by_id_u17,
           u17_created.u17_full_name AS u17_created_by,
           m98.m98_created_date,
           m98.m98_modified_by_id_u17,
           u17_modified.u17_full_name AS u17_modified_by,
           m98.m98_modified_date,
           m98.m98_status_id_v01,
           status_list.v01_description,
           m98.m98_status_changed_by_id_u17,
           u17_status_changed.u17_full_name AS u17_status_changed_by,
           m98.m98_status_changed_date
      FROM m98_institution_txn_codes m98
           JOIN u17_employee u17_created
               ON m98.m98_created_by_id_u17 = u17_created.u17_id
           JOIN vw_status_list status_list
               ON m98.m98_status_id_v01 = status_list.v01_id
           LEFT JOIN u17_employee u17_modified
               ON m98.m98_modified_by_id_u17 = u17_modified.u17_id
           LEFT JOIN u17_employee u17_status_changed
               ON m98.m98_status_changed_by_id_u17 =
                      u17_status_changed.u17_id
/