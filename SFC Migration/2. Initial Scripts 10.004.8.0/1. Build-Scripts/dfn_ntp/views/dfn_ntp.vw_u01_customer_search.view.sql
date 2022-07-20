CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_u01_customer_search
(
    u01_id,
    u01_customer_no,
    u01_institute_id_m02,
    u01_account_category_id_v01,
    u01_first_name,
    u01_first_name_lang,
    u01_last_name,
    u01_last_name_lang,
    u01_second_name,
    u01_third_name,
    u01_date_of_birth,
    u01_default_id_no,
    u01_default_id_type_m15,
    u01_status_id_v01,
    default_mobile,
    default_email,
    u01_grade,
    u01_nationality_id_m05,
    u01_trading_enabled,
    u01_full_name,
    u01_full_name_lang,
    u01_external_ref_no,
    u01_account_type_id_v01,
    u02_customer_id_u01,
    u02_mobile,
    u02_fax,
    u02_email,
    u02_po_box,
    u02_zip_code,
    u02_address_line1,
    u02_address_line2,
    u02_telephone,
    m06_name,
    u02_country_id_m05,
    m02_code,
    u05_id_no,
    u06_investment_account_no,
    u07_exchange_account_no,
    u07_display_name,
    u01_modified_date,
    u01_created_date,
    u01_poa_available,
	u01_direct_dealing_enabled,
    u01_dd_from_date,
    u01_dd_to_date,
    u01_dd_reference_no
)
AS
    SELECT u01_id,
           u01_customer_no,
           u01_institute_id_m02,
           u01_account_category_id_v01,
           u01_first_name,
           u01_first_name_lang,
           u01_last_name,
           u01_last_name_lang,
           u01_second_name,
           u01_third_name,
           u01_date_of_birth,
           u01_default_id_no,
           u01_default_id_type_m15,
           u01_status_id_v01,
           u02_mobile AS default_mobile,
           u02_email AS default_email,
           u01_grade,
           u01_nationality_id_m05,
           u01_trading_enabled,
           u01_full_name,
           u01_full_name_lang,
           u01_external_ref_no,
           u01_account_type_id_v01,
           u02_customer_id_u01,
           u02_mobile,
           u02_fax,
           u02_email,
           u02_po_box,
           u02_zip_code,
           u02_address_line1,
           u02_address_line2,
           u02_telephone,
           m06_name,
           u02_country_id_m05,
           m02_code,
           u01_default_id_no AS u05_id_no, -- U05 was joined to take default ID. Now takes from U01. If DT can change the column this alias can be removed
           u06_investment_account_no,
           u07_exchange_account_no,
           u07_display_name,
           u01_modified_date,
           u01_created_date,
           u01_poa_available,
		   u01_direct_dealing_enabled,
           u01_dd_from_date,
           u01_dd_to_date,
           u01_dd_reference_no
      FROM u01_customer a
           LEFT JOIN u02_customer_contact_info
               ON u01_id = u02_customer_id_u01 AND u02_is_default = 1
           JOIN m02_institute
               ON u01_institute_id_m02 = m02_id
           LEFT JOIN m06_city
               ON u02_city_id_m06 = m06_id
           LEFT JOIN (SELECT u06_investment_account_no, u06_customer_id_u01
                        FROM u06_cash_account
                       WHERE u06_is_default = 1)
               ON u01_id = u06_customer_id_u01
           LEFT JOIN (SELECT u07_exchange_account_no,
                             u07_display_name,
                             u07_customer_id_u01
                        FROM u07_trading_account)
 --                      WHERE u07_is_default = 1)
               ON u01_id = u07_customer_id_u01
/

COMMENT ON TABLE dfn_ntp.vw_u01_customer_search IS
    'Front office customer search for DT'
/