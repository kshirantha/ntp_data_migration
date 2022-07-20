
CREATE OR REPLACE PROCEDURE dfn_ntp.sp_process_corporate_action (
    p_status                         OUT NUMBER,
    p_txn_type                    IN     NUMBER,
    p_ca_type                     IN     NUMBER DEFAULT NULL,
    p_last_trade_price            IN     NUMBER,
    p_file_date                   IN     VARCHAR,
    p_other_symbol                IN     NUMBER,
    p_processed_by                IN     NUMBER,
    p_process_forcefully          IN     NUMBER,
    p_primary_institution_id      IN     NUMBER,
    p_automated_file_processing   IN     NUMBER DEFAULT 0,
    p_auto_approve                IN     NUMBER DEFAULT 0,
    p_batch_id                    IN     NUMBER)
IS
    l_file_date                DATE;
    l_weekly_file_count        NUMBER;
    l_weekly_file_status       NUMBER;
    l_proceed_processing       NUMBER := 0;
    l_approved_items           NUMBER;
    l_pending_items            NUMBER;
    l_pending_item_id          NUMBER;
    l_error_reason             VARCHAR2 (4000);
    l_approval_level           NUMBER;

    l_default_custodian        NUMBER;
    l_current_approval_level   NUMBER;
    l_next_status              NUMBER;
    l_status                   NUMBER;
    l_count                    NUMBER;
