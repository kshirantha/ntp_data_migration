CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_beneficiary_accounts
(
    u08_id,
    u08_institute_id_m02,
    u08_customer_id_u01,
    u08_bank_id_m16,
    u08_account_no,
    u08_account_type_v01_id,
    u08_currency_code_m03,
    u08_account_name,
    u08_is_default,
    u08_created_by_id_u17,
    u08_created_date,
    u08_status_id_v01,
    u08_bank_branch_name,
    u08_iban_no,
    u08_modified_by_id_u17,
    u08_modified_date,
    u08_status_changed_by_id_u17,
    u08_status_changed_date,
    u08_currency_id_m03,
    u08_cash_account_id_u06,
    u08_account_id,
    u06_id,
    u06_balance,
    u06_blocked,
    u06_primary_od_limit
)
AS
    SELECT u08.u08_id,
           u08.u08_institute_id_m02,
           u08.u08_customer_id_u01,
           u08.u08_bank_id_m16,
           u08.u08_account_no,
           u08.u08_account_type_v01_id,
           u08.u08_currency_code_m03,
           u08.u08_account_name,
           u08.u08_is_default,
           u08.u08_created_by_id_u17,
           u08.u08_created_date,
           u08.u08_status_id_v01,
           u08.u08_bank_branch_name,
           u08.u08_iban_no,
           u08.u08_modified_by_id_u17,
           u08.u08_modified_date,
           u08.u08_status_changed_by_id_u17,
           u08.u08_status_changed_date,
           u08.u08_currency_id_m03,
           u08.u08_cash_account_id_u06,
           u08.u08_account_id,
           u06.u06_id,
           u06.u06_balance,
           u06.u06_blocked,
           u06.u06_primary_od_limit
      FROM     u08_customer_beneficiary_acc u08
           LEFT OUTER JOIN
               u06_cash_account u06
           ON u08.u08_account_id = u06.u06_id;
/
