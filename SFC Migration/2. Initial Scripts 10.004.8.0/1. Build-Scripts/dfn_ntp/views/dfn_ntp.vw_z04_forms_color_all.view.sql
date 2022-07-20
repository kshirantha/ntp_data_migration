CREATE OR REPLACE VIEW dfn_ntp.vw_z04_forms_color_all
(
    z04_z01_id,
    z04_seq_no,
    z04_criteria,
    z04_color,
    z04_column,
    z04_time_stamp,
    z04_broker_code,
    col_priority
)
AS
    (SELECT a.z04_z01_id,
            a.z04_seq_no,
            a.z04_criteria,
            a.z04_color,
            a.z04_column,
            a.z04_time_stamp,
            NULL AS z04_broker_code,
            2 AS col_priority
       FROM z04_forms_color a
      WHERE z04_z01_id || '--' || z04_criteria NOT IN
                (SELECT z04_z01_id || '--' || z04_criteria
                   FROM z04_forms_color_c
                  WHERE z04_broker_code IS NULL)
     UNION ALL
     SELECT a.z04_z01_id,
            a.z04_seq_no,
            a.z04_criteria,
            a.z04_color,
            a.z04_column,
            a.z04_time_stamp,
            a.z04_broker_code,
            1 AS col_priority
       FROM z04_forms_color_c a
      WHERE a.z04_change_status <> 3)
/