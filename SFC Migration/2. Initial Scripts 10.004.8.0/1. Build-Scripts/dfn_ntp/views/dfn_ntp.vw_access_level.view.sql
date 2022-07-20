CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_access_level
(
    v01_id,
    v01_description,
    v01_description_lang,
    v01_type,
    v01_type_description
)
AS
    (SELECT v01_id,
            v01_description,
            v01_description_lang,
            v01_type,
            v01_type_description
       FROM v01_system_master_data
      WHERE v01_type = 1);
/
