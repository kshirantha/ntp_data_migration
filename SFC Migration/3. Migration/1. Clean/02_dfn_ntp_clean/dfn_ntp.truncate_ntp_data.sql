-- Institution wise Master Data --

DELETE FROM dfn_ntp.m39_price_qty_factors
      WHERE m39_institute_id_m02 > 0;

DELETE FROM dfn_ntp.u53_process_detail
      WHERE u53_primary_institute_id_m02 > 0;

DELETE FROM dfn_ntp.m126_rules
      WHERE m126_primary_institute_id > 0;

DELETE FROM dfn_ntp.m35_customer_settl_group
      WHERE m35_id > 0;

DELETE FROM dfn_ntp.v20_default_master_data
      WHERE    (    v20_institute_id_m02 > 0
                AND v20_primary_institute_id_m02 IS NULL)
            OR (    v20_institute_id_m02 IS NULL
                AND v20_primary_institute_id_m02 > 0);

DELETE FROM dfn_ntp.v00_sys_config_broker_wise
      WHERE v00_primary_institution_id_m02 > 0;

-- Migrated Data --

TRUNCATE TABLE dfn_ntp.a10_entity_status_history;

TRUNCATE TABLE dfn_ntp.u59_trading_acc_fix_logins;

TRUNCATE TABLE dfn_ntp.t90_murabaha_amortize;

TRUNCATE TABLE dfn_ntp.t67_stock_block_request;

TRUNCATE TABLE dfn_ntp.h13_interest_indices_history;

TRUNCATE TABLE dfn_ntp.t76_murabaha_contract_comp;

TRUNCATE TABLE dfn_ntp.t75_murabaha_contracts;

TRUNCATE TABLE dfn_ntp.t70_mark_to_market;

TRUNCATE TABLE dfn_ntp.m182_murabaha_bskt_composition;

TRUNCATE TABLE dfn_ntp.m181_murabaha_baskets;

TRUNCATE TABLE dfn_ntp.t49_tax_invoice_details;

TRUNCATE TABLE dfn_ntp.t48_tax_invoices;

TRUNCATE TABLE dfn_ntp.t502_change_account_requests_c;

TRUNCATE TABLE dfn_ntp.t15_authorization_request;

TRUNCATE TABLE dfn_ntp.m18_derivative_spread_matrix;

TRUNCATE TABLE dfn_ntp.t43_cust_corp_act_cash_adjust;

TRUNCATE TABLE dfn_ntp.t42_cust_corp_act_hold_adjust;

TRUNCATE TABLE dfn_ntp.t41_cust_corp_act_distribution;

TRUNCATE TABLE dfn_ntp.t29_gl_column_wise_entries;

TRUNCATE TABLE dfn_ntp.t28_gl_record_wise_entries;

DELETE FROM dfn_ntp.t27_gl_batches;

TRUNCATE TABLE dfn_ntp.t38_conditional_order;

TRUNCATE TABLE dfn_ntp.m76_stock_conc_symbol_details;

TRUNCATE TABLE dfn_ntp.m75_stock_concentration_group;

TRUNCATE TABLE dfn_ntp.t61_bulk_share_transactions;

TRUNCATE TABLE dfn_ntp.t501_payment_detail_c;

TRUNCATE TABLE dfn_ntp.t500_payment_sessions_c;

TRUNCATE TABLE dfn_ntp.m170_institute_cash_acc_config;

TRUNCATE TABLE dfn_ntp.m167_custody_charges_slab;

TRUNCATE TABLE dfn_ntp.m166_custody_charges_group;

TRUNCATE TABLE dfn_ntp.m141_cust_corporate_action;

TRUNCATE TABLE dfn_ntp.m177_cash_transfer_limit_group;

TRUNCATE TABLE dfn_ntp.m176_order_limit_group;

DELETE FROM dfn_ntp.m39_price_qty_factors
      WHERE m39_institute_id_m02 > 0;

TRUNCATE TABLE dfn_ntp.t60_exchange_subscription_log;

TRUNCATE TABLE dfn_ntp.t59_product_subscription_log;

TRUNCATE TABLE dfn_ntp.m160_offline_symbol_update_log;

TRUNCATE TABLE dfn_ntp.t57_exchange_subscription_data;

TRUNCATE TABLE dfn_ntp.t56_product_subscription_data;

