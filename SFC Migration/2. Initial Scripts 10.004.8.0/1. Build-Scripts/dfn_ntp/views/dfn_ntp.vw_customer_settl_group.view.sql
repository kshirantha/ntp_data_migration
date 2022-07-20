CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_customer_settl_group
(
    m35_id,
    m35_description,
    m35_description_lang,
    m35_additional_details,
    m35_status_id_v01,
    status,
    m35_created_by_id_u17,
    created_by_full_name,
    m35_created_date,
    m35_modified_by_id_u17,
    modified_by_full_name,
    m35_modified_date,
    m35_status_changed_by_id_u17,
    m35_institute_id_m02,
    m35_is_default,
    is_default,
    status_changed_by_full_name
)
AS
    ( (SELECT m35.m35_id,
              m35.m35_description,
              m35.m35_description_lang,
              m35.m35_additional_details,
              m35.m35_status_id_v01,
              status.v01_description AS status,
              m35.m35_created_by_id_u17,
              createdby.u17_full_name AS created_by_full_name,
              m35.m35_created_date,
              m35.m35_modified_by_id_u17,
              modifiedby.u17_full_name AS modified_by_full_name,
              m35.m35_modified_date,
              m35.m35_status_changed_by_id_u17,
              m35.m35_institute_id_m02,
              m35.m35_is_default,
              CASE
                  WHEN m35.m35_is_default = 0 THEN 'No'
                  WHEN m35.m35_is_default = 1 THEN 'Yes'
              END
                  AS is_default,
              statuschangedby.u17_full_name AS status_changed_by_full_name
       FROM m35_customer_settl_group m35
            LEFT JOIN u17_employee createdby
                ON m35.m35_created_by_id_u17 = createdby.u17_id
            LEFT JOIN u17_employee createdby
                ON m35.m35_created_by_id_u17 = createdby.u17_id
            LEFT JOIN u17_employee modifiedby
                ON m35.m35_modified_by_id_u17 = modifiedby.u17_id
            LEFT JOIN u17_employee statuschangedby
                ON m35.m35_status_changed_by_id_u17 = statuschangedby.u17_id
            LEFT JOIN vw_status_list status
                ON m35.m35_status_id_v01 = status.v01_id))
/