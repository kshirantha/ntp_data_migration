CREATE OR REPLACE VIEW dfn_ntp.vw_m151_trade_config_list 
(
	m151_id,
    m151_code,
    m151_name,
    m151_institute_id_m02,
    m151_trade_confirm_format_v12,
    trade_confirm_format,
    m151_is_default,
    is_default,
    m151_is_clearing,
    is_clearing,
    m151_is_symbol,
    is_symbol,
    m151_is_market,
    is_market,
    m151_is_order_side,
    is_order_side,
    m151_is_custodian,
    is_custodian,
    m151_created_by_id_u17,
    m151_created_date,
    m151_modified_by_id_u17,
    m151_modified_date,
    m151_status_id_v01,
    m151_status_changed_by_id_u17,
    m151_status_changed_date,
    status_description,
    created_by_full_name,
    modified_by_full_name,
    status_changed_by_full_name
)
AS
SELECT 
		 m151_id,
         m151_code,
         m151_name,
         m151_institute_id_m02,
         m151_trade_confirm_format_v12,
         Nvl(v12.v12_description,'') trade_confirm_format,
         m151_is_default,
         CASE WHEN m151_is_default = 0 THEN 'NO' ELSE 'YES' END is_default,
         m151_is_clearing,
         CASE WHEN m151_is_clearing = 0 THEN 'NO' ELSE 'YES' END is_clearing,
         m151_is_symbol,
         CASE WHEN m151_is_symbol = 0 THEN 'NO' ELSE 'YES' END is_symbol,
         m151_is_market,
         CASE WHEN m151_is_market = 0 THEN 'NO' ELSE 'YES' END is_market,
         m151_is_order_side,
         CASE WHEN m151_is_order_side = 0 THEN 'NO' ELSE 'YES' END is_order_side,
         m151_is_custodian,
         CASE WHEN m151_is_custodian = 0 THEN 'NO' ELSE 'YES' END is_custodian,
         m151_created_by_id_u17,
         m151_created_date,
         m151_modified_by_id_u17,
         m151_modified_date,
         m151_status_id_v01,
         m151_status_changed_by_id_u17,
         m151_status_changed_date,
         status_list.v01_description         AS status_description,
         u17_created_by.u17_full_name        AS created_by_full_name,
         u17_modified_by.u17_full_name       AS modified_by_full_name,
         u17_status_changed_by.u17_full_name AS status_changed_by_full_name
  FROM m151_trade_confirm_config m151
         JOIN u17_employee u17_created_by 
			ON m151.m151_created_by_id_u17 = u17_created_by.u17_id
         LEFT JOIN u17_employee u17_modified_by 
			ON m151.m151_modified_by_id_u17 = u17_modified_by.u17_id
         JOIN u17_employee u17_status_changed_by 
			ON m151.m151_status_changed_by_id_u17 = u17_status_changed_by.u17_id
         LEFT JOIN vw_status_list status_list 
			ON m151.m151_status_id_v01 = status_list.v01_id
         LEFT JOIN v12_trade_config_format v12
			ON m151.m151_trade_confirm_format_v12 = v12.v12_id;
/		 
