CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_city_list
(
    m06_id,
    m06_country_id_m05,
    m06_name,
    m06_name_lang,
    m06_created_by_id_u17,
    m06_created_date,
    m06_status_changed_date,
    m06_status_id_v01,
    m06_modified_by_id_u17,
    m06_modified_date,
    status,
    created_by_name,
    modified_by_name,
    status_changed_by_name
)
AS
    SELECT m06_id,
           m06_country_id_m05,
           m06_name,
           m06_name_lang,
           m06_created_by_id_u17,
           m06_created_date,
           m06_status_changed_date,
           m06_status_id_v01,
           m06_modified_by_id_u17,
           m06_modified_date,
           status_list.v01_description AS status,
           createdby.u17_full_name AS created_by_name,
           modifiedby.u17_full_name AS modified_by_name,
           statuschangedby.u17_full_name AS status_changed_by_name
      FROM m06_city m06,
           vw_status_list status_list,
           u17_employee createdby,
           u17_employee modifiedby,
           u17_employee statuschangedby
     WHERE     m06.m06_status_id_v01 = status_list.v01_id(+)
           AND m06.m06_created_by_id_u17 = createdby.u17_id
           AND m06.m06_modified_by_id_u17 = modifiedby.u17_id(+)
           AND m06.m06_status_changed_by_id_u17 = statuschangedby.u17_id;
/
