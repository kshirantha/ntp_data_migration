CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_minor_accounts_list
(
    u01_id,
    u01_customer_no,
    u01_account_category_id_v01,
    u01_display_name,
    u01_display_name_lang,
    u01_preferred_lang_id_v01,
    u01_status_id_v01,
    status_description,
    v01_description_lang,
    u01_trading_enabled,
    u01_online_trading_enabled,
    nationalitycountry,
    u01_account_type_id_v01,
    u01_master_account_id_u01,
    u01_guardian_id_u01,
    guardian_name,
    guardian_customer_no,
    u01_guardian_relationship_v01,
    guardian_relationship,
    u01_institute_id_m02
)
AS
    SELECT u01.u01_id,
           u01.u01_customer_no,
           u01.u01_account_category_id_v01,
           u01.u01_display_name,
           u01.u01_display_name_lang,
           u01.u01_preferred_lang_id_v01,
           u01.u01_status_id_v01,
           status.v01_description AS status_description,
           status.v01_description_lang,
           u01.u01_trading_enabled,
           u01.u01_online_trading_enabled,
           m05.m05_name AS nationalitycountry,
           u01.u01_account_type_id_v01,
           u01.u01_master_account_id_u01,
           u01.u01_guardian_id_u01,
           guardian.u01_display_name AS guardian_name,
           guardian.u01_customer_no AS guardian_customer_no,
           u01.u01_guardian_relationship_v01,
           CASE
               WHEN u01.u01_guardian_relationship_v01 = 1 THEN 'Father'
               WHEN u01.u01_guardian_relationship_v01 = 2 THEN 'Mother'
               WHEN u01.u01_guardian_relationship_v01 = 3 THEN 'Uncle'
               WHEN u01.u01_guardian_relationship_v01 = 4 THEN 'Aunt'
           END
               AS guardian_relationship,
           u01.u01_institute_id_m02
      FROM u01_customer u01
           LEFT JOIN m05_country m05
               ON u01.u01_nationality_id_m05 = m05.m05_id
           LEFT JOIN u01_customer guardian
               ON u01.u01_guardian_id_u01 = guardian.u01_id
           LEFT JOIN v01_system_master_data status
               ON     u01.u01_status_id_v01 = status.v01_id
                  AND status.v01_type = 4
     WHERE u01.u01_minor_account = 1
/