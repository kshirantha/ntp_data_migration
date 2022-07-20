CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_z04_forms_color
(
    z04_z01_id,
    z04_seq_no,
    z04_criteria,
    z04_color,
    z04_column,
    z04_time_stamp
)
AS
    SELECT a.z04_z01_id,
           a.z04_seq_no,
           a.z04_criteria,
           a.z04_color,
           a.z04_column,
           a.z04_time_stamp
      FROM z04_forms_color a
--FROM  Mubasher_dc.z04_forms_color@GBL a;
/
