CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_m119_sharia_compliant_sym
(
    m119_exchange_code_m01,
    m119_institute_id_m02,
    m20_symbol_code,
    m20_long_description,
    m20_long_description_lang,
    m120_name,
    status_description,
    status_description_lang
)
AS
    SELECT m119.m119_exchange_code_m01,
           m119.m119_institute_id_m02,
           m20_symbol_code,
           m20_long_description,
           m20_long_description_lang,
           m120_name,
           status_list.v01_description AS status_description,
           status_list.v01_description_lang AS status_description_lang
      FROM m119_sharia_symbol m119
           LEFT JOIN m20_symbol m20
               ON m119.m119_symbol_id_m20 = m20.m20_id
           LEFT JOIN m120_sharia_compliant_group m120
               ON m119.m119_sharia_group_id_m120 = m120.m120_id
           LEFT JOIN vw_status_list status_list
               ON m20.m20_status_id_v01 = status_list.v01_id;
/
