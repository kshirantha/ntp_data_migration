CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_status_list
(
    v01_id,
    v01_description,
    v01_description_lang
)
AS
    SELECT a.v01_id, a.v01_description, a.v01_description_lang
      FROM v01_system_master_data a
     WHERE v01_type = 4;
/
