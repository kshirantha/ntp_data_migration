CREATE OR REPLACE PROCEDURE dfn_ntp.sp_get_top_trade_sym_val (
    p_view            OUT SYS_REFCURSOR,
    prows             OUT NUMBER,
    psortby               VARCHAR2 DEFAULT NULL,
    pfromrownumber        NUMBER DEFAULT NULL,
    ptorownumber          NUMBER DEFAULT NULL,
    psearchcriteria       VARCHAR2 DEFAULT NULL,
    pinstituteid          NUMBER)
IS
    l_qry   VARCHAR2 (15000);
    s1      VARCHAR2 (15000);
    s2      VARCHAR2 (15000);
BEGIN
    prows := 0;
    l_qry :=
           'SELECT *
FROM (select *
from (select sum(abs(T02_AMNT_IN_STL_CURRENCY)) as traded_value, T02_SYMBOL_CODE_M20 as symbol, T02_SYMBOL_ID_M20
      from T02_TRANSACTION_LOG_ORDER_ALL
      where T02_CREATE_DATE between trunc(sysdate) and trunc(sysdate) + 0.9999 and
            T02_INST_ID_M02 = '||pinstituteid||'
      group by T02_SYMBOL_CODE_M20, T02_SYMBOL_ID_M20)
order by traded_value desc)
WHERE ROWNUM <= 10';

    s1 :=
        fn_get_sp_data_query (psearchcriteria,
                              l_qry,
                              psortby,
                              ptorownumber,
                              pfromrownumber);
    s2 := fn_get_sp_row_count_query (psearchcriteria, l_qry);

    OPEN p_view FOR s1;

    EXECUTE IMMEDIATE s2
        INTO prows;
END;
/

