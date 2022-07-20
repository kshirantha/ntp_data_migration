CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_u48_corp_contact_list
(
    u48_id,
    u48_customer_id_u01,
    u48_date_of_birth,
    u48_email,
    u48_fax,
    u48_is_default,
    is_default,
    u48_mobile,
    u48_name,
    u48_position,
    u48_telephone,
    u48_title_id_v01,
    u48_created_by_id_u17,
    created_by_full_name,
    u48_created_date,
    u48_modified_by_id_u17,
    modified_by_full_name,
    u48_modified_date,
    u48_status_id_v01,
    status,
    status_lang,
    u48_status_changed_by_id_u17,
    status_changed_by_full_name
)
AS
    SELECT u48_id,
           u48_customer_id_u01,
           u48_date_of_birth,
           u48_email,
           u48_fax,
           u48_is_default,
           CASE WHEN u48_is_default = 1 THEN 'Yes' ELSE 'No' END
               AS is_default,
           u48_mobile,
           u48_name,
           u48_position,
           u48_telephone,
           u48_title_id_v01,
           u48_created_by_id_u17,
           u17_created_by.u17_full_name AS created_by_full_name,
           u48_created_date,
           u48_modified_by_id_u17,
           u17_modified_by.u17_full_name AS modified_by_full_name,
           u48_modified_date,
           u48_status_id_v01,
           status_list.v01_description AS status,
           status_list.v01_description_lang AS status_lang,
           u48_status_changed_by_id_u17,
           u17_status_changed_by.u17_full_name AS status_changed_by_full_name
      FROM u48_corp_customer_contact u48
           JOIN u17_employee u17_created_by
               ON u48.u48_created_by_id_u17 = u17_created_by.u17_id
           LEFT JOIN u17_employee u17_modified_by
               ON u48.u48_modified_by_id_u17 = u17_modified_by.u17_id
           JOIN u17_employee u17_status_changed_by
               ON u48.u48_status_changed_by_id_u17 =
                      u17_status_changed_by.u17_id
           LEFT JOIN vw_status_list status_list
               ON u48.u48_status_id_v01 = status_list.v01_id;
/
