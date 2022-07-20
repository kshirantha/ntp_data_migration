CREATE OR REPLACE PROCEDURE dfn_ntp.sp_get_weekly_recon_detail (
    p_view                        OUT SYS_REFCURSOR,
    prows                         OUT NUMBER,
    psortby                    IN     VARCHAR2 DEFAULT NULL, -- Corporate Action Specific Default NULL
    pfromrownumber             IN     NUMBER,
    ptorownumber               IN     NUMBER,
    pfromdate                  IN     DATE DEFAULT NULL, -- Corporate Action Specific Default NULL
    ptodate                    IN     DATE DEFAULT NULL, -- Corporate Action Specific Default NULL
    psearchcriteria            IN     VARCHAR2 DEFAULT NULL,
    p_exchange_code            IN     VARCHAR,
    p_primary_institution_id   IN     NUMBER DEFAULT 1,
    p_batch_id                 IN     NUMBER,
    p_routed_from_batches      IN     NUMBER DEFAULT 0)
IS
    l_default_custodian   NUMBER;
    l_broker_id           NUMBER;
    l_qry                 VARCHAR2 (15000);
    s1                    VARCHAR2 (15000);
    s2                    VARCHAR2 (15000);
    s3                    VARCHAR2 (15000);
    l_missmatched_count   NUMBER;
    l_log_pkey            NUMBER;
