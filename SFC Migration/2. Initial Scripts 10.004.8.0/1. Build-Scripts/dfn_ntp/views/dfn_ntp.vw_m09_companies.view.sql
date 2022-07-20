CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_m09_companies
(
    m09_id,
    m09_description,
    m09_created_by_id_u17,
    created_by_full_name,
    m09_created_date,
    m09_modified_by_id_u17,
    m09_modified_date,
    m09_status_id_v01,
    status_description,
    m09_status_changed_by_id_u17,
    status_changed_by_full_name,
    m09_status_changed_date,
	m09_institute_id_m02
)
AS
    SELECT m09_id,
           m09_description,
           m09_created_by_id_u17,
           u17_created_by.u17_full_name AS created_by_full_name,
           m09_created_date,
           m09_modified_by_id_u17,
           m09_modified_date,
           m09_status_id_v01,
           status_list.v01_description AS status_description,
           m09_status_changed_by_id_u17,
           u17_status_changed_by.u17_full_name AS status_changed_by_full_name,
		   m09_status_changed_date,
		   m09_institute_id_m02
      FROM m09_companies m09
           JOIN u17_employee u17_created_by
               ON m09.m09_created_by_id_u17 = u17_created_by.u17_id
           LEFT JOIN u17_employee u17_modified_by
               ON m09.m09_modified_by_id_u17 = u17_modified_by.u17_id
           JOIN u17_employee u17_status_changed_by
               ON m09.m09_status_changed_by_id_u17 =
                      u17_status_changed_by.u17_id
           LEFT JOIN vw_status_list status_list
               ON m09.m09_status_id_v01 = status_list.v01_id;
/
