CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_data_loader_template_list
(
    m173_id,
    m173_file_type_id_v01,
    file_type,
    file_type_lang,
    m173_template_name,
    m173_template_name_lang,
    m173_file_format,
    m173_separator_type,
    m173_field_separator,
    m173_field_separator_id,
    m173_line_separator,
    m173_line_separator_id,
    m173_skip_first_row,
    m173_created_by_id_u17,
    created_by_name,
    m173_created_date,
    m173_modified_by_id_u17,
    modified_by_name,
    m173_modified_date,
    m173_table_validated,
    is_validated,
    m173_validated_by_id_u17,
    validated_by_name,
    m173_validated_date,
    m173_custom_type,
    m173_institution_id_m02,
    m173_db_proc_name,
    m173_use_custom_proc,
    m173_file_name,
    file_name,
    m173_is_automated_file
)
AS
    (SELECT m173.m173_id,
            m173.m173_file_type_id_v01,
            v01.v01_description AS file_type,
            v01.v01_description_lang AS file_type_lang,
            m173.m173_template_name,
            m173.m173_template_name_lang,
            m173.m173_file_format,
            m173.m173_separator_type,
            m173.m173_field_separator,
            m173.m173_field_separator_id,
            m173.m173_line_separator,
            m173.m173_line_separator_id,
            m173.m173_skip_first_row,
            m173.m173_created_by_id_u17,
            u17_created_by.u17_full_name AS created_by_name,
            m173.m173_created_date,
            m173.m173_modified_by_id_u17,
            u17_modified_by.u17_full_name AS modified_by_name,
            m173.m173_modified_date,
            m173.m173_table_validated,
            CASE m173.m173_table_validated WHEN 1 THEN 'Yes' ELSE 'No' END
                AS is_validated,
            m173.m173_validated_by_id_u17,
            u17_validated_by.u17_full_name AS validated_by_name,
            m173.m173_validated_date,
            m173.m173_custom_type,
            m173.m173_institution_id_m02,
            m173.m173_db_proc_name,
            m173.m173_use_custom_proc,
            m173.m173_file_name,
               m173.m173_template_name
            || '_'
            || m173_file_type_id_v01
            || m173.m173_file_format
                AS file_name,
            m173.m173_is_automated_file
     FROM m173_data_loader_template m173
          JOIN u17_employee u17_created_by
              ON m173.m173_created_by_id_u17 = u17_created_by.u17_id
          LEFT JOIN u17_employee u17_modified_by
              ON m173.m173_modified_by_id_u17 = u17_modified_by.u17_id
          LEFT JOIN u17_employee u17_validated_by
              ON m173.m173_validated_by_id_u17 = u17_validated_by.u17_id
          LEFT JOIN v01_system_master_data v01
              ON     m173.m173_file_type_id_v01 = v01.v01_id
                 AND v01.v01_type = 72)
/