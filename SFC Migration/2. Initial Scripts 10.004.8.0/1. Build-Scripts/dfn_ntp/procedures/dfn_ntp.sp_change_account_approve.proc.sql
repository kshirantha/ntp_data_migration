CREATE OR REPLACE PROCEDURE dfn_ntp.sp_change_account_approve (
   p_key                    OUT VARCHAR,
   p_t502_id             IN     NUMBER,
   p_changed_by_id_u17   IN     NUMBER)
IS
   l_u07_from_id              NUMBER;
   l_u06_to_cash_account_id   NUMBER;
   l_count                    NUMBER := 0;
   l_count_cash               NUMBER := 0;
   l_count_to_trading_acc     NUMBER := 0;
   l_blob_id                  NUMBER;
   l_u07_customer_id_u01      NUMBER;
   l_u07_display_name_u06     VARCHAR2 (20);
   l_u07_customer_no_u01      VARCHAR2 (20);
   l_u07_display_name_u01     VARCHAR2 (1000);
   l_u07_default_id_no_u01    VARCHAR2 (20);
BEGIN
   BEGIN
      SELECT t502_from_trading_acc_id_u07, t502_target_cash_acc_id_u06
        INTO l_u07_from_id, l_u06_to_cash_account_id
        FROM t502_change_account_requests_c a
       WHERE a.t502_id = p_t502_id;

      SELECT COUNT (*)
        INTO l_count
        FROM u07_trading_account u07
       WHERE u07.u07_id = l_u07_from_id;

      SELECT COUNT (*)
        INTO l_count_cash
        FROM u06_cash_account u06
       WHERE u06.u06_id = l_u06_to_cash_account_id;


      SELECT COUNT (*)
        INTO l_count_to_trading_acc
        FROM u07_trading_account u07
       WHERE u07.u07_cash_account_id_u06 = l_u06_to_cash_account_id;


      IF l_count = 0 OR l_count_cash = 0
      THEN
         p_key := '-2';
         RETURN;
      ELSIF l_count_to_trading_acc > 0
      THEN
         SELECT u07.u07_id
           INTO p_key
           FROM u07_trading_account u07
          WHERE u07.u07_cash_account_id_u06 = l_u06_to_cash_account_id;

         RETURN;
      ELSE
         SELECT a.u06_customer_id_u01,
                a.u06_display_name,
                a.u06_customer_no_u01,
                a.u06_display_name_u01,
                a.u06_default_id_no_u01
           INTO l_u07_customer_id_u01,
                l_u07_display_name_u06,
                l_u07_customer_no_u01,
                l_u07_display_name_u01,
                l_u07_default_id_no_u01
           FROM u06_cash_account a
          WHERE a.u06_id = l_u06_to_cash_account_id;

         SELECT a.app_seq_value + 1
           INTO p_key
           FROM app_seq_store a
          WHERE app_seq_name = 'U07_TRADING_ACCOUNT';

         UPDATE app_seq_store a
            SET app_seq_value = app_seq_value + 1
          WHERE app_seq_name = 'U07_TRADING_ACCOUNT';

         INSERT INTO u07_trading_account (u07_id,
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
                                          u07_discount_prec_to_date)
            SELECT p_key,
                   a.u07_institute_id_m02,
                   l_u07_customer_id_u01,            -- a.u07_customer_id_u01,
                   l_u06_to_cash_account_id,    --  a.u07_cash_account_id_u06,
                   a.u07_exchange_code_m01,
                   l_u07_display_name_u06,           --a.u07_display_name_u06,
                   l_u07_customer_no_u01,             --a.u07_customer_no_u01,
                   l_u07_display_name_u01,           --a.u07_display_name_u01,
                   l_u07_default_id_no_u01,        -- a.u07_default_id_no_u01,
                   a.u07_is_default,
                   a.u07_type,
                   a.u07_trading_enabled,
                   a.u07_sharia_compliant,
                   a.u07_trading_group_id_m08,
                   p_changed_by_id_u17,            -- a.u07_created_by_id_u17,
                   SYSDATE,                              --a.u07_created_date,
                   2,                                  -- a.u07_status_id_v01,
                   a.u07_commission_group_id_m22,
                   a.u07_discount_percentage,
                   a.u07_commission_dis_grp_id_m24,
                   p_changed_by_id_u17,           -- a.u07_modified_by_id_u17,
                   SYSDATE,                             --a.u07_modified_date,
                   p_changed_by_id_u17,      --a.u07_status_changed_by_id_u17,
                   SYSDATE,                      -- a.u07_status_changed_date,
                   a.u07_exe_broker_id_m26,
                   a.u07_display_name,
                   a.u07_exchange_account_no,
                   a.u07_txn_fee,
                   a.u07_cust_settle_group_id_m35,
                   a.u07_custodian_id_m26,
                   a.u07_exchange_id_m01,
                   a.u07_pending_restriction,
                   a.u07_external_ref_no,
                   a.u07_trade_rejection_enabled,
                   a.u07_short_selling_enabled,
                   a.u07_market_segment_v01,
                   a.u07_sharia_compliant_grp_m120,
                   a.u07_ca_charge_enabled,
                   a.u07_status_changed_reason,
                   a.u07_exchange_customer_name,
                   a.u07_account_category,
                   a.u07_trading_enabled_date,
                   a.u07_custodian_type_v01,
                   NULL,                    --a.u07_parent_trading_acc_id_u07,
                   a.u07_forgn_bank_account,
                   a.u07_market_maker_enabled,
                   a.u07_market_maker_group_id_m131,
                   a.u07_custom_type,
                   a.u07_trade_conf_config_id_m151,
                   a.u07_trade_conf_format_id_v12,
                   a.u07_discount_prec_from_date,
                   a.u07_discount_prec_to_date
              FROM u07_trading_account a
             WHERE u07_id = l_u07_from_id;
			 
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         p_key := -1;
   END;
END;
/