CREATE OR REPLACE PROCEDURE dfn_ntp.sp_update_custody_hldg_charges
IS
    l_charge_id     NUMBER;
    l_charge_code   VARCHAR2 (50);
    l_eod_date      DATE := func_get_eod_date;
BEGIN
    SELECT m97.m97_id, m97.m97_code
      INTO l_charge_id, l_charge_code
      FROM m97_transaction_codes m97
     WHERE m97_code = 'CUDYHLDFEE';

    FOR i
        IN (SELECT t02_customer_id_u01,
                   t02_symbol_id_m20,
                   cash_account_id,
                   t02_custodian_id_m26,
                   t02_inst_id_m02,
                   net_volume,
                   fn_get_custody_charge_amount (t02_custodian_id_m26,
                                                 9,
                                                 net_volume,
                                                 trans_currency,
                                                 instrument_type_code)
                       AS custody_charge,
                   get_exchange_rate (t02_inst_id_m02,
                                      trans_currency,
                                      settle_currency)
                       AS exchange_rate,
                   0 AS interest_rate,
                   0 AS status,
                   m26.m26_hold_chrg_grp_id_m166,
                   m166.m166_holding_charg_freq_v01,
                   fn_get_posted_date (m166.m166_holding_charg_freq_v01,
                                       l_eod_date)
                       AS post_or_value_date,
                   t02_symbol_code_m20,
                   t02_exchange_code_m01,
                   m65.m65_rate
              FROM (  SELECT t02_inst_id_m02,
                             t02.t02_customer_id_u01,
                             t02.t02_symbol_id_m20,
                             t02.t02_cash_acnt_id_u06 AS cash_account_id,
                             t02.t02_custodian_id_m26,
                             MAX (t02.t02_settle_currency) AS settle_currency,
                             MAX (t02.t02_txn_currency) AS trans_currency,
                             MAX (t02.t02_instrument_type)
                                 AS instrument_type_code,
                             SUM (t02.t02_holding_net_adjst) AS net_volume,
                             MAX (t02.t02_symbol_code_m20)
                                 AS t02_symbol_code_m20,
                             MAX (t02.t02_exchange_code_m01)
                                 AS t02_exchange_code_m01
                        FROM t02_transaction_log t02
                       WHERE     t02_trade_process_stat_id_v01 = 25
                             AND t02_update_type IN (1, 3)
                             AND t02_holding_net_adjst <> 0
                             AND NVL (t02_holding_settle_date, t02_create_date) =
                                     TRUNC (SYSDATE) - 1 -- TODO: this should populate from OMS Side for updat type 3
                    GROUP BY t02_inst_id_m02,
                             t02.t02_customer_id_u01,
                             t02.t02_symbol_id_m20,
                             t02.t02_cash_acnt_id_u06,
                             t02.t02_custodian_id_m26) hldg
                   INNER JOIN m26_executing_broker m26
                       ON hldg.t02_custodian_id_m26 = m26.m26_id
                   INNER JOIN m166_custody_charges_group m166
                       ON m26.m26_hold_chrg_grp_id_m166 = m166.m166_id
                   INNER JOIN (SELECT m65.m65_rate,
                                      u23.u23_default_cash_acc_id_u06
                                 FROM m65_saibor_basis_rates m65
                                      JOIN m74_margin_interest_group m74
                                          ON m65.m65_id =
                                                 m74.m74_saibor_basis_group_id_m65
                                      JOIN u23_customer_margin_product u23
                                          ON m74.m74_id =
                                                 u23.u23_interest_group_id_m74) m65
                       ON cash_account_id = m65.u23_default_cash_acc_id_u06)
    LOOP
        INSERT
          INTO t21_daily_interest_for_charges (t21_id,
                                               t21_cash_account_id_u06,
                                               t21_charges_id_m97,
                                               t21_interest_charge_amt,
                                               t21_created_date,
                                               t21_value_date,
                                               t21_status,
                                               t21_remarks,
                                               t21_cash_transaction_id_t06, -- Do we need to create to6 entry also here ?
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
                                               t21_interest_indices_rate_m65)
        VALUES (fn_get_next_sequnce ('T21_DAILY_INTEREST_FOR_CHARGES'),
                i.cash_account_id,
                l_charge_id,
                i.custody_charge * i.interest_rate,
                l_eod_date,
                i.post_or_value_date,
                i.status,
                '',
                -1, -- TODO : Need to Discuss
                i.net_volume,
                i.interest_rate,
                NULL,
                i.m166_holding_charg_freq_v01,
                l_charge_code,
                0,
                i.post_or_value_date,
                NULL,
                NULL,
                '1',
                i.t02_inst_id_m02,
                i.t02_custodian_id_m26,
                i.t02_symbol_code_m20,
                0,
                i.t02_symbol_id_m20,
                i.t02_exchange_code_m01,
                i.m65_rate); -- t21_interest_indices_rate_m65
    END LOOP;
END;
/