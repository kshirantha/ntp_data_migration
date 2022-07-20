CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_cash_transfer_limit_group
(
    m177_id,
    m177_group_name,
    m177_cash_transfer_limit,
    m177_frequency_id_v01,
    transaction_limit_frequency,
    m177_is_default,
    is_default,
    m177_status_id_v01,
    status,
    m177_created_by_id_u17,
    created_by_full_name,
    m177_created_date,
    m177_status_changed_by_id_u17,
    status_changed_by_full_name,
    m177_status_changed_date,
    m177_modified_by_id_u17,
    modified_by_full_name,
    m177_modified_date,
    m177_institute_id_m02,
    institute
)
AS
    SELECT m177.m177_id,
           m177.m177_group_name,
           m177.m177_cash_transfer_limit,
           m177.m177_frequency_id_v01,
           CASE
               WHEN m177.m177_frequency_id_v01 = 1 THEN 'Cumulative'
               WHEN m177.m177_frequency_id_v01 = 2 THEN 'Per Transaction'
           END
               AS transaction_limit_frequency,
           m177.m177_is_default,
           CASE
               WHEN m177.m177_is_default = 0 THEN 'No'
               WHEN m177.m177_is_default = 1 THEN 'Yes'
           END
               AS is_default,
           m177.m177_status_id_v01,
           vw_status_list.v01_description AS status,
           m177.m177_created_by_id_u17,
           createdby.u17_full_name AS created_by_full_name,
           m177.m177_created_date,
           m177.m177_status_changed_by_id_u17,
           statuschangedby.u17_full_name AS status_changed_by_full_name,
           m177.m177_status_changed_date,
           m177.m177_modified_by_id_u17,
           modifiedby.u17_full_name AS modified_by_full_name,
           m177.m177_modified_date,
           m177.m177_institute_id_m02,
           institute.m02_name AS institute
      FROM m177_cash_transfer_limit_group m177
           LEFT JOIN vw_status_list
               ON m177.m177_status_id_v01 = vw_status_list.v01_id
           LEFT JOIN u17_employee createdby
               ON m177.m177_created_by_id_u17 = createdby.u17_id
           LEFT JOIN u17_employee statuschangedby
               ON m177.m177_status_changed_by_id_u17 = statuschangedby.u17_id
           LEFT JOIN u17_employee modifiedby
               ON m177.m177_modified_by_id_u17 = modifiedby.u17_id
           LEFT JOIN m02_institute institute
               ON m177.m177_institute_id_m02 = institute.m02_id
/
