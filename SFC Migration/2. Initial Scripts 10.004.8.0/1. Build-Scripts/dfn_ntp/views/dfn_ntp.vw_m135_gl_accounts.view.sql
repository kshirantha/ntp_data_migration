CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_m135_gl_accounts
(
    m135_id,
    m135_code,
    m135_currency_code_m03,
    m135_currency_id_m03,
    m135_acc_cat_id_m134,
    m135_external_ref,
    m135_created_by_id_u17,
    m135_created_date,
    m135_modified_by_id_u17,
    m135_modified_date,
    acc_category_desc,
    acc_category_desc_lang,
    created_by_full_name,
    modified_by_full_name,
    status,
    status_lang,
    status_changed_by_full_name,
    m135_status_changed_date,
    m135_status_id_v01,
	m135_institute_id_m02
)
AS
    SELECT m135.m135_id,
           m135.m135_code,
           m135.m135_currency_code_m03,
           m135.m135_currency_id_m03,
           m135.m135_acc_cat_id_m134,
           m135.m135_external_ref,
           m135.m135_created_by_id_u17,
           m135.m135_created_date,
           m135.m135_modified_by_id_u17,
           m135.m135_modified_date,
           m134.m134_description AS acc_category_desc,
           m134.m134_description_lang AS acc_category_desc_lang,
           u17_created_by.u17_full_name AS created_by_full_name,
           u17_modified_by.u17_full_name AS modified_by_full_name,
           status_list.v01_description AS status,
           status_list.v01_description_lang AS status_lang,
           u17_statuschanged_by.u17_full_name AS status_changed_by_full_name,
           m135.m135_status_changed_date AS m135_status_changed_date,
           m135.m135_status_id_v01,
		   m135_institute_id_m02
      FROM m135_gl_accounts m135
           JOIN m134_gl_account_categories m134
               ON m135.m135_acc_cat_id_m134 = m134.m134_id
           JOIN u17_employee u17_created_by
               ON m135.m135_created_by_id_u17 = u17_created_by.u17_id
           JOIN vw_status_list status_list
               ON m135.m135_status_id_v01 = status_list.v01_id
           LEFT JOIN u17_employee u17_modified_by
               ON m135.m135_modified_by_id_u17 = u17_modified_by.u17_id
           LEFT JOIN u17_employee u17_statuschanged_by
               ON m135.m135_status_changed_by_id_u17 =
                      u17_statuschanged_by.u17_id
/