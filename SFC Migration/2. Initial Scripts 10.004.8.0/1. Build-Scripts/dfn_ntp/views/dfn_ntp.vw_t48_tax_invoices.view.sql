CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_t48_tax_invoices
(
    t48_id,
    t48_invoice_no,
    t48_customer_id_u01,
    u01_customer_no,
    u01_display_name,
    u01_display_name_lang,
    u01_preferred_lang_id_v01,
    preferred_ln,
    preferred_ln_lang,
    t48_from_date,
    t48_to_date,
    t48_txn_code,
    t48_issue_date,
    transaction_type,
    transaction_type_lang,
    u01_external_ref_no,
    t48_institute_id_m02
)
AS
    SELECT t48.t48_id,
           t48.t48_invoice_no,
           t48.t48_customer_id_u01,
           u01.u01_customer_no,
           u01.u01_display_name,
           u01.u01_display_name_lang,
           u01.u01_preferred_lang_id_v01,
           v01.v01_description AS preferred_ln,
           v01.v01_description_lang AS preferred_ln_lang,
           t48.t48_from_date,
           t48.t48_to_date,
           t48.t48_txn_code,
           t48.t48_issue_date,
           CASE t48.t48_txn_code
               WHEN 'ALL' THEN 'ALL'
               ELSE m97.m97_description
           END
               AS transaction_type,
           CASE t48.t48_txn_code
               WHEN 'ALL' THEN 'ALL'
               ELSE m97.m97_description_lang
           END
               AS transaction_type_lang,
           u01.u01_external_ref_no,
           t48.t48_institute_id_m02
      FROM t48_tax_invoices t48
           LEFT JOIN u01_customer u01
               ON t48.t48_customer_id_u01 = u01.u01_id
           LEFT JOIN (SELECT v01_id, v01_description, v01_description_lang
                        FROM v01_system_master_data
                       WHERE v01_type = 14) v01
               ON u01.u01_preferred_lang_id_v01 = v01.v01_id
           LEFT JOIN m97_transaction_codes m97
               ON t48.t48_txn_code = m97.m97_code
     WHERE t48.t48_eom_report = 0
/