TRUNCATE TABLE dfn_ntp.m156_exchange_waiveoff_details;

TRUNCATE TABLE dfn_ntp.m155_product_waiveoff_details;

DELETE FROM dfn_ntp.m154_subscription_waiveoff_grp;

TRUNCATE TABLE dfn_ntp.m153_exchange_subscription_prd;

TRUNCATE TABLE dfn_ntp.m157_subcription_prd_channels;

TRUNCATE TABLE dfn_ntp.m152_products;

TRUNCATE TABLE dfn_ntp.t54_slice_orders;

TRUNCATE TABLE dfn_ntp.m132_market_maker_grp_details;

TRUNCATE TABLE dfn_ntp.m178_asset_management_company;

TRUNCATE TABLE dfn_ntp.m158_priceuser_agreement;

TRUNCATE TABLE dfn_ntp.m161_price_user_pool;

TRUNCATE TABLE dfn_ntp.t19_c_umessage_share_details;

TRUNCATE TABLE dfn_ntp.t18_c_umessage;

TRUNCATE TABLE dfn_ntp.t14_notification_data;

TRUNCATE TABLE dfn_ntp.t13_notifications;

TRUNCATE TABLE dfn_ntp.m163_incentive_slabs;

TRUNCATE TABLE dfn_ntp.m162_incentive_group;

TRUNCATE TABLE dfn_ntp.a18_user_login_audit;

TRUNCATE TABLE dfn_ntp.m1001_sukuk_coupon_payment;

TRUNCATE TABLE dfn_ntp.h24_gl_cash_account_summary;

TRUNCATE TABLE dfn_ntp.a06_audit;

TRUNCATE TABLE dfn_ntp.h10_bank_accounts_summary;

TRUNCATE TABLE dfn_ntp.h09_cash_account_update;

TRUNCATE TABLE dfn_ntp.h07_user_sessions;

TRUNCATE TABLE dfn_ntp.h05_institute_trading_limits;

TRUNCATE TABLE dfn_ntp.h03_currency_rate;

TRUNCATE TABLE dfn_ntp.h02_cash_account_summary;

TRUNCATE TABLE dfn_ntp.h01_holding_summary;

TRUNCATE TABLE dfn_ntp.t53_order_canceled_requests;

TRUNCATE TABLE dfn_ntp.t52_desk_orders;

TRUNCATE TABLE dfn_ntp.h26_daily_status;

TRUNCATE TABLE dfn_ntp.t24_customer_margin_request;

TRUNCATE TABLE dfn_ntp.t22_order_audit;

TRUNCATE TABLE dfn_ntp.t21_daily_interest_for_charges;

TRUNCATE TABLE dfn_ntp.t20_pending_pledge;

TRUNCATE TABLE dfn_ntp.t12_share_transaction;

TRUNCATE TABLE dfn_ntp.t11_block_amount_details;

TRUNCATE TABLE dfn_ntp.t10_cash_block_request;

TRUNCATE TABLE dfn_ntp.t08_od_withdraw_limit;

TRUNCATE TABLE dfn_ntp.t06_cash_transaction;

TRUNCATE TABLE dfn_ntp.t05_institute_cash_acc_log;

TRUNCATE TABLE dfn_ntp.t04_disable_exchange_acc_req;

TRUNCATE TABLE dfn_ntp.t02_transaction_log;

TRUNCATE TABLE dfn_ntp.t01_order;

TRUNCATE TABLE dfn_ntp.u13_ext_custody_portfolios;

TRUNCATE TABLE dfn_ntp.u55_poa_symbol_restrictions;

TRUNCATE TABLE dfn_ntp.u49_poa_trading_privileges;

TRUNCATE TABLE dfn_ntp.u52_poa_trad_privilege_pending;

DELETE FROM dfn_ntp.u47_power_of_attorney;

TRUNCATE TABLE dfn_ntp.u45_uploaded_doc_pages;

TRUNCATE TABLE dfn_ntp.u44_uploaded_documents;

TRUNCATE TABLE dfn_ntp.u41_notification_configuration;

TRUNCATE TABLE dfn_ntp.u29_emp_notification_groups;

TRUNCATE TABLE dfn_ntp.u28_employee_exchanges;

TRUNCATE TABLE dfn_ntp.u24_holdings;

TRUNCATE TABLE dfn_ntp.m43_institute_exchanges;

