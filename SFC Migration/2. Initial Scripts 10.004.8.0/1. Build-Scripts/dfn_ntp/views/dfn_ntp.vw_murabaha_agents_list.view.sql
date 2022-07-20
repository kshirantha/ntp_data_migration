CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_murabaha_agents_list
(
    u01_id,
    u01_customer_no,
    u01_default_id_type_txt,
    u01_default_id_no,
    u01_agent_type,
    u01_agent_code,
    status_description,
    nationalitycountry,
    trading,
    u01_def_mobile,
    u07_display_name,
    u01_display_name,
    m02_name,
    m02_telephone,
    u02_telephone
)
AS
    SELECT u01.u01_id,
           u01.u01_customer_no,
           m15.m15_name AS u01_default_id_type_txt,
           u01.u01_default_id_no,
           u01.u01_agent_type,
           u01.u01_agent_code,
           status.v01_description AS status_description,
           nationality.m05_name AS nationalitycountry,
           CASE WHEN u01.u01_trading_enabled = 1 THEN 'Yes' ELSE 'No' END
               AS trading,
           u01.u01_def_mobile,
           u07.u07_display_name,
           u01.u01_display_name,
           m02.m02_name,
           m02.m02_telephone,
           u02.u02_telephone
      FROM u07_trading_account u07
           JOIN u01_customer u01
               ON u01.u01_id = u07.u07_customer_id_u01
           LEFT JOIN u02_customer_contact_info u02
               ON u01.u01_id = u02.u02_customer_id_u01 AND u02_is_default = 1
           LEFT JOIN m06_city m06
               ON u02.u02_city_id_m06 = m06.m06_id
           LEFT JOIN m05_country m05
               ON u02.u02_country_id_m05 = m05.m05_id
           JOIN m15_identity_type m15
               ON u01.u01_default_id_type_m15 = m15.m15_id
           JOIN v01_system_master_data status
               ON     u01.u01_status_id_v01 = status.v01_id
                  AND status.v01_type = 4
           JOIN m05_country nationality
               ON u01.u01_nationality_id_m05 = nationality.m05_id
           JOIN m02_institute m02
               ON u07.u07_institute_id_m02 = m02.m02_id
     WHERE u07.u07_murabaha_margin_enabled = 1
/
