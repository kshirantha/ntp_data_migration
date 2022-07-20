DECLARE
    l_tax_invoices_id   NUMBER;
    l_sqlerrm           VARCHAR2 (4000);
BEGIN
    SELECT NVL (MAX (t48_id), 0)
      INTO l_tax_invoices_id
      FROM dfn_ntp.t48_tax_invoices;

    DELETE FROM error_log
          WHERE mig_table = 'T48_TAX_INVOICES';

    FOR i
        IN (SELECT t102.t102_invoice_no,
                   u01_map.new_customer_id,
                   t102.t102_from_date,
                   t102.t102_to_date,
                   t102.t102_issue_date,
                   CASE
                       WHEN t102.t102_txn_type = 'ALL'
                       THEN
                           'ALL'
                       WHEN t102.t102_txn_type = 'TRNFEE' -- [TRNFEE] Updating Later in the Post Migration Script
                       THEN
                           'TRNFEE'
                       WHEN t102.t102_txn_type IS NOT NULL
                       THEN
                           map15.map15_ntp_code
                   END
                       AS txn_code,
                   NVL (u17_created.new_employee_id, 0) AS created_by_new_id,
                   u01.u01_institute_id_m02,
                   t48.t48_id
              FROM mubasher_oms.t102_tax_invoices@mubasher_db_link t102,
                   u01_customer_mappings u01_map,
                   map15_transaction_codes_m97 map15,
                   u17_employee_mappings u17_created,
                   dfn_ntp.u01_customer u01,
                   dfn_ntp.t48_tax_invoices t48
             WHERE     t102.t102_m01_customer_id = u01_map.old_customer_id(+)
                   AND u01_map.new_customer_id = u01.u01_id(+)
                   AND t102.t102_txn_type = map15.map15_oms_code(+)
                   AND t102.t102_created_by = u17_created.old_employee_id(+)
                   AND t102.t102_invoice_no = t48.t48_invoice_no(+)
                   AND u01_map.new_customer_id = t48.t48_customer_id_u01(+))
    LOOP
        BEGIN
            IF i.txn_code IS NULL
            THEN
                raise_application_error (-20001,
                                         'Transaction Code Not Available',
                                         TRUE);
            END IF;

            IF i.new_customer_id IS NULL
            THEN
                raise_application_error (-20001,
                                         'Customer Not Available',
                                         TRUE);
            END IF;

            IF i.t48_id IS NULL
            THEN
                l_tax_invoices_id := l_tax_invoices_id + 1;

                INSERT
                  INTO dfn_ntp.t48_tax_invoices (t48_id,
                                                 t48_invoice_no,
                                                 t48_customer_id_u01,
                                                 t48_from_date,
                                                 t48_to_date,
                                                 t48_issue_date,
                                                 t48_txn_code,
                                                 t48_created_by_id_u17,
                                                 t48_custom_type,
                                                 t48_institute_id_m02,
                                                 t48_eom_report,
                                                 t48_cash_account_id_u06)
                VALUES (l_tax_invoices_id, -- t48_id
                        i.t102_invoice_no, -- t48_invoice_no
                        i.new_customer_id, -- t48_customer_id_u01
                        i.t102_from_date, -- t48_from_date
                        i.t102_to_date, -- t48_to_date
                        i.t102_issue_date, -- t48_issue_date
                        i.txn_code, -- t48_txn_code | [TRNFEE] Updating Later in the Post Migration Script
                        i.created_by_new_id, -- t48_created_by_id_u17
                        '1', -- t48_custom_type
                        i.u01_institute_id_m02, -- t48_institute_id_m02
                        0, -- t48_eom_report | Not Available
                        NULL -- t48_cash_account_id_u06 | Not Available
                            );
            ELSE
                UPDATE dfn_ntp.t48_tax_invoices
                   SET t48_from_date = i.t102_from_date, -- t48_from_date
                       t48_to_date = i.t102_to_date, -- t48_to_date
                       t48_issue_date = i.t102_issue_date, -- t48_issue_date
                       t48_txn_code = i.txn_code, -- t48_txn_code
                       t48_institute_id_m02 = i.u01_institute_id_m02 -- t48_institute_id_m02
                 WHERE t48_id = i.t48_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'T48_TAX_INVOICES',
                                i.t102_invoice_no,
                                CASE
                                    WHEN i.t48_id IS NULL
                                    THEN
                                        l_tax_invoices_id
                                    ELSE
                                        i.t48_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.t48_id IS NULL THEN 'INSERT'
                                    ELSE 'UPDATE'
                                END,
                                SYSDATE);
        END;
    END LOOP;
END;
/