TRUNCATE TABLE dfn_ntp.u22_customer_margin_call_log;

TRUNCATE TABLE dfn_ntp.u23_customer_margin_product;

TRUNCATE TABLE dfn_ntp.u18_trading_channel_restrict;

TRUNCATE TABLE dfn_ntp.u16_trading_instrument_restric;

TRUNCATE TABLE dfn_ntp.u14_trading_symbol_restriction;

TRUNCATE TABLE dfn_ntp.u12_trading_restriction;

TRUNCATE TABLE dfn_ntp.u11_cash_restriction;

TRUNCATE TABLE dfn_ntp.m104_cust_notification_schedul;

DELETE FROM dfn_ntp.u10_login_trading_acc;

TRUNCATE TABLE dfn_ntp.u30_login_cash_acc;

TRUNCATE TABLE dfn_ntp.u46_user_sessions;

DELETE FROM dfn_ntp.u09_customer_login;

TRUNCATE TABLE dfn_ntp.u08_customer_beneficiary_acc;

DELETE FROM dfn_ntp.u07_trading_account;

DELETE FROM dfn_ntp.m131_market_maker_grps;

DELETE FROM dfn_ntp.u06_cash_account;

TRUNCATE TABLE dfn_ntp.u03_customer_kyc;

TRUNCATE TABLE dfn_ntp.u05_customer_identification;

TRUNCATE TABLE dfn_ntp.u48_corp_customer_contact;

TRUNCATE TABLE dfn_ntp.u02_customer_contact_info;

TRUNCATE TABLE dfn_ntp.m109_customer_family_members;

DELETE FROM dfn_ntp.u01_customer;

TRUNCATE TABLE dfn_ntp.m93_bank_accounts;

TRUNCATE TABLE dfn_ntp.m139_gl_column_destribution;

TRUNCATE TABLE dfn_ntp.m138_gl_record_destribution;

DELETE FROM dfn_ntp.m137_gl_event_data_sources;

DELETE FROM dfn_ntp.m136_gl_event_categories;

TRUNCATE TABLE dfn_ntp.m135_gl_accounts;

DELETE FROM dfn_ntp.m134_gl_account_categories;

DELETE FROM dfn_ntp.m133_gl_account_types;

TRUNCATE TABLE dfn_ntp.m151_trade_confirm_config;

TRUNCATE TABLE dfn_ntp.m125_exchange_instrument_type;

TRUNCATE TABLE dfn_ntp.m122_exchange_tick_sizes;

TRUNCATE TABLE dfn_ntp.m119_sharia_symbol;

DELETE FROM dfn_ntp.m120_sharia_compliant_group;

TRUNCATE TABLE dfn_ntp.m118_charge_fee_structure;

TRUNCATE TABLE dfn_ntp.m117_charge_groups;

TRUNCATE TABLE dfn_ntp.m116_hijri_adjustments;

TRUNCATE TABLE dfn_ntp.m110_reasons;

TRUNCATE TABLE dfn_ntp.m114_company_positions;

TRUNCATE TABLE dfn_ntp.m105_other_brokerages;

TRUNCATE TABLE dfn_ntp.m89_customer_category;

TRUNCATE TABLE dfn_ntp.m87_exec_broker_exchange;

TRUNCATE TABLE dfn_ntp.m79_pending_symbl_mrg_request;

TRUNCATE TABLE dfn_ntp.m78_symbol_marginability;

DELETE FROM dfn_ntp.m77_symbol_marginability_grps;

TRUNCATE TABLE dfn_ntp.m74_margin_interest_group;

DELETE FROM dfn_ntp.m73_margin_products;

TRUNCATE TABLE dfn_ntp.m72_exec_broker_cash_account;

TRUNCATE TABLE dfn_ntp.m70_custody_exchanges;

TRUNCATE TABLE dfn_ntp.m69_institute_trading_limits;

TRUNCATE TABLE dfn_ntp.m68_institute_order_channels;

TRUNCATE TABLE dfn_ntp.m67_fix_logins;

DELETE FROM dfn_ntp.m65_saibor_basis_rates;

DELETE FROM dfn_ntp.m52_notification_group
      WHERE m52_institute_id_m02 > 0;

DELETE FROM dfn_ntp.m62_institute_documents;

