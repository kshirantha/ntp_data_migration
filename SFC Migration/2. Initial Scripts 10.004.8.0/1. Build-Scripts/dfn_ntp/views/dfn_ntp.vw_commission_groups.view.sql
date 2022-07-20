CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_commission_groups
(
    m22_id,
    m22_description,
    m22_exchange_code_m01,
    m22_exchange_id_m01,
    m22_institute_id_m02,
    m22_is_default,
    is_default,
    m22_status_id_v01,
    status,
    status_changed_by_full_name,
    m22_additional_details
)
AS
    SELECT m22.m22_id AS m22_id,
           m22.m22_description,
           m22.m22_exchange_code_m01,
           m22.m22_exchange_id_m01,
           m22.m22_institute_id_m02,
           m22.m22_is_default,
           CASE
               WHEN m22.m22_is_default = 0 THEN 'No'
               WHEN m22.m22_is_default = 1 THEN 'Yes'
           END
               AS is_default,
           m22.m22_status_id_v01,
           status_list.v01_description AS status,
           u17_status_changed_by.u17_full_name AS status_changed_by_full_name,
           m22.m22_additional_details
      FROM m22_commission_group m22
           LEFT JOIN u17_employee u17_status_changed_by
               ON m22.m22_status_changed_by_id_u17 =
                      u17_status_changed_by.u17_id
           LEFT JOIN vw_status_list status_list
               ON m22.m22_status_id_v01 = status_list.v01_id;
/
