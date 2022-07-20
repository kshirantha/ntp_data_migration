CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_notification_configuration
(
    u41_id,
    u41_institution_id_m02,
    u41_notification_type_id_m100,
    notification_type,
    u41_status_id_v01,
    status_description,
    status_description_lang,
    u41_modified_by_id_u17,
    modified_by_full_name,
    u41_notify_sms_cc_list,
    u41_notify_email_cc_list,
    u41_modified_date,
    u41_created_by_id_u17,
    created_by_full_name,
    u41_created_date,
    u41_status_changed_by_id_u17,
    status_changed_by_full_name,
    u41_status_changed_date
)
AS
    SELECT u41.u41_id,
           u41.u41_institution_id_m02,
           u41.u41_notification_type_id_m100,
           m100.m100_description AS notification_type,
           u41.u41_status_id_v01,
           status_list.v01_description AS status_description,
           status_list.v01_description_lang AS status_description_lang,
           u41.u41_modified_by_id_u17,
           u17_modified_by.u17_full_name AS modified_by_full_name,
           u41.u41_notify_sms_cc_list,
           u41.u41_notify_email_cc_list,
           u41.u41_modified_date,
           u41.u41_created_by_id_u17,
           u17_created_by.u17_full_name AS created_by_full_name,
           u41.u41_created_date,
           u41.u41_status_changed_by_id_u17,
           u17_status_changed_by.u17_full_name AS status_changed_by_full_name,
           u41.u41_status_changed_date
      FROM u41_notification_configuration u41
           JOIN m100_notification_sub_items m100
               ON u41.u41_notification_type_id_m100 = m100.m100_id
           LEFT JOIN u17_employee u17_modified_by
               ON u41.u41_modified_by_id_u17 = u17_modified_by.u17_id
           LEFT JOIN u17_employee u17_created_by
               ON u41.u41_modified_by_id_u17 = u17_created_by.u17_id
           LEFT JOIN u17_employee u17_status_changed_by
               ON u41.u41_modified_by_id_u17 = u17_status_changed_by.u17_id
           LEFT JOIN vw_status_list status_list
               ON u41.u41_status_id_v01 = status_list.v01_id
/