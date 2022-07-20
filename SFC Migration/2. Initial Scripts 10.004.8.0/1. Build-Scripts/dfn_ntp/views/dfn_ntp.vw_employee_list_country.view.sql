CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_employee_list_country
(
    u17_id,
    u17_institution_id_m02,
    institution_name,
    u17_full_name,
    u17_login_name,
    u17_password,
    u17_failed_attempts,
    u17_is_first_time,
    u17_created_by_id_u17,
    u17_created_date,
    u17_status_id_v01,
    status,
    u17_login_status,
    login_status,
    u17_type_id_m11,
    u17_price_login_name,
    u17_price_password,
    u17_pw_expire_date,
    u17_last_login_date,
    u17_telephone,
    u17_telephone_ext,
    u17_mobile,
    u17_email,
    u17_department_id_m12,
    u17_employee_no,
    u17_modified_by_id_u17,
    u17_modified_date,
    u17_status_changed_by_u17,
    u17_status_changed_date,
    m11_name,
    m11_name_lang,
    m11_category,
    m12_name,
    m12_name_lang,
    u17_client_version,
    u17_full_name_saudi
)
AS
    SELECT u17.u17_id,
           u17.u17_institution_id_m02,
           m02.m02_name AS institution_name,
           u17.u17_full_name,
           u17.u17_login_name,
           u17.u17_password,
           u17.u17_failed_attempts,
           u17.u17_is_first_time,
           u17.u17_created_by_id_u17,
           u17.u17_created_date,
           u17.u17_status_id_v01,
           status.v01_description AS status,
           u17.u17_login_status,
           CASE u17.u17_login_status
               WHEN 0 THEN 'Pending'
               WHEN 1 THEN 'Active'
               WHEN 2 THEN 'Locked'
           END
               AS login_status,
           u17.u17_type_id_m11,
           u17.u17_price_login_name,
           u17.u17_price_password,
           u17.u17_pw_expire_date,
           u17.u17_last_login_date,
           u17.u17_telephone,
           u17.u17_telephone_ext,
           u17.u17_mobile,
           u17.u17_email,
           u17.u17_department_id_m12,
           u17.u17_employee_no,
           u17.u17_modified_by_id_u17,
           u17.u17_modified_date,
           u17.u17_status_changed_by_u17,
           u17.u17_status_changed_date,
           m11.m11_name,
           m11.m11_name_lang,
           m11.m11_category,
           m12.m12_name,
           m12.m12_name_lang,
           u17.u17_client_version,
           u17.u17_full_name_saudi
      FROM u17_employee u17,
           m11_employee_type m11,
           m12_employee_department m12,
           m02_institute m02,
           v01_system_master_data status
     WHERE     u17.u17_type_id_m11 = m11.m11_id
           AND u17.u17_department_id_m12 = m12.m12_id
           AND u17.u17_institution_id_m02 = m02.m02_id
           AND u17.u17_status_id_v01 = status.v01_id
           AND status.v01_type = 4;
/
