CREATE OR REPLACE PROCEDURE dfn_ntp.sp_interest_index_inquiry (
    p_view            OUT SYS_REFCURSOR,
    prows             OUT NUMBER,
    psortby               VARCHAR2 DEFAULT NULL,
    pfromrownumber        NUMBER DEFAULT NULL,
    ptorownumber          NUMBER DEFAULT NULL,
    psearchcriteria       VARCHAR2 DEFAULT NULL,
    pfromdate             DATE DEFAULT SYSDATE,
    ptodate               DATE DEFAULT SYSDATE)
IS
    l_qry   VARCHAR2 (4000);
    s1      VARCHAR2 (4000);
    s2      VARCHAR2 (4000);
BEGIN
    prows := 0;

    l_qry :=
           'SELECT h13_date,
       h13_type,
       type_description,
       h13_description,
       h13_rate,
       h13_institution_id_m02
  FROM (SELECT TRUNC (SYSDATE) AS h13_date,
               m65.m65_type AS h13_type,
               CASE m65.m65_type
                   WHEN 1 THEN ''SAIBOR''
                   WHEN 2 THEN ''BASIS''
                   WHEN 3 THEN ''SIBOR''
                   WHEN 4 THEN ''LIBOR''
               END
                   AS type_description,
               m65.m65_description AS h13_description,
               m65.m65_rate AS h13_rate,
               m65.m65_institution_id_m02 AS h13_institution_id_m02
          FROM m65_saibor_basis_rates m65
        UNION ALL
        SELECT h13.h13_date,
               h13.h13_type,
               CASE h13.h13_type
                   WHEN 1 THEN ''SAIBOR''
                   WHEN 2 THEN ''BASIS''
                   WHEN 3 THEN ''SIBOR''
                   WHEN 4 THEN ''LIBOR''
               END
                   AS type_description,
               h13.h13_description,
               h13.h13_rate,
               h13.h13_institution_id_m02
          FROM h13_interest_indices_history h13)
 WHERE h13_date BETWEEN TO_DATE (
                                                        '''
        || TO_CHAR (pfromdate, 'DD-MM-YYYY')
        || ''',
                                                        ''DD-MM-YYYY''
                                                    )
                                                AND  TO_DATE (
                                                         '''
        || TO_CHAR (ptodate, 'DD-MM-YYYY')
        || ''',
                                                         ''DD-MM-YYYY''
                                                     )
                                                     + .99999';

    s1 :=
        fn_get_sp_data_query (psearchcriteria,
                              l_qry,
                              psortby,
                              ptorownumber,
                              pfromrownumber);
    s2 := fn_get_sp_row_count_query (psearchcriteria, l_qry);



    OPEN p_view FOR s1;

    EXECUTE IMMEDIATE s2 INTO prows;
END;
/