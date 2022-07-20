CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_spread_matrix_list
(
    m18_id,
    m18_symbol1_id_m20,
    symbol_code_from,
    symbol_code_to,
    m18_symbol2_id_m20,
    m18_spread_value,
    m18_status_id_v01,
    m18_created_by_id_u17,
    m18_created_date,
    m18_status_change_by_id_u17,
    m18_status_change_date,
    m18_modified_by_id_u17,
    m18_modified_date,
    m18_custom_type,
    m18_institute_id_m02,
    created_by_full_name,
    modified_by_full_name,
    status_changed_by_full_name,
    status
)
AS
    SELECT a.m18_id,
           a.m18_symbol1_id_m20,
           m20_from.m20_symbol_code symbol_code_from,
           m20_to.m20_symbol_code symbol_code_to,
           a.m18_symbol2_id_m20,
           a.m18_spread_value,
           a.m18_status_id_v01,
           a.m18_created_by_id_u17,
           a.m18_created_date,
           a.m18_status_change_by_id_u17,
           a.m18_status_change_date,
           a.m18_modified_by_id_u17,
           a.m18_modified_date,
           a.m18_custom_type,
           a.m18_institute_id_m02,
           u17_created_by.u17_full_name AS created_by_full_name,
           u17_modified_by.u17_full_name AS modified_by_full_name,
           u17_changed_by.u17_full_name AS status_changed_by_full_name,
           status_list.v01_description AS status
      FROM m18_derivative_spread_matrix a
           JOIN m20_symbol m20_from ON a.m18_symbol1_id_m20 = m20_from.m20_id
           JOIN m20_symbol m20_to ON a.m18_symbol2_id_m20 = m20_to.m20_id
           LEFT JOIN u17_employee u17_created_by
               ON a.m18_created_by_id_u17 = u17_created_by.u17_id
           LEFT JOIN u17_employee u17_modified_by
               ON a.m18_modified_by_id_u17 = u17_modified_by.u17_id
           LEFT JOIN u17_employee u17_changed_by
               ON a.m18_status_change_by_id_u17 = u17_changed_by.u17_id
           LEFT JOIN vw_status_list status_list
               ON a.m18_status_id_v01 = status_list.v01_id
/