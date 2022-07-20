CREATE OR REPLACE PROCEDURE dfn_ntp.get_form_columns_all (
    p_updated_datetime   IN     VARCHAR2 DEFAULT NULL,
    p_broker_code        IN     VARCHAR2 DEFAULT NULL,
    p_country_code       IN     VARCHAR2 DEFAULT NULL,
    p_view                  OUT SYS_REFCURSOR,
    prows                   OUT NUMBER)
IS
    l_qry   VARCHAR2 (15000);
BEGIN
    l_qry :=
           'SELECT z02.* FROM (SELECT a.z02_z01_id,
       a.z02_mapping_name,
       a.z02_column_name,
       a.z02_width,
       a.z02_alignment,
       a.z02_format,
       a.z02_seq_no,
       a.z02_visible,
       a.z02_translatable,
       a.z02_show_by_default,
       a.z02_force_default_formatting,
       a.z02_adjust_gmt,
       a.z02_format_based_on_currency,
       a.z02_currency_field_name,
       a.z02_show_total,
       a.z02_fixed_filter_value,
       a.z02_min_filter_length,
       a.z02_show_in_filter,
       a.z02_column_type,
       NULL AS z02_broker_code,
       2    AS col_priority,
       a.z02_feature_id_v14
FROM z02_forms_cols a
WHERE z02_z01_id || ''--'' || z02_mapping_name NOT IN
      (SELECT z02_z01_id || ''--'' || z02_mapping_name
       FROM z02_forms_cols_c
       WHERE z02_broker_code in ('''
        || p_country_code
        || ''', '''
        || p_broker_code
        || '''))

UNION ALL
SELECT a.z02_z01_id,
       a.z02_mapping_name,
       a.z02_column_name,
       a.z02_width,
       a.z02_alignment,
       a.z02_format,
       a.z02_seq_no,
       a.z02_visible,
       a.z02_translatable,
       a.z02_show_by_default,
       a.z02_force_default_formatting,
       a.z02_adjust_gmt,
       a.z02_format_based_on_currency,
       a.z02_currency_field_name,
       a.z02_show_total,
       a.z02_fixed_filter_value,
       a.z02_min_filter_length,
       a.z02_show_in_filter,
       a.z02_column_type,
       a.z02_broker_code,
       1 AS col_priority,
       a.z02_feature_id_v14
FROM z02_forms_cols_c a
WHERE a.z02_change_status <> 3
  AND z02_broker_code = '''
        || p_country_code
        || '''
  AND z02_z01_id || ''--'' || z02_mapping_name NOT IN
      (SELECT z02_z01_id || ''--'' || z02_mapping_name
       FROM z02_forms_cols_c
       WHERE z02_broker_code = '''
        || p_broker_code
        || ''')

UNION ALL
SELECT a.z02_z01_id,
       a.z02_mapping_name,
       a.z02_column_name,
       a.z02_width,
       a.z02_alignment,
       a.z02_format,
       a.z02_seq_no,
       a.z02_visible,
       a.z02_translatable,
       a.z02_show_by_default,
       a.z02_force_default_formatting,
       a.z02_adjust_gmt,
       a.z02_format_based_on_currency,
       a.z02_currency_field_name,
       a.z02_show_total,
       a.z02_fixed_filter_value,
       a.z02_min_filter_length,
       a.z02_show_in_filter,
       a.z02_column_type,
       a.z02_broker_code,
       1 AS col_priority,
       a.z02_feature_id_v14
FROM z02_forms_cols_c a
WHERE a.z02_change_status <> 3
  AND z02_broker_code = '''
        || p_broker_code
        || ''') z02
LEFT JOIN
    v14_controllable_features v14
ON z02.z02_feature_id_v14 = v14.id
WHERE NVL(v14.enabled, 1) = 1';

    IF p_updated_datetime IS NOT NULL
    THEN
        l_qry :=
               l_qry
            || ' AND UPPER(z02_z01_id) in
       ( SELECT Z01_ID FROM Z01_FORMS_M
       WHERE Z01_COLUMNS_UPDATED_DATETIME > TO_DATE ('''
            || p_updated_datetime
            || ''', ''dd/MM/yyyy hh24:mi:ss'')) ';
    END IF;

    l_qry := l_qry || ' order by z02_z01_id';

    OPEN p_view FOR l_qry;
END;
/
