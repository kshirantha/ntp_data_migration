DECLARE
    l_blk_amt_detail_id   NUMBER;
BEGIN
    SELECT NVL (MAX (t11_trns_id), 0)
      INTO l_blk_amt_detail_id
      FROM dfn_ntp.t11_block_amount_details;

    DELETE FROM error_log
          WHERE mig_table = 'T11_BLOCK_AMOUNT_DETAILS';

    FOR i
        IN (SELECT t77_trns_id,
                   t06_map.new_cash_transaction_id,
                   t77_trns_date,
                   t77_value_date,
                   m97.m97_code,
                   t77_trans_description,
                   t77_trans_amount,
                   t77_adjusted_amount,
                   t77.t77_created_date AS created_date, -- NULL Value Not Replaced with SYSDATE for Transaction Tables for Logical Reasons
                   NVL (u17_created.new_employee_id, 0) AS created_by_new_id,
                   map01.map01_ntp_id,
                   t77_status_change_date AS status_changed_date, -- NULL Value Not Replaced with SYSDATE for Transaction Tables for Logical Reasons
                   NVL (u17_status_changed.new_employee_id, 0)
                       AS status_changed_by_new_id,
                   u06_map.new_cash_account_id,
                   t77_t03_available_balance,
                   u06.u06_institute_id_m02,
                   t11_map.new_block_amt_details_id
              FROM mubasher_oms.t77_block_amount_details@mubasher_db_link t77,
                   map01_approval_status_v01 map01,
                   t06_cash_transaction_mappings t06_map,
                   u06_cash_account_mappings u06_map,
                   dfn_ntp.u06_cash_account u06,
                   map15_transaction_codes_m97 map15,
                   dfn_ntp.m97_transaction_codes m97,
                   u17_employee_mappings u17_created,
                   u17_employee_mappings u17_status_changedy,
                   t11_block_amt_details_mappings t11_map
             WHERE     t77.t77_status = map01.map01_oms_id
                   AND t77.t77_t12_reference =
                           t06_map.old_cash_transaction_id(+)
                   AND t77.t77_trans_code = map15.map15_oms_code
                   AND map15.map15_ntp_code = m97.m97_code
                   AND t77.t77_t03_id = u06_map.old_cash_account_id
                   AND u06_map.new_cash_account_id = u06.u06_id
                   AND t77.t77_created_by = u17_created.old_employee_id(+)
                   AND t77.t77_status_change_by =
                           u17_status_changed.old_employee_id(+)
                   AND t77.t77_trns_id = t11_map.old_block_amt_details_id(+))
    LOOP
        BEGIN
            IF i.new_block_amt_details_id IS NULL
            THEN
                l_blk_amt_detail_id := l_blk_amt_detail_id + 1;

                INSERT INTO t11_block_amt_details_mappings
                     VALUES (i.t77_trns_id, l_blk_amt_detail_id);

                INSERT
                  INTO dfn_ntp.t11_block_amount_details (
                           t11_trns_id,
                           t11_cash_trns_id_t06,
                           t11_trns_date,
                           t11_value_date,
                           t11_trans_code,
                           t11_trans_description,
                           t11_trans_amount,
                           t11_adjusted_amount,
                           t11_created_date,
                           t11_created_by,
                           t11_status,
                           t11_status_change_date,
                           t11_status_change_by,
                           t11_id_u06,
                           t11_balance_u06,
                           t11_institute_id_m02)
                VALUES (l_blk_amt_detail_id, -- t21_id
                        i.new_cash_transaction_id, -- t11_cash_trns_id_t06,
                        i.t77_trns_date, -- t11_trns_date,
                        i.t77_value_date, -- t11_value_date,
                        i.m97_code, -- t11_trans_code,
                        i.t77_trans_description, -- t11_trans_description,
                        i.t77_trans_amount, -- t11_trans_amount,
                        i.t77_adjusted_amount, -- t11_adjusted_amount,
                        i.created_date, -- t11_created_date,
                        i.created_by_new_id, -- t11_created_by,
                        i.map01_ntp_id, -- t11_status,
                        i.status_changed_date, -- t11_status_change_date,
                        i.status_changed_by_new_id, -- t11_status_change_by,
                        i.new_cash_account_id, -- t11_id_u06,
                        i.t77_t03_available_balance, -- t11_balance_u06
                        i.u06_institute_id_m02 -- t11_institute_id_m02
                                              );
            ELSE
                UPDATE dfn_ntp.t11_block_amount_details
                   SET t11_cash_trns_id_t06 = i.new_cash_transaction_id, -- t11_cash_trns_id_t06,
                       t11_trns_date = i.t77_trns_date, -- t11_trns_date,
                       t11_value_date = i.t77_value_date, -- t11_value_date,
                       t11_trans_code = i.m97_code, -- t11_trans_code,
                       t11_trans_description = i.t77_trans_description, -- t11_trans_description,
                       t11_trans_amount = i.t77_trans_amount, -- t11_trans_amount,
                       t11_adjusted_amount = i.t77_adjusted_amount, -- t11_adjusted_amount,
                       t11_status = i.map01_ntp_id, -- t11_status,
                       t11_status_change_date = i.status_changed_date, -- t11_status_change_date,
                       t11_status_change_by = i.status_changed_by_new_id, -- t11_status_change_by,
                       t11_id_u06 = i.new_cash_account_id, -- t11_id_u06,
                       t11_balance_u06 = i.t77_t03_available_balance, -- t11_balance_u06
                       t11_institute_id_m02 = i.u06_institute_id_m02 -- t11_institute_id_m02
                 WHERE t11_id = i.new_block_amt_details_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'T11_BLOCK_AMOUNT_DETAILS',
                                i.t77_trns_id,
                                CASE
                                    WHEN i.new_block_amt_details_id IS NULL
                                    THEN
                                        l_blk_amt_detail_id
                                    ELSE
                                        i.new_block_amt_details_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_block_amt_details_id IS NULL
                                    THEN
                                        'INSERT'
                                    ELSE
                                        'UPDATE'
                                END,
                                SYSDATE);
        END;
    END LOOP;
END;
/
