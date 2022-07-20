CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_m40_file_procs_job_conf
(
    m40_id,
    m40_file_type_id_v01,
    file_type,
    m40_description,
    m40_template_id_m173,
    m173_template_name,
    m40_file_name_format,
    m40_file_location,
    m40_archive_file_location,
    m40_error_file_location,
    m40_frequency_per_day,
    frequency,
    m40_start_time,
    start_time,
    m40_parent_config_id_m40,
    m40_notification_enabled,
    m40_institute_id_m02,
    m40_custom_type,
    m40_job_status_id_v01,
    job_status,
    m40_status_id_v01,
    status,
    m40_last_update_date_time,
    m40_last_update_date,
    m40_file_extension,
    m40_is_enable,
    enabled,
    m40_is_auto_approve,
    auto_approve
)
AS
    SELECT m40.m40_id,
           m40.m40_file_type_id_v01,
           file_type.v01_description AS file_type,
           m40.m40_description,
           m40.m40_template_id_m173,
           m173.m173_template_name,
           m40.m40_file_name_format,
           m40.m40_file_location,
           m40.m40_archive_file_location,
           m40.m40_error_file_location,
           m40.m40_frequency_per_day,
           CASE
               WHEN m40.m40_frequency_per_day > 1 THEN 'More Than Once'
               ELSE 'Once'
           END
               AS frequency,
           m40.m40_start_time,
           TO_CHAR (m40.m40_start_time, 'hh24:mi') AS start_time,
           m40.m40_parent_config_id_m40,
           m40.m40_notification_enabled,
           m40.m40_primary_institute_id_m02 AS m40_institute_id_m02,
           m40.m40_custom_type,
           m40.m40_job_status_id_v01,
           job_status.v01_description AS job_status,
           m40.m40_status_id_v01,
           status.v01_description AS status,
           m40.m40_last_update_date_time,
           m40.m40_last_update_date,
           m40.m40_file_extension,
           m40.m40_is_enable,
           CASE m40.m40_is_enable WHEN 0 THEN 'No' WHEN 1 THEN 'Yes' END
               AS enabled,
           m40.m40_is_auto_approve,
           CASE m40.m40_is_auto_approve
               WHEN 1 THEN 'Auto Approve and send to OMS'
               WHEN 0 THEN ' Do Not Auto Approve'
           END
               AS autoapprove
      FROM m40_file_processing_job_config m40
           JOIN m173_data_loader_template m173
               ON m40.m40_template_id_m173 = m173.m173_id
           JOIN vw_status_list status
               ON m40.m40_status_id_v01 = status.v01_id
           JOIN vw_status_list job_status
               ON m40.m40_job_status_id_v01 = job_status.v01_id
           JOIN v01_system_master_data file_type
               ON     m40.m40_file_type_id_v01 = file_type.v01_id
                  AND file_type.v01_type = 72
/