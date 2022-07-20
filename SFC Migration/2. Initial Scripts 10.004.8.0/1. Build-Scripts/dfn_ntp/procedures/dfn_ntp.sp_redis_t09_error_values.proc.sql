CREATE OR REPLACE PROCEDURE dfn_ntp.sp_redis_t09_error_values (
    t09c_error    t09_txn_single_entry_v3%ROWTYPE,
    p_error       VARCHAR2)
IS
    i_values          CLOB;
    i_columns         CLOB;
    i_final_script    CLOB;
    i_query_string    CLOB;
    i_t09_audit_key   VARCHAR2 (1000);
BEGIN
    BEGIN
        i_t09_audit_key := t09c_error.t09_audit_key;

          --SELECT 'INSERT INTO '||'T09_TXN_SINGLE_ENTRY_V3' || ' ( '||LISTAGG(COLUMN_NAME, ', ') WITHIN GROUP (ORDER BY TABLE_NAME)||' ) ' INTO I_COLUMNS
          SELECT    'INSERT INTO '
                 || 'T09_TXN_SINGLE_ENTRY_V3'
                 || ' ( '
                 || SUBSTR (
                        XMLAGG (
                            XMLELEMENT (e, column_name, ', ').EXTRACT (
                                '//text()')).getclobval (),
                        0,
                          INSTR (
                              XMLAGG (
                                  XMLELEMENT (e, column_name, ', ').EXTRACT (
                                      '//text()')).getclobval (),
                              ',',
                              -1)
                        - 1)
                 || ' ) '
            INTO i_columns
            FROM user_tab_columns
           WHERE table_name = 'T09_TXN_SINGLE_ENTRY_V3'
        ORDER BY column_name;

          --SELECT 'SELECT '||'''''''''||t09c_error.'|| LISTAGG(COLUMN_NAME, ',') WITHIN GROUP (ORDER BY TABLE_NAME) || ' ||'''''''' FROM T09_TXN_SINGLE_ENTRY_V3 t09c_error WHERE T09_AUDIT_KEY = '''||I_T09_AUDIT_KEY||'''' INTO I_VALUES
          SELECT    'SELECT '
                 || '''''''''||t09c_error.'
                 || SUBSTR (
                        XMLAGG (
                            XMLELEMENT (e, column_name, ', ').EXTRACT (
                                '//text()')).getclobval (),
                        0,
                          INSTR (
                              XMLAGG (
                                  XMLELEMENT (e, column_name, ', ').EXTRACT (
                                      '//text()')).getclobval (),
                              ',',
                              -1)
                        - 1)
                 || ' ||'''''''' FROM T09_TXN_SINGLE_ENTRY_V3 t09c_error WHERE T09_AUDIT_KEY = '''
                 || i_t09_audit_key
                 || ''''
            INTO i_values
            FROM user_tab_columns
           WHERE table_name = 'T09_TXN_SINGLE_ENTRY_V3' --and COLUMN_NAME in ('T09_AUDIT_KEY', 'T09_CASH_BLK'
        --)
        ORDER BY column_name;

        i_values := REPLACE (i_values, ',', '||'''''',''''''||t09c_error.');

        i_final_script := i_values;

        EXECUTE IMMEDIATE (i_final_script) INTO i_query_string;

        i_query_string := i_columns || ' VALUES(' || i_query_string || ')';

        dfn_ntp.sp_redis_t09_error_insert (t09c_error,
                                           i_query_string,
                                           p_error);
    END;
END;
/