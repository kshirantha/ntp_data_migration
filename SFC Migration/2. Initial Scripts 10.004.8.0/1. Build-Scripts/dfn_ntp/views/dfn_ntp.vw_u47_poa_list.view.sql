CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_u47_poa_list
(
    u47_id,
    u47_customer_id_u01,
    u01_customer_no,
    u01_full_name,
    u47_poa_customer_id_u01,
    poa_category_id,
    poa_category_desc,
    u47_poa_name,
    u47_poa_name_lang,
    poa_customer_no,
    poa_account_type_id,
    poa_account_category_id,
    u47_zip,
    u47_po_box,
    u47_street_address_1,
    u47_street_address_2,
    u47_city_id_m06,
    u47_country_id_m05,
    u47_nationality_id_m05,
    u47_poa_type,
    u47_poa_type_desc,
    u47_id_type_m15,
    m15_name,
    u47_id_no,
    u47_id_expiry_date,
    u47_contact_no,
    u47_bank_acc_no,
    u47_created_by_id_u17,
    u17_created_by,
    u47_created_date,
    u47_modified_by_id_u17,
    u17_modified_by,
    u47_modified_date,
    u47_status_id_v01,
    v01_description,
    u47_status_changed_by_id_u17,
    u17_status_changed_by,
    u47_status_changed_date
)
AS
    SELECT u47.u47_id,
           u47.u47_customer_id_u01,
           u01.u01_customer_no,
           u01.u01_full_name,
           u01_poa.u01_id AS u47_poa_customer_id_u01,
           DECODE (u47.u47_poa_customer_id_u01, NULL, 1, 0)
               AS poa_category_id,
           DECODE (u47.u47_poa_customer_id_u01, NULL, 'External Party', 'Internal Customer')
               AS poa_category_desc,
           CASE
               WHEN u47.u47_poa_customer_id_u01 IS NOT NULL
               THEN
                   u01_poa.u01_full_name
               ELSE
                   u47.u47_poa_name
           END
               u47_poa_name,
           CASE
               WHEN u47.u47_poa_customer_id_u01 IS NOT NULL
               THEN
                   u01_poa.u01_full_name_lang
               ELSE
                   u47.u47_poa_name_lang
           END
               AS u47_poa_name_lang,
           u01_poa.u01_customer_no AS poa_customer_no,
           u01_poa.u01_account_type_id_v01 AS poa_account_type_id,
           u01_poa.u01_account_category_id_v01 AS poa_account_category_id,
           u47.u47_zip,
           u47.u47_po_box,
           u47.u47_street_address_1,
           u47.u47_street_address_2,
           u47.u47_city_id_m06,
           u47.u47_country_id_m05,
           u47.u47_nationality_id_m05,
           u47.u47_poa_type,
           DECODE (u47.u47_poa_type,
                   0, 'None',
                   1, 'Family',
                   2, 'Non-Family',
                   3, 'Guardian',
                   4, 'Guardian for Impaired')
               AS u47_poa_type_desc,
           u47.u47_id_type_m15,
           m15.m15_name,
           u47.u47_id_no,
           u47.u47_id_expiry_date,
           u47.u47_contact_no,
           u47.u47_bank_acc_no,
           u47.u47_created_by_id_u17,
           u17_created.u17_full_name AS u17_created_by,
           u47.u47_created_date,
           u47.u47_modified_by_id_u17,
           u17_modified.u17_full_name AS u17_modified_by,
           u47.u47_modified_date,
           u47.u47_status_id_v01,
           status_list.v01_description,
           u47.u47_status_changed_by_id_u17,
           u17_status_changed.u17_full_name AS u17_status_changed_by,
           u47.u47_status_changed_date
      FROM u47_power_of_attorney u47
           JOIN u01_customer u01
               ON u47.u47_customer_id_u01 = u01.u01_id
           JOIN u17_employee u17_created
               ON u47.u47_created_by_id_u17 = u17_created.u17_id
           JOIN vw_status_list status_list
               ON u47.u47_status_id_v01 = status_list.v01_id
           LEFT JOIN m15_identity_type m15
               ON u47.u47_id_type_m15 = m15.m15_id
           LEFT JOIN u01_customer u01_poa
               ON u47.u47_poa_customer_id_u01 = u01_poa.u01_id
           LEFT JOIN u17_employee u17_modified
               ON u47.u47_modified_by_id_u17 = u17_modified.u17_id
           LEFT JOIN u17_employee u17_status_changed
               ON u47.u47_status_changed_by_id_u17 =
                      u17_status_changed.u17_id;
/
