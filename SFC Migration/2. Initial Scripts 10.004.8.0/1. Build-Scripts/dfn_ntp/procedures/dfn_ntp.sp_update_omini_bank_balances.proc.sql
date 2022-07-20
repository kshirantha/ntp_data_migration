CREATE OR REPLACE PROCEDURE dfn_ntp.sp_update_omini_bank_balances (
    pdate     DATE DEFAULT func_get_eod_date,
    pinstid   NUMBER DEFAULT 1,
    peod      NUMBER DEFAULT 0)
IS
    l_has_entries            NUMBER := 0;
    l_has_adjusted_entries   NUMBER := 0;
    i_t05_rec_count          NUMBER := 0;
    i_sequence               NUMBER (18);
BEGIN
    SELECT COUNT (*)
    INTO l_has_entries
    FROM t02_transaction_log_cash_all t02
    WHERE     t02.t02_inst_id_m02 = pinstid
          AND (   t02.t02_create_date BETWEEN TRUNC (pdate)
                                          AND TRUNC (pdate) + 0.99999
               OR t02.t02_cash_settle_date BETWEEN TRUNC (pdate)
                                               AND TRUNC (pdate) + 0.99999);

    IF (l_has_entries > 0 AND peod = 0)
    THEN
        SELECT COUNT (1)
        INTO i_t05_rec_count
        FROM t05_institute_cash_acc_log t05
        WHERE     t05_institute_id_m02 = pinstid
              AND t05.t05_settle_date BETWEEN TRUNC (pdate)
                                          AND TRUNC (pdate) + .99999;

        IF (i_t05_rec_count > 0) -- Roleback Bank Accounts Cash Blance If It Has Run More Than 1 Time
        THEN
            FOR i
                IN (SELECT t05_institute_bank_id_m93,
                           NVL (SUM (t05_amnt_in_stl_currency), 0) --t05_amnt_in_stl_currency  --t02_amnt_in_txn_currency
                                                                  AS adjustable_balance
                    FROM t05_institute_cash_acc_log t05
                    WHERE     t05_institute_id_m02 = pinstid
                          AND /*t05_txn_date_time*/
                              t05_settle_date BETWEEN TRUNC (pdate)
                                                  AND TRUNC (pdate) + .99999
                    GROUP BY t05.t05_institute_bank_id_m93)
            LOOP
                UPDATE m93_bank_accounts m93
                SET m93_balance = (m93_balance - i.adjustable_balance)
                WHERE m93_id = i.t05_institute_bank_id_m93;
            END LOOP;

            DELETE FROM t05_institute_cash_acc_log
            WHERE     t05_institute_id_m02 = pinstid
                  AND /*t05_txn_date_time*/
                      t05_settle_date BETWEEN TRUNC (pdate)
                                          AND TRUNC (pdate) + .99999;

            COMMIT;
            i_t05_rec_count := 0;
        END IF;

        FOR i
            IN (SELECT t02_inst_id_m02,
                       NVL (
                           SUM (
                               (CASE
                                    WHEN t02.t02_txn_code IN ('STLBUY')
                                    THEN
                                        t02.t02_ord_value_adjst
                                    ELSE
                                        0
                                END)),
                           0)
                           AS buy_settle,
                       NVL (
                           SUM (
                               (CASE
                                    WHEN t02.t02_txn_code IN ('STLSEL')
                                    THEN
                                        t02.t02_ord_value_adjst
                                    ELSE
                                        0
                                END)),
                           0)
                           AS sel_settle,
                       NVL (SUM (t02.t02_exg_commission), 0)
                           AS exchange_commission,
                       NVL (
                             SUM (t02.t02_cum_commission)
                           - SUM (t02.t02_exg_commission),
                           0)
                           AS broker_commission,
                       NVL (SUM (t02.t02_broker_tax), 0)
                           AS broker_vat,
                       NVL (SUM (t02.t02_exchange_tax), 0)
                           AS exchange_vat,
                       t02.t02_cash_settle_date,
                       MAX (t02.t02_create_datetime)
                           t02_create_datetime,
                       MAX (t02.t02_fx_rate)
                           AS t02_fx_rate,
                       MAX (t02.t02_exchange_code_m01)
                           AS t02_exchange_code_m01,
                       m01.m01_id,
                       m93_id,
                       MAX (m03_txn.m03_id)
                           AS txn_m03_id,
                       m03_settle.m03_id
                           AS settle_m03_id,
                       MAX (t02.t02_txn_currency)
                           AS t02_txn_currency,
                       MAX (t02.t02_settle_currency)
                           AS t02_settle_currency
                FROM t02_transaction_log_order t02,
                     t01_order t01,
                     m01_exchanges m01,
                     m93_bank_accounts m93,
                     m03_currency m03_txn,
                     m03_currency m03_settle
                WHERE     t02.t02_cash_settle_date BETWEEN TRUNC (pdate)
                                                       AND   TRUNC (pdate)
                                                           + 0.99999
                      AND t02.t02_order_no = t01.t01_ord_no
                      AND t01.t01_status_id_v30 IN ('1',
                                                    '2',
                                                    'q',
                                                    'r',
                                                    '5')
                      AND t01.t01_exchange_code_m01 = m01.m01_exchange_code
                      AND t02.t02_settle_currency = m93.m93_currency_code_m03
                      AND m93.m93_is_default_omnibus = 1
                      AND t02.t02_inst_id_m02 = pinstid
                      AND t02.t02_txn_currency = m03_txn.m03_code
                      AND t02.t02_settle_currency = m03_settle.m03_code
                      AND t02.t02_txn_code IN ('STLBUY',
                                               'STLSEL',
                                               'CONOPN',
                                               'CONCLS')
                GROUP BY t02.t02_cash_settle_date,
                         m03_settle.m03_id,
                         m01.m01_id,
                         m93_id,
                         t02_inst_id_m02)
        LOOP
            IF i.buy_settle <> 0
            THEN
                INSERT --BUYSET
                       INTO t05_institute_cash_acc_log (
                                t05_id,
                                t05_institute_id_m02,
                                t05_exchange_id_m01,
                                t05_exchange_code_m01,
                                t05_institute_bank_id_m93,
                                t05_txn_id_m97,
                                t05_txn_code_m97,
                                t05_amnt_in_stl_currency,
                                t05_amnt_in_txn_currency,
                                t05_txn_date,
                                t05_txn_date_time,
                                t05_settle_date,
                                t05_txn_currency_id_m03,
                                t05_txn_currency_code_m03,
                                t05_settle_currency_id_m03,
                                t05_settle_currency_code_m03,
                                t05_fx_rate,
                                t05_reference_doc_narration)
                VALUES (fn_get_next_sequnce ('T05_INSTITUTE_CASH_ACC_LOG'),
                        i.t02_inst_id_m02,
                        i.m01_id,
                        i.t02_exchange_code_m01,
                        i.m93_id,
                        fn_get_txn_code_id ('BUYSET'),
                        'BUYSET',
                        i.buy_settle,
                        i.buy_settle,
                        i.t02_create_datetime,
                        i.t02_create_datetime,
                        i.t02_cash_settle_date,
                        i.txn_m03_id,
                        i.t02_txn_currency,
                        i.settle_m03_id,
                        i.t02_settle_currency,
                        i.t02_fx_rate,
                        'Buy Settlement');
            END IF;

            IF i.sel_settle <> 0
            THEN
                INSERT --SELSET
                       INTO t05_institute_cash_acc_log (
                                t05_id,
                                t05_institute_id_m02,
                                t05_exchange_id_m01,
                                t05_exchange_code_m01,
                                t05_institute_bank_id_m93,
                                t05_txn_id_m97,
                                t05_txn_code_m97,
                                t05_amnt_in_stl_currency,
                                t05_amnt_in_txn_currency,
                                t05_txn_date,
                                t05_txn_date_time,
                                t05_settle_date,
                                t05_txn_currency_id_m03,
                                t05_txn_currency_code_m03,
                                t05_settle_currency_id_m03,
                                t05_settle_currency_code_m03,
                                t05_fx_rate,
                                t05_reference_doc_narration)
                VALUES (fn_get_next_sequnce ('T05_INSTITUTE_CASH_ACC_LOG'),
                        i.t02_inst_id_m02,
                        i.m01_id,
                        i.t02_exchange_code_m01,
                        i.m93_id,
                        fn_get_txn_code_id ('SELSET'),
                        'SELSET',
                        i.sel_settle,
                        i.sel_settle,
                        i.t02_create_datetime,
                        i.t02_create_datetime,
                        i.t02_cash_settle_date,
                        i.txn_m03_id,
                        i.t02_txn_currency,
                        i.settle_m03_id,
                        i.t02_settle_currency,
                        i.t02_fx_rate,
                        'Sell Settlement');
            END IF;

            IF i.exchange_commission <> 0
            THEN
                INSERT --EXGCOM
                       INTO t05_institute_cash_acc_log (
                                t05_id,
                                t05_institute_id_m02,
                                t05_exchange_id_m01,
                                t05_exchange_code_m01,
                                t05_institute_bank_id_m93,
                                t05_txn_id_m97,
                                t05_txn_code_m97,
                                t05_amnt_in_stl_currency,
                                t05_amnt_in_txn_currency,
                                t05_txn_date,
                                t05_txn_date_time,
                                t05_settle_date,
                                t05_txn_currency_id_m03,
                                t05_txn_currency_code_m03,
                                t05_settle_currency_id_m03,
                                t05_settle_currency_code_m03,
                                t05_fx_rate,
                                t05_reference_doc_narration)
                VALUES (fn_get_next_sequnce ('T05_INSTITUTE_CASH_ACC_LOG'),
                        i.t02_inst_id_m02,
                        i.m01_id,
                        i.t02_exchange_code_m01,
                        i.m93_id,
                        fn_get_txn_code_id ('EXGCOM'),
                        'EXGCOM',
                        i.exchange_commission,
                        i.exchange_commission,
                        i.t02_create_datetime,
                        i.t02_create_datetime,
                        i.t02_cash_settle_date,
                        i.txn_m03_id,
                        i.t02_txn_currency,
                        i.settle_m03_id,
                        i.t02_settle_currency,
                        i.t02_fx_rate,
                        'Exchange Commission');
            END IF;

            IF i.broker_commission <> 0
            THEN
                --BRKCOM
                INSERT INTO t05_institute_cash_acc_log (
                                t05_id,
                                t05_institute_id_m02,
                                t05_exchange_id_m01,
                                t05_exchange_code_m01,
                                t05_institute_bank_id_m93,
                                t05_txn_id_m97,
                                t05_txn_code_m97,
                                t05_amnt_in_stl_currency,
                                t05_amnt_in_txn_currency,
                                t05_txn_date,
                                t05_txn_date_time,
                                t05_settle_date,
                                t05_txn_currency_id_m03,
                                t05_txn_currency_code_m03,
                                t05_settle_currency_id_m03,
                                t05_settle_currency_code_m03,
                                t05_fx_rate,
                                t05_reference_doc_narration)
                VALUES (fn_get_next_sequnce ('T05_INSTITUTE_CASH_ACC_LOG'),
                        i.t02_inst_id_m02,
                        i.m01_id,
                        i.t02_exchange_code_m01,
                        i.m93_id,
                        fn_get_txn_code_id ('BRKCOM'),
                        'BRKCOM',
                        i.broker_commission,
                        i.broker_commission,
                        i.t02_create_datetime,
                        i.t02_create_datetime,
                        i.t02_cash_settle_date,
                        i.txn_m03_id,
                        i.t02_txn_currency,
                        i.settle_m03_id,
                        i.t02_settle_currency,
                        i.t02_fx_rate,
                        'Broker Commission');
            END IF;

            IF i.broker_vat <> 0
            THEN
                --BRKVAT
                INSERT INTO t05_institute_cash_acc_log (
                                t05_id,
                                t05_institute_id_m02,
                                t05_exchange_id_m01,
                                t05_exchange_code_m01,
                                t05_institute_bank_id_m93,
                                t05_txn_id_m97,
                                t05_txn_code_m97,
                                t05_amnt_in_stl_currency,
                                t05_amnt_in_txn_currency,
                                t05_txn_date,
                                t05_txn_date_time,
                                t05_settle_date,
                                t05_txn_currency_id_m03,
                                t05_txn_currency_code_m03,
                                t05_settle_currency_id_m03,
                                t05_settle_currency_code_m03,
                                t05_fx_rate,
                                t05_reference_doc_narration)
                VALUES (fn_get_next_sequnce ('T05_INSTITUTE_CASH_ACC_LOG'),
                        i.t02_inst_id_m02,
                        i.m01_id,
                        i.t02_exchange_code_m01,
                        i.m93_id,
                        fn_get_txn_code_id ('BRKVAT'),
                        'BRKVAT',
                        i.broker_vat,
                        i.broker_vat,
                        i.t02_create_datetime,
                        i.t02_create_datetime,
                        i.t02_cash_settle_date,
                        i.txn_m03_id,
                        i.t02_txn_currency,
                        i.settle_m03_id,
                        i.t02_settle_currency,
                        i.t02_fx_rate,
                        'Broker VAT');
            END IF;

            IF i.exchange_vat <> 0
            THEN
                --EXGVAT
                INSERT INTO t05_institute_cash_acc_log (
                                t05_id,
                                t05_institute_id_m02,
                                t05_exchange_id_m01,
                                t05_exchange_code_m01,
                                t05_institute_bank_id_m93,
                                t05_txn_id_m97,
                                t05_txn_code_m97,
                                t05_amnt_in_stl_currency,
                                t05_amnt_in_txn_currency,
                                t05_txn_date,
                                t05_txn_date_time,
                                t05_settle_date,
                                t05_txn_currency_id_m03,
                                t05_txn_currency_code_m03,
                                t05_settle_currency_id_m03,
                                t05_settle_currency_code_m03,
                                t05_fx_rate,
                                t05_reference_doc_narration)
                VALUES (fn_get_next_sequnce ('T05_INSTITUTE_CASH_ACC_LOG'),
                        i.t02_inst_id_m02,
                        i.m01_id,
                        i.t02_exchange_code_m01,
                        i.m93_id,
                        fn_get_txn_code_id ('EXGVAT'),
                        'EXGVAT',
                        i.exchange_vat,
                        i.exchange_vat,
                        i.t02_create_datetime,
                        i.t02_create_datetime,
                        i.t02_cash_settle_date,
                        i.txn_m03_id,
                        i.t02_txn_currency,
                        i.settle_m03_id,
                        i.t02_settle_currency,
                        i.t02_fx_rate,
                        'Exchange VAT');
            END IF;
        END LOOP;

        COMMIT;

        FOR j
            IN (SELECT t02_inst_id_m02,
                       NVL (SUM (t02_amnt_in_txn_currency), 0)
                           t02_amnt_in_txn_currency,
                       NVL (SUM (t02_amnt_in_stl_currency), 0)
                           t02_amnt_in_stl_currency,
                       t02.t02_cash_settle_date,
                       MAX (t02.t02_exchange_code_m01)
                           AS t02_exchange_code_m01,
                       m01.m01_id,
                       m93_id,
                       MAX (t02.t02_create_datetime)
                           t02_create_datetime,
                       MAX (t02.t02_fx_rate)
                           AS t02_fx_rate,
                       MAX (m03_txn.m03_id)
                           AS txn_m03_id,
                       MAX (t02.t02_txn_currency)
                           AS t02_txn_currency,
                       m03_settle.m03_id
                           AS settle_m03_id,
                       MAX (t02.t02_settle_currency)
                           AS t02_settle_currency,
                       m97.m97_id,
                       MAX (t02.t02_txn_code)
                           AS t02_txn_code,
                       MAX (m97.m97_description)
                           m97_description
                FROM t02_transaction_log_cash_all t02,
                     m01_exchanges m01,
                     m93_bank_accounts m93,
                     m03_currency m03_txn,
                     m03_currency m03_settle,
                     m97_transaction_codes m97
                WHERE     t02.t02_cash_settle_date BETWEEN TRUNC (pdate)
                                                       AND   TRUNC (pdate)
                                                           + 0.99999
                      AND t02.t02_settle_currency = m93.m93_currency_code_m03
                      AND m93.m93_is_default_omnibus = 1
                      AND t02.t02_txn_currency = m03_txn.m03_code
                      AND t02.t02_settle_currency = m03_settle.m03_code
                      AND t02.t02_exchange_code_m01 =
                          m01.m01_exchange_code(+)
                      AND t02.t02_txn_code = m97.m97_code
                      AND t02.t02_inst_id_m02 = pinstid
                      AND t02_txn_code NOT IN ('STLBUY',
                                               'STLSEL',
                                               'CONOPN',
                                               'CONCLS',
                                               'DEPOST',
                                               'WITHDR',
                                               'CSHTRN')
                GROUP BY t02.t02_cash_settle_date,
                         m03_settle.m03_id,
                         m97.m97_id,
                         m01.m01_id,
                         m93_id,
                         t02_inst_id_m02)
        LOOP
            IF    j.t02_amnt_in_txn_currency <> 0
               OR j.t02_amnt_in_stl_currency <> 0
            THEN
                INSERT INTO t05_institute_cash_acc_log (
                                t05_id,
                                t05_institute_id_m02,
                                t05_exchange_id_m01,
                                t05_exchange_code_m01,
                                t05_institute_bank_id_m93,
                                t05_txn_id_m97,
                                t05_txn_code_m97,
                                t05_amnt_in_stl_currency,
                                t05_amnt_in_txn_currency,
                                t05_txn_date,
                                t05_txn_date_time,
                                t05_settle_date,
                                t05_txn_currency_id_m03,
                                t05_txn_currency_code_m03,
                                t05_settle_currency_id_m03,
                                t05_settle_currency_code_m03,
                                t05_fx_rate,
                                t05_reference_doc_narration)
                VALUES (fn_get_next_sequnce ('T05_INSTITUTE_CASH_ACC_LOG'),
                        j.t02_inst_id_m02,
                        j.m01_id,
                        j.t02_exchange_code_m01,
                        j.m93_id,
                        j.m97_id,
                        j.t02_txn_code,
                        j.t02_amnt_in_stl_currency,
                        j.t02_amnt_in_txn_currency,
                        j.t02_create_datetime,
                        j.t02_create_datetime,
                        j.t02_cash_settle_date,
                        j.txn_m03_id,
                        j.t02_txn_currency,
                        j.settle_m03_id,
                        j.t02_settle_currency,
                        j.t02_fx_rate,
                        j.m97_description);
            END IF;
        END LOOP;

        COMMIT;

        FOR k
            IN (SELECT t02_inst_id_m02,
                       t02_amnt_in_txn_currency,
                       t02_amnt_in_stl_currency,
                       t02.t02_cash_settle_date,
                       t02_exchange_code_m01,
                       m01.m01_id,
                       NVL (m93_at.m93_id, m93.m93_id) m93_id,
                       t02_create_datetime,
                       t02_fx_rate,
                       m03_txn.m03_id AS txn_m03_id,
                       t02.t02_txn_currency,
                       m03_settle.m03_id AS settle_m03_id,
                       t02.t02_settle_currency,
                       m97.m97_id,
                       t02.t02_txn_code,
                       t02.t02_narration,
                       CASE t02.t02_txn_code
                           WHEN ('DEPOST')
                           THEN
                                  'Fund transfered '
                               || DECODE (u08.u08_account_no,
                                          NULL, 'as Cash/Cheque',
                                          'from ' || u08.u08_account_no)
                               || ' to Investment account '
                               || u06.u06_investment_account_no
                           WHEN ('WITHDR')
                           THEN
                                  'Fund transfered from Investment account '
                               || u06.u06_investment_account_no
                               || DECODE (u08.u08_account_no,
                                          NULL, ' as Cash/Cheque',
                                          ' to ' || u08.u08_account_no)
                       END AS narration,
                       t06_beneficiary_id_u08,
                       t06_cash_acc_id_u06,
                       t02_cashtxn_id,
                       t06.t06_bank_id_m93,
                       t02_last_db_seq_id
                FROM t02_transaction_log_cash_all t02,
                     t06_cash_transaction t06,
                     m01_exchanges m01,
                     m93_bank_accounts m93,
                     m03_currency m03_txn,
                     m03_currency m03_settle,
                     m97_transaction_codes m97,
                     m93_bank_accounts m93_at,
                     u08_customer_beneficiary_acc u08,
                     u06_cash_account u06
                WHERE     t02.t02_create_datetime BETWEEN TRUNC (pdate)
                                                      AND   TRUNC (pdate)
                                                          + 0.99999
                      AND t02.t02_settle_currency = m93.m93_currency_code_m03
                      AND t02.t02_cashtxn_id = t06.t06_id
                      AND t06.t06_beneficiary_id_u08 = u08.u08_id(+)
                      AND t02.t02_cash_acnt_id_u06 = u06.u06_id
                      AND t02.t02_exchange_code_m01 =
                          m01.m01_exchange_code(+)
                      AND m93.m93_is_default_omnibus = 1
                      AND t02.t02_txn_currency = m03_txn.m03_code
                      AND t02.t02_settle_currency = m03_settle.m03_code
                      AND t02.t02_txn_code = m97.m97_code
                      AND t02.t02_bank_id_m93 = m93_at.m93_id(+)
                      AND t02.t02_inst_id_m02 = pinstid
                      AND t02.t02_txn_code IN ('DEPOST', 'WITHDR'))
        LOOP
            IF    k.t02_amnt_in_txn_currency <> 0
               OR k.t02_amnt_in_stl_currency <> 0
            THEN
                INSERT INTO t05_institute_cash_acc_log (
                                t05_id,
                                t05_institute_id_m02,
                                t05_exchange_id_m01,
                                t05_exchange_code_m01,
                                t05_institute_bank_id_m93,
                                t05_txn_id_m97,
                                t05_txn_code_m97,
                                t05_amnt_in_stl_currency,
                                t05_amnt_in_txn_currency,
                                t05_txn_date,
                                t05_txn_date_time,
                                t05_settle_date,
                                t05_txn_currency_id_m03,
                                t05_txn_currency_code_m03,
                                t05_settle_currency_id_m03,
                                t05_settle_currency_code_m03,
                                t05_fx_rate,
                                t05_cust_bank_account_id_u08,
                                t05_cust_cash_acc_id_u06,
                                t05_t02_id,
                                t05_reference_doc_narration)
                VALUES (fn_get_next_sequnce ('T05_INSTITUTE_CASH_ACC_LOG'),
                        k.t02_inst_id_m02,
                        k.m01_id,
                        k.t02_exchange_code_m01,
                        k.m93_id,
                        k.m97_id,
                        k.t02_txn_code,
                        k.t02_amnt_in_stl_currency,
                        k.t02_amnt_in_txn_currency,
                        k.t02_create_datetime,
                        k.t02_create_datetime,
                        k.t02_cash_settle_date,
                        k.txn_m03_id,
                        k.t02_txn_currency,
                        k.settle_m03_id,
                        k.t02_settle_currency,
                        k.t02_fx_rate,
                        k.t06_beneficiary_id_u08,
                        k.t06_cash_acc_id_u06,
                        k.t02_last_db_seq_id,
                        k.narration);
            END IF;
        END LOOP;

        COMMIT;

        -- Finaly Update Bank Account Cash Blances With Totals


        SELECT COUNT (1)
        INTO i_t05_rec_count
        FROM t05_institute_cash_acc_log t05
        WHERE t05.t05_settle_date BETWEEN TRUNC (pdate)
                                      AND TRUNC (pdate) + .99999;

        IF (i_t05_rec_count > 0)
        THEN
            FOR i
                IN (SELECT t05_institute_bank_id_m93,
                           NVL (SUM (t05_amnt_in_stl_currency), 0) --t05_amnt_in_stl_currency t05_amnt_in_txn_currency
                                                                  AS adjustable_balance
                    FROM t05_institute_cash_acc_log t05
                    WHERE t05_settle_date BETWEEN TRUNC (pdate)
                                              AND TRUNC (pdate) + .99999
                    GROUP BY t05.t05_institute_bank_id_m93)
            LOOP
                UPDATE m93_bank_accounts m93
                SET m93_balance = (m93_balance + i.adjustable_balance)
                WHERE m93_id = i.t05_institute_bank_id_m93;
            END LOOP;

            COMMIT;
            i_t05_rec_count := 0;
        END IF;
    END IF;
END;
/