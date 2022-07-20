CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_update_versions_all
(
    z25_id,
    z25_application,
    z25_internal_version,
    z25_external_version,
    z25_created_time,
    z25_created_by,
    z25_status,
    z25_size,
    z25_mode,
    z25_min_required_version,
    product,
    z25_client_hash,
    file_status_1,
    file_status_2,
    z25_file_1,
    z25_file_2
)
AS
    SELECT a.z25_id,
           a.z25_application,
           a.z25_internal_version,
           a.z25_external_version,
           a.z25_created_time,
           a.z25_created_by_id_u17,
           a.z25_status,
           a.z25_size,
           z25_mode,
           z25_min_required_version,
           CASE
               WHEN a.z25_application = 1 THEN 'AT'
               WHEN a.z25_application = 2 THEN 'DT'
               WHEN a.z25_application = 3 THEN 'TWS'
           END
               AS product,
           a.z25_client_hash,
           CASE
               WHEN a.z25_file_1 = 1 THEN 'Uploaded'
               WHEN a.z25_file_1 = 0 THEN 'Not Uploaded'
           END
               AS filestatus1,
           CASE
               WHEN a.z25_file_2 = 1 THEN 'Uploaded'
               WHEN a.z25_file_2 = 0 THEN 'Not Uploaded'
           END
               AS filestatus2,
           a.z25_file_1,
           a.z25_file_2
      FROM z25_auto_update_versions a
     WHERE a.z25_status <> 2
/