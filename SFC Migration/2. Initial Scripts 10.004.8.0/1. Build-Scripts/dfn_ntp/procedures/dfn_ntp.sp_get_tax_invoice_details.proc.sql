CREATE OR REPLACE PROCEDURE dfn_ntp.sp_get_tax_invoice_details (
    p_view              OUT SYS_REFCURSOR,
    prows               OUT NUMBER,
    p_decimals       IN     NUMBER DEFAULT 5,
    p_invoiceno      IN     VARCHAR2,
    p_institute_id   IN     NUMBER)
IS
    lcount     NUMBER;
    lformat    VARCHAR (100);
    l_status   NUMBER;
    l_qry      VARCHAR (15000);
    s1         VARCHAR2 (15000);
    s2         VARCHAR2 (15000);
BEGIN
    lformat := '9,999';
    lcount := 0;

    IF (p_decimals > 0)
    THEN
        lformat := lformat || '.';

        WHILE (lcount < p_decimals)
        LOOP
            lformat := lformat || '9';
            lcount := lcount + 1;
        END LOOP;
    END IF;

    l_qry :=
           'SELECT ROWNUM AS rownumber,
       tot.description,
       tot.description_lang,
       tot.create_date,
       tot.row_count,
       ROUND(tot.total_vat/(tot.amnt_in_stl_currency - tot.total_vat),2) AS vat_per,
        ROUND (tot.amnt_in_stl_currency - tot.total_vat,'
        || p_decimals
        || ')  AS total_price,
       ROUND (tot.total_vat,'
        || p_decimals
        || ') AS total_vat,
       ROUND (tot.amnt_in_stl_currency,'
        || p_decimals
        || ') AS amnt_in_stl_currency,
        tot.t02_txn_code,
        tot.address,
        tot.address_lang,
        tot.tax_ref,
        tot.vat_no,
        tot.u01_display_name,
        tot.u01_display_name_lang,
        '''
        || p_invoiceno
        || ''' AS invoice_no,
        tot.settle_currency
  FROM (  SELECT MAX (m97.m97_description) AS description,
                 MAX (m97.m97_description_lang) AS description_lang,
                 MIN (t02.t02_create_date) AS create_date,
                 CASE
                     WHEN MAX (t02.t02_update_type) = 1
                     THEN
                         COUNT (t02.t02_order_no)
                     ELSE
                         COUNT (t02.t02_last_db_seq_id)
                 END
                     AS row_count,
                 t02.t02_txn_code,
                 MAX (u01.u01_tax_ref) AS tax_ref,
                 MAX (m02.m02_vat_no) AS vat_no,
                 SUM (ABS (t02.t02_amnt_in_stl_currency))
                     AS amnt_in_stl_currency,
                 SUM (t02_broker_tax + t02_exchange_tax) AS total_vat,
                 MAX (u01.u01_display_name) AS u01_display_name,
                 MAX (u01.u01_display_name_lang) AS u01_display_name_lang,
                    NVL (MAX (u02.u02_po_box), '''')
                 || CASE WHEN MAX (u02.u02_po_box) IS NULL THEN '''' ELSE '','' END
                 || NVL (MAX (u02.u02_address_line1), '''')
                 || CASE WHEN MAX (u02.u02_address_line1) IS NULL THEN '''' ELSE '','' END
                 || NVL (MAX (u02.u02_address_line2), '''')
                 || CASE WHEN MAX (u02.u02_address_line2) IS NULL THEN '''' ELSE '','' END
                 || NVL (MAX (u02.u02_zip_code), '''')
                     AS address,
                    NVL (MAX (u02.u02_po_box), '''')
                 || CASE WHEN MAX (u02.u02_po_box) IS NULL THEN '''' ELSE '','' END
                 || NVL (MAX (u02.u02_address_line1_lang), '''')
                 || CASE WHEN MAX (u02.u02_address_line1_lang) IS NULL THEN '''' ELSE '','' END
                 || NVL (MAX (u02.u02_address_line2_lang), '''')
                 || CASE WHEN MAX (u02.u02_address_line2_lang) IS NULL THEN '''' ELSE '','' END
                 || NVL (MAX (u02.u02_zip_code), '''') AS address_lang,
                 MAX(t02.t02_settle_currency) AS settle_currency
            FROM t49_tax_invoice_details t49
                 LEFT JOIN t02_transaction_log_all t02
                     ON t49.t49_last_db_seq_id_t02 = t02.t02_last_db_seq_id
                 LEFT JOIN t48_tax_invoices t48
                     ON t49.t49_invoice_no_t48 = t48.t48_id
                 LEFT JOIN u01_customer u01
                     ON t48.t48_customer_id_u01 = u01.u01_id
                 LEFT JOIN m97_transaction_codes m97
                     ON t49.t49_txn_code = m97.m97_code
                 LEFT JOIN u02_customer_contact_info u02
                     ON u01.u01_id = u02.u02_customer_id_u01 AND u02_is_default = 1
                 LEFT JOIN m02_institute m02 ON t48.t48_institute_id_m02 = m02.m02_id
           WHERE  t48.t48_institute_id_m02 = '
        || p_institute_id
        || ' AND t49.t49_invoice_no_t48 = '''
        || p_invoiceno
        || ''' GROUP BY t02_txn_code, t02.t02_order_no, t02.t02_create_date) tot ORDER BY tot.create_date';
    s1 :=
        fn_get_sp_data_query (psearchcriteria   => NULL,
                              psortby           => NULL,
                              ptorownumber      => NULL,
                              pfromrownumber    => NULL,
                              l_qry             => l_qry);

    s2 := fn_get_sp_row_count_query (psearchcriteria => NULL, l_qry => l_qry);

    OPEN p_view FOR s1;

    EXECUTE IMMEDIATE s2 INTO prows;
END;
/
