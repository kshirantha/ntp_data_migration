CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_z03_forms_menu
(
   z03_z01_id,
   z03_seq_no,
   z03_text,
   z03_sec_id,
   z03_time_stamp,
   z03_visible,
   z03_parent_menu
)
AS
   SELECT a.z03_z01_id,
          a.z03_seq_no,
          a.z03_text,
          a.z03_sec_id,
          a.z03_time_stamp,
          a.z03_visible,
          a.z03_parent_menu
     FROM z03_forms_menu a
    WHERE Z03_VISIBLE = 1;
/