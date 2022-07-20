CREATE OR REPLACE FORCE VIEW dfn_ntp.beneficiary_account_list
(
    u08_id,
    u08_institute_id_m02,
    u08_customer_id_u01,
    u08_bank_id_m16,
    u08_bank_branch_name,
    bank_name,
    bank_name_lang,
    u08_account_no,
    u08_account_type_v01_id,
    account_type,
    u08_bank_account_type_v01,
    bank_account_type,
    u08_currency_code_m03,
    u08_account_name,
    u06_display_name,
    u08_is_default,
    is_default,
    u08_created_by_id_u17,
    u08_created_date,
    u08_status_id_v01,
    u08_iban_no,
    u08_modified_by_id_u17,
    u08_modified_date,
    u08_status_changed_by_id_u17,
    u08_status_changed_date,
    u08_currency_id_m03,
    u08_cash_account_id_u06,
    u08_account_id,
    u08_is_foreign_bank_acc,
    is_foreign_bank_acc,
    u06_id,
    u06_balance,
    u06_blocked,
    u06_primary_od_limit,
    created_by_name,
    status,
    modified_by_name,
    status_changed_by_name
)
AS
    SELECT u08.u08_id,
           u08.u08_institute_id_m02,
           u08.u08_customer_id_u01,
           u08.u08_bank_id_m16,
           u08.u08_bank_branch_name,
           m16.m16_name AS bank_name,
           m16.m16_name_lang AS bank_name_lang,
           CASE
               WHEN ben_cash_ac.u06_id IS NULL THEN u08.u08_account_no
               ELSE ben_cash_ac.u06_display_name
           END
               AS u08_account_no,
           u08.u08_account_type_v01_id,
           CASE u08_account_type_v01_id
               WHEN 1 THEN 'SFC'
               WHEN 2 THEN 'BSF'
               WHEN 3 THEN 'Other'
           END
               AS account_type,
           u08.u08_bank_account_type_v01,
           CASE u08_bank_account_type_v01
               WHEN 1 THEN 'Current'
               WHEN 2 THEN 'Saving'
               WHEN 3 THEN 'Investment'
           END
               AS bank_account_type,
           u08.u08_currency_code_m03,
           u08.u08_account_name,
           ben_of.u06_display_name,
           u08.u08_is_default,
           CASE u08.u08_is_default WHEN 1 THEN 'Yes' ELSE 'No' END
               AS is_default,
           u08.u08_created_by_id_u17,
           u08.u08_created_date,
           u08.u08_status_id_v01,
           u08.u08_iban_no,
           u08.u08_modified_by_id_u17,
           u08.u08_modified_date,
           u08.u08_status_changed_by_id_u17,
           u08.u08_status_changed_date,
           u08.u08_currency_id_m03,
           u08.u08_cash_account_id_u06,
           u08.u08_account_id,
           u08.u08_is_foreign_bank_acc,
           CASE WHEN u08.u08_is_foreign_bank_acc = 1 THEN 'YES' ELSE 'NO' END
               AS is_foreign_bank_acc,
           ben_of.u06_id,
           ben_of.u06_balance,
           ben_of.u06_blocked,
           ben_of.u06_primary_od_limit,
           created_by.u17_full_name AS created_by_name,
           status.v01_description AS status,
           modified_by.u17_full_name AS modified_by_name,
           status_changed_by.u17_full_name AS status_changed_by_name
      FROM u08_customer_beneficiary_acc u08
           LEFT JOIN m16_bank m16 ON u08.u08_bank_id_m16 = m16.m16_id
           LEFT JOIN u06_cash_account ben_of
               ON u08.u08_cash_account_id_u06 = ben_of.u06_id
           LEFT JOIN u06_cash_account ben_cash_ac
               ON u08.u08_account_id = ben_cash_ac.u06_id
           INNER JOIN u17_employee created_by
               ON u08.u08_created_by_id_u17 = created_by.u17_id
           LEFT JOIN u17_employee modified_by
               ON u08.u08_modified_by_id_u17 = modified_by.u17_id
           LEFT JOIN u17_employee status_changed_by
               ON u08.u08_status_changed_by_id_u17 = status_changed_by.u17_id
           LEFT JOIN vw_status_list status
               ON u08.u08_status_id_v01 = status.v01_id
/
