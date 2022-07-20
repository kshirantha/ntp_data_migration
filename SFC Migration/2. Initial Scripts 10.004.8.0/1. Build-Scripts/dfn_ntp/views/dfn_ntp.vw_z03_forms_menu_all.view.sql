CREATE OR REPLACE VIEW dfn_ntp.vw_z03_forms_menu_all
(
    z03_z01_id,
    z03_seq_no,
    z03_text,
    z03_time_stamp,
    z03_visible,
    z03_parent_menu,
    z03_sec_id,
    z03_broker_code,
    col_priority
)
AS
    (SELECT a.z03_z01_id,
            a.z03_seq_no,
            a.z03_text,
            a.z03_time_stamp,
            a.z03_visible,
            a.z03_parent_menu,
            a.z03_sec_id,
            NULL AS z03_broker_code,
            2 AS col_priority
       FROM z03_forms_menu a
      WHERE z03_z01_id || '--' || z03_text NOT IN
                (SELECT z03_z01_id || '--' || z03_text
                   FROM z03_forms_menu_c
                  WHERE z03_broker_code IS NULL)
     UNION ALL
     SELECT a.z03_z01_id,
            a.z03_seq_no,
            a.z03_text,
            a.z03_time_stamp,
            a.z03_visible,
            a.z03_parent_menu,
            a.z03_sec_id,
            a.z03_broker_code,
            1 AS col_priority
       FROM z03_forms_menu_c a
      WHERE a.z03_change_status <> 3)
/