BEGIN
    l_file_date := TO_DATE (p_file_date, 'DD-MON-YYYY');

    /* SELECT COUNT (*)
       INTO l_weekly_file_count
       FROM u53_process_detail u53
      WHERE     u53.u53_code = 'CA_LOCAL'
            AND TRUNC (u53.u53_position_date) >= p_file_date;

     IF l_weekly_file_count > 0
     THEN
         SELECT u53.u53_status_id_v01
           INTO l_weekly_file_status
           FROM u53_process_detail u53
          WHERE     u53.u53_code = 'CA_LOCAL'
                AND TRUNC (u53.u53_position_date) >= p_file_date;

         IF p_process_forcefully = 1
         THEN
             l_proceed_processing := 1;
         ELSE
             IF l_weekly_file_status = 18
             THEN
                 p_status := -2;
                 RETURN;
             ELSE
                 p_status := -3;
                 RETURN;
             END IF;
         END IF;
     ELSE
         l_proceed_processing := 1;
     END IF;*/

    l_proceed_processing := 1;

    SELECT m88_approval_levels
      INTO l_approval_level
      FROM m88_function_approval
     WHERE m88_function = 'CA_TDWL_REQUEST';

    l_current_approval_level := 0;

    l_status := 1;



    IF p_auto_approve = 1
    THEN
        l_status := 2;
        l_current_approval_level := 2;
        l_next_status := 2;
    END IF;

    SELECT m43_custodian_id_m26
      INTO l_default_custodian
      FROM m43_institute_exchanges
     WHERE     m43_institute_id_m02 = p_primary_institution_id
           AND m43_exchange_code_m01 = 'TDWL';

    l_count := 0;


    IF l_proceed_processing = 1
    THEN
        FOR i
            IN (  SELECT *
                    FROM (SELECT detail.*,
                                 CASE
                                     WHEN detail.current_balance_difference =
                                              0
                                     THEN
                                         1
                                     ELSE
                                         -1
                                 END
                                     AS status_id,
                                 CASE
                                     WHEN detail.current_balance_difference =
                                              0
                                     THEN
                                         'Matched'
                                     ELSE
                                         'Not Matched'
                                 END
                                     AS status
                            FROM (SELECT ca.*,
                                         ca.u07_id AS trading_account_id,
                                         NVL (ca.u07_custodian_id_m26,
                                              l_default_custodian)
                                             AS custodian_id,
                                         NVL (qty.net_holdings, 0)
                                             AS oms_current_balance,
                                           ca.file_current_balance
                                         - NVL (qty.net_holdings, 0)
                                             AS current_balance_difference
                                    FROM     (SELECT u01.u01_display_name,
                                                     u01.u01_customer_no,
                                                     e01.symbol,
                                                     e01.investor_id,
                                                     e01.equator_no,
                                                     e01.isin,
                                                     e01.current_balance
                                                         AS file_current_balance,
                                                     e01.available_balance
                                                         AS file_available_balance,
                                                     e01.pledge_qty
                                                         AS file_pledge_qty,
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
                                                     LEFT JOIN m20_symbol m20
                                                         ON     e01.symbol =
                                                                    m20.m20_symbol_code
                                                            AND m20.m20_exchange_code_m01 =
                                                                    'TDWL'
                                                     LEFT JOIN u01_customer u01
                                                         ON u07.u07_customer_id_u01 =
                                                                u01.u01_id
                                               WHERE     e01.primary_institute_id =
                                                             p_primary_institution_id
                                                     AND e01.batch_id =
                                                             p_batch_id
                                                     AND m20.m20_institute_id_m02 =
                                                             p_primary_institution_id) ca
                                         LEFT JOIN
                                             (SELECT TRUNC (SYSDATE)
                                                         AS position_date,
                                                     u24.u24_symbol_code_m20
                                                         AS symbol_code,
                                                     u24.u24_trading_acnt_id_u07
                                                         AS trading_account_id,
                                                     (  u24.u24_net_holding
                                                      + u24.u24_payable_holding
                                                      - u24.u24_receivable_holding)
                                                         AS net_holdings
                                                FROM     u24_holdings u24
                                                     JOIN
                                                         u07_trading_account u07
                                                     ON u24.u24_trading_acnt_id_u07 =
                                                            u07.u07_id
                                               WHERE     u24.u24_exchange_code_m01 =
                                                             'TDWL' -- Corporate Action File is Specific to TDWL
                                                     AND TRUNC (SYSDATE) =
                                                             l_file_date
                                              UNION ALL
                                              SELECT h01_date
                                                         AS position_date,
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
                                                             'TDWL' -- Corporate Action File is Specific to TDWL
                                                     AND m02_primary_institute_id_m02 =
                                                             p_primary_institution_id
                                                     AND h01_date =
                                                             l_file_date) qty
                                         ON     ca.u07_id =
                                                    qty.trading_account_id
                                            AND ca.symbol = qty.symbol_code) detail)
                   WHERE     status_id = -1
                         AND (   (101 = 102 AND current_balance_difference < 0)
                              OR (101 <> 102 AND current_balance_difference > 0))
                ORDER BY ABS (current_balance_difference) DESC)
        LOOP
            /*  SELECT COUNT (*), MAX (t23.t23_id)
                INTO l_pending_items, l_pending_item_id
                FROM t23_share_txn_requests t23
               WHERE     t23.t23_file_symbol = i.symbol
                     AND t23.t23_exchange_acc_no = i.equator_no
                     AND t23.t23_position_date = i.position_date
                     AND t23.t23_reference = p_ca_type
                     AND t23.t23_status_id_v01 IN
                             (1,
                              101,
                              102,
                              103,
                              104,
                              105,
                              106,
                              107,
                              108,
                              109,
                              110);*/

            IF i.trading_account_id IS NOT NULL
            THEN
                l_count := l_count + 1;

                INSERT
                  INTO t23_share_txn_requests (t23_id,
                                               t23_batch_id,
                                               t23_type,
                                               t23_reference,
                                               t23_exchange_id_m01,
                                               t23_status_id_v01,
                                               t23_processed_forcefully,
                                               t23_position_date,
                                               t23_changed_date,
                                               t23_upload_date,
                                               t23_processed_date,
                                               t23_processed_by_id_u17,
                                               t23_file_symbol,
                                               t23_symbol_id_m20,
                                               t23_exchange_acc_no,
                                               t23_trading_acc_id_u07,
                                               t23_custodian_id_m26,
                                               t23_investor_id,
                                               t23_file_current_balance,
                                               t23_file_available_balance,
                                               t23_file_pledge_quantity,
                                               t23_current_balance_difference,
                                               t23_last_trade_price,
                                               t23_other_symbol_id_m20,
                                               t23_no_of_approval,
                                               t23_is_approval_completed,
                                               t23_current_approval_level,
                                               t23_next_status,
                                               t23_primary_institute_id_m02,
                                               t23_is_auto_file_processing)
                VALUES (seq_t23_id.NEXTVAL,
                        p_batch_id,
                        p_txn_type,
                        p_ca_type,
                        i.u07_exchange_id_m01,
                        l_status,
                        p_process_forcefully,
                        i.position_date,
                        i.change_date,
                        l_file_date,
                        SYSDATE,
                        p_processed_by,
                        i.symbol,
                        i.symbol_id,
                        i.equator_no,
                        i.trading_account_id,
                        i.custodian_id,
                        i.investor_id,
                        i.file_current_balance,
                        i.file_available_balance,
                        i.file_pledge_qty,
                        i.current_balance_difference,
                        p_last_trade_price,
                        p_other_symbol,
                        l_approval_level,
                        DECODE (l_approval_level, 0, 1, 0),
                        l_current_approval_level,
                        l_next_status,
                        p_primary_institution_id,
                        p_automated_file_processing);
            END IF;
        END LOOP;

        IF p_auto_approve = 1 AND l_count > 0
        THEN
            INSERT
              INTO t86_bulk_cash_holding_process (t86_id,
                                                  t86_created_date,
                                                  t86_description,
                                                  t86_txn_type,
                                                  t86_status_id_v01,
                                                  t86_status_changed_by_id_u17,
                                                  t86_status_changed_date,
                                                  t86_custom_type,
                                                  t86_primary_institute_id_m02,
                                                  t86_type,
                                                  t86_user_id_u17,
                                                  t86_position_date,
                                                  t86_attempt_count,
                                                  t86_batch_id_t80)
            VALUES (seq_t86_id.NEXTVAL,                               --t86_id
                    SYSDATE,                                --t86_created_date
                    NULL,                                    --t86_description
                    1,                                          --t86_txn_type
                    1,                                     --t86_status_id_v01
                    p_processed_by,             --t86_status_changed_by_id_u17
                    SYSDATE,                         --t86_status_changed_date
                    1,                                       --t86_custom_type
                    p_primary_institution_id,   --t86_primary_institute_id_m02
                    p_ca_type,                                      --t86_type
                    p_processed_by,                          --t86_user_id_u17
                    NULL,                                  --t86_position_date
                    0,                                    -- t86_attempt_count
                    p_batch_id);
        END IF;

        UPDATE u53_process_detail
           SET u53_status_id_v01 = 18,
               u53_failed_reason = NULL,
               u53_updated_by_id_u17 = p_processed_by,
               u53_updated_date_time = SYSDATE
         WHERE     u53_code = 'CA_LOCAL'
               AND u53_primary_institute_id_m02 = p_primary_institution_id;

        p_status := l_count;
    END IF;
EXCEPTION
    WHEN OTHERS
    THEN
        l_error_reason := SUBSTR (SQLERRM, 1, 512);

        UPDATE u53_process_detail
           SET u53_failed_reason =
                   'File Processing Failed - ' || l_error_reason,
               u53_updated_by_id_u17 = p_processed_by,
               u53_updated_date_time = SYSDATE
         WHERE     u53_code = 'CA_LOCAL'
               AND u53_primary_institute_id_m02 = p_primary_institution_id;

        p_status := -1;
END;
/
