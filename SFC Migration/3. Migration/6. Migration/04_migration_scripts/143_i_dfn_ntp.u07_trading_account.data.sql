DECLARE
    l_broker_id              NUMBER;
    l_primary_institute_id   NUMBER;
    l_trading_acc_id         NUMBER;
    l_sqlerrm                VARCHAR2 (4000);

    l_rec_cnt                NUMBER := 0;
    l_use_new_key            NUMBER;
BEGIN
    SELECT VALUE
      INTO l_broker_id
      FROM migration_params
     WHERE code = 'BROKERAGE_ID';

    SELECT m150.m150_primary_institute_id_m02
      INTO l_primary_institute_id
      FROM dfn_ntp.m150_broker m150
     WHERE m150.m150_id = l_broker_id;

    SELECT NVL (MAX (u07_id), 0)
      INTO l_trading_acc_id
      FROM dfn_ntp.u07_trading_account;

    l_use_new_key := fn_use_new_key ('U07_TRADING_ACCOUNT');

    DELETE FROM error_log
          WHERE mig_table = 'U07_TRADING_ACCOUNT';

    FOR i
        IN (  SELECT u06_oms.u06_exec_broker_sid,
                     u06_oms.u06_security_ac_id,
                     u06.u06_institute_id_m02,
                     u01.u01_id,
                     u06.u06_id,
                     u06_oms.u06_id AS routing_acc_id,
                     NVL (map16.map16_ntp_code, u06_oms.u06_exchange)
                         AS exchange_code,
                     u06.u06_display_name,
                     u01.u01_customer_no,
                     u01.u01_display_name,
                     u01.u01_default_id_no,
                     CASE
                         WHEN u06_oms.u06_routing_ac_type = 0 THEN 1
                         ELSE u06_oms.u06_routing_ac_type
                     END
                         AS acc_type,
                     u06_oms.u06_trading_enabled,
                     u06_oms.u06_sharia_complient,
                     NVL (
                         m08_map.new_trd_group_id,
                         CASE
                             WHEN NVL (map16.map16_ntp_code,
                                       u06_oms.u06_exchange) = 'TDWL'
                             THEN
                                 (SELECT m08_id
                                    FROM dfn_ntp.m08_trading_group
                                   WHERE     m08_is_default = 1
                                         AND m08_institute_id_m02 =
                                                 u06.u06_institute_id_m02)
                             ELSE
                                 (SELECT MIN (m08_id)
                                    FROM dfn_ntp.m08_trading_group m08,
                                         m08_trd_group_mappings m08_map
                                   WHERE     m08.m08_id =
                                                 m08_map.new_trd_group_id
                                         AND m08_map.is_local_exchange = 0
                                         AND m08_institute_id_m02 =
                                                 u06.u06_institute_id_m02)
                         END)
                         AS trd_group_id,
                     NVL (u17_created.new_employee_id, 0) AS created_by_new_id,
                     NVL (u06_oms.u06_created_date, SYSDATE) AS created_date,
                     map01.map01_ntp_id,
                     NVL (m22_map.new_comm_grp_id, m22_default.comm_group)
                         AS new_comm_grp_id,
                     u17_modified.new_employee_id AS modifed_by_new_id,
                     u06_oms.u06_modified_date AS modified_date,
                     NVL (u17_status_changed.new_employee_id, 0)
                         AS status_changed_by_new_id,
                     NVL (u06_oms.u06_status_changed_date, SYSDATE)
                         AS status_changed_date,
                     m26_map_exec.new_executing_broker_id
                         AS executing_broker_id,
                        u05_oms.u05_portfolio_name
                     || CASE
                            WHEN     u05_oms.u05_portfolio_name IS NOT NULL
                                 AND NVL (map16.map16_ntp_code,
                                          u06_oms.u06_exchange) <> 'TDWL'
                            THEN
                                ' - '
                        END
                     || CASE
                            WHEN NVL (map16.map16_ntp_code,
                                      u06_oms.u06_exchange) <> 'TDWL'
                            THEN
                                NVL (map16.map16_ntp_code,
                                     u06_oms.u06_exchange)
                        END
                         AS display_name, -- [Discussed with Janaka, Dushantha & Sandamal : Issues Discussion]
                     u06_oms.u06_exchange_ac,
                     u06_oms.u06_txn_fee,
                     m26_map_custody.new_executing_broker_id AS custodian_id,
                     m35.m35_id,
                     m01.m01_id,
                     u06_oms.u06_trade_rejection_acc,
                     u06_oms.u06_short_selling_acc,
                     DECODE (u06_oms.u06_market_segment,
                             0, 1,
                             1, 3,
                             2, 2,
                             u06_oms.u06_market_segment)
                         AS market_segment,
                     UNISTR (REPLACE (u06_oms.u06_exchange_customer_name, 'u'))
                         AS exchange_customer_name,
                     u06_oms.u06_account_category, -- [SAME IDs]
                     u06_oms.u06_trading_enabled_date,
                     CASE
                         WHEN    u06_oms.u06_is_custodian_account IS NULL
                              OR u06_oms.u06_is_custodian_account = 0
                         THEN
                             0
                         ELSE
                             1
                     END
                         AS is_custodian_account,
                     u05_oms.u05_parent_ac_id,
                     u06_oms.u06_forgn_bank_account,
                     u06_oms.u06_market_maker_enabled,
                     m131_map.new_market_maker_grp_id,
                     u06_oms.u06_comm_discount_from_date,
                     u06_oms.u06_commission_discount_per,
                     u06_oms.u06_comm_discount_to_date,
                     u05_oms.u05_maintenance_margin_perc,
                     u05_oms.u05_murabaha_transfer_enabled,
                     CASE
                         WHEN u05_oms.u05_security_account_type = 3 THEN 1
                         ELSE 0
                     END
                         AS prefred_inst_type_id,
                     m151.m151_id,
                     m151.m151_trade_confirm_format_v12,
                     m22_algo.new_comm_grp_id AS algo_comm_grp,
                     u07_map.new_trading_account_id
                FROM mubasher_oms.u06_routing_accounts@mubasher_db_link u06_oms,
                     mubasher_oms.u05_security_accounts@mubasher_db_link u05_oms,
                     mubasher_oms.m01_customer@mubasher_db_link m01_oms,
                     m02_institute_mappings m02_map,
                     u01_customer_mappings u01_map,
                     dfn_ntp.u01_customer u01,
                     u06_cash_account_mappings u06_map,
                     dfn_ntp.u06_cash_account u06,
                     map01_approval_status_v01 map01,
                     map16_optional_exchanges_m01 map16,
                     (SELECT m01_id, m01_exchange_code
                        FROM dfn_ntp.m01_exchanges
                       WHERE m01_institute_id_m02 = l_primary_institute_id) m01,
                     m08_trd_group_mappings m08_map,
                     m22_comm_grp_mappings m22_map,
                     m22_default_comm_groups m22_default,
                     m26_executing_broker_mappings m26_map_exec,
                     m26_executing_broker_mappings m26_map_custody,
                     u17_employee_mappings u17_created,
                     u17_employee_mappings u17_modified,
                     u17_employee_mappings u17_status_changed,
                     dfn_ntp.m35_customer_settl_group m35,
                     m131_market_maker_grp_mappings m131_map,
                     u07_trading_account_mappings u07_map,
                     dfn_ntp.m151_trade_confirm_config m151,
                     m22_comm_grp_mappings m22_algo
               WHERE     u06_oms.u06_security_ac_id = u05_oms.u05_id
                     AND TO_NUMBER (u05_oms.u05_customer_id) =
                             m01_oms.m01_customer_id(+)
                     AND TO_NUMBER (u05_oms.u05_customer_id) =
                             u01_map.old_customer_id(+)
                     AND u01_map.new_customer_id = u01.u01_id(+)
                     AND u01.u01_institute_id_m02 = m02_map.new_institute_id
                     AND u05_oms.u05_cash_account_id =
                             u06_map.old_cash_account_id(+)
                     AND u06_map.new_cash_account_id = u06.u06_id(+)
                     AND u06_oms.u06_status_id = map01.map01_oms_id
                     AND u06_oms.u06_exchange = map16.map16_oms_code(+)
                     AND NVL (map16.map16_ntp_code, u06_oms.u06_exchange) =
                             m01.m01_exchange_code(+)
                     AND m01_oms.m01_customer_group =
                             m08_map.old_trd_group_id(+)
                     AND CASE
                             WHEN NVL (map16.map16_ntp_code,
                                       u06_oms.u06_exchange) = 'TDWL'
                             THEN
                                 1
                             ELSE
                                 0
                         END = m08_map.is_local_exchange(+)
                     AND NVL (map16.map16_ntp_code, u06_oms.u06_exchange) =
                             m22_default.exchange(+)
                     AND u06_oms.u06_commision_group_id =
                             m22_map.old_comm_grp_id(+)
                     AND u06_oms.u06_exec_broker_inst =
                             m26_map_exec.old_executing_broker_id(+)
                     AND u06_oms.u06_custodian_inst_id =
                             m26_map_custody.old_executing_broker_id(+)
                     AND u06_oms.u06_created_by =
                             u17_created.old_employee_id(+)
                     AND u06_oms.u06_modified_by =
                             u17_modified.old_employee_id(+)
                     AND u06_oms.u06_status_changed_by =
                             u17_status_changed.old_employee_id(+)
                     AND u05_oms.u05_branch_id = m35.m35_institute_id_m02
                     AND u06_oms.u06_market_maker =
                             m131_map.old_market_maker_grp_id(+)
                     AND u05_oms.u05_branch_id = m131_map.new_institute_id(+) -- One Customer Settle Group for Each Institution (If Available)
                     AND u06.u06_institute_id_m02 =
                             m151.m151_institute_id_m02(+)
                     AND u06_oms.u06_algo_comm_group_id =
                             m22_algo.old_comm_grp_id(+)
                     AND u06_oms.u06_security_ac_id =
                             u07_map.old_trading_account_id(+)
                     AND NVL (map16.map16_ntp_code, u06_oms.u06_exchange) =
                             u07_map.exchange_code(+)
            ORDER BY u06_oms.u06_security_ac_id)
    LOOP
        BEGIN
            IF i.m01_id IS NULL
            THEN
                raise_application_error (-20001,
                                         'Exchange Not Available',
                                         TRUE);
            END IF;

            IF i.u01_id IS NULL
            THEN
                raise_application_error (-20001,
                                         'Customer Not Available',
                                         TRUE);
            END IF;

            IF i.u06_id IS NULL
            THEN
                raise_application_error (-20001,
                                         'Cash Account Not Available',
                                         TRUE);
            END IF;

            IF i.new_comm_grp_id IS NULL
            THEN
                raise_application_error (-20001,
                                         'Commision Group Not Available',
                                         TRUE);
            END IF;

            IF i.new_trading_account_id IS NULL
            THEN
                l_trading_acc_id :=
                    CASE
                        WHEN l_use_new_key = 0 THEN i.routing_acc_id
                        ELSE l_trading_acc_id + 1
                    END;

                INSERT
                  INTO dfn_ntp.u07_trading_account (
                           u07_id,
                           u07_institute_id_m02,
                           u07_customer_id_u01,
                           u07_cash_account_id_u06,
                           u07_exchange_code_m01,
                           u07_display_name_u06,
                           u07_customer_no_u01,
                           u07_display_name_u01,
                           u07_default_id_no_u01,
                           u07_is_default,
                           u07_type,
                           u07_trading_enabled,
                           u07_sharia_compliant,
                           u07_trading_group_id_m08,
                           u07_created_by_id_u17,
                           u07_created_date,
                           u07_status_id_v01,
                           u07_commission_group_id_m22,
                           u07_discount_percentage,
                           u07_commission_dis_grp_id_m24,
                           u07_modified_by_id_u17,
                           u07_modified_date,
                           u07_status_changed_by_id_u17,
                           u07_status_changed_date,
                           u07_exe_broker_id_m26,
                           u07_display_name,
                           u07_exchange_account_no,
                           u07_txn_fee,
                           u07_cust_settle_group_id_m35,
                           u07_custodian_id_m26,
                           u07_exchange_id_m01,
                           u07_pending_restriction,
                           u07_external_ref_no,
                           u07_trade_rejection_enabled,
                           u07_short_selling_enabled,
                           u07_market_segment_v01,
                           u07_sharia_compliant_grp_m120,
                           u07_ca_charge_enabled,
                           u07_status_changed_reason,
                           u07_exchange_customer_name,
                           u07_account_category,
                           u07_trading_enabled_date,
                           u07_custodian_type_v01,
                           u07_parent_trading_acc_id_u07,
                           u07_forgn_bank_account,
                           u07_market_maker_enabled,
                           u07_market_maker_group_id_m131,
                           u07_custom_type,
                           u07_trade_conf_config_id_m151,
                           u07_trade_conf_format_id_v12,
                           u07_discount_prec_from_date,
                           u07_discount_prec_to_date,
                           u07_allocation_eligible,
                           u07_maintenance_margin_value,
                           u07_prefred_inst_type_id,
                           u07_sms_notification,
                           u07_email_notification,
                           u07_murabaha_margin_enabled,
                           u07_exg_acc_type_id_v37,
                           u07_clearing_acc_m86,
                           u07_pref_mkt_ids_m29,
                           u07_other_commsion_grp_id_m22,
                           u07_update_extenal_system_b,
                           u07_order_approval_type)
                VALUES (l_trading_acc_id, -- u07_id
                        i.u06_institute_id_m02, -- u07_institute_id_m02
                        i.u01_id, -- u07_customer_id_u01
                        i.u06_id, -- u07_cash_account_id_u06
                        i.exchange_code, -- u07_exchange_code_m01
                        i.u06_display_name, -- u07_display_name_u06
                        i.u01_customer_no, -- u07_customer_no_u01
                        i.u01_display_name, -- u07_display_name_u01
                        i.u01_default_id_no, -- u07_default_id_no_u01
                        '0', -- u07_is_default
                        i.acc_type, -- u07_type
                        i.u06_trading_enabled, -- u07_trading_enabled
                        i.u06_sharia_complient, -- u07_sharia_compliant
                        i.trd_group_id, -- u07_trading_group_id_m08
                        i.created_by_new_id, -- u07_created_by_id_u17
                        i.created_date, -- u07_created_date
                        i.map01_ntp_id, -- u07_status_id_v01
                        i.new_comm_grp_id, -- u07_commission_group_id_m22
                        i.u06_commission_discount_per, -- u07_discount_percentage
                        NULL, -- u07_commission_dis_grp_id_m24 | Not Available
                        i.modifed_by_new_id, --u 07_modified_by_id_u17
                        i.modified_date, -- u07_modified_date
                        i.status_changed_by_new_id, -- u07_status_changed_by_id_u17
                        i.status_changed_date, -- u07_status_changed_date
                        i.executing_broker_id, -- u07_exe_broker_id_m26
                        i.display_name, -- u07_display_name
                        i.u06_exchange_ac, -- u07_exchange_account_no
                        i.u06_txn_fee, -- u07_txn_fee
                        i.m35_id, -- u07_cust_settle_group_id_m35
                        i.custodian_id, -- u07_custodian_id_m26
                        i.m01_id, -- u07_exchange_id_m01
                        '0', -- u07_pending_restriction
                        i.u06_security_ac_id, -- u07_external_ref_no
                        i.u06_trade_rejection_acc, -- u07_trade_rejection_enabled
                        i.u06_short_selling_acc, -- u07_short_selling_enabled
                        i.market_segment, -- u07_market_segment_v01
                        1, --u07_sharia_compliant_grp_m120
                        0, -- u07_ca_charge_enabled
                        NULL, -- u07_status_changed_reason | Not Available
                        i.exchange_customer_name, -- u07_exchange_customer_name
                        i.u06_account_category, -- u07_account_category
                        i.u06_trading_enabled_date, -- u07_trading_enabled_date
                        i.is_custodian_account, -- u07_custodian_type_v01
                        i.u05_parent_ac_id, -- u07_parent_trading_acc_id_u07 | Update Later in this Script
                        i.u06_forgn_bank_account, -- u07_forgn_bank_account
                        i.u06_market_maker_enabled, -- u07_market_maker_enabled
                        i.new_market_maker_grp_id, -- u07_market_maker_group_id_m131
                        '1', -- u07_custom_type
                        i.m151_id, -- u07_trade_conf_config_id_m151
                        i.m151_trade_confirm_format_v12, -- u07_trade_conf_format_id_v12
                        i.u06_comm_discount_from_date, -- u07_discount_prec_from_date
                        i.u06_comm_discount_to_date, -- u07_discount_prec_to_date
                        0, -- u07_allocation_eligible | Not Available
                        i.u05_maintenance_margin_perc, -- u07_maintenance_margin_value
                        i.prefred_inst_type_id, -- u07_prefred_inst_type_id
                        0, -- u07_sms_notification | Not Available
                        0, -- u07_email_notification | Not Available
                        i.u05_murabaha_transfer_enabled, -- u07_murabaha_margin_enabled | Not Available and Asked to Use u05_murabaha_transfer_enabled Column
                        3, -- u07_exg_acc_type_id_v37 | Default Value 3 (Market maker)
                        NULL, -- u07_clearing_acc_m86 | Not Available
                        NULL, -- u07_pref_mkt_ids_m29 | Update Later in this Script
                        i.algo_comm_grp, -- u07_other_commsion_grp_id_m22
                        0, -- u07_update_extenal_system_b | Not Available
                        0 -- u07_order_approval_type | Not Available
                         );

                INSERT INTO u07_trading_account_mappings
                     VALUES (i.u06_security_ac_id,
                             i.routing_acc_id,
                             l_trading_acc_id,
                             i.exchange_code);
            ELSE
                UPDATE dfn_ntp.u07_trading_account
                   SET u07_institute_id_m02 = i.u06_institute_id_m02, -- u07_institute_id_m02
                       u07_customer_id_u01 = i.u01_id, -- u07_customer_id_u01
                       u07_cash_account_id_u06 = i.u06_id, -- u07_cash_account_id_u06
                       u07_display_name_u06 = i.u06_display_name, -- u07_display_name_u06
                       u07_customer_no_u01 = i.u01_customer_no, -- u07_customer_no_u01
                       u07_display_name_u01 = i.u01_display_name, -- u07_display_name_u01
                       u07_default_id_no_u01 = i.u01_default_id_no, -- u07_default_id_no_u01
                       u07_type = i.acc_type, -- u07_type
                       u07_trading_enabled = i.u06_trading_enabled, -- u07_trading_enabled
                       u07_sharia_compliant = i.u06_sharia_complient, -- u07_sharia_compliant
                       u07_trading_group_id_m08 = i.trd_group_id, -- u07_trading_group_id_m08
                       u07_status_id_v01 = i.map01_ntp_id, -- u07_status_id_v01
                       u07_commission_group_id_m22 = i.new_comm_grp_id, -- u07_commission_group_id_m22
                       u07_discount_percentage = i.u06_commission_discount_per, -- u07_discount_percentage
                       u07_modified_by_id_u17 = NVL (i.modifed_by_new_id, 0), --u 07_modified_by_id_u17
                       u07_modified_date = NVL (i.modified_date, SYSDATE), -- u07_modified_date
                       u07_status_changed_by_id_u17 =
                           i.status_changed_by_new_id, -- u07_status_changed_by_id_u17
                       u07_status_changed_date = i.status_changed_date, -- u07_status_changed_date
                       u07_exe_broker_id_m26 = i.executing_broker_id, -- u07_exe_broker_id_m26
                       u07_display_name = i.display_name, -- u07_display_name
                       u07_exchange_account_no = i.u06_exchange_ac, -- u07_exchange_account_no
                       u07_txn_fee = i.u06_txn_fee, -- u07_txn_fee
                       u07_cust_settle_group_id_m35 = i.m35_id, -- u07_cust_settle_group_id_m35
                       u07_custodian_id_m26 = i.custodian_id, -- u07_custodian_id_m26
                       u07_exchange_id_m01 = i.m01_id, -- u07_exchange_id_m01
                       u07_external_ref_no = i.u06_security_ac_id, -- u07_external_ref_no
                       u07_trade_rejection_enabled = i.u06_trade_rejection_acc, -- u07_trade_rejection_enabled
                       u07_short_selling_enabled = i.u06_short_selling_acc, -- u07_short_selling_enabled
                       u07_market_segment_v01 = i.market_segment, -- u07_market_segment_v01
                       u07_exchange_customer_name = i.exchange_customer_name, -- u07_exchange_customer_name
                       u07_account_category = i.u06_account_category, -- u07_account_category
                       u07_trading_enabled_date = i.u06_trading_enabled_date, -- u07_trading_enabled_date
                       u07_custodian_type_v01 = i.is_custodian_account, -- u07_custodian_type_v01
                       u07_parent_trading_acc_id_u07 = i.u05_parent_ac_id, -- u07_parent_trading_acc_id_u07 | Update Later in this Script
                       u07_forgn_bank_account = i.u06_forgn_bank_account, -- u07_forgn_bank_account
                       u07_market_maker_enabled = i.u06_market_maker_enabled, -- u07_market_maker_enabled
                       u07_market_maker_group_id_m131 =
                           i.new_market_maker_grp_id, -- u07_market_maker_group_id_m131
                       u07_trade_conf_config_id_m151 = i.m151_id, -- u07_trade_conf_config_id_m151
                       u07_trade_conf_format_id_v12 =
                           i.m151_trade_confirm_format_v12, -- u07_trade_conf_format_id_v12
                       u07_discount_prec_from_date =
                           i.u06_comm_discount_from_date, -- u07_discount_prec_from_date
                       u07_discount_prec_to_date = i.u06_comm_discount_to_date, -- u07_discount_prec_to_date
                       u07_maintenance_margin_value =
                           i.u05_maintenance_margin_perc, -- u07_maintenance_margin_value
                       u07_prefred_inst_type_id = i.prefred_inst_type_id, -- u07_prefred_inst_type_id
                       u07_murabaha_margin_enabled =
                           i.u05_murabaha_transfer_enabled, -- u07_murabaha_margin_enabled | Not Available and Asked to Use u05_murabaha_transfer_enabled Column
                       u07_other_commsion_grp_id_m22 = i.algo_comm_grp -- u07_other_commsion_grp_id_m22
                 WHERE u07_id = i.new_trading_account_id;
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
                                'U07_TRADING_ACCOUNT',
                                   'Sec. Acc. : '
                                || i.u06_security_ac_id
                                || 'Exchange : '
                                || i.exchange_code,
                                CASE
                                    WHEN i.new_trading_account_id IS NULL
                                    THEN
                                        l_trading_acc_id
                                    ELSE
                                        i.new_trading_account_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_trading_account_id IS NULL
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
    dfn_ntp.sp_stat_gather ('U07_TRADING_ACCOUNT');
