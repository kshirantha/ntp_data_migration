CREATE OR REPLACE PROCEDURE dfn_ntp.sp_get_swap_monthly_report (
    p_view            OUT SYS_REFCURSOR,
    prows             OUT NUMBER,
    psortby               VARCHAR2 DEFAULT NULL,
    pfromrownumber        NUMBER DEFAULT NULL,
    ptorownumber          NUMBER DEFAULT NULL,
    psearchcriteria       VARCHAR2 DEFAULT NULL,
    pfromdate             DATE DEFAULT SYSDATE,
    ptodate               DATE DEFAULT SYSDATE)
IS
    l_qry   VARCHAR2 (10000);
    s1      VARCHAR2 (15000);
    s2      VARCHAR2 (15000);
BEGIN
    prows := 0;
    l_qry :=
           'SELECT h01.h01_date, u01.u01_full_name, u01.u01_full_name_lang,
    u01.u01_full_name as ownercode, u01.u01_full_name_lang as ownercode_lang,
         u01.u01_customer_no, '''' AS descriptionofother,
         m20.m20_symbol_code,
          m20.m20_symbol_code || ''-'' || m20.m20_short_description AS securitycode,
           m20.m20_symbol_code || ''-'' || m20.m20_short_description_lang AS securitycode_lang,
           acctype,
           CASE
           WHEN acctype = ''Individual'' THEN acctype
           WHEN acctype = ''Corporate'' THEN u01.client_type
           END AS investertype,
           CASE
           WHEN acctype = ''Individual'' THEN c2.m05_name
           WHEN acctype = ''Corporate'' THEN c1.m05_name
           END AS investercountry,
           SUM (h01.h01_net_holding) AS h01_net_holdings,
            NVL (u02.u02_po_box, '''') || CASE WHEN u02.u02_po_box IS NULL THEN '''' ELSE '','' END
            || NVL(u02.u02_address_line1, '''') || CASE WHEN u02.u02_address_line1 IS NULL THEN '''' ELSE '','' END
            || NVL (u02.u02_address_line2, '''') || CASE WHEN u02.u02_address_line2 IS NULL THEN '''' ELSE '','' END
            || NVL (u02.u02_zip_code, '''') AS cusaddress, m02.m02_code
 FROM vw_h01_holding_summary h01,(SELECT CASE WHEN a.u01_corp_client_type_id_v01 = 1  THEN ''Company''
         WHEN a.u01_corp_client_type_id_v01 = 2 THEN ''Government''
         WHEN a.u01_corp_client_type_id_v01 = 3 THEN ''Institution'' END AS client_type,
     CASE WHEN a.u01_account_category_id_v01 = 1 THEN ''Individual''
        -- WHEN a.u01_account_category_id_v01 = 1 THEN ''Joint''
         WHEN a.u01_account_category_id_v01 = 2 THEN ''Corporate'' END AS acctype,
     a.* FROM u01_customer a) u01, u07_trading_account u07, m20_symbol m20,u02_customer_contact_info u02,
        m05_country c1,  m05_country c2, m02_institute m02
     WHERE u01.u01_id = u07.u07_customer_id_u01
        AND u07.u07_id = h01.h01_trading_acnt_id_u07
        AND u01.u01_swap_master = 1
        AND u01.u01_birth_country_id_m05 = c1.m05_id(+)
        AND u01.u01_nationality_id_m05 = c2.m05_id(+)
        AND h01.h01_symbol_id_m20 = m20.m20_id
        AND u01.u01_id = u02.u02_customer_id_u01
        AND u01.u01_institute_id_m02 = m02.m02_id
        AND u02.u02_is_default = 1
       AND h01.h01_date BETWEEN TO_DATE('''
        || TO_CHAR (pfromdate, ' DD - MM - YYYY ')
        || ''' ,
        ''DD - MM - YYYY '') AND
       TO_DATE(
       '''
        || TO_CHAR (pfromdate, ' DD - MM - YYYY ')
        || ''' ,
        '' DD - MM - YYYY '') + 0.99999
       GROUP BY u01_customer_no,
         m20.m20_symbol_code,
         u01.u01_full_name_lang,
         u01.u01_full_name,
         m20.m20_short_description,
         m20.m20_short_description_lang,
         acctype,
         c1.m05_name,
         c2.m05_name,
         client_type,
         u02.u02_po_box,
         u02.u02_address_line1,
         u02.u02_address_line2,
         u02.u02_zip_code,
         u01.u01_corp_client_type_id_v01,
         h01_date,
         m02.m02_code

ORDER BY u01.u01_customer_no, m20_symbol_code';

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
