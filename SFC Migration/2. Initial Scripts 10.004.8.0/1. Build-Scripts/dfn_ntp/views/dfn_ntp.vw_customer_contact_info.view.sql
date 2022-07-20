CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_customer_contact_info
(
    u02_id,
    u02_customer_id_u01,
    u02_is_default,
    is_default,
    u02_mobile,
    u02_fax,
    u02_email,
    u02_po_box,
    u02_zip_code,
    u02_address_line1,
    u02_address_line1_lang,
    u02_address_line2,
    u02_address_line2_lang,
    u02_telephone,
    u02_contact_description,
    contact_description,
    u02_created_by_id_u17,
    created_by_name,
    u02_created_date,
    u02_modified_by_id_u17,
    modified_by_name,
    u02_modified_date,
    u02_city_id_m06,
    u02_country_id_m05,
    u02_building_no,
    u02_unit_no,
    u02_additional_code,
    u02_district,
    u02_district_lang,
    country,
    country_lang,
    city,
    city_lang,
    u02_status_id_v01,
    u02_status_changed_by_id_u17,
    u02_status_changed_date,
    status,
	u02_cc_email,
    u02_bcc_email
)
AS
    SELECT u02_id,
           u02_customer_id_u01,
           u02_is_default,
           CASE WHEN u02_is_default = 1 THEN 'Yes' ELSE 'No' END
               AS is_default,
           u02_mobile,
           u02_fax,
           u02_email,
           u02_po_box,
           u02_zip_code,
           u02_address_line1,
           u02_address_line1_lang,
           u02_address_line2,
           u02_address_line2_lang,
           u02_telephone,
           u02_contact_description,
           CASE
               WHEN u02_contact_description = 1 THEN 'Mailing Address'
               WHEN u02_contact_description = 2 THEN 'Office Address'
               WHEN u02_contact_description = 3 THEN 'Residential Address'
               WHEN u02_contact_description = 4 THEN 'Wasel Address'
           END
               AS contact_description,
           u02_created_by_id_u17,
           createdby.u17_full_name AS created_by_name,
           u02_created_date,
           u02_modified_by_id_u17,
           modifiedby.u17_full_name AS modified_by_name,
           u02_modified_date,
           u02_city_id_m06,
           u02_country_id_m05,
           u02_building_no,
           u02_unit_no,
           u02_additional_code,
           u02_district,
           u02_district_lang,
           m05.m05_name AS country,
           m05.m05_name_lang AS country_lang,
           m06.m06_name AS city,
           m06.m06_name_lang AS city_lang,
           u02.u02_status_id_v01,
           u02.u02_status_changed_by_id_u17,
           u02.u02_status_changed_date,
           status_list.v01_description AS status,
		   	u02_cc_email,
			u02_bcc_email
      FROM u02_customer_contact_info u02,
           u17_employee createdby,
           u17_employee modifiedby,
           m06_city m06,
           m05_country m05,
           vw_status_list status_list
     WHERE     u02.u02_created_by_id_u17 = createdby.u17_id
           AND u02.u02_modified_by_id_u17 = modifiedby.u17_id(+)
           AND u02.u02_city_id_m06 = m06.m06_id(+)
           AND u02.u02_country_id_m05 = m05.m05_id(+)
           AND u02.u02_status_id_v01 = status_list.v01_id(+);
/