END;
/

BEGIN
    DBMS_STATS.gather_table_stats (
        ownname            => 'DFN_MIG',
        tabname            => 'U07_TRADING_ACCOUNT_MAPPINGS',
        cascade            => TRUE,
        estimate_percent   => DBMS_STATS.auto_sample_size);
END;
/

-- Updating Default Trading Account

MERGE INTO dfn_ntp.u07_trading_account u07
     USING (  SELECT MIN (u07_id) AS min_id
                FROM dfn_ntp.u07_trading_account
            GROUP BY u07_customer_id_u01) u07_default
        ON (u07.u07_id = u07_default.min_id)
WHEN MATCHED
THEN
    UPDATE SET u07_is_default = 1;

COMMIT;

-- Updating Parent Trading Account

MERGE INTO dfn_ntp.u07_trading_account u07
     USING (SELECT u07.u07_id, u07_map_parent.new_trading_account_id
              FROM dfn_ntp.u07_trading_account u07,
                   u07_trading_account_mappings u07_map_parent
             WHERE     u07.u07_exchange_code_m01 =
                           u07_map_parent.exchange_code
                   AND u07.u07_parent_trading_acc_id_u07 =
                           u07_map_parent.old_trading_account_id) u07_parent
        ON (u07.u07_id = u07_parent.u07_id)
WHEN MATCHED
THEN
    UPDATE SET
        u07.u07_parent_trading_acc_id_u07 = u07_parent.new_trading_account_id;

COMMIT;

-- Updating Preferred Market IDs

DECLARE
    l_broker_id              NUMBER;
    l_primary_institute_id   NUMBER;
    l_tdwl_main              VARCHAR2 (1000);
    l_tdwl_nomu              VARCHAR2 (1000);
    l_tdwl_both              VARCHAR2 (1000);
BEGIN
    SELECT VALUE
      INTO l_broker_id
      FROM migration_params
     WHERE code = 'BROKERAGE_ID';

    SELECT m150.m150_primary_institute_id_m02
      INTO l_primary_institute_id
      FROM dfn_ntp.m150_broker m150
     WHERE m150.m150_id = l_broker_id;

    FOR i IN (SELECT m02_id
                FROM dfn_ntp.m02_institute
               WHERE m02_primary_institute_id_m02 = l_primary_institute_id)
    LOOP
        SELECT MAX (m29_id)
          INTO l_tdwl_main
          FROM dfn_ntp.m29_markets
         WHERE     m29_primary_institution_id_m02 = i.m02_id
               AND m29_exchange_code_m01 = 'TDWL'
               AND m29_market_code = 'MAIN';

        SELECT MAX (m29_id)
          INTO l_tdwl_nomu
          FROM dfn_ntp.m29_markets
         WHERE     m29_primary_institution_id_m02 = i.m02_id
               AND m29_exchange_code_m01 = 'TDWL'
               AND m29_market_code = 'NOMU';

        l_tdwl_both := l_tdwl_main || ',' || l_tdwl_nomu;

        -- Update TDWL Market Segment - Main

        UPDATE dfn_ntp.u07_trading_account
           SET u07_pref_mkt_ids_m29 = l_tdwl_main
         WHERE     u07_institute_id_m02 = i.m02_id
               AND u07_exchange_code_m01 = 'TDWL'
               AND u07_market_segment_v01 = 1;

        -- Update TDWL Market Segment - Nomu

        UPDATE dfn_ntp.u07_trading_account
           SET u07_pref_mkt_ids_m29 = l_tdwl_nomu
         WHERE     u07_institute_id_m02 = i.m02_id
               AND u07_exchange_code_m01 = 'TDWL'
               AND u07_market_segment_v01 = 2;

        -- Update TDWL Market Segment - Both

        UPDATE dfn_ntp.u07_trading_account
           SET u07_pref_mkt_ids_m29 = l_tdwl_both
         WHERE     u07_institute_id_m02 = i.m02_id
               AND u07_exchange_code_m01 = 'TDWL'
               AND u07_market_segment_v01 = 3;

        -- Uupdate TDWL Market Segment - Empty
        UPDATE dfn_ntp.u07_trading_account
           SET u07_pref_mkt_ids_m29 = l_tdwl_main, u07_market_segment_v01 = 1
         WHERE     u07_institute_id_m02 = i.m02_id
               AND u07_exchange_code_m01 = 'TDWL'
               AND u07_market_segment_v01 IS NULL;

        -- Update TDWL Market Segment - Any Other

        UPDATE dfn_ntp.u07_trading_account
           SET u07_pref_mkt_ids_m29 = l_tdwl_main, u07_market_segment_v01 = 1
         WHERE     u07_institute_id_m02 = i.m02_id
               AND u07_exchange_code_m01 = 'TDWL'
               AND u07_market_segment_v01 NOT IN (1, 2, 3);

        -- Update Market Segment Oher than TDWL to Null

        MERGE INTO dfn_ntp.u07_trading_account
             USING DUAL
                ON (    u07_exchange_code_m01 <> 'TDWL'
                    AND u07_institute_id_m02 = i.m02_id)
        WHEN MATCHED
        THEN
            UPDATE SET u07_pref_mkt_ids_m29 = NULL;
    END LOOP;
END;
/

COMMIT;

BEGIN
    dfn_ntp.sp_stat_gather ('U07_TRADING_ACCOUNT');
END;
/