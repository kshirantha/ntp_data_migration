CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_m17_bank_branches
(
    m17_id,
    m17_bank_id,
    m17_branch_name,
    m17_address,
    m17_tel,
    m17_created_by_id_u17,
    m17_created_date,
    m17_updated_by_id_u17,
    m17_updated_date,
    m17_external_ref,
    updated_by_fullname,
    status,
    status_changed_by_name,
    m17_status_id_v01,
    status_changed_date
)
AS
    SELECT m17.m17_id,
           m17.m17_bank_id,
           m17.m17_branch_name,
           m17.m17_address,
           m17.m17_tel,
           m17.m17_created_by_id_u17,
           m17.m17_created_date,
           m17.m17_updated_by_id_u17,
           m17.m17_updated_date,
           m17.m17_external_ref,
           u17_updated_by.u17_full_name AS updated_by_fullname,
           status_list.v01_description AS status,
           statuschangedby.u17_full_name AS status_changed_by_name,
           m17.m17_status_id_v01,
           m17.m17_status_changed_date AS status_changed_date
      FROM m17_bank_branches m17
           LEFT JOIN vw_status_list status_list
               ON m17.m17_status_id_v01 = status_list.v01_id
           LEFT JOIN u17_employee u17_updated_by
               ON m17.m17_updated_by_id_u17 = u17_updated_by.u17_id
           LEFT JOIN u17_employee statuschangedby
               ON m17.m17_status_changed_by_id_u17 = statuschangedby.u17_id
/