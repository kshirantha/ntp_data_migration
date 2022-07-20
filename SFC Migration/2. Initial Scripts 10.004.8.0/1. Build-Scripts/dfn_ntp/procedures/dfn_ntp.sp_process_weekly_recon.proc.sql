CREATE OR REPLACE PROCEDURE dfn_ntp.sp_process_weekly_recon (
    p_status                         OUT NUMBER,
    p_exchange_code               IN     VARCHAR,
    p_file_date                   IN     VARCHAR,
    p_processed_by                IN     NUMBER,
    p_primary_institution_id      IN     NUMBER DEFAULT 1,
    p_automated_file_processing   IN     NUMBER DEFAULT 0,
    p_auto_approve                IN     NUMBER DEFAULT 0,
    p_batch_id                    IN     NUMBER)
IS
    l_file_date                DATE;
    l_pending_items            NUMBER;
    l_pending_item_id          NUMBER;
    l_error_reason             VARCHAR2 (4000);
    l_approval_level           NUMBER;
    l_batch_id                 NUMBER;
    l_default_custodian        NUMBER;
    l_current_approval_level   NUMBER;
    l_next_status              NUMBER;
    l_status                   NUMBER;
    l_count                    NUMBER;
BEGIN
    l_file_date := TO_DATE (p_file_date, 'DD-MON-YYYY');

    SELECT m88_approval_levels
      INTO l_approval_level
      FROM m88_function_approval
     WHERE m88_function = 'WEEKLY_RECONCILIATION';

    l_current_approval_level := 0;

    l_status := 1;

    SELECT DECODE (l_approval_level, 0, 2, 101) INTO l_next_status FROM DUAL;

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

    FOR i IN (  SELECT *
                  FROM (SELECT detail.u01_id,
                               detail.u01_display_name,
                               detail.u01_customer_no,
                               detail.u24_trading_acnt_id_u07,
                               detail.u07_exchange_id_m01,
                               NVL (detail.u24_custodian_id_m26,
                                    l_default_custodian)
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
                                        AND detail.u07_exchange_account_no
                                                IS NULL
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
                                       'Matched'
                                   WHEN     detail.equator_no IS NOT NULL
                                        AND detail.u07_exchange_account_no
                                                IS NOT NULL
                                        AND detail.current_balance_diff <> 0
                                   THEN
                                       'Not Matched'
                                   WHEN     detail.equator_no IS NOT NULL
                                        AND detail.u07_exchange_account_no
                                                IS NULL
                                   THEN
                                       'Not in OMS'
                                   WHEN     detail.equator_no IS NULL
                                        AND detail.u07_exchange_account_no
                                                IS NOT NULL
                                   THEN
                                       'Not in File'
                                   ELSE
                                       'Error'
                               END
                                   AS status
                          FROM (SELECT oms.u01_id,
                                       oms.u01_display_name,
                                       oms.u01_customer_no,
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
                                       NVL (e03.current_balance, 0)
                                           AS file_current_balance,
                                       NVL (oms.current_holding, 0)
                                           AS oms_current_balance,
                                         NVL (e03.current_balance, 0)
                                       - NVL (oms.current_holding, 0)
                                           AS current_balance_diff,
                                       NVL (e03.available_balance, 0)
                                           AS file_available_balance,
                                       NVL (oms.available_holdings, 0)
                                           AS oms_available_balance,
                                         NVL (e03.available_balance, 0)
                                       - NVL (oms.available_holdings, 0)
                                           AS available_balance_diff,
                                       NVL (e03.pledge_qty, 0)
                                           AS file_pledge_qty,
                                       NVL (oms.u24_pledge_qty, 0)
                                           AS oms_pledge_qty,
                                         NVL (e03.pledge_qty, 0)
                                       - NVL (oms.u24_pledge_qty, 0)
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
                                                   u01.u01_display_name
                                              FROM u24_holdings u24
                                                   JOIN (SELECT u07_id,
                                                                u07_exchange_id_m01,
                                                                u07_exchange_code_m01,
                                                                u07_exchange_account_no,
                                                                u07_customer_id_u01,
                                                                u07_institute_id_m02,
                                                                NVL (
                                                                    u07_custodian_id_m26,
                                                                    l_default_custodian)
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
                                                   JOIN m125_exchange_instrument_type m125
                                                       ON     m125.m125_instrument_type_id_v09 =
                                                                  m20.m20_instrument_type_id_v09
                                                          AND m125.m125_exchange_id_m01 =
                                                                  m20.m20_exchange_id_m01
                                             WHERE u24_exchange_code_m01 =
                                                       p_exchange_code) oms
                                       ON     e03.equator_no =
                                                  oms.u07_exchange_account_no
                                          AND e03.symbol =
                                                  oms.u24_symbol_code_m20
                                 WHERE     e03.primary_institute_id =
                                               p_primary_institution_id
                                       AND e03.batch_id = p_batch_id) detail)
                 WHERE status_id = -4
              ORDER BY ABS (current_balance_diff) DESC)
    LOOP
        SELECT COUNT (*), MAX (t23.t23_id)
          INTO l_pending_items, l_pending_item_id
          FROM t23_share_txn_requests t23
         WHERE     t23.t23_file_symbol = i.symbol
               AND t23.t23_exchange_acc_no = i.equator_no
               AND t23.t23_position_date = i.position_date
               AND t23.t23_exchange_id_m01 = i.u07_exchange_id_m01
               AND t23.t23_status_id_v01 IN
                       (1,
                        2,
                        101,
                        102,
                        103,
                        104,
                        105,
                        106,
                        107,
                        108,
                        109,
                        110);

        IF l_pending_items = 0
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
                                           t23_no_of_approval,
                                           t23_is_approval_completed,
                                           t23_current_approval_level,
                                           t23_next_status,
                                           t23_primary_institute_id_m02,
                                           t23_is_auto_file_processing)
            VALUES (seq_t23_id.NEXTVAL,
                    p_batch_id,
                    2,
                    p_batch_id,
                    i.u07_exchange_id_m01,
                    l_status,
                    0,
                    i.position_date,
                    i.change_date,
                    l_file_date,
                    SYSDATE,
                    p_processed_by,
                    i.symbol,
                    i.u24_symbol_id_m20,
                    i.equator_no,
                    i.u24_trading_acnt_id_u07,
                    i.u24_custodian_id_m26,
                    i.investor_id,
                    i.file_current_balance,
                    i.file_available_balance,
                    i.file_pledge_qty,
                    i.current_balance_diff,
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
        VALUES (seq_t86_id.NEXTVAL,                                   --t86_id
                SYSDATE,                                    --t86_created_date
                NULL,                                        --t86_description
                2,                                              --t86_txn_type
                1,                                         --t86_status_id_v01
                p_processed_by,                 --t86_status_changed_by_id_u17
                SYSDATE,                             --t86_status_changed_date
                1,                                           --t86_custom_type
                p_primary_institution_id,       --t86_primary_institute_id_m02
                NULL,                                               --t86_type
                p_processed_by,                              --t86_user_id_u17
                NULL,                                      --t86_position_date
                0,                                        -- t86_attempt_count
                p_batch_id);
    END IF;

    UPDATE u53_process_detail
       SET u53_status_id_v01 = 18,
           u53_failed_reason = NULL,
           u53_updated_by_id_u17 = p_processed_by,
           u53_updated_date_time = SYSDATE
     WHERE     u53_code = 'WEEKLY'
           AND u53_primary_institute_id_m02 = p_primary_institution_id;

    p_status := l_count;
EXCEPTION
    WHEN OTHERS
    THEN
        l_error_reason := SUBSTR (SQLERRM, 1, 512);

        UPDATE u53_process_detail
           SET u53_failed_reason =
                   'File Processing Failed - ' || l_error_reason,
               u53_updated_by_id_u17 = p_processed_by,
               u53_updated_date_time = SYSDATE
         WHERE     u53_code = 'WEEKLY'
               AND u53_primary_institute_id_m02 = p_primary_institution_id;

        p_status := -1;
END;
/