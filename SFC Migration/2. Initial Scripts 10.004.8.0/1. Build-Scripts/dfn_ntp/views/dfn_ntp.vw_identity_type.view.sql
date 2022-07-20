CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_identity_type
(
    m15_id,
    m15_name,
    m15_name_lang,
    m15_account_frozen_type,
    account_frozen_type,
    m15_frozen_days,
    m15_applicable_acc_type_id_v01,
    applicable_acc_type,
    m15_id_number_length,
    m15_created_by_id_u17,
    created_by_full_name,
    m15_created_date,
    m15_status_id_v01,
    status_description,
    status_description_lang,
    m15_modified_by_id_u17,
    modified_by_full_name,
    m15_modified_date,
    m15_status_changed_by_id_u17,
    status_changed_by_full_name,
    m15_status_changed_date,
    m15_external_ref
)
AS
    SELECT m15_id,
           m15_name,
           m15_name_lang,
           m15_account_frozen_type,
           CASE m15.m15_account_frozen_type
               WHEN 0 THEN ' '
               WHEN 1 THEN 'No'
               WHEN 2 THEN 'Yes, on Expiry Date'
               WHEN 3 THEN 'Yes, after the Expiry Date'
           END
               AS account_frozen_type,
           m15_frozen_days,
           m15_applicable_acc_type_id_v01,
           CASE m15.m15_applicable_acc_type_id_v01
               WHEN 1 THEN 'Individual'
               WHEN 2 THEN 'Corporate'
               WHEN 3 THEN 'Both'
           END
               AS applicable_acc_type,
           m15.m15_id_number_length,
           m15_created_by_id_u17,
           u17_created_by.u17_full_name AS created_by_full_name,
           m15_created_date,
           m15_status_id_v01,
           status_list.v01_description AS status_description,
           status_list.v01_description_lang AS status_description_lang,
           m15_modified_by_id_u17,
           u17_modified_by.u17_full_name AS modified_by_full_name,
           m15_modified_date,
           m15_status_changed_by_id_u17,
           u17_status_changed_by.u17_full_name AS status_changed_by_full_name,
           m15_status_changed_date,
           m15_external_ref
      FROM m15_identity_type m15
           JOIN u17_employee u17_created_by
               ON m15.m15_created_by_id_u17 = u17_created_by.u17_id
           LEFT JOIN u17_employee u17_modified_by
               ON m15.m15_modified_by_id_u17 = u17_modified_by.u17_id
           JOIN u17_employee u17_status_changed_by
               ON m15.m15_status_changed_by_id_u17 =
                      u17_status_changed_by.u17_id
           LEFT JOIN vw_status_list status_list
               ON m15.m15_status_id_v01 = status_list.v01_id;
/
