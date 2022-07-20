CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_om_questionnaire
(
    m183_id,
    m183_product_id_m73,
    margin_product,
    m183_description,
    m183_description_lang,
    m183_status_id_v01,
    status,
    m183_created_by_id_u17,
    created_by_full_name,
    m183_created_date,
    m183_status_changed_by_id_u17,
    status_changed_by_full_name,
    m183_status_changed_date,
    m183_modified_by_id_u17,
    modified_by_full_name,
    m183_modified_date,
    m183_institute_id_m02
)
AS
    SELECT m183.m183_id,
           m183.m183_product_id_m73,
           m73.m73_name,
           m183.m183_description,
           m183.m183_description_lang,
           m183.m183_status_id_v01,
           status.v01_description,
           m183.m183_created_by_id_u17,
           createdby.u17_full_name,
           m183.m183_created_date,
           m183.m183_status_changed_by_id_u17,
           statuschangedby.u17_full_name,
           m183.m183_status_changed_date,
           m183.m183_modified_by_id_u17,
           modifiedby.u17_full_name,
           m183.m183_modified_date,
           m183.m183_institute_id_m02
      FROM m183_om_questionnaire m183
           JOIN m73_margin_products m73
               ON m183.m183_product_id_m73 = m73.m73_id
           JOIN vw_status_list status
               ON m183.m183_status_id_v01 = status.v01_id
           LEFT JOIN u17_employee createdby
               ON m183.m183_created_by_id_u17 = createdby.u17_id
           LEFT JOIN u17_employee statuschangedby
               ON m183.m183_status_changed_by_id_u17 = statuschangedby.u17_id
           LEFT JOIN u17_employee modifiedby
               ON m183.m183_modified_by_id_u17 = modifiedby.u17_id
/
