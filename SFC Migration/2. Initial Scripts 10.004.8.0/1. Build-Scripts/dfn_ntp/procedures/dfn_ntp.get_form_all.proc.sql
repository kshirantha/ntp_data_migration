CREATE OR REPLACE PROCEDURE dfn_ntp.get_form_all (
    p_updated_datetime   IN     VARCHAR2 DEFAULT NULL,
    p_broker_code        IN     VARCHAR2 DEFAULT NULL,
    p_country_code       IN     VARCHAR2 DEFAULT NULL,
    p_view                  OUT SYS_REFCURSOR,
    prows                   OUT NUMBER)
IS
    l_qry   VARCHAR2 (15000);
BEGIN
    l_qry :=
           'SELECT z01.* FROM(SELECT a.z01_id,
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
           a.z01_source_type, a.z01_ignore_sort,
           a.z01_load_data_on_opening,
           a.z01_fully_loaded, a.z01_updated_datetime,
           a.z01_broker_code,
           a.z01_custom_type,
           a.z01_is_customized,
           a.z01_feature_id_v14
        FROM z01_forms_m a
        WHERE z01_tag NOT IN
             (SELECT z01_tag
              FROM z01_forms_m_c
              WHERE z01_broker_code in ('''
        || p_country_code
        || ''', '''
        || p_broker_code
        || '''))

        UNION ALL
             SELECT nvl(b.z01_id, a.z01_id),
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
                   a.z01_source_type, a.z01_ignore_sort,
                   a.z01_load_data_on_opening,
                   a.z01_fully_loaded, a.z01_updated_datetime,
                   a.z01_broker_code,
                   a.z01_custom_type,
                   a.z01_is_customized,
                   a.z01_feature_id_v14
              FROM z01_forms_m_c a, z01_forms_m b
              WHERE a.z01_broker_code = '''
        || p_country_code
        || '''
             AND a.Z01_TAG = b.Z01_TAG(+)
             AND a.z01_tag NOT IN
             (SELECT z01_tag
              FROM z01_forms_m_c
              WHERE z01_broker_code = '''
        || p_broker_code
        || ''')

        UNION ALL
             SELECT nvl(b.z01_id, a.z01_id),
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
                   a.z01_source_type, a.z01_ignore_sort,
                   a.z01_load_data_on_opening,
                   a.z01_fully_loaded, a.z01_updated_datetime,
                   a.z01_broker_code,
                   a.z01_custom_type,
                   a.z01_is_customized,
                   a.z01_feature_id_v14
              FROM z01_forms_m_c a, z01_forms_m b
             WHERE a.z01_broker_code = '''
        || p_broker_code
        || ''' AND a.Z01_TAG = b.Z01_TAG(+)) z01
    LEFT JOIN
        v14_controllable_features v14
    ON z01.z01_feature_id_v14 = v14.id
    WHERE NVL(v14.enabled, 1) = 1';

    IF p_updated_datetime IS NOT NULL
    THEN
        l_qry :=
               l_qry
            || ' and z01_updated_datetime > to_date('''
            || p_updated_datetime
            || ''',''dd/MM/yyyy hh24:mi:ss'')';
    END IF;

    OPEN p_view FOR l_qry;
END;
/
