CREATE OR REPLACE PROCEDURE dfn_ntp.sp_get_file_processing_log (
    p_view               OUT SYS_REFCURSOR,
    prows                OUT NUMBER,
    pprocessid        IN     VARCHAR2,
    psortby           IN     VARCHAR2 DEFAULT NULL,
    pfromrownumber    IN     NUMBER DEFAULT NULL,
    ptorownumber      IN     NUMBER DEFAULT NULL,
    psearchcriteria   IN     VARCHAR2 DEFAULT NULL)
IS
    l_qry   VARCHAR2 (15000);
    s1      VARCHAR2 (15000);
    s2      VARCHAR2 (15000);
BEGIN
    l_qry :=
        'SELECT t81.t81_id,
       t81.t81_batch_id_t80,
       t80.m40_description AS file_process,
       t81.t81_date,
       to_char(t81.t81_date, ''MM/DD/YYYY  HH24:MI:SS'') AS t81_date_time,
       t81.t81_log_type,
       CASE
           WHEN t81.t81_log_type = 1 THEN ''Info''
           WHEN t81.t81_log_type = 2 THEN ''Success''
           WHEN t81.t81_log_type = 3 THEN ''Error''
       END
           AS log_type,
       t81.t81_description,
       t81.t81_custom_type
  FROM     t81_file_processing_log t81
       INNER JOIN
           vw_t80_file_processing_batches t80
       ON t80.t80_id = t81.t81_batch_id_t80
         Where t81_batch_id_t80 = ' || pprocessid;

    s1 :=
        fn_get_sp_data_query (psearchcriteria   => psearchcriteria,
                              psortby           => psortby,
                              ptorownumber      => ptorownumber,
                              pfromrownumber    => pfromrownumber,
                              l_qry             => l_qry);

    s2 := fn_get_sp_row_count_query (psearchcriteria, l_qry);

    OPEN p_view FOR s1;

    EXECUTE IMMEDIATE s2 INTO prows;
END;
/