TRUNCATE TABLE dfn_ntp.m60_institute_banks;

TRUNCATE TABLE dfn_ntp.m51_employee_trading_groups;

TRUNCATE TABLE dfn_ntp.m50_employee_trd_limits;

DELETE FROM dfn_ntp.m47_permission_grp_users
      WHERE m47_group_id_m45 IN (SELECT m45_id
                                   FROM dfn_ntp.m45_permission_groups
                                  WHERE m45_institute_id_m02 > 0);

DELETE FROM dfn_ntp.m46_permission_grp_entlements
      WHERE m46_group_id_m45 IN (SELECT m45_id
                                   FROM dfn_ntp.m45_permission_groups
                                  WHERE m45_institute_id_m02 > 0);

DELETE FROM dfn_ntp.m45_permission_groups
      WHERE m45_institute_id_m02 > 0;

DELETE FROM dfn_ntp.m44_institution_entitlements
      WHERE m44_institution_id_m02 > 0;

TRUNCATE TABLE dfn_ntp.m32_ex_market_status_tif;

TRUNCATE TABLE dfn_ntp.m30_ex_market_permissions;

TRUNCATE TABLE dfn_ntp.m59_exchange_market_status;

TRUNCATE TABLE dfn_ntp.m58_exchange_tif;

TRUNCATE TABLE dfn_ntp.m57_exchange_order_types;

TRUNCATE TABLE dfn_ntp.m28_customer_grade_data;

TRUNCATE TABLE dfn_ntp.m34_exec_broker_commission;

DELETE FROM dfn_ntp.m26_executing_broker;

TRUNCATE TABLE dfn_ntp.m25_commission_discount_slabs;

DELETE FROM dfn_ntp.m24_commission_discount_group;

TRUNCATE TABLE dfn_ntp.m23_commission_slabs;

DELETE FROM dfn_ntp.m22_commission_group;

TRUNCATE TABLE dfn_ntp.m21_introducing_broker;

TRUNCATE TABLE dfn_ntp.m20_symbol_extended;

DELETE FROM dfn_ntp.m20_symbol;

DELETE FROM dfn_ntp.m63_sectors;

TRUNCATE TABLE dfn_ntp.m29_markets;

TRUNCATE TABLE dfn_ntp.m17_bank_branches;

DELETE FROM dfn_ntp.m16_bank;

DELETE FROM dfn_ntp.m14_issue_location;

DELETE FROM dfn_ntp.m10_relationship_manager;

TRUNCATE TABLE dfn_ntp.m09_companies;

DELETE FROM dfn_ntp.m08_trading_group;

DELETE FROM dfn_ntp.m01_exchanges;

DELETE FROM dfn_ntp.m07_location
      WHERE m07_id > 0;

DELETE FROM dfn_ntp.m04_currency_rate
      WHERE m04_id > 0;

DELETE FROM dfn_ntp.u17_employee
      WHERE u17_id > 0;

DELETE FROM dfn_ntp.m12_employee_department
      WHERE m12_id > 0;

DELETE FROM dfn_ntp.m35_customer_settl_group
      WHERE m35_id > 0;

TRUNCATE TABLE dfn_ntp.m140_corp_action_templates;

TRUNCATE TABLE dfn_ntp.m175_data_loader_type_fields;

TRUNCATE TABLE dfn_ntp.m174_data_loader_field_map;

DELETE FROM dfn_ntp.m173_data_loader_template;

DELETE FROM dfn_ntp.m02_institute
      WHERE m02_id > 0;

DELETE FROM dfn_ntp.m150_broker
      WHERE m150_id > 0;

TRUNCATE TABLE dfn_ntp.h00_dates;

TRUNCATE TABLE dfn_ntp.a01_db_jobs_execution_log;

TRUNCATE TABLE dfn_ntp.t67_stock_block_request;

COMMIT;

-- Post Migration

TRUNCATE TABLE dfn_ntp.m180_institute_default_values;

TRUNCATE TABLE dfn_ntp.m31_exec_broker_routing;

TRUNCATE TABLE dfn_ntp.m19_routing_data;

-- Automation Related

TRUNCATE TABLE dfn_ntp.m165_discount_charge_groups;

TRUNCATE TABLE dfn_ntp.m117_charge_groups;

TRUNCATE TABLE dfn_ntp.m151_trade_confirm_config;

COMMIT;