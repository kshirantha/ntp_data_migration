CREATE OR REPLACE PROCEDURE dfn_ntp.sp_get_corp_actions_report (
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
           'SELECT m141.m141_custodian_id_m26,
                   m26.m26_name,
                   m26.m26_sid,
                   m141.m141_exchange_code_m01,
                   m141.m141_symbol_code_m20,
                   m140.m140_description,
                   m140.m140_description_lang,
                   m141.m141_description,
                   m141.m141_ex_date,
                   m141.m141_pay_date,
                   m20.m20_currency_code_m03,
                   t41.t41_trading_acc_id_u07,
                   u01.u01_customer_no,
                   u01.u01_full_name,
                   u01.u01_full_name_lang,
                   u06.u06_investment_account_no,
                   u06.u06_currency_code_m03,
                   u07.u07_display_name,
                   t41.t41_hold_on_rec_date,
                   t41.t41_avg_cost_on_ex_date,
                   m141.m141_symbol_id_m20,
                   m141.m141_id,
                   t41.t41_id
              FROM m141_cust_corporate_action m141
                   JOIN m26_executing_broker m26
                       ON m141.m141_custodian_id_m26 = m26.m26_id
                   JOIN m140_corp_action_templates m140
                       ON m141.m141_template_id_m140 = m140.m140_id
                   JOIN m20_symbol m20
                       ON m141.m141_symbol_id_m20 = m20.m20_id
                   JOIN t41_cust_corp_act_distribution t41
                       ON m141.m141_id = t41.t41_cust_corp_act_id_m141
                   JOIN u07_trading_account u07
                       ON u07.u07_id = t41.t41_trading_acc_id_u07
                   JOIN u01_customer u01
                       ON u01.u01_id = u07.u07_customer_id_u01
                   JOIN u06_cash_account u06
                       ON u06.u06_id = u07.u07_cash_account_id_u06
             WHERE m141.m141_pay_date BETWEEN TO_DATE ('''
        || TO_CHAR (pfromdate, 'DD/MM/YYYY')
        || ''', ''DD/MM/YYYY'') AND TO_DATE ('''
        || TO_CHAR (ptodate, 'DD/MM/YYYY')
        || ''', ''DD/MM/YYYY'') + 0.99999 AND m141.m141_institute_id_m02 = '
        || pm141_institute_id_m02
        || CASE
               WHEN pu01_id IS NOT NULL THEN ' AND u01.u01_id = ' || pu01_id
               ELSE ''
           END
        || CASE
               WHEN pm20_id IS NOT NULL THEN ' AND m20.m20_id = ' || pm20_id
               ELSE ''
           END
        || CASE
               WHEN pm140_id IS NOT NULL
               THEN
                   ' AND m140.m140_id = ' || pm140_id
               ELSE
                   ''
           END
        || CASE
               WHEN pm26_id IS NOT NULL THEN ' AND m26.m26_id = ' || pm26_id
               ELSE ''
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
