CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_t80_file_processing_batches
(
    t80_id,
    t80_config_id_m40,
    file_type,
    m40_file_type_id_v01,
    m40_description,
    t80_job_time,
    job_time,
    t80_batch_type,
    batch_type,
    t80_created_by_id_u17,
    created_by,
    t80_created_date,
    t80_modified_by_id_u17,
    modified_by,
    t80_modified_date,
    t80_status_id_v01,
    status,
    t80_status_changed_by_id_u17,
    statuschanged_by,
    t80_status_changed_date,
    t80_custom_type,
    t80_description,
    t80_mismatch
)
AS
    SELECT t80.t80_id,
           t80.t80_config_id_m40,
           m40.file_type,
           m40.m40_file_type_id_v01,
           m40.m40_description,
           t80.t80_job_time,
           TO_CHAR (t80_job_time, 'MM/DD/YYYY  HH24:MI:SS') AS job_time,
           t80.t80_batch_type,
           CASE t80.t80_batch_type
               WHEN 1 THEN 'Auto'
               WHEN 2 THEN 'Manual'
           END
               AS batch_type,
           t80.t80_created_by_id_u17,
           createdby.u17_full_name AS created_by,
           t80.t80_created_date,
           t80.t80_modified_by_id_u17,
           modifiedby.u17_full_name AS modified_by,
           t80.t80_modified_date,
           t80.t80_status_id_v01,
           status.v01_description AS status,
           t80.t80_status_changed_by_id_u17,
           statuschangedby.u17_full_name AS statuschanged_by,
           t80.t80_status_changed_date,
           t80.t80_custom_type,
           t80.t80_description,
           t80.t80_mismatch
      FROM t80_file_processing_batches t80
           INNER JOIN vw_m40_file_procs_job_conf m40
               ON m40.m40_id = t80.t80_config_id_m40
           INNER JOIN u17_employee createdby
               ON createdby.u17_id = t80.t80_created_by_id_u17
           LEFT JOIN u17_employee modifiedby
               ON modifiedby.u17_id = t80.t80_modified_by_id_u17
           LEFT JOIN u17_employee statuschangedby
               ON statuschangedby.u17_id = t80.t80_status_changed_by_id_u17
           JOIN vw_status_list status
               ON status.v01_id = t80.t80_status_id_v01
/