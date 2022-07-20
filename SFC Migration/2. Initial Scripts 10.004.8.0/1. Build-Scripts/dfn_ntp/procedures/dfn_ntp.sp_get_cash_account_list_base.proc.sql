CREATE OR REPLACE PROCEDURE dfn_ntp.sp_get_cash_account_list_base (
    p_view                  OUT SYS_REFCURSOR,
    prows                   OUT NUMBER,
    psortby                     VARCHAR2 DEFAULT NULL,
    pfromrownumber              NUMBER DEFAULT NULL,
    ptorownumber                NUMBER DEFAULT NULL,
    psearchcriteria             VARCHAR2 DEFAULT NULL,
    puserid                     NUMBER DEFAULT NULL,
    pcashaccountid              NUMBER DEFAULT NULL,
    p_user_filter_enabled       NUMBER DEFAULT NULL)
IS
    l_qry   VARCHAR2 (15000);
    s1      VARCHAR2 (15000);
    s2      VARCHAR2 (15000);
BEGIN
    prows := 0;
    l_qry :=
           'SELECT u06.u06_id,
       u06.u06_institute_id_m02,
       u06.u06_customer_id_u01,
       u06.u06_customer_no_u01,
       u06.u06_display_name_u01,
       u06.u06_default_id_no_u01,
       u06.u06_currency_code_m03,
       u06.u06_currency_id_m03,
       u06.u06_balance,
       CASE WHEN u06_balance + u06_payable_blocked - u06_receivable_amount - u06_loan_amount < 0  THEN ABS (u06_balance + u06_payable_blocked - u06_receivable_amount - u06_loan_amount) ELSE 0 END
           AS od_margin_utilized,
       u06.u06_blocked,
       u06.u06_payable_blocked,
       u06.u06_manual_trade_blocked,
       u06.u06_manual_full_blocked,
       u06.u06_manual_transfer_blocked,
       u06.u06_receivable_amount,
       u06.u06_is_default,
       CASE WHEN u06_is_default = 1 THEN ''Yes'' ELSE ''No'' END AS is_default,
       u06.u06_created_date,
       u06.u06_status_id_v01,
       status.v01_description AS status,
       u06.u06_margin_product_id_u23,
       m73.m73_name AS margin_product,
       m73.m73_product_type,
       u06.u06_display_name,
       u06.u06_margin_enabled,
        CASE u06.u06_margin_enabled WHEN 1 THEN ''Yes'' WHEN 2 THEN ''Expired'' ELSE ''No'' END
           AS margin_enabled,
       m02.m02_name AS institute_name,
       u01.u01_external_ref_no,
       u06.u06_external_ref_no,
       u06.u06_primary_od_limit,
       u06.u06_primary_start,
       u06.u06_primary_expiry,
       u06.u06_secondary_od_limit,
       u06.u06_secondary_start,
       u06.u06_secondary_expiry,
       u06.u06_investment_account_no,
       m77.m77_name AS symbol_marginability_group,
       u06.u06_pending_withdraw,
       u06.u06_pending_deposit,
       u06.cash_for_withdraw,
       u06.od_limit_today,
       u06.u06_balance + u06.u06_payable_blocked - u06.u06_receivable_amount
           AS balance,
           u06.u06_accrued_interest AS interest,
       --fn_get_interest_for_cash_acc (u06.u06_id) AS interest,
       u06.u06_account_type_v01,
       CASE u06.u06_account_type_v01
           WHEN 1 THEN ''Investment''
           WHEN 2 THEN ''Share Finance''
           WHEN 3 THEN ''Mutual Fund''
       END
           AS account_type,
       u06.u06_inactive_drmnt_status_v01,
       CASE u06.u06_inactive_drmnt_status_v01
           WHEN 11 THEN dormnt_status.v01_description
           WHEN 12 THEN dormnt_status.v01_description
           ELSE ''''
       END
           AS dormant_status,
       u06.u06_net_receivable,
       u06.u06_status_changed_reason,
        u06.u06_margin_block,
         u06.u06_margin_due,
         u06.u06_blocked + u06.u06_manual_transfer_blocked + u06.u06_manual_full_blocked AS total_block_amount,
       bs.v01_description AS block_status
  FROM vw_u06_cash_account_base u06
       JOIN m02_institute m02
           ON u06.u06_institute_id_m02 = m02.m02_id
       JOIN u01_customer u01
           ON u06.u06_customer_id_u01 = u01.u01_id
       LEFT JOIN vw_status_list status
           ON u06.u06_status_id_v01 = status.v01_id
       LEFT JOIN u23_customer_margin_product u23
           ON u06.u06_margin_product_id_u23 = u23.u23_id
       LEFT JOIN m77_symbol_marginability_grps m77
           ON u23.u23_sym_margin_group_m77 = m77.m77_id
       LEFT JOIN vw_status_list dormnt_status
           ON u06.u06_inactive_drmnt_status_v01 = dormnt_status.v01_id
       LEFT JOIN m73_margin_products m73
           ON u23.u23_margin_product_m73 = m73.m73_id
       LEFT JOIN vw_block_status_list_b bs
           ON u01.u01_block_status_b = bs.v01_id'
        || fn_get_cash_acc_filter (
               pcash_column            => 'u06_id',
               ptab_alies              => 'u06',
               puser_id                => puserid,
               p_user_filter_enabled   => p_user_filter_enabled)
        || CASE
               WHEN pcashaccountid IS NOT NULL
               THEN
                   ' WHERE u06.u06_id = ' || pcashaccountid
               ELSE
                   ' '
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