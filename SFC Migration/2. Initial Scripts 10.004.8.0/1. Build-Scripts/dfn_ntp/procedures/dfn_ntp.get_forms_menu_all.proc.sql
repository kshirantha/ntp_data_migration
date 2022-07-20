CREATE OR REPLACE PROCEDURE dfn_ntp.get_form_menu_all (
    p_updated_datetime   IN     VARCHAR2 DEFAULT NULL,
    p_broker_code        IN     VARCHAR2 DEFAULT NULL,
    p_country_code       IN     VARCHAR2 DEFAULT NULL,
    p_view                  OUT SYS_REFCURSOR,
    prows                   OUT NUMBER)
IS
    l_qry   VARCHAR2 (15000);
BEGIN
    l_qry :=
           'SELECT z03.* FROM (SELECT a.Z03_Z01_ID,
         a.Z03_SEQ_NO,
         a.Z03_TEXT,
         a.Z03_TIME_STAMP,
         a.Z03_VISIBLE,
         a.Z03_PARENT_MENU,
         a.Z03_SEC_ID,
         null as Z03_BROKER_CODE,
         2    as col_priority,
         a.z03_feature_id_v14
  FROM Z03_FORMS_MENU a
WHERE z03_z01_id || ''--'' || Z03_TEXT NOT IN
      (SELECT z03_z01_id || ''--'' || Z03_TEXT
       FROM Z03_FORMS_MENU_C
       WHERE Z03_BROKER_CODE in ('''
        || p_country_code
        || ''', '''
        || p_broker_code
        || '''))

UNION ALL
SELECT a.Z03_Z01_ID,
         a.Z03_SEQ_NO,
         a.Z03_TEXT,
         a.Z03_TIME_STAMP,
         a.Z03_VISIBLE,
         a.Z03_PARENT_MENU,
         a.Z03_SEC_ID,
         a.z03_broker_code,
         1 as col_priority,
         a.z03_feature_id_v14
FROM Z03_FORMS_MENU_C a
WHERE a.z03_change_status <> 3
  AND Z03_BROKER_CODE = '''
        || p_country_code
        || '''
  AND Z03_Z01_ID || ''--'' || Z03_TEXT NOT IN
      (SELECT Z03_Z01_ID || ''--'' || Z03_TEXT
       FROM Z03_FORMS_MENU_C
       WHERE Z03_BROKER_CODE = '''
        || p_broker_code
        || ''')

UNION ALL
SELECT a.Z03_Z01_ID,
         a.Z03_SEQ_NO,
         a.Z03_TEXT,
         a.Z03_TIME_STAMP,
         a.Z03_VISIBLE,
         a.Z03_PARENT_MENU,
         a.Z03_SEC_ID,
         a.z03_broker_code,
         1 as col_priority,
         a.z03_feature_id_v14
FROM Z03_FORMS_MENU_C a
WHERE a.z03_change_status <> 3
  AND z03_broker_code = '''
        || p_broker_code
        || ''') z03
LEFT JOIN
    v14_controllable_features v14
ON z03.z03_feature_id_v14 = v14.id
WHERE NVL(v14.enabled, 1) = 1';

    IF p_updated_datetime IS NOT NULL
    THEN
        l_qry :=
               l_qry
            || ' AND UPPER(Z03_Z01_ID) in
       ( SELECT Z01_ID FROM Z01_FORMS_M
       WHERE Z01_MENUS_UPDATED_DATETIME > TO_DATE ('''
            || p_updated_datetime
            || ''', ''dd/MM/yyyy hh24:mi:ss'')) ';
    END IF;

    l_qry := l_qry || ' order by Z03_Z01_ID';

    OPEN p_view FOR l_qry;
END;
/
