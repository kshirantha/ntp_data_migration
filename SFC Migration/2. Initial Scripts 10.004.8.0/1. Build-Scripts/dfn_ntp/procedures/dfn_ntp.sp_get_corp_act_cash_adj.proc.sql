CREATE OR REPLACE PROCEDURE dfn_ntp.sp_get_corp_act_cash_adj (
    p_view                      OUT SYS_REFCURSOR,
    prows                       OUT NUMBER,
    psortby                  IN     VARCHAR2 DEFAULT NULL,
    pfromrownumber           IN     NUMBER DEFAULT NULL,
    ptorownumber             IN     NUMBER DEFAULT NULL,
    psearchcriteria          IN     VARCHAR2 DEFAULT NULL,
    pfromdate                IN     DATE DEFAULT SYSDATE,
    ptodate                  IN     DATE DEFAULT SYSDATE,
    pm141_institute_id_m02   IN     m141_cust_corporate_action.m141_institute_id_m02%TYPE,
    pu01_id                  IN     u01_customer.u01_id%TYPE DEFAULT NULL,
    pm20_id                  IN     m20_symbol.m20_id%TYPE DEFAULT NULL,
    pm140_id                 IN     m140_corp_action_templates.m140_id%TYPE DEFAULT NULL,
    pm26_id                  IN     m26_executing_broker.m26_id%TYPE DEFAULT NULL)
IS
    l_qry   VARCHAR2 (15000);
    s1      VARCHAR2 (15000);
    s2      VARCHAR2 (15000);
BEGIN
    l_qry :=
           'SELECT t43.t43_cust_distr_id_t41,
                   m143.m143_type,
                   CASE m143.m143_type
                       WHEN 1 THEN ''Charge''
                       WHEN 2 THEN ''Cash Adjustment''
                   END
                       AS cash_type,
                   t43.t43_adj_mode,
                   CASE m143.m143_adj_mode WHEN 1 THEN ''Pay'' WHEN 2 THEN ''Deduct'' END
                       AS adj_mode,
                   t43.t43_amnt_in_txn_currency,
                   t43.t43_fx_rate,
                   t43.t43_amnt_in_stl_currency,
                   t43.t43_tax_amount,
                   t43.t43_narration
              FROM t43_cust_corp_act_cash_adjust t43
                   JOIN m141_cust_corporate_action m141
                       ON t43.t43_cust_corp_act_id_m141 = m141.m141_id
                   JOIN u06_cash_account u06
                       ON t43.t43_cash_account_id_u06 = u06.u06_id
                   JOIN m143_corp_act_cash_adjustments m143
                       ON t43.t43_corp_act_adj_id_m143 = m143.m143_id
             WHERE m141.m141_pay_date BETWEEN TO_DATE ('''
        || TO_CHAR (pfromdate, 'DD/MM/YYYY')
        || ''', ''DD/MM/YYYY'') AND TO_DATE ('''
        || TO_CHAR (ptodate, 'DD/MM/YYYY')
        || ''', ''DD/MM/YYYY'') + 0.99999 AND m141.m141_institute_id_m02 = '
        || pm141_institute_id_m02
        || CASE
               WHEN pu01_id IS NOT NULL
               THEN
                   ' AND u06.u06_customer_id_u01 = ' || pu01_id
               ELSE
                   ''
           END
        || CASE
               WHEN pm20_id IS NOT NULL
               THEN
                   ' AND m141.m141_symbol_id_m20 = ' || pm20_id
               ELSE
                   ''
           END
        || CASE
               WHEN pm140_id IS NOT NULL
               THEN
                   ' AND m141.m141_template_id_m140 = ' || pm140_id
               ELSE
                   ''
           END
        || CASE
               WHEN pm26_id IS NOT NULL
               THEN
                   ' AND m141.m141_custodian_id_m26 = ' || pm26_id
               ELSE
                   ''
           END;

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