BEGIN
    SELECT m43_custodian_id_m26
      INTO l_default_custodian
      FROM m43_institute_exchanges
     WHERE     m43_institute_id_m02 = p_primary_institution_id
           AND m43_exchange_code_m01 = 'TDWL';

    SELECT m150_id
      INTO l_broker_id
      FROM m150_broker
     WHERE m150_primary_institute_id_m02 = p_primary_institution_id;

    l_qry :=
           'SELECT *
            FROM (SELECT detail.u01_id,
                         detail.u01_display_name,
                         detail.u01_customer_no,
                         detail.u01_external_ref_no,
                         detail.u24_trading_acnt_id_u07,
                         detail.u07_exchange_id_m01,
                         NVL (detail.u24_custodian_id_m26, '
        || l_default_custodian
        || ')
                             AS u24_custodian_id_m26,
                         NVL (detail.symbol, detail.u24_symbol_code_m20)
                             AS symbol,
                         detail.u24_symbol_id_m20,
                         detail.investor_id,
                         NVL (detail.equator_no,
                              detail.u07_exchange_account_no)
                             AS equator_no,
                         NVL (detail.isin, detail.m20_isincode) AS isin,
                         detail.file_current_balance,
                         detail.oms_current_balance,
                         detail.current_balance_diff,
                         detail.file_available_balance,
                         detail.oms_available_balance,
                         detail.available_balance_diff,
                         detail.file_pledge_qty,
                         detail.oms_pledge_qty,
                         detail.pledged_qty_dif,
                         detail.position_date,
                         detail.change_date,
                         CASE
                             WHEN     detail.equator_no IS NOT NULL
                                  AND detail.u07_exchange_account_no
                                          IS NOT NULL
                                  AND detail.current_balance_diff = 0
                             THEN
                                 0
                             WHEN     detail.equator_no IS NOT NULL
                                  AND detail.u07_exchange_account_no
                                          IS NOT NULL
                                  AND detail.current_balance_diff <> 0
                             THEN
                                 -4
                             WHEN     detail.equator_no IS NOT NULL
                                  AND detail.u07_exchange_account_no IS NULL
                             THEN
                                 -3
                             WHEN     detail.equator_no IS NULL
                                  AND detail.u07_exchange_account_no
                                          IS NOT NULL
                             THEN
                                 -2
                             ELSE
                                 -1
                         END
                             AS status_id,
                         CASE
                             WHEN     detail.equator_no IS NOT NULL
                                  AND detail.u07_exchange_account_no
                                          IS NOT NULL
                                  AND detail.current_balance_diff = 0
                             THEN
                                 ''Matched''
                             WHEN     detail.equator_no IS NOT NULL
                                  AND detail.u07_exchange_account_no
                                          IS NOT NULL
                                  AND detail.current_balance_diff <> 0
                             THEN
                                 ''Not Matched''
                             WHEN     detail.equator_no IS NOT NULL
                                  AND detail.u07_exchange_account_no IS NULL
                             THEN
                                 ''Not in OMS''
                             WHEN     detail.equator_no IS NULL
                                  AND detail.u07_exchange_account_no
                                          IS NOT NULL
                             THEN
                                 ''Not in File''
                             ELSE
                                 ''Error''
                         END
                             AS status
                    FROM (SELECT oms.u01_id,
                                 oms.u01_display_name,
                                 oms.u01_customer_no,
                                 oms.u01_external_ref_no,
                                 oms.u24_trading_acnt_id_u07,
                                 oms.u07_exchange_id_m01,
                                 oms.u24_custodian_id_m26,
                                 oms.u07_exchange_account_no,
                                 oms.u24_symbol_id_m20,
                                 oms.u24_symbol_code_m20,
                                 oms.m20_isincode,
                                 e03.symbol,
                                 e03.investor_id,
                                 e03.equator_no,
                                 e03.isin,
                                 e03.current_balance AS file_current_balance,
                                 oms.current_holding AS oms_current_balance,
                                 e03.current_balance - oms.current_holding
                                     AS current_balance_diff,
                                 e03.available_balance
                                     AS file_available_balance,
                                 oms.available_holdings
                                     AS oms_available_balance,
                                 e03.available_balance - oms.available_holdings
                                     AS available_balance_diff,
                                 e03.pledge_qty AS file_pledge_qty,
                                 oms.u24_pledge_qty AS oms_pledge_qty,
                                 e03.pledge_qty - oms.u24_pledge_qty
                                     AS pledged_qty_dif,
                                 e03.position_date,
                                 e03.change_date
                            FROM     vw_t32_weekly_reconciliation e03
                                 FULL JOIN
                                     (SELECT u24.u24_trading_acnt_id_u07,
                                             u24.u24_symbol_id_m20,
                                             u24.u24_symbol_code_m20,
                                             m20.m20_isincode,
                                             u24.u24_custodian_id_m26,
                                             u24.u24_pledge_qty,
                                             (  u24.u24_net_holding
                                              - DECODE (
                                                    m125.m125_allow_sell_unsettle_hold,
                                                    1, 0,
                                                    u24.u24_receivable_holding)
                                              - u24.u24_manual_block
                                              - u24.u24_pledge_qty
                                              - u24.u24_holding_block)
                                                 AS available_holdings,
                                             (  u24.u24_net_holding
                                              + u24.u24_payable_holding
                                              - u24.u24_receivable_holding)
                                                 AS current_holding,
                                             u07.u07_id,
                                             u07.u07_exchange_id_m01,
                                             u07.u07_exchange_code_m01,
                                             u07.u07_exchange_account_no,
                                             u01.u01_id,
                                             u01.u01_customer_no,
                                             u01.u01_external_ref_no,
                                             u01.u01_display_name
                                        FROM u24_holdings u24
                                             JOIN (SELECT u07_id,
                                                         u07_exchange_id_m01,
                                                         u07_exchange_code_m01,
                                                         u07_exchange_account_no,
                                                         u07_customer_id_u01,
                                                         u07_institute_id_m02,
                                                         NVL (u07_custodian_id_m26, '
        || l_default_custodian
        || ')
                                                             AS u07_custodian_id_m26
                                                    FROM u07_trading_account) u07
                                                 ON     u24.u24_trading_acnt_id_u07 =
                                                            u07.u07_id
                                                    AND u24.u24_exchange_code_m01 =
                                                            u07.u07_exchange_code_m01
                                                    AND u07.u07_custodian_id_m26 =
                                                        u24.u24_custodian_id_m26
                                             JOIN u01_customer u01
                                                 ON u07.u07_customer_id_u01 =
                                                        u01.u01_id
                                             JOIN m20_symbol m20
                                                 ON u24.u24_symbol_id_m20 =
                                                        m20.m20_id
                                             JOIN m02_institute m02
                                                 ON u07.u07_institute_id_m02 =
                                                        m02.m02_id
                                             JOIN m125_exchange_instrument_type m125
                                                 ON     m125.m125_instrument_type_id_v09 =
                                                            m20.m20_instrument_type_id_v09
                                                    AND m125.m125_exchange_id_m01 =
                                                            m20.m20_exchange_id_m01
                                       WHERE     m02.m02_broker_id_m150 = '
        || l_broker_id
        || ' AND u24_exchange_code_m01 = '''
        || p_exchange_code
        || ''') oms
                                 ON     e03.equator_no =
                                            oms.u07_exchange_account_no
                                    AND e03.symbol = oms.u24_symbol_code_m20
                           WHERE e03.primary_institute_id = '
        || p_primary_institution_id
        || ' AND e03.batch_id = '
        || p_batch_id
        || ') detail)
        ORDER BY status_id, ABS (current_balance_diff) DESC';


    s3 := 'SELECT COUNT(*) FROM (' || l_qry || ') WHERE status_id = -4 ';

    EXECUTE IMMEDIATE s3 INTO l_missmatched_count;

    IF p_routed_from_batches = 0
	
    THEN
	
        IF l_missmatched_count = 0
        THEN
            UPDATE t80_file_processing_batches
               SET t80_status_id_v01 = 17,
                   t80_status_changed_date = SYSDATE,
                   t80_mismatch = 0,
                   t80_description =
                       'All records reconciled no mismatches found'
             WHERE t80_id = p_batch_id;

            sp_add_t81_batch_logs (
                p_key           => l_log_pkey,
                p_batch_id      => p_batch_id,
                p_log_type      => 2,
                p_log_message   => 'All records reconciled no mismatches found');
        ELSE
            UPDATE t80_file_processing_batches
               SET t80_mismatch = 1,
                   t80_description =
                          'Records are not reconciled ['
                       || l_missmatched_count
                       || ' ] mismatches found'
             WHERE t80_id = p_batch_id;

            sp_add_t81_batch_logs (
                p_key           => l_log_pkey,
                p_batch_id      => p_batch_id,
                p_log_type      => 2,
                p_log_message   =>    'Records are not reconciled ['
                                   || l_missmatched_count
                                   || ' ] mismatches found');
        END IF;
    END IF;

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
