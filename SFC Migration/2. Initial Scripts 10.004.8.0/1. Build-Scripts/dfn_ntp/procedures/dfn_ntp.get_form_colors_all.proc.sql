CREATE OR REPLACE PROCEDURE dfn_ntp.get_form_color_all (
    p_updated_datetime   IN     VARCHAR2 DEFAULT NULL,
    p_broker_code        IN     VARCHAR2 DEFAULT NULL,
    p_country_code       IN     VARCHAR2 DEFAULT NULL,
    p_view                  OUT SYS_REFCURSOR,
    prows                   OUT NUMBER)
IS
    l_qry   VARCHAR2 (15000);
BEGIN
    l_qry :=
           'SELECT z04.* FROM (SELECT a.Z04_Z01_ID,
         a.Z04_SEQ_NO,
         a.Z04_CRITERIA,
         a.Z04_COLOR,
         a.Z04_COLUMN,
         a.Z04_TIME_STAMP,
         null as Z04_BROKER_CODE,
         2    as col_priority,
         a.z04_feature_id_v14
  FROM Z04_FORMS_COLOR a
WHERE z04_z01_id || ''--'' || Z04_CRITERIA NOT IN
      (SELECT z04_z01_id || ''--'' || Z04_CRITERIA
       FROM Z04_FORMS_COLOR_C
       WHERE Z04_BROKER_CODE in ('''
        || p_country_code
        || ''', '''
        || p_broker_code
        || '''))

UNION ALL
SELECT a.Z04_Z01_ID,
         a.Z04_SEQ_NO,
         a.Z04_CRITERIA,
         a.Z04_COLOR,
         a.Z04_COLUMN,
         a.Z04_TIME_STAMP,
         a.z04_broker_code,
         1 as col_priority,
         a.z04_feature_id_v14
FROM Z04_FORMS_COLOR_C a
WHERE a.z04_change_status <> 3
  AND Z04_BROKER_CODE = '''
        || p_country_code
        || '''
  AND z04_z01_id || ''--'' || Z04_CRITERIA NOT IN
      (SELECT z04_z01_id || ''--'' || Z04_CRITERIA
       FROM Z04_FORMS_COLOR_C
       WHERE Z04_BROKER_CODE = '''
        || p_broker_code
        || ''')

UNION ALL
SELECT a.Z04_Z01_ID,
         a.Z04_SEQ_NO,
         a.Z04_CRITERIA,
         a.Z04_COLOR,
         a.Z04_COLUMN,
         a.Z04_TIME_STAMP,
         a.z04_broker_code,
         1 as col_priority,
         a.z04_feature_id_v14
FROM Z04_FORMS_COLOR_C a
WHERE a.z04_change_status <> 3
  AND Z04_BROKER_CODE = '''
        || p_broker_code
        || ''') z04
LEFT JOIN
    v14_controllable_features v14
ON z04.z04_feature_id_v14 = v14.id
WHERE NVL(v14.enabled, 1) = 1';

    IF p_updated_datetime IS NOT NULL
    THEN
        l_qry :=
               l_qry
            || ' AND UPPER(Z04_Z01_ID) in
       ( SELECT Z01_ID FROM Z01_FORMS_M
       WHERE Z01_COLORS_UPDATED_DATETIME > TO_DATE ('''
            || p_updated_datetime
            || ''', ''dd/MM/yyyy hh24:mi:ss'')) ';
    END IF;

    l_qry := l_qry || ' order by Z04_Z01_ID';

    OPEN p_view FOR l_qry;
END;
/
