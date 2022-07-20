CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_m178_asset_management_compa
(
    m178_id,
    m178_company_name,
    m178_address,
    m178_phone,
    m178_fax,
    m178_country_id_m05,
    m178_code,
    m178_status_id_v01,
    status,
    status_lang,
    status_changed_by_full_name,
    country_name,
    country_name_lang
)
AS
    ( (SELECT m178.m178_id,
              m178.m178_company_name,
              m178.m178_address,
              m178.m178_phone,
              m178.m178_fax,
              m178.m178_country_id_m05,
              m178.m178_code,
              m178.m178_status_id_v01,
              status_list.v01_description AS status,
              status_list.v01_description_lang AS status_lang,
              u17.u17_full_name AS status_changed_by_full_name,
              country.m05_name AS country_name,
              country.m05_name_lang AS country_name_lang
         FROM m178_asset_management_company m178
              LEFT JOIN u17_employee u17
                  ON u17.u17_id = m178.m178_status_changed_by_id_u17
              LEFT JOIN vw_status_list status_list
                  ON status_list.v01_id = m178.m178_status_id_v01
              LEFT JOIN m05_country country
                  ON country.m05_id = m178.m178_country_id_m05))
/