DECLARE
    l_dail_int_chrg_id   NUMBER;
    l_sqlerrm            VARCHAR2 (4000);

    l_rec_cnt            NUMBER := 0;
    l_err_cnt            NUMBER := 0;
BEGIN
    SELECT NVL (MAX (t21_id), 0)
      INTO l_dail_int_chrg_id
      FROM dfn_ntp.t21_daily_interest_for_charges;

    DELETE FROM error_log
          WHERE mig_table = 'T21_DAILY_INTEREST_FOR_CHARGES';

    FOR i
        IN (SELECT t75_id,
                   u06_map.new_cash_account_id,
                   m97.m97_id,
                   m97.m97_code,
                   t75_interest_charge_amt AS interest_charge_amt,
                   t75.t75_created_date AS created_date, -- NULL Value Not Replaced with SYSDATE for Transaction Tables for Logical Reasons
                   t75_value_date AS value_date,
                   map01.map01_ntp_id,
                   t75_narration AS narration,
                   t06_map.new_cash_transaction_id,
                   t75_ovedraw_amt AS ovedraw_amt,
                   t75_interest_rate AS interest_rate,
                   t75_posted_date AS posted_date,
                   t75_frequency_id AS frequency_id, -- [SAME IDs]
                   u06.u06_institute_id_m02 AS institute_id,
                   'T75_DAILY_INTEREST_FOR_CHARGES' AS source_table,
                   t75.t75_flat_rate,
                   t75.t75_orginal_rate,
                   t75.t75_saibor_libor_fee,
                   t75_broker_vat AS broker_vat,
                   t75_spread_fee AS spread_fee,
                   NVL (m253.m253_rate, 0) AS add_sub_saibor_rate,
                   t21_map.new_daily_int_charges_id
              FROM mubasher_oms.t75_daily_interest_for_charges@mubasher_db_link t75,
                   mubasher_oms.m253_saibor_basis_rates@mubasher_db_link m253,
                   map01_approval_status_v01 map01,
                   u06_cash_account_mappings u06_map,
                   dfn_ntp.u06_cash_account u06,
                   map15_transaction_codes_m97 map15,
                   dfn_ntp.m97_transaction_codes m97,
                   t06_cash_transaction_mappings t06_map,
                   (SELECT *
                      FROM t21_daily_int_charges_mappings
                     WHERE old_source_table =
                               'T75_DAILY_INTEREST_FOR_CHARGES') t21_map
             WHERE     t75.t75_interest_index_id = m253.m253_id(+)
                   AND t75.t75_status = map01.map01_oms_id
                   AND t75.t75_cash_account_id =
                           u06_map.old_cash_account_id(+)
                   AND u06_map.new_cash_account_id = u06.u06_id(+)
                   AND t75.t75_charges_code = map15.map15_oms_code(+)
                   AND map15.map15_ntp_code = m97.m97_code(+)
                   AND t75.t75_t12_id = t06_map.old_cash_transaction_id(+)
                   AND t75.t75_id = t21_map.old_daily_int_charges_id(+)
            UNION ALL
            SELECT t108.t108_id AS t75_id,
                   u06_map.new_cash_account_id,
                   48 AS m97_id, -- For CUDYHLDFEE Only
                   'CUDYHLDFEE' AS m97_code,
                   0 AS interest_charge_amt,
                   t108.t108_created_date AS created_date, -- NULL Value Not Replaced with SYSDATE for Transaction Tables for Logical Reasons
                   t108.t108_value_date AS value_date,
                   map01.map01_ntp_id,
                   t108.t108_narration AS narration,
                   NULL AS new_cash_transaction_id,
                   NULL AS ovedraw_amt,
                   NULL AS interest_rate,
                   t108.t108_created_date AS posted_date,
                   t108.t108_frequency_id AS frequency_id,
                   u06.u06_institute_id_m02 AS institute_id,
                   'T108_CUSTODIAN_ACCRUAL_FEE' AS source_table,
                   NULL AS t75_flat_rate,
                   NULL AS t75_orginal_rate,
                   NULL AS t75_saibor_libor_fee,
                   t108_broker_vat AS broker_vat,
                   NULL AS spread_fee,
                   0 AS add_sub_saibor_rate,
                   t21_map.new_daily_int_charges_id
              FROM mubasher_oms.t108_custodian_accrual_fee@mubasher_db_link t108,
                   map01_approval_status_v01 map01,
                   u06_cash_account_mappings u06_map,
                   dfn_ntp.u06_cash_account u06,
                   (SELECT *
                      FROM t21_daily_int_charges_mappings
                     WHERE old_source_table = 'T108_CUSTODIAN_ACCRUAL_FEE') t21_map
             WHERE     t108.t108_status = map01.map01_oms_id
                   AND t108.t108_cash_account_id =
                           u06_map.old_cash_account_id(+)
                   AND u06_map.new_cash_account_id = u06.u06_id(+)
                   AND t108.t108_id = t21_map.old_daily_int_charges_id(+))
    LOOP
        BEGIN
            IF i.m97_id IS NULL
            THEN
                raise_application_error (-20001,
                                         'Transaction Code Not Available',
                                         TRUE);
            END IF;

            IF i.new_cash_account_id IS NULL
            THEN
                raise_application_error (-20001,
                                         'Cash Account Not Available',
                                         TRUE);
            END IF;

            IF i.new_daily_int_charges_id IS NULL
            THEN
                l_dail_int_chrg_id := l_dail_int_chrg_id + 1;

                INSERT
                  INTO dfn_ntp.t21_daily_interest_for_charges (
                           t21_id,
                           t21_cash_account_id_u06,
                           t21_charges_id_m97,
                           t21_interest_charge_amt,
                           t21_created_date,
                           t21_value_date,
                           t21_status,
                           t21_remarks,
                           t21_cash_transaction_id_t06,
                           t21_ovedraw_amt,
                           t21_interest_rate,
                           t21_posted_date,
                           t21_frequency_id,
                           t21_charges_code_m97,
                           t21_created_by_id_u17,
                           t21_trans_value_date,
                           t21_approved_by_id_u17,
                           t21_approved_date,
                           t21_custom_type,
                           t21_institute_id_m02,
                           t21_custodian_id_m26,
                           t21_u24_symbol_code_m20,
                           t21_net_holding,
                           t21_u24_symbol_id_m20,
                           t21_u24_exchange_code_m01,
                           t21_flat_fee,
                           t21_orginal_rate,
                           t21_margin_product_id_u23,
                           t21_interest_indices_rate_m65,
                           t21_add_or_sub_to_saibor_rt_b,
                           t21_add_or_sub_rate_b,
                           t21_spread_amount_b,
                           t21_tax_rate,
                           t21_tax_amount)
                VALUES (l_dail_int_chrg_id, -- t21_id
                        i.new_cash_account_id, -- t21_cash_account_id_u06
                        i.m97_id, -- t21_charges_id_m97
                        i.interest_charge_amt, -- t21_interest_charge_amt
                        i.created_date, -- t21_created_date
                        i.value_date, -- t21_value_date
                        i.map01_ntp_id, -- t21_status
                        i.narration, -- t21_remarks
                        i.new_cash_transaction_id, -- t21_cash_transaction_id_t06
                        i.ovedraw_amt, -- t21_ovedraw_amt
                        i.interest_rate, -- t21_interest_rate
                        i.posted_date, -- t21_posted_date
                        i.frequency_id, -- t21_frequency_id
                        i.m97_code, -- t21_charges_code_m97
                        0, -- t21_created_by_id_u17
                        i.created_date, -- t21_trans_value_date
                        0, -- t21_approved_by_id_u17
                        i.created_date, -- t21_approved_date
                        '1', -- t21_custom_type
                        i.institute_id, -- t21_institute_id_m02
                        NULL, --  t21_custodian_id_m26 | Not Available
                        NULL, --  t21_u24_symbol_code_m20 | Not Available
                        NULL, --   t21_net_holding | Not Available
                        NULL, --   t21_u24_symbol_id_m20 | Not Available
                        NULL, --   t21_u24_exchange_code_m01 | Not Available
                        i.t75_flat_rate, -- t21_flat_fee
                        i.t75_orginal_rate, -- t21_orginal_rate
                        NULL, -- t21_margin_product_id_u23 | Not Available
                        i.t75_saibor_libor_fee, -- t21_interest_indices_rate_m65
                        0, -- t21_add_or_sub_to_saibor_rt_b | Default (0 - Add)
                        i.add_sub_saibor_rate, -- t21_add_or_sub_rate_b
                        i.spread_fee, -- t21_spread_amount_b
                        i.add_sub_saibor_rate, -- t21_tax_rate | Not Available (Add or Sub Rate Used)
                        i.broker_vat -- t21_tax_amount
                                    );

                INSERT
                  INTO t21_daily_int_charges_mappings (
                           old_daily_int_charges_id,
                           new_daily_int_charges_id,
                           old_source_table)
                VALUES (i.t75_id, l_dail_int_chrg_id, i.source_table);
            ELSE
                UPDATE dfn_ntp.t21_daily_interest_for_charges
                   SET t21_cash_account_id_u06 = i.new_cash_account_id, -- t21_cash_account_id_u06
                       t21_charges_id_m97 = i.m97_id, -- t21_charges_id_m97
                       t21_interest_charge_amt = i.interest_charge_amt, -- t21_interest_charge_amt
                       t21_value_date = i.value_date, -- t21_value_date
                       t21_status = i.map01_ntp_id, -- t21_status
                       t21_remarks = i.narration, -- t21_remarks
                       t21_cash_transaction_id_t06 = i.new_cash_transaction_id, -- t21_cash_transaction_id_t06
                       t21_ovedraw_amt = i.ovedraw_amt, -- t21_ovedraw_amt
                       t21_interest_rate = i.interest_rate, -- t21_interest_rate
                       t21_posted_date = i.posted_date, -- t21_posted_date
                       t21_frequency_id = i.frequency_id, -- t21_frequency_id
                       t21_charges_code_m97 = i.m97_code, -- t21_charges_code_m97
                       t21_trans_value_date = i.created_date, -- t21_trans_value_date
                       t21_approved_by_id_u17 = 0, -- t21_approved_by_id_u17
                       t21_approved_date = i.created_date, -- t21_approved_date
                       t21_institute_id_m02 = i.institute_id, -- t21_institute_id_m02
                       t21_flat_fee = i.t75_flat_rate, -- t21_flat_fee
                       t21_orginal_rate = i.t75_orginal_rate, -- t21_orginal_rate
                       t21_interest_indices_rate_m65 = i.t75_saibor_libor_fee, -- t21_interest_indices_rate_m65
                       t21_add_or_sub_rate_b = i.add_sub_saibor_rate, -- t21_add_or_sub_rate_b
                       t21_spread_amount_b = i.spread_fee, -- t21_spread_amount_b
                       t21_tax_rate = i.add_sub_saibor_rate, -- t21_tax_rate | Not Available (Add or Sub Rate Used)
                       t21_tax_amount = i.broker_vat -- t21_tax_amount
                 WHERE t21_id = i.new_daily_int_charges_id;
            END IF;

            l_rec_cnt := l_rec_cnt + 1;

            IF MOD (l_rec_cnt, 25000) = 0
            THEN
                COMMIT;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'T21_DAILY_INTEREST_FOR_CHARGES',
                                i.source_table || ' - ' || i.t75_id,
                                CASE
                                    WHEN i.new_daily_int_charges_id IS NULL
                                    THEN
                                        l_dail_int_chrg_id
                                    ELSE
                                        i.new_daily_int_charges_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_daily_int_charges_id IS NULL
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
