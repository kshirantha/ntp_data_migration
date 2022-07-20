CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_z01_forms_m
(
    z01_id,
    z01_tag,
    z01_version_no,
    z01_view_name,
    z01_title,
    z01_form_type,
    z01_sort_column,
    z01_date_field,
    z01_truncate_date,
    z01_load_all_data,
    z01_time_stamp,
    z01_has_sensitive_data,
    z01_excel_export_sec_id,
    z01_textfile_export_sec_id,
    z01_auto_refresh,
    z01_source_type,
    z01_ignore_sort,
    z01_load_data_on_opening,
    z01_fully_loaded,
    z01_updated_datetime
)
AS
    SELECT a.z01_id,
           a.z01_tag,
           a.z01_version_no,
           a.z01_view_name,
           a.z01_title,
           a.z01_form_type,
           a.z01_sort_column,
           a.z01_date_field,
           a.z01_truncate_date,
           a.z01_load_all_data,
           a.z01_time_stamp,
           a.z01_has_sensitive_data,
           a.z01_excel_export_sec_id,
           a.z01_textfile_export_sec_id,
           a.z01_auto_refresh,
           a.z01_source_type,
           a.z01_ignore_sort,
           a.z01_load_data_on_opening,
           a.z01_fully_loaded,
           z01_updated_datetime
      --FROM Mubasher_dc.z01_forms_m@GBL a
      FROM z01_forms_m a;
/
