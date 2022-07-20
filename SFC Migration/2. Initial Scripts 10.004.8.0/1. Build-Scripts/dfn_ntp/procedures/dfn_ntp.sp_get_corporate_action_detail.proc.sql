CREATE OR REPLACE PROCEDURE dfn_ntp.sp_get_corporate_action_detail (
     p_view                        OUT SYS_REFCURSOR,
    prows                         OUT NUMBER,
    psortby                    IN     VARCHAR2 DEFAULT NULL, -- Corporate Action Specific Default NULL
    pfromrownumber             IN     NUMBER,
    ptorownumber               IN     NUMBER,
    pfromdate                  IN     DATE DEFAULT NULL, -- Corporate Action Specific Default NULL
    ptodate                    IN     DATE DEFAULT NULL, -- Corporate Action Specific Default NULL
    psearchcriteria            IN     VARCHAR2 DEFAULT NULL,
    p_position_date            IN     VARCHAR,
    p_primary_institution_id   IN     VARCHAR,
    p_batch_id                 IN     NUMBER DEFAULT 0,
    p_routed_from_batches      IN     NUMBER DEFAULT 0)
IS
    l_position_date       DATE;
    l_default_custodian   NUMBER;
    l_qry                 VARCHAR2 (15000);
    s1                    VARCHAR2 (15000);
    s2                    VARCHAR2 (15000);
    s3                    VARCHAR2 (15000);
    l_missmatched_count   NUMBER;
    l_log_pkey            NUMBER;
BEGIN
    l_position_date := TO_DATE (p_position_date, 'DD-MON-YYYY');

    SELECT m43_custodian_id_m26
      INTO l_default_custodian
      FROM m43_institute_exchanges
     WHERE     m43_institute_id_m02 = p_primary_institution_id
           AND m43_exchange_code_m01 = 'TDWL';

    l_qry :=
           'SELECT *
             FROM (SELECT detail.*,
                         CASE
                             WHEN detail.current_balance_difference = 0 THEN 1
                             ELSE -1
                         END
                             AS status_id,
                         CASE
                             WHEN detail.current_balance_difference = 0
                             THEN
                                 ''Matched''
                             ELSE
                                 ''Not Matched''
                         END
                             AS status
                    FROM (SELECT ca.*,
                                 ca.u07_id AS trading_account_id,
                                 NVL (ca.u07_custodian_id_m26,'
        || l_default_custodian
        || ')
                                     AS custodian_id,
                                    NVL(qty.net_holdings,0) AS oms_current_balance,
                                    ca.file_current_balance - NVL(qty.net_holdings,0)
                                    AS current_balance_difference
                            FROM     (SELECT u01.u01_display_name,
                                             u01.u01_customer_no,
                                             u01.u01_external_ref_no,
                                             e01.symbol,
                                             e01.investor_id,
                                             e01.equator_no,
                                             e01.isin,
                                             e01.current_balance
                                                 AS file_current_balance,
                                             e01.available_balance
                                                 AS file_available_balance,
                                             e01.pledge_qty AS file_pledge_qty,
                                             e01.position_date,
                                             e01.change_date,
                                             u07.u07_id,
                                             u07.u07_exchange_id_m01,
                                             u07.u07_custodian_id_m26,
                                             m20.m20_id AS symbol_id
                                        FROM vw_t33_corporate_actions e01
                                             LEFT JOIN u07_trading_account u07
                                                 ON e01.equator_no =
                                                        u07.u07_exchange_account_no
                                             INNER JOIN m02_institute m02
                                                 ON u07.u07_institute_id_m02 =
                                                        m02.m02_id
                                             LEFT JOIN m20_symbol m20
                                                 ON     e01.symbol =
                                                            m20.m20_symbol_code
                                                           and m20.m20_exchange_code_m01=''TDWL''
                                                    AND m20_institute_id_m02 = '
        || p_primary_institution_id
        || ' LEFT JOIN u01_customer u01
                                                 ON u07.u07_customer_id_u01 =
                                                        u01.u01_id
                                       WHERE     e01.primary_institute_id = '
        || p_primary_institution_id
        || ' AND m02.m02_primary_institute_id_m02 ='
        || p_primary_institution_id
        || ' ) ca
                                 LEFT JOIN
                                     (select * from (SELECT TRUNC (SYSDATE) AS position_date,
                                             u24.u24_symbol_code_m20
                                                 AS symbol_code,
                                             u24.u24_trading_acnt_id_u07
                                                 AS trading_account_id,
                                             (  u24.u24_net_holding
                                              + u24.u24_payable_holding
                                              - u24.u24_receivable_holding)
                                                 AS net_holdings
                                        FROM u24_holdings u24
                                             JOIN u07_trading_account u07
                                                 ON u24.u24_trading_acnt_id_u07 =
                                                        u07.u07_id
                                             INNER JOIN m02_institute m02
                                                 ON u07.u07_institute_id_m02 =
                                                        m02.m02_id
                                       WHERE     u24.u24_exchange_code_m01 =
                                                     ''TDWL'' -- Corporate Action File is Specific to TDWL
                                                      AND TRUNC (SYSDATE) = TO_DATE('''
        || TO_CHAR (l_position_date, 'DD-MM-YYYY')
        || ''', ''DD-MM-YYYY'')
                                             AND m02.m02_primary_institute_id_m02 = '
        || p_primary_institution_id
        || ' UNION ALL
                                      SELECT h01.h01_date AS position_date,
                                             h01.h01_symbol_code_m20
                                                 AS symbol_code,
                                             h01.h01_trading_acnt_id_u07
                                                 AS trading_account_id,
                                             (  h01.h01_net_holding
                                              + h01.h01_payable_holding
                                              - h01.h01_receivable_holding)
                                                 AS net_holdings
                                        FROM vw_h01_holding_summary h01
                                             JOIN u07_trading_account u07
                                                 ON h01.h01_trading_acnt_id_u07 =
                                                        u07.u07_id
                                             INNER JOIN m02_institute m02
                                                 ON u07.u07_institute_id_m02 =
                                                        m02.m02_id
                                       WHERE     h01.h01_exchange_code_m01 =
                                                     ''TDWL'' -- Corporate Action File is Specific to TDWL
                                             AND m02.m02_primary_institute_id_m02 = '
        || p_primary_institution_id
        || ' AND h01.h01_date =
        TO_DATE('''
        || TO_CHAR (l_position_date, 'DD-MM-YYYY')
        || ''', ''DD-MM-YYYY'')
        )  history where   history.position_date =
        TO_DATE('''
        || TO_CHAR (l_position_date, 'DD-MM-YYYY')
        || ''', ''DD-MM-YYYY'')) qty
                                 ON     ca.u07_id = qty.trading_account_id(+)
                                    AND ca.symbol = qty.symbol_code(+)) detail )
        ORDER BY ABS (current_balance_difference) DESC';

    s3 := 'SELECT COUNT(*) FROM (' || l_qry || ') WHERE status_id = -1 ';

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