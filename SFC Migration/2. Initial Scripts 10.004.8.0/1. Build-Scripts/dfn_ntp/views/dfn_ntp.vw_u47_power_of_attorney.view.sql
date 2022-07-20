CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_u47_power_of_attorney
(
    u47_id,
    u47_customer_id_u01,
    u47_poa_customer_id_u01,
    u47_zip,
    u47_po_box,
    u47_street_address_1,
    u47_street_address_2,
    address,
    u47_city_id_m06,
    u47_country_id_m05,
    u47_nationality_id_m05,
    u47_id_type_m15,
    u47_poa_type,
    u47_bank_acc_no,
    u47_created_by_id_u17,
    u47_created_date,
    u47_modified_by_id_u17,
    u47_modified_date,
    u47_status_id_v01,
    u47_status_changed_by_id_u17,
    u47_status_changed_date,
    u47_custom_type,
    u47_institute_id_m02,
    approvalstatus,
    created_by,
    modified_by,
    status_changed_by,
    u47_poa_name,
    u47_id_no,
    u47_id_expiry_date,
    u47_contact_no,
    m06_name,
    u01_customer_no,
    u01_display_name
)
AS
    SELECT a.u47_id,
           a.u47_customer_id_u01,
           a.u47_poa_customer_id_u01,
           a.u47_zip,
           a.u47_po_box,
           a.u47_street_address_1,
           a.u47_street_address_2,
              a.u47_street_address_1
           || NVL2 (a.u47_street_address_2, ', ' || u47_street_address_2, '')
               AS address,
           a.u47_city_id_m06,
           a.u47_country_id_m05,
           a.u47_nationality_id_m05,
           a.u47_id_type_m15,
           a.u47_poa_type,
           a.u47_bank_acc_no,
           a.u47_created_by_id_u17,
           a.u47_created_date,
           a.u47_modified_by_id_u17,
           a.u47_modified_date,
           a.u47_status_id_v01,
           a.u47_status_changed_by_id_u17,
           a.u47_status_changed_date,
           a.u47_custom_type,
           a.u47_institute_id_m02,
           status_list.v01_description AS approvalstatus,
           u17_created_by.u17_full_name AS created_by,
           u17_modified_by.u17_full_name AS modified_by,
           u17_status_changed_by.u17_full_name AS status_changed_by,
           CASE
               WHEN u47_poa_customer_id_u01 IS NULL THEN u47_poa_name
               ELSE u01_full_name
           END
               AS u47_poa_name,
           CASE
               WHEN u47_poa_customer_id_u01 IS NULL THEN u47_id_no
               ELSE u01_default_id_no
           END
               AS u47_id_no,
           CASE
               WHEN u47_poa_customer_id_u01 IS NULL THEN a.u47_id_expiry_date
               ELSE u05.u05_expiry_date
           END
               AS u47_id_expiry_date,
           CASE
               WHEN u47_poa_customer_id_u01 IS NULL THEN u47_contact_no
               ELSE u01_def_mobile
           END
               AS u47_contact_no,
           m06.m06_name,
           u01.u01_customer_no,
           u01.u01_display_name
      FROM u47_power_of_attorney a
           LEFT OUTER JOIN u01_customer u01
               ON u47_customer_id_u01 = u01_id
           LEFT OUTER JOIN u05_customer_identification u05
               ON u01_id = u05.u05_customer_id_u01 AND u05_is_default = 1
           JOIN u17_employee u17_created_by
               ON a.u47_created_by_id_u17 = u17_created_by.u17_id
           LEFT JOIN u17_employee u17_modified_by
               ON a.u47_modified_by_id_u17 = u17_modified_by.u17_id
           JOIN u17_employee u17_status_changed_by
               ON a.u47_status_changed_by_id_u17 =
                      u17_status_changed_by.u17_id
           LEFT JOIN vw_status_list status_list
               ON a.u47_status_id_v01 = status_list.v01_id
           LEFT JOIN m06_city m06
               ON u47_city_id_m06 = m06.m06_id
/