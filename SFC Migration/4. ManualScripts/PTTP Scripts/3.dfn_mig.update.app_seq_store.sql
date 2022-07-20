DECLARE
    l_table_pkey   VARCHAR2 (10);
    l_query        VARCHAR2 (4000);
    l_count        NUMBER;
BEGIN
    FOR i
        IN (  SELECT *
                FROM dfn_ntp.app_seq_store
               WHERE app_seq_name NOT IN
                         ('M71_INSTITUTE_RESTRICTIONS', 'Z07_MENU')
            ORDER BY app_seq_name)
    LOOP
        SELECT    SUBSTR (i.app_seq_name, 0, INSTR (i.app_seq_name, '_') - 1)
               || '_ID'
          INTO l_table_pkey
          FROM DUAL;

        SELECT COUNT (*)
          INTO l_count
          FROM all_tables
         WHERE     owner = UPPER ('dfn_ntp')
               AND table_name = UPPER (i.app_seq_name);

        IF l_count = 1
        THEN
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
        ELSE
            DELETE FROM dfn_ntp.app_seq_store
                  WHERE app_seq_name = i.app_seq_name;
      END IF;
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
