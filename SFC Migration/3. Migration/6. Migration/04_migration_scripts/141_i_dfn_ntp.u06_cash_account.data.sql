DECLARE
    l_cash_account_id   NUMBER;
    l_sqlerrm           VARCHAR2 (4000);

    l_rec_cnt           NUMBER := 0;
    l_use_new_key       NUMBER;
BEGIN
    SELECT NVL (MAX (u06_id), 0)
      INTO l_cash_account_id
      FROM dfn_ntp.u06_cash_account;

    l_use_new_key := fn_use_new_key ('U06_CASH_ACCOUNT');

    DELETE FROM error_log
          WHERE mig_table = 'U06_CASH_ACCOUNT';

    FOR i
        IN (  SELECT t03.t03_account_id,
                     m02_map.new_institute_id,
                     u01_map.new_customer_id,
                     u01.u01_customer_no,
                     u01.u01_display_name,
                     u01.u01_default_id_no,
                     t03.t03_currency,
                     t03.t03_balance,
                     (ABS (t03.t03_blocked_amount) + ABS (t03.t03_margin_block))
                         AS blocked_amount, -- [Discussed]
                     ABS (t03.t03_open_buy_blocked) AS open_buy_blocked,
                     t03.t03_payable_amount,
                     ABS (t03.t03_trading_block_amount)
                         AS t03_trading_block_amount,
                     ABS (t03.t03_other_block_amt) AS other_block_amt,
                     ABS (t03.t03_transfer_blocked_amt) AS transfer_blocked_amt,
                     t03.t03_pending_settle,
                     NVL (u17_created_by.new_employee_id, 0)
                         AS created_by_new_id,
                     NVL (t03.t03_created_date, SYSDATE) AS created_date,
                     u17_modified_by.new_employee_id AS modified_by_new_id,
                     t03.t03_modified_date AS modified_date,
                     NVL (u17_status_changed_by.new_employee_id, 0)
                         AS status_changed_by_new_id,
                     NVL (t03.t03_status_changed_date, SYSDATE)
                         AS status_changed_date,
                     NVL (map01.map01_ntp_id, 2) AS map01_ntp_id,
                     t03.t03_accountno,
                     m03.m03_id,
                     t03.t03_margin_enabled,
                     t03.t03_external_reference,
                     t03.t03_pending_depost,
                     t03.t03_pending_withdr,
                     t03.t03_od_limit,
                     CASE
                         WHEN TRUNC (t03.t03_trd_lmt_primary_expiry) >=
                                  TRUNC (SYSDATE)
                         THEN
                             TRUNC (t03.t03_trd_lmt_primary_expiry)
                         ELSE
                             TRUNC (SYSDATE)
                     END
                         AS primary_start,
                     t03.t03_trd_lmt_primary_expiry,
                     t03.t03_trd_lmt_secondary,
                     CASE
                         WHEN TRUNC (t03.t03_trd_lmt_secondary_expiry) >=
                                  TRUNC (SYSDATE)
                         THEN
                             TRUNC (t03.t03_trd_lmt_secondary_expiry)
                         ELSE
                             TRUNC (SYSDATE)
                     END
                         AS secondary_start,
                     t03.t03_trd_lmt_secondary_expiry,
                     t03.t03_investor_acc_no,
                     ABS (t03.t03_margin_due) AS margin_due,
                     ABS (t03.t03_margin_block) AS margin_block,
                     CASE WHEN t03.t03_account_type = 4 THEN 2 ELSE 1 END
                         AS new_account_type,
                     t03.t03_iban_no,
                     NVL (t03.t03_vat_waive_off, 0) AS vat_waive_off,
                     m117_map.new_charge_groups_id,
                     t03.t03_net_receivable,
                     ABS (t03.t03_withdr_overdrawn_amt) AS withdr_overdrawn_amt,
                     ABS (t03.t03_incident_overdrawn_amt)
                         AS incident_overdrawn_amt,
                     t03.t03_accrual_interest,
                     t03.t03_maintain_margin_value,
                     t03.t03_maintain_margin_blk_amt,
                     t03.t03_maintain_margin_utilize,
                     t03.t03_initial_margin_value,
                     t03.t03_loan_amount,
                     u01.u01_id,
                     NVL (t03.t03_block_status, 2) AS block_status, -- [2 : Debit Block]
                     u06_map.new_cash_account_id,
                     u01.u01_is_ipo_customer,
                     m22_algo.new_comm_grp_id AS algo_com_group
                FROM mubasher_oms.t03_cash_account@mubasher_db_link t03,
                     m02_institute_mappings m02_map,
                     u01_customer_mappings u01_map,
                     dfn_ntp.u01_customer u01,
                     dfn_ntp.m03_currency m03,
                     map01_approval_status_v01 map01,
                     m117_charge_groups_mappings m117_map,
                     u17_employee_mappings u17_created_by,
                     u17_employee_mappings u17_modified_by,
                     u17_employee_mappings u17_status_changed_by,
                     m22_comm_grp_mappings m22_algo,
                     u06_cash_account_mappings u06_map
               WHERE     t03.t03_branch_id = m02_map.old_institute_id
                     AND t03.t03_profile_id = u01_map.old_customer_id(+)
                     AND u01_map.new_customer_id = u01.u01_id(+)
                     AND t03.t03_currency = m03.m03_code
                     AND t03.t03_status_id = map01.map01_oms_id(+)
                     AND t03.t03_charges_group =
                             m117_map.old_charge_groups_id(+)
                     AND m02_map.new_institute_id =
                             m117_map.new_institute_id(+)
                     AND t03.t03_created_by = u17_created_by.old_employee_id(+)
                     AND t03.t03_modified_by =
                             u17_modified_by.old_employee_id(+)
                     AND t03.t03_status_changed_by =
                             u17_status_changed_by.old_employee_id(+)
                     AND t03.t03_algo_comm_group_id =
                             m22_algo.old_comm_grp_id(+)
                     AND t03.t03_account_id = u06_map.old_cash_account_id(+)
            ORDER BY t03.t03_account_id)
    LOOP
        BEGIN
            IF i.u01_id IS NULL
            THEN
                raise_application_error (-20001,
                                         'Customer Not Available',
                                         TRUE);
            END IF;

            IF i.new_cash_account_id IS NULL
            THEN
                l_cash_account_id :=
                    CASE
                        WHEN l_use_new_key = 0 THEN i.t03_account_id
                        ELSE l_cash_account_id + 1
                    END;

                INSERT
                  INTO dfn_ntp.u06_cash_account (
                           u06_id,
                           u06_institute_id_m02,
                           u06_customer_id_u01,
                           u06_customer_no_u01,
                           u06_display_name_u01,
                           u06_default_id_no_u01,
                           u06_currency_code_m03,
                           u06_balance,
                           u06_blocked,
                           u06_open_buy_blocked,
                           u06_payable_blocked,
                           u06_manual_trade_blocked,
                           u06_manual_full_blocked,
                           u06_manual_transfer_blocked,
                           u06_receivable_amount,
                           u06_is_default,
                           u06_created_by_id_u17,
                           u06_created_date,
                           u06_status_id_v01,
                           u06_modified_by_id_u17,
                           u06_modified_date,
                           u06_status_changed_by_id_u17,
                           u06_status_changed_date,
                           u06_last_activity_date,
                           u06_display_name,
                           u06_currency_id_m03,
                           u06_margin_enabled,
                           u06_external_ref_no,
                           u06_pending_deposit,
                           u06_pending_withdraw,
                           u06_primary_od_limit,
                           u06_primary_start,
                           u06_primary_expiry,
                           u06_secondary_od_limit,
                           u06_secondary_start,
                           u06_secondary_expiry,
                           u06_investment_account_no,
                           u06_dbseqid,
                           u06_margin_due,
                           u06_margin_block,
                           u06_ordexecseq,
                           u06_pending_restriction,
                           u06_group_bp_enable,
                           u06_inactive_dormant_date,
                           u06_inactive_drmnt_status_v01,
                           u06_margin_product_id_u23,
                           u06_account_type_v01,
                           u06_iban_no,
                           u06_vat_waive_off,
                           u06_charges_group_m117,
                           u06_net_receivable,
                           u06_status_changed_reason,
                           u06_withdr_overdrawn_amt,
                           u06_incident_overdrawn_amt,
                           u06_accrued_interest,
                           u06_custom_type,
                           u06_discunt_charges_group_m165,
                           u06_mutual_fund_account,
                           u06_order_limit_grp_id_m176,
                           u06_transfer_limit_grp_id_m177,
                           u06_cum_sell_order_value,
                           u06_cum_buy_order_value,
                           u06_cum_transfer_value,
                           u06_maintain_margin_charged,
                           u06_maintain_margin_block,
                           u06_initial_margin,
                           u06_maintain_margin_utilized,
                           u06_loan_amount,
                           u06_net_receivable_include,
                           u06_pending_full_blocked,
                           u06_block_status_b,
                           u06_is_ipo_customer,
                           u06_sub_waive_grp_id_m154_c,
                           u06_cum_online_sel_order_value,
                           u06_cum_online_buy_order_value,
                           u06_other_commsion_grp_id_m22,
                           u06_is_unasgnd_account)
                VALUES (l_cash_account_id, -- u06_id
                        i.new_institute_id, -- u06_institute_id_m02
                        i.new_customer_id, -- u06_customer_id_u01
                        i.u01_customer_no, -- u06_customer_no_u01
                        i.u01_display_name, -- u06_display_name_u01
                        i.u01_default_id_no, -- u06_default_id_no_u01
                        i.t03_currency, -- u06_currency_code_m03
                        i.t03_balance, -- u06_balance | This is Already Included for Balance in Old System
                        i.blocked_amount, -- u06_blocked | (Block Amount + Margin Block)
                        i.open_buy_blocked, --u06_open_buy_blocked,
                        i.t03_payable_amount, --u06_payable_blocked,
                        i.t03_trading_block_amount, -- u06_manual_trade_blocked
                        i.other_block_amt, -- u06_manual_full_blocked
                        i.transfer_blocked_amt, -- u06_manual_transfer_blocked
                        i.t03_pending_settle, -- u06_receivable_amount
                        0, -- u06_is_default | Update Later in this Script
                        i.created_by_new_id, -- u06_created_by_id_u17
                        i.created_date, -- u06_created_date
                        i.map01_ntp_id, -- u06_status_id_v01
                        i.modified_by_new_id, -- u06_modified_by_id_u17
                        i.modified_date, -- u06_modified_date
                        i.status_changed_by_new_id, -- u06_status_changed_by_id_u17
                        i.status_changed_date, -- u06_status_changed_date
                        SYSDATE, -- u06_last_activity_date
                        i.t03_accountno, -- u06_display_name
                        i.m03_id, -- u06_currency_id_m03
                        NULL, -- u06_margin_enabled | Updating in the Post Migration Script
                        i.t03_external_reference, -- u06_external_ref_no
                        i.t03_pending_depost, -- u06_pending_deposit
                        i.t03_pending_withdr, -- u06_pending_withdraw
                        i.t03_od_limit, -- u06_primary_od_limit
                        i.primary_start, -- u06_primary_start
                        i.t03_trd_lmt_primary_expiry, -- u06_primary_expiry
                        i.t03_trd_lmt_secondary, -- u06_secondary_od_limit
                        i.secondary_start, -- u06_secondary_start
                        i.t03_trd_lmt_secondary_expiry, -- u06_secondary_expiry
                        i.t03_investor_acc_no, -- u06_investment_account_no
                        NULL, -- u06_dbseqid
                        0, -- u06_margin_due | This is Already Included in Balance for Old System. No Usage of this Column in NTP
                        0, -- u06_margin_block | No Usage of this Column in NTP
                        NULL, -- u06_ordexecseq
                        0, -- 06_pending_restriction
                        0, -- u06_group_bp_enable | Not Available
                        NULL, -- u06_inactive_dormant_date| Not Available
                        NULL, -- u06_inactive_drmnt_status_v01| Not Available
                        -1, -- u06_margin_product_id_u23 | Updating in the Post Migration Script
                        i.new_account_type, -- u06_account_type_v01
                        i.t03_iban_no, -- u06_iban_no
                        i.vat_waive_off, -- u06_vat_waive_off
                        i.new_charge_groups_id, -- u06_charges_group_m117
                        i.t03_net_receivable, -- u06_net_receivable
                        NULL, -- u06_status_changed_reason| Not Available
                        i.withdr_overdrawn_amt, -- t03_withdr_overdrawn_amt
                        i.incident_overdrawn_amt, -- u06_incident_overdrawn_amt
                        i.t03_accrual_interest, -- u06_accrued_interest
                        '1', -- u06_custom_type
                        NULL, -- u06_discunt_charges_group_m165 | Not Available
                        0, -- u06_mutual_fund_account | Not Available
                        NULL, -- u06_order_limit_grp_id_m176 | Updating in the Post Migration Script
                        NULL, -- u06_transfer_limit_grp_id_m177, | Not Available
                        0, -- u06_cum_sell_order_value, | Not Available
                        0, -- u06_cum_buy_order_value, | Not Available
                        0, -- u06_cum_transfer_value | Not Available
                        i.t03_maintain_margin_value, -- u06_maintain_margin_charged
                        i.t03_maintain_margin_blk_amt, -- u06_maintain_margin_block
                        i.t03_initial_margin_value, -- u06_initial_margin
                        i.t03_maintain_margin_utilize, -- u06_maintain_margin_utilized
                        i.t03_loan_amount, -- u06_loan_amount
                        0, -- u06_net_receivable_include | Not Available
                        0, -- u06_pending_full_blocked | Not Available & Need to Discuss
                        i.block_status, -- u06_block_status_b
                        i.u01_is_ipo_customer, -- u06_is_ipo_customer
                        NULL, -- u06_sub_waive_grp_id_m154_c | Not Available
                        0, -- u06_cum_online_sel_order_value | Not Available
                        0, -- u06_cum_online_buy_order_value | Not Available
                        i.algo_com_group, -- u06_other_commsion_grp_id_m22
                        0 -- u06_is_unasgnd_account | Updating Later in the Post Migration Script
                         );

                INSERT INTO u06_cash_account_mappings
                     VALUES (i.t03_account_id, l_cash_account_id);
            ELSE
                UPDATE dfn_ntp.u06_cash_account
                   SET u06_institute_id_m02 = i.new_institute_id, -- u06_institute_id_m02
                       u06_customer_id_u01 = i.new_customer_id, -- u06_customer_id_u01
                       u06_customer_no_u01 = i.u01_customer_no, -- u06_customer_no_u01
                       u06_display_name_u01 = i.u01_display_name, -- u06_display_name_u01
                       u06_default_id_no_u01 = i.u01_default_id_no, -- u06_default_id_no_u01
                       u06_currency_code_m03 = i.t03_currency, -- u06_currency_code_m03
                       u06_balance = i.t03_balance, -- u06_balance | This is Already Included for Balance in Old System
                       u06_blocked = i.blocked_amount, -- u06_blocked | (Block Amount + Margin Block)
                       u06_open_buy_blocked = i.open_buy_blocked, --u06_open_buy_blocked,
                       u06_payable_blocked = i.t03_payable_amount, --u06_payable_blocked,
                       u06_manual_trade_blocked = i.t03_trading_block_amount, -- u06_manual_trade_blocked
                       u06_manual_full_blocked = i.other_block_amt, -- u06_manual_full_blocked
                       u06_manual_transfer_blocked = i.transfer_blocked_amt, -- u06_manual_transfer_blocked
                       u06_receivable_amount = i.t03_pending_settle, -- u06_receivable_amount
                       u06_status_id_v01 = i.map01_ntp_id, -- u06_status_id_v01
                       u06_modified_by_id_u17 = NVL (i.modified_by_new_id, 0), -- u06_modified_by_id_u17
                       u06_modified_date = NVL (i.modified_date, SYSDATE), -- u06_modified_date
                       u06_status_changed_by_id_u17 =
                           i.status_changed_by_new_id, -- u06_status_changed_by_id_u17
                       u06_status_changed_date = i.status_changed_date, -- u06_status_changed_date
                       u06_display_name = i.t03_accountno, -- u06_display_name
                       u06_currency_id_m03 = i.m03_id, -- u06_currency_id_m03
                       u06_margin_enabled = NULL, -- u06_margin_enabled | Updating in the Post Migration Script
                       u06_external_ref_no = i.t03_external_reference, -- u06_external_ref_no
                       u06_pending_deposit = i.t03_pending_depost, -- u06_pending_deposit
                       u06_pending_withdraw = i.t03_pending_withdr, -- u06_pending_withdraw
                       u06_primary_od_limit = i.t03_od_limit, -- u06_primary_od_limit
                       u06_primary_start = i.primary_start, -- u06_primary_start
                       u06_primary_expiry = i.t03_trd_lmt_primary_expiry, -- u06_primary_expiry
                       u06_secondary_od_limit = i.t03_trd_lmt_secondary, -- u06_secondary_od_limit
                       u06_secondary_start = i.secondary_start, -- u06_secondary_start
                       u06_secondary_expiry = i.t03_trd_lmt_secondary_expiry, -- u06_secondary_expiry
                       u06_investment_account_no = i.t03_investor_acc_no, -- u06_investment_account_no
                       u06_account_type_v01 = i.new_account_type, -- u06_account_type_v01
                       u06_iban_no = i.t03_iban_no, -- u06_iban_no
                       u06_vat_waive_off = i.vat_waive_off, -- u06_vat_waive_off
                       u06_charges_group_m117 = i.new_charge_groups_id, -- u06_charges_group_m117
                       u06_net_receivable = i.t03_net_receivable, -- u06_net_receivable
                       u06_withdr_overdrawn_amt = i.withdr_overdrawn_amt, -- t03_withdr_overdrawn_amt
                       u06_incident_overdrawn_amt = i.incident_overdrawn_amt, -- u06_incident_overdrawn_amt
                       u06_accrued_interest = i.t03_accrual_interest, -- u06_accrued_interest
                       u06_maintain_margin_charged =
                           i.t03_maintain_margin_value, -- u06_maintain_margin_charged
                       u06_maintain_margin_block =
                           i.t03_maintain_margin_blk_amt, -- u06_maintain_margin_block
                       u06_initial_margin = i.t03_initial_margin_value, -- u06_initial_margin
                       u06_maintain_margin_utilized =
                           i.t03_maintain_margin_utilize, -- u06_maintain_margin_utilized
                       u06_loan_amount = i.t03_loan_amount, -- u06_loan_amount
                       u06_block_status_b = i.block_status, -- u06_block_status_b
                       u06_is_ipo_customer = i.u01_is_ipo_customer, -- u06_is_ipo_customer
                       u06_other_commsion_grp_id_m22 = i.algo_com_group -- u06_other_commsion_grp_id_m22
                 WHERE u06_id = i.new_cash_account_id;
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
                                'U06_CASH_ACCOUNT',
                                i.t03_account_id,
                                CASE
                                    WHEN i.new_cash_account_id IS NULL
                                    THEN
                                        l_cash_account_id
                                    ELSE
                                        i.new_cash_account_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_cash_account_id IS NULL
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

COMMIT;

BEGIN
    dfn_ntp.sp_stat_gather ('U06_CASH_ACCOUNT');
END;
/

BEGIN
    DBMS_STATS.gather_table_stats (
        ownname            => 'DFN_MIG',
        tabname            => 'U06_CASH_ACCOUNT_MAPPINGS',
        cascade            => TRUE,
        estimate_percent   => DBMS_STATS.auto_sample_size);
END;
/

-- Updating Default Cash Account

MERGE INTO dfn_ntp.u06_cash_account u06
     USING (  SELECT MIN (u06_id) AS min_id
                FROM dfn_ntp.u06_cash_account
            GROUP BY u06_customer_id_u01) u06_default
        ON (u06_id = u06_default.min_id)
WHEN MATCHED
THEN
    UPDATE SET u06_is_default = 1;

COMMIT;

BEGIN
    dfn_ntp.sp_stat_gather ('U06_CASH_ACCOUNT');
END;
/
