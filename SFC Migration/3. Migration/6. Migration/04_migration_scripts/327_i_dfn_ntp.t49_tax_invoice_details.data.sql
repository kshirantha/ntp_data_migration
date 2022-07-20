DECLARE
    l_sqlerrm   VARCHAR2 (4000);
BEGIN
    DELETE FROM error_log
          WHERE mig_table = 'T49_TAX_INVOICE_DETAILS';

    FOR i
        IN ( -- None INDCH & TRNFEE Transactions
            SELECT t48.t48_invoice_no,
                   t103.t103_t05_id,
                   t02_map.new_cash_txn_log_id,
                   t48.t48_txn_code AS txn_code,
                   t49.t49_invoice_no_t48,
                   t49.t49_last_db_seq_id_t02
              FROM mubasher_oms.t103_tax_invoice_details@mubasher_db_link t103,
                   mubasher_oms.t05_cash_account_log@mubasher_db_link t05,
                   (  SELECT t05_orderno
                        FROM mubasher_oms.t05_cash_account_log@mubasher_db_link
                       WHERE t05_code = 'INDCH'
                    GROUP BY t05_orderno) t05_indch,
                   dfn_ntp.t48_tax_invoices t48,
                   t02_transaction_log_mappings t02_map,
                   dfn_ntp.t49_tax_invoice_details t49,
                   map15_transaction_codes_m97 map15
             WHERE     t103.t103_t05_id = t05.t05_id
                   AND t05.t05_orderno = t05_indch.t05_orderno(+)
                   AND t05_indch.t05_orderno IS NULL
                   AND t103.t103_t102_invoice_no = t48.t48_invoice_no(+)
                   AND t103.t103_t05_id = t02_map.old_cash_txn_log_id(+)
                   AND t103.t103_t05_code = map15.map15_oms_code(+)
                   AND map15.map15_ntp_code = t02_map.new_txn_code(+)
                   AND t48.t48_invoice_no = t49.t49_invoice_no_t48(+)
                   AND t02_map.new_cash_txn_log_id =
                           t49.t49_last_db_seq_id_t02(+)
                   AND t103.t103_t05_code <> 'TRNFEE'
            UNION ALL
            -- INDCH Transactions
            SELECT t48.t48_invoice_no,
                   t103.t103_t05_id,
                   t02_map.new_cash_txn_log_id,
                   t48.t48_txn_code AS txn_code,
                   t49.t49_invoice_no_t48,
                   t49.t49_last_db_seq_id_t02
              FROM mubasher_oms.t103_tax_invoice_details@mubasher_db_link t103,
                   (  SELECT MIN (t05_id) AS t05_id,
                             t05_orderno AS t05_orderno,
                             MIN (t05_code) AS t05_code
                        FROM (SELECT t05.t05_id,
                                     t05.t05_orderno,
                                     MIN (
                                         t05.t05_code_min)
                                     KEEP (DENSE_RANK FIRST ORDER BY t05.t05_id)
                                     OVER (PARTITION BY t05.t05_orderno)
                                         AS t05_code
                                FROM (SELECT t05.*,
                                             CASE
                                                 WHEN MIN (
                                                          t05_code)
                                                      KEEP (DENSE_RANK FIRST ORDER BY
                                                                                 t05_id)
                                                      OVER (
                                                          PARTITION BY t05_orderno) IN
                                                          ('STLBUY', 'STLSEL')
                                                 THEN
                                                     MIN (
                                                         t05_code)
                                                     KEEP (DENSE_RANK FIRST ORDER BY
                                                                                t05_id)
                                                     OVER (
                                                         PARTITION BY t05_orderno)
                                                 ELSE
                                                     MAX (
                                                         t05_code)
                                                     KEEP (DENSE_RANK FIRST ORDER BY
                                                                                t05_id DESC)
                                                     OVER (
                                                         PARTITION BY t05_orderno)
                                             END
                                                 AS t05_code_min
                                        FROM mubasher_oms.t05_cash_account_log@mubasher_db_link t05) t05,
                                     (  SELECT t05_orderno
                                          FROM mubasher_oms.t05_cash_account_log@mubasher_db_link
                                         WHERE t05_code = 'INDCH'
                                      GROUP BY t05_orderno) t05_indch
                               WHERE t05.t05_orderno = t05_indch.t05_orderno)
                    GROUP BY t05_orderno) t05,
                   (  SELECT t05_orderno
                        FROM mubasher_oms.t05_cash_account_log@mubasher_db_link
                       WHERE t05_code = 'INDCH'
                    GROUP BY t05_orderno) t05_indch,
                   dfn_ntp.t48_tax_invoices t48,
                   t02_transaction_log_mappings t02_map,
                   dfn_ntp.t49_tax_invoice_details t49,
                   map15_transaction_codes_m97 map15
             WHERE     t103.t103_t05_id = t05.t05_id
                   AND t05.t05_orderno = t05_indch.t05_orderno
                   AND t103.t103_t102_invoice_no = t48.t48_invoice_no(+)
                   AND t05.t05_id = t02_map.old_cash_txn_log_id(+)
                   AND t05.t05_code = map15.map15_oms_code(+)
                   AND map15.map15_ntp_code = t02_map.new_txn_code(+)
                   AND t48.t48_invoice_no = t49.t49_invoice_no_t48(+)
                   AND t02_map.new_cash_txn_log_id =
                           t49.t49_last_db_seq_id_t02(+)
                   AND t103.t103_t05_code <> 'TRNFEE'
            UNION ALL
            -- TRNFEE Transactions
            SELECT t48.t48_invoice_no,
                   t103.t103_t05_id,
                   t02_map.new_cash_txn_log_id,
                   t02_map.new_txn_code AS txn_code,
                   t49.t49_invoice_no_t48,
                   t49.t49_last_db_seq_id_t02
              FROM mubasher_oms.t103_tax_invoice_details@mubasher_db_link t103,
                   dfn_ntp.t48_tax_invoices t48,
                   t02_transaction_log_mappings t02_map,
                   dfn_ntp.t49_tax_invoice_details t49
             WHERE     t103.t103_t102_invoice_no = t48.t48_invoice_no(+)
                   AND t103.t103_t05_id = t02_map.old_cash_txn_log_id(+) -- TXN Code Not Included in Mapping & But 1 : 1 Mapped with IDs. Hence Code is Ignored
                   AND t48.t48_invoice_no = t49.t49_invoice_no_t48(+)
                   AND t02_map.new_cash_txn_log_id =
                           t49.t49_last_db_seq_id_t02(+)
                   AND t103.t103_t05_code = 'TRNFEE')
    LOOP
        BEGIN
            IF i.txn_code IS NULL
            THEN
                raise_application_error (-20001,
                                         'Transaction Code Not Available',
                                         TRUE);
            END IF;

            IF i.t48_invoice_no IS NULL
            THEN
                raise_application_error (-20001,
                                         'Tax Invoice No Not Available',
                                         TRUE);
            END IF;

            IF i.new_cash_txn_log_id IS NULL
            THEN
                raise_application_error (
                    -20001,
                    'Tax Invoice Detail Log Id Not Available',
                    TRUE);
            END IF;

            IF     i.t49_invoice_no_t48 IS NOT NULL
               AND i.t49_last_db_seq_id_t02 IS NOT NULL
            THEN
                UPDATE dfn_ntp.t49_tax_invoice_details
                   SET t49_txn_code = i.txn_code -- t49_txn_code
                 WHERE     t49_invoice_no_t48 = i.t49_invoice_no_t48
                       AND t49_last_db_seq_id_t02 = i.new_cash_txn_log_id;
            ELSE
                INSERT
                  INTO dfn_ntp.t49_tax_invoice_details (t49_invoice_no_t48,
                                                        t49_last_db_seq_id_t02,
                                                        t49_txn_code)
                VALUES (i.t48_invoice_no, -- t49_invoice_no_t48
                                         i.new_cash_txn_log_id, -- t49_last_db_seq_id_t02
                                                               i.txn_code -- t49_txn_code
                                                                         );
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'T49_TAX_INVOICE_DETAILS',
                                   'Invoice No - | '
                                || i.t48_invoice_no
                                || ' | Log Id - '
                                || i.t103_t05_id,
                                   'Invoice No - | '
                                || i.t48_invoice_no
                                || ' | Log Id - '
                                || i.new_cash_txn_log_id,
                                l_sqlerrm,
                                CASE
                                    WHEN     i.t49_invoice_no_t48 IS NOT NULL
                                         AND i.t49_last_db_seq_id_t02
                                                 IS NOT NULL
                                    THEN
                                        'UPDATE'
                                    ELSE
                                        'INSERT'
                                END,
                                SYSDATE);
        END;
    END LOOP;
END;
/
