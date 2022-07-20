CREATE OR REPLACE FUNCTION dfn_ntp.fn_get_max_txn_stl_date_diff
    RETURN NUMBER
IS
    l_max_txn_stl_date_diff   NUMBER (10);
BEGIN
    SELECT NVL (MAX (v00_value), 10)
      INTO l_max_txn_stl_date_diff
      FROM v00_sys_config
     WHERE v00_key = 'MAX_TXN_STL_DATE_DIFF';

    RETURN l_max_txn_stl_date_diff;
END;
/
