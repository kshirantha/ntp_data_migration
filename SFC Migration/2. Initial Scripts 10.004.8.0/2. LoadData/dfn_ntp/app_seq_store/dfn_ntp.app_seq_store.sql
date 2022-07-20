DECLARE
    l_table_pkey   VARCHAR2 (10);
    l_query        VARCHAR2 (4000);
BEGIN
    FOR i IN (  SELECT *
                  FROM dfn_ntp.app_seq_store
                 WHERE app_seq_refresh = 1
              ORDER BY app_seq_name)
    LOOP
        SELECT    SUBSTR (i.app_seq_name, 0, INSTR (i.app_seq_name, '_') - 1)
               || '_ID'
          INTO l_table_pkey
          FROM DUAL;

        l_query :=
               'UPDATE dfn_ntp.app_seq_store
                       SET app_seq_value =
                               (SELECT NVL (MAX ('
            || l_table_pkey
            || '), 0) FROM dfn_ntp.'
            || i.app_seq_name
            || ')
                     WHERE app_seq_name = '''
            || i.app_seq_name
            || '''';

        EXECUTE IMMEDIATE l_query;
    END LOOP;
END;
/

COMMIT;

UPDATE dfn_ntp.app_seq_store
   SET app_seq_value = (SELECT NVL (MAX (z07_pkey), 0) FROM dfn_ntp.z07_menu)
 WHERE app_seq_name = 'Z07_MENU';

UPDATE dfn_ntp.app_seq_store
   SET app_seq_value =
           (SELECT NVL (MAX (m71_restriction_id), 0)
              FROM dfn_ntp.m71_institute_restrictions)
 WHERE app_seq_name = 'M71_INSTITUTE_RESTRICTIONS';

COMMIT;
