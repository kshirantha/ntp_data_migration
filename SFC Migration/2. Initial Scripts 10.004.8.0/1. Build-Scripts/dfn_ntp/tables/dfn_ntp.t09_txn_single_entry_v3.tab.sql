CREATE TABLE dfn_ntp.t09_txn_single_entry_v3
(
    t09_db_seq_id                    NUMBER (20, 0) NOT NULL,
    t09_audit_key                    VARCHAR2 (200 BYTE) NOT NULL,
    t09_cash_blk                     NUMBER (18, 5),
    t09_holding_net                  NUMBER (18, 0),
    t09_holding_blk                  NUMBER (18, 0),
    t09_holding_paybale              NUMBER (18, 0),
    t09_holding_receivable           NUMBER (18, 0),
    t09_sell_pending                 NUMBER (18, 0),
    t09_buy_pending                  NUMBER (18, 0),
    t09_weighted_avgprice            NUMBER (18, 5),
    t09_weighted_avgcost             NUMBER (18, 5),
    t09_ord_type_v06                 VARCHAR2 (10 BYTE),
    t09_institution_id_m02           NUMBER (5, 0),
    t09_commission_orig              NUMBER (18, 5),
    t09_fxrate                       NUMBER (18, 5),
    t09_settle_currency_m03          VARCHAR2 (5 BYTE),
    t09_poa_id_u47                   NUMBER (18, 0),
    t09_customer_id_u01              NUMBER (18, 0),
    t09_remarks                      VARCHAR2 (100 BYTE),
    t09_last_updated_time            VARCHAR2 (100 BYTE),
    t09_price                        NUMBER (18, 5),
    t09_quantity                     NUMBER (18, 0),
    t09_side                         NUMBER (5, 0),
    t09_clordid                      VARCHAR2 (50 BYTE),
    t09_clordid_orig                 VARCHAR2 (50 BYTE),
    t09_ordid                        VARCHAR2 (50 BYTE),
    t09_custodian_id_m26             NUMBER (10, 0),
    t09_ord_value                    NUMBER (18, 5),
    t09_ord_netvalue                 NUMBER (18, 5),
    t09_commission                   NUMBER (18, 5),
    t09_ord_netsettle                NUMBER (18, 5),
    t09_exec_brk_commission          NUMBER (18, 5),
    t09_exchange_m01                 VARCHAR2 (10 BYTE),
    t09_narration                    VARCHAR2 (100 BYTE),
    t09_cashacnt_id_u06              NUMBER (18, 0),
    t09_trading_acc_id_u07           NUMBER (10, 0),
    t09_minfil_qty                   NUMBER (10, 0),
    t09_netvalue_this_execution      NUMBER (18, 5),
    t09_netsettle_this_execution     NUMBER (18, 5),
    t09_ordvalue_this_execution      NUMBER (18, 5),
    t09_created_time                 VARCHAR2 (100 BYTE),
    t09_execid                       VARCHAR2 (100 BYTE),
    t09_last_price                   NUMBER (18, 5),
    t09_avg_price                    NUMBER (18, 5),
    t09_trade_match_id               VARCHAR2 (100 BYTE),
    t09_ord_netsettle_diff           NUMBER (18, 5),
    t09_cumord_value                 NUMBER (18, 5),
    t09_cumord_netvalue              NUMBER (18, 5),
    t09_cumord_netsettle             NUMBER (18, 5),
    t09_last_shares                  NUMBER (18, 0),
    t09_leaves_qty                   NUMBER (18, 0),
    t09_cum_qty                      NUMBER (18, 0),
    t09_avg_cost                     NUMBER (18, 5),
    t09_cum_commission               NUMBER (18, 5),
    t09_cash_settle_date             VARCHAR2 (50 BYTE),
    t09_holding_settle_date          VARCHAR2 (50 BYTE),
    t09_tenant_code                  VARCHAR2 (50 BYTE),
    t09_lockseq                      VARCHAR2 (20 BYTE) NOT NULL,
    t09_accrd_intrst_diff            NUMBER (18, 5),
    t09_txntime                      VARCHAR2 (100 BYTE),
    t09_symbol_code_m20              VARCHAR2 (24 BYTE),
    t09_dealer_id_u18                VARCHAR2 (100 BYTE),
    t09_accurd_intrst                NUMBER (18, 5),
    t09_cash_balance_orig            NUMBER (30, 5),
    t09_symbol_id_m20                VARCHAR2 (10 BYTE),
    t09_cash_balance                 NUMBER (30, 5),
    t09_cash_blk_orig                NUMBER (18, 5),
    t09_cash_blk_diff                NUMBER (18, 5),
    t09_cash_payable_orig            NUMBER (18, 5),
    t09_cash_receivable_orig         NUMBER (18, 5),
    t09_cash_open_buy_blk            NUMBER (18, 5),
    t09_cash_open_buy_blk_orig       NUMBER (18, 5),
    t09_pre_ord_cum_value            NUMBER (18, 5),
    t09_pre_ord_qty                  NUMBER (18, 0),
    t09_pre_ord_cum_commisn          NUMBER (18, 5),
    t09_commisn_diff                 NUMBER (18, 5),
    t09_holding_entry_key            VARCHAR2 (100 BYTE),
    t09_ord_no                       VARCHAR2 (50 BYTE),
    t09_remote_clordid               VARCHAR2 (100 BYTE),
    t09_remote_orig_clordid          VARCHAR2 (100 BYTE),
    t09_created_date                 VARCHAR2 (100 BYTE),
    t09_disclosed_qty                NUMBER (18, 0),
    t09_tif_m58                      VARCHAR2 (100 BYTE),
    t09_instruction_type             VARCHAR2 (5 BYTE),
    t09_commisn_discount             NUMBER (18, 5),
    t09_exp_date                     VARCHAR2 (100 BYTE),
    t09_cum_exec_brk_commisn         NUMBER (18, 5),
    t09_cum_accrd_intrst             NUMBER (18, 5),
    t09_exec_brkr_id_m26             NUMBER (18, 0),
    t09_holding_blk_manual           NUMBER (18, 0),
    t09_position_effect              VARCHAR2 (100 BYTE),
    t09_remote_sub_comp_id           VARCHAR2 (100 BYTE),
    t09_remote_tag_22                VARCHAR2 (100 BYTE),
    t09_remote_tag_100               VARCHAR2 (100 BYTE),
    t09_remote_sid                   VARCHAR2 (100 BYTE),
    t09_txn_currency_m03             VARCHAR2 (5 BYTE),
    t09_txlogid                      VARCHAR2 (100 BYTE),
    t09_netholding_orig              NUMBER (18, 0),
    t09_avg_cost_orig                NUMBER (18, 5),
    t09_extnl_ref                    VARCHAR2 (100 BYTE),
    t09_gain_loss                    NUMBER (18, 5),
    t09_cust_beneficiary_acc_u08     VARCHAR2 (100 BYTE),
    t09_institute_id_m02             NUMBER (10, 0),
    t09_customer_no_u01              VARCHAR2 (100 BYTE),
    t09_instrument_type              VARCHAR2 (10 BYTE),
    t09_ord_blk                      NUMBER (18, 5),
    t09_ord_status_v30               VARCHAR2 (10 BYTE),
    t09_channel_id_v29               VARCHAR2 (100 BYTE),
    t09_display_name                 VARCHAR2 (100 BYTE),
    t09_app_server_id                VARCHAR2 (20 BYTE),
    t09_cash_payable_blk             NUMBER (18, 5),
    t09_cash_receivable_amnt         NUMBER (18, 5),
    t09_pending_deposit              NUMBER (18, 5),
    t09_pending_deposit_orig         NUMBER (18, 5),
    t09_pending_withdraw             NUMBER (18, 5),
    t09_pending_withdraw_orig        NUMBER (18, 5),
    t09_txn_code                     VARCHAR2 (50 BYTE),
    t09_market_code_m29              VARCHAR2 (50 BYTE),
    t09_db_created_time              DATE DEFAULT SYSDATE,
    t09_tnsfer_paymethod             NUMBER (4, 0),
    t09_commisn_this_execution       VARCHAR2 (100 BYTE),
    t09_holding_net_diff             NUMBER (18, 0),
    t09_holding_blk_diff             NUMBER (18, 0),
    t09_online_login_id_u09          NUMBER (18, 0),
    t09_pledge_qty                   NUMBER (18, 0) DEFAULT 0,
    t09_cum_discount                 NUMBER (18, 5),
    t09_discount_diff                NUMBER (18, 5),
    t09_exec_brk_commisn_diff        NUMBER (18, 5),
    t09_ord_mode                     NUMBER (2, 0),
    t09_fix_msg_type                 VARCHAR2 (20 BYTE),
    t09_price_inst_type              NUMBER (10, 0),
    t09_exec_instruction             VARCHAR2 (50 BYTE),
    t09_orig_ord_status_v30          VARCHAR2 (10 BYTE),
    t09_brker_fix_id                 VARCHAR2 (100 BYTE),
    t09_trading_acntno_u07           VARCHAR2 (50 BYTE),
    t09_db_insert_time               TIMESTAMP (6),
    t09_db_entry_insert_time         TIMESTAMP (6),
    t09_update_impact_code           NUMBER (2, 0),
    t09_amnt_in_txn_curr             NUMBER (18, 5),
    t09_amnt_in_stl_curr             NUMBER (18, 5),
    t09_is_active_order              NUMBER (1, 0) DEFAULT -1,
    t09_is_active_order_orig         NUMBER (1, 0) DEFAULT -1,
    t09_fail_mngmnt_status           NUMBER (1, 0) DEFAULT 0,
    t09_fail_mngmnt_clord_id         VARCHAR2 (50 BYTE),
    t09_fail_mngmnt_exec_id          VARCHAR2 (100 BYTE),
    t09_subscribed_qty               NUMBER (18, 0) DEFAULT 0,
    t09_profit_loss                  NUMBER (18, 5),
    t09_profit_loss_this_exec        NUMBER (18, 5),
    t09_broker_tax                   NUMBER (18, 5),
    t09_exchange_tax                 NUMBER (18, 5),
    t09_cum_broker_tax               NUMBER (18, 5),
    t09_cum_exchange_tax             NUMBER (18, 5),
    t09_wfa_current_level            NUMBER (2, 0),
    t09_profit_loss_holding          NUMBER (18, 5),
    t09_act_broker_tax               NUMBER (18, 5),
    t09_act_exchange_tax             NUMBER (18, 5),
    t09_cum_act_broker_tax           NUMBER (18, 5),
    t09_cum_act_exchange_tax         NUMBER (18, 5),
    t09_exec_brk_tax                 NUMBER (18, 5),
    t09_exec_exchange_tax            NUMBER (18, 5),
    t09_exec_act_brk_tax             NUMBER (18, 5),
    t09_exec_act_exchange_tax        NUMBER (18, 5),
    t09_ib_commission                NUMBER (18, 5),
    t09_cum_ib_commission            NUMBER (18, 5),
    t09_exec_ib_commission           NUMBER (18, 5),
    t09_custodian_type_v01           NUMBER (2, 0),
    t09_short_holdings               NUMBER (18, 0) DEFAULT 0,
    t09_base_symbol_code_m20         VARCHAR2 (10 BYTE),
    t09_base_sym_exchange_m01        VARCHAR2 (10 BYTE),
    t09_base_holding_block           NUMBER (18, 0) DEFAULT 0,
    t09_internal_order_status_v30    VARCHAR2 (10 BYTE),
    t09_cum_child_qty                NUMBER (18, 0),
    t09_desk_order_type              NUMBER (1, 0),
    t09_reject_reason                VARCHAR2 (100 BYTE),
    t09_desk_order_ref_t52           VARCHAR2 (18 BYTE) DEFAULT NULL,
    t09_desk_order_no_t52            VARCHAR2 (18 BYTE) DEFAULT NULL,
    t09_parent_status_v30            VARCHAR2 (10 BYTE),
    t09_parent_cum_quantity          NUMBER (18, 0) DEFAULT 0,
    t09_parent_avg_price             NUMBER (18, 5),
    t09_trade_processing_status_id   NUMBER (2, 0) DEFAULT 25,
    t09_approved_by_id_u17           NUMBER (5, 0) DEFAULT -1,
    t09_condition                    VARCHAR2 (100 BYTE),
    t09_inst_service_id              NUMBER (2, 0) DEFAULT 0,
    t09_start_time                   DATE,
    t09_would_condition              VARCHAR2 (100 BYTE),
    t09_limit_condition              VARCHAR2 (100 BYTE),
    t09_shadowing_depth              NUMBER (10, 0) DEFAULT -1,
    t09_exec_type                    NUMBER (2, 0),
    t09_ord_qty_sent                 NUMBER (10, 0),
    t09_block_size                   NUMBER (10, 0),
    t09_trig_interval                NUMBER (10, 0),
    t09_interval_type                NUMBER (2, 0),
    t09_max_percentage_vol           NUMBER (10, 0),
    t09_would_level                  NUMBER (18, 5),
    t09_max_orders                   NUMBER (10, 0),
    t09_renewal_percentage           NUMBER (10, 0),
    t09_thirdparty_mre               NUMBER (1, 0),
    t09_algorithm_id                 VARCHAR2 (20 BYTE),
    t09_algo_start_time              DATE,
    t09_algo_end_time                DATE,
    t09_participation_perc           NUMBER (18, 5),
    t09_min_order_amount             NUMBER (10, 0),
    t09_behind_perc                  NUMBER (18, 5),
    t09_kickoff_perc                 NUMBER (18, 5),
    t09_aggressive_chase             NUMBER (18, 5),
    t09_opening                      NUMBER (10, 0),
    t09_closing                      NUMBER (10, 0),
    t09_waves                        NUMBER (10, 0),
    t09_would_price                  NUMBER (18, 5),
    t09_perc_at_open                 NUMBER (18, 5),
    t09_perc_at_close                NUMBER (18, 5),
    t09_style                        NUMBER (10, 0),
    t09_slices                       NUMBER (10, 0),
    t09_strategy_status              NUMBER (5, 0),
    t09_accumulate_volume            NUMBER (10, 0),
    t09_close_simulation             NUMBER (10, 0),
    t09_exchange_fee                 NUMBER (18, 5),
    t09_broker_fee                   NUMBER (18, 5),
    t09_price_sub_fee                NUMBER (18, 5),
    t09_parent_net_value             NUMBER (18, 5),
    t09_queued_ord_count             NUMBER (10, 0),
    t09_algo_order_ref_t54           VARCHAR2 (18 BYTE),
    t09_algo_parent_cum_qty          NUMBER (18, 0),
    t09_net_receivable               NUMBER (18, 5),
    t09_holding_txn_id               NUMBER (18, 0),
    t09_cash_txn_id                  NUMBER (18, 0),
    t09_holding_net_receivable       NUMBER (18, 0),
    t09_last_updated_by              VARCHAR2 (30 BYTE),
    t09_wfa_current_value            VARCHAR2 (100 BYTE),
    t09_wfa_expected_value           VARCHAR2 (100 BYTE),
    t09_eod_job_id_a13               NUMBER (18, 0),
    t09_bank_id_m93                  VARCHAR2 (18 BYTE),
    t09_remote_sec_source_id         VARCHAR2 (25 BYTE),
    t09_tag50                        VARCHAR2 (25 BYTE),
    t09_exg_commission_orig          NUMBER (18, 5),
    t09_exchange_id_m01              NUMBER (10, 0),
    t09_settle_cal_conf_id_m95       NUMBER (10, 0),
    t09_original_ordid               VARCHAR2 (16 BYTE),
    t09_origin_txn_id                VARCHAR2 (50 BYTE),
    t09_txn_refrence_id              VARCHAR2 (50 BYTE),
    t09_wfa_reason                   VARCHAR2 (100 BYTE),
    t09_cond_order_id_t38            VARCHAR2 (22 BYTE),
    t09_master_ref_t500              NUMBER (20, 0),
    t09_trade_confirm_no             NUMBER (20, 0),
    t09_parent_cumord_netvalue       NUMBER (18, 5),
    t09_parent_cumord_netsettle      NUMBER (18, 5),
    t09_option_base_holding_block    NUMBER (18, 0),
    t09_option_base_cash_block       NUMBER (18, 0),
    t09_reference_type               VARCHAR2 (200 BYTE)
)
/



CREATE UNIQUE INDEX dfn_ntp.ix_t09_db_seq_id
    ON dfn_ntp.t09_txn_single_entry_v3 ("T09_DB_SEQ_ID" DESC)
/


ALTER TABLE dfn_ntp.t09_txn_single_entry_v3
ADD CONSTRAINT t09_txn_single_entry_v3_pk PRIMARY KEY (t09_audit_key)
USING INDEX
/

COMMENT ON COLUMN dfn_ntp.t09_txn_single_entry_v3.t09_accumulate_volume IS
    '1-Yes; 0-No'
/
COMMENT ON COLUMN dfn_ntp.t09_txn_single_entry_v3.t09_algo_end_time IS
    'ThirdParty Algo End time'
/
COMMENT ON COLUMN dfn_ntp.t09_txn_single_entry_v3.t09_algo_start_time IS
    'ThirdParty Algo Start Time'
/
COMMENT ON COLUMN dfn_ntp.t09_txn_single_entry_v3.t09_algorithm_id IS
    'Algorithm ID for Thirdparty MRE'
/
COMMENT ON COLUMN dfn_ntp.t09_txn_single_entry_v3.t09_amnt_in_stl_curr IS
    'Amount in settle currency'
/
COMMENT ON COLUMN dfn_ntp.t09_txn_single_entry_v3.t09_amnt_in_txn_curr IS
    'Amount in transaction currency'
/
COMMENT ON COLUMN dfn_ntp.t09_txn_single_entry_v3.t09_approved_by_id_u17 IS
    'Approve by Dealer / Employee ID'
/
COMMENT ON COLUMN dfn_ntp.t09_txn_single_entry_v3.t09_audit_key IS
    'Unique key for audit entry'
/
COMMENT ON COLUMN dfn_ntp.t09_txn_single_entry_v3.t09_bank_id_m93 IS
    'Bank Account Number'
/
COMMENT ON COLUMN dfn_ntp.t09_txn_single_entry_v3.t09_brker_fix_id IS
    'Used to save external broker fix id to maintina uniqueness of external clOrdId'
/
COMMENT ON COLUMN dfn_ntp.t09_txn_single_entry_v3.t09_close_simulation IS
    '1-Yes; 0-No'
/
COMMENT ON COLUMN dfn_ntp.t09_txn_single_entry_v3.t09_closing IS
    '0:Default 1:Yes'
/
COMMENT ON COLUMN dfn_ntp.t09_txn_single_entry_v3.t09_commission_orig IS
    'original comm when broker comm overwite happens'
/
COMMENT ON COLUMN dfn_ntp.t09_txn_single_entry_v3.t09_cond_order_id_t38 IS
    'Reference for T38 Condition Orders'
/
COMMENT ON COLUMN dfn_ntp.t09_txn_single_entry_v3.t09_condition IS
    'Condition to be Evaluate'
/
COMMENT ON COLUMN dfn_ntp.t09_txn_single_entry_v3.t09_cum_discount IS
    'Discount for filled quantity'
/
COMMENT ON COLUMN dfn_ntp.t09_txn_single_entry_v3.t09_custodian_type_v01 IS
    'Type =57'
/
COMMENT ON COLUMN dfn_ntp.t09_txn_single_entry_v3.t09_db_entry_insert_time IS
    'sysdate where db insert happens'
/
COMMENT ON COLUMN dfn_ntp.t09_txn_single_entry_v3.t09_db_insert_time IS
    'sysdate at data insert'
/
COMMENT ON COLUMN dfn_ntp.t09_txn_single_entry_v3.t09_desk_order_no_t52 IS
    'T52_ORDERNO'
/
COMMENT ON COLUMN dfn_ntp.t09_txn_single_entry_v3.t09_desk_order_ref_t52 IS
    'T52_ORDER_ID'
/
COMMENT ON COLUMN dfn_ntp.t09_txn_single_entry_v3.t09_discount_diff IS
    'Discount for this execution'
/
COMMENT ON COLUMN dfn_ntp.t09_txn_single_entry_v3.t09_exec_brk_commisn_diff IS
    'Exec broker commission for this execution'
/
COMMENT ON COLUMN dfn_ntp.t09_txn_single_entry_v3.t09_exec_instruction IS
    'Tag 18'
/
COMMENT ON COLUMN dfn_ntp.t09_txn_single_entry_v3.t09_exec_type IS
    '0 = All at Once, 1 = After Fill(Iceberg), 2 = At Interval'
/
COMMENT ON COLUMN dfn_ntp.t09_txn_single_entry_v3.t09_exg_commission_orig IS
    'original exg commission when exchange comm overwrite happens'
/
COMMENT ON COLUMN dfn_ntp.t09_txn_single_entry_v3.t09_fail_mngmnt_clord_id IS
    'trade rejected cl order'
/
COMMENT ON COLUMN dfn_ntp.t09_txn_single_entry_v3.t09_fail_mngmnt_exec_id IS
    'trade rejected execution'
/
COMMENT ON COLUMN dfn_ntp.t09_txn_single_entry_v3.t09_fail_mngmnt_status IS
    'Custodian reject fail management'
/
COMMENT ON COLUMN dfn_ntp.t09_txn_single_entry_v3.t09_is_active_order IS
    'Current order active/latest display status, -1: default value(when not set),1:Active(Latest Display order),0: Not Active'
/
COMMENT ON COLUMN dfn_ntp.t09_txn_single_entry_v3.t09_is_active_order_orig IS
    'Original order active/latest display status, -1: default value(when not set),1:Active(Latest Display order),0: Not Active'
/
COMMENT ON COLUMN dfn_ntp.t09_txn_single_entry_v3.t09_master_ref_t500 IS
    'Reference for T500 Paying Agent'
/
COMMENT ON COLUMN dfn_ntp.t09_txn_single_entry_v3.t09_min_order_amount IS
    'ThirdParty Algo End time'
/
COMMENT ON COLUMN dfn_ntp.t09_txn_single_entry_v3.t09_opening IS
    '0:Default 1:Yes'
/
COMMENT ON COLUMN dfn_ntp.t09_txn_single_entry_v3.t09_option_base_cash_block IS
    'Option Base Cash Block'
/
COMMENT ON COLUMN dfn_ntp.t09_txn_single_entry_v3.t09_option_base_holding_block IS
    'Option Base Holding Block'
/
COMMENT ON COLUMN dfn_ntp.t09_txn_single_entry_v3.t09_ord_mode IS
    'Order mode (offline,etc.)'
/
COMMENT ON COLUMN dfn_ntp.t09_txn_single_entry_v3.t09_orig_ord_status_v30 IS
    'Original order status'
/
COMMENT ON COLUMN dfn_ntp.t09_txn_single_entry_v3.t09_price_inst_type IS
    'Instrument type in price side'
/
COMMENT ON COLUMN dfn_ntp.t09_txn_single_entry_v3.t09_reference_type IS
    'Reference Table Name'
/
COMMENT ON COLUMN dfn_ntp.t09_txn_single_entry_v3.t09_shadowing_depth IS
    'ThirdParty Algo End time'
/
COMMENT ON COLUMN dfn_ntp.t09_txn_single_entry_v3.t09_short_holdings IS
    'Short Holdings'
/
COMMENT ON COLUMN dfn_ntp.t09_txn_single_entry_v3.t09_style IS
    '0:Normal(Default) 1:Aggressive 2:Passive'
/
COMMENT ON COLUMN dfn_ntp.t09_txn_single_entry_v3.t09_subscribed_qty IS
    'Subscribed Quantity'
/
COMMENT ON COLUMN dfn_ntp.t09_txn_single_entry_v3.t09_thirdparty_mre IS
    '1-ThirdParty MRE; 0-Default'
/
COMMENT ON COLUMN dfn_ntp.t09_txn_single_entry_v3.t09_tnsfer_paymethod IS
    'pay method for transfers'
/
COMMENT ON COLUMN dfn_ntp.t09_txn_single_entry_v3.t09_trig_interval IS
    'Slice Trig Interval'
/
COMMENT ON COLUMN dfn_ntp.t09_txn_single_entry_v3.t09_txn_code IS
    'Buy/Sell/CashTransfer/etc.'
/
COMMENT ON COLUMN dfn_ntp.t09_txn_single_entry_v3.t09_txn_refrence_id IS
    'Reference id to identify Request Type (Ex: Trade Allocation/ Trade Processing)'
/
COMMENT ON COLUMN dfn_ntp.t09_txn_single_entry_v3.t09_update_impact_code IS
    '1:Order(i.e. Order+Cash+Holding),2:Cash Only,3:Holding Only'
/
COMMENT ON COLUMN dfn_ntp.t09_txn_single_entry_v3.t09_waves IS
    '0:Default 1:Yes'
/
COMMENT ON COLUMN dfn_ntp.t09_txn_single_entry_v3.t09_wfa_current_level IS
    'used for order approval level maintainance'
/
COMMENT ON COLUMN dfn_ntp.t09_txn_single_entry_v3.t09_wfa_reason IS
    'Waiting for Approval Reason'
/
COMMENT ON COLUMN dfn_ntp.t09_txn_single_entry_v3.t09_would_price IS
    '0:Default 1:yes'
/

ALTER TABLE DFN_NTP.T09_TXN_SINGLE_ENTRY_V3 
RENAME COLUMN T09_MASTER_REF_T500 TO T09_MASTER_REF
/

ALTER TABLE DFN_NTP.T09_TXN_SINGLE_ENTRY_V3 
 ADD (
  T09_SHORT_HOLDING_BLOCK NUMBER (18)
 )
/

ALTER TABLE DFN_NTP.T09_TXN_SINGLE_ENTRY_V3 
 ADD (
  T09_cum_transfer_value NUMBER (18, 5) DEFAULT 0,
  t09_cum_sell_order_value NUMBER (18, 5) DEFAULT 0,
  t09_cum_buy_order_value NUMBER (18, 5) DEFAULT 0
 )
 /
 
 ALTER TABLE DFN_NTP.T09_TXN_SINGLE_ENTRY_V3 
 ADD (
  T09_PARENT_LOCKSEQ VARCHAR2 (20 BYTE)
 )
/
COMMENT ON COLUMN DFN_NTP.T09_TXN_SINGLE_ENTRY_V3.T09_PARENT_LOCKSEQ IS 'use to update base holding / cash account lock seq value in option trading'
/

ALTER TABLE DFN_NTP.T09_TXN_SINGLE_ENTRY_V3 
 ADD (
  T09_BASE_TRADING_ACC_ID_U07 NUMBER (10, 0)
 )
/

ALTER TABLE dfn_ntp.t09_txn_single_entry_v3
ADD (
    t09_parent_ord_category NUMBER (2)
)
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
                  := 'ALTER TABLE DFN_NTP.T09_TXN_SINGLE_ENTRY_V3
ADD (
  t09_cma_tax NUMBER (18, 5)
)
';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('DFN_NTP')
           AND table_name = UPPER ('T09_TXN_SINGLE_ENTRY_V3')
           AND column_name = UPPER ('t09_cma_tax');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
                  := 'ALTER TABLE DFN_NTP.T09_TXN_SINGLE_ENTRY_V3
ADD (
  t09_cpp_tax NUMBER (18, 5) 
)
';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('DFN_NTP')
           AND table_name = UPPER ('T09_TXN_SINGLE_ENTRY_V3')
           AND column_name = UPPER ('t09_cpp_tax');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
                  := 'ALTER TABLE DFN_NTP.T09_TXN_SINGLE_ENTRY_V3
ADD (
  t09_dcm_tax NUMBER (18, 5)
)
';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('DFN_NTP')
           AND table_name = UPPER ('T09_TXN_SINGLE_ENTRY_V3')
           AND column_name = UPPER ('t09_dcm_tax');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
                  := 'ALTER TABLE DFN_NTP.T09_TXN_SINGLE_ENTRY_V3
ADD (
  t09_cum_cma_tax NUMBER (18, 5) 
)
';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('DFN_NTP')
           AND table_name = UPPER ('T09_TXN_SINGLE_ENTRY_V3')
           AND column_name = UPPER ('t09_cum_cma_tax');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
                  := 'ALTER TABLE DFN_NTP.T09_TXN_SINGLE_ENTRY_V3
ADD (
  t09_cum_cpp_tax NUMBER (18, 5) 
)
';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('DFN_NTP')
           AND table_name = UPPER ('T09_TXN_SINGLE_ENTRY_V3')
           AND column_name = UPPER ('t09_cum_cpp_tax');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
                  := 'ALTER TABLE DFN_NTP.T09_TXN_SINGLE_ENTRY_V3
ADD (
  t09_cum_dcm_tax NUMBER (18, 5) 
)
';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('DFN_NTP')
           AND table_name = UPPER ('T09_TXN_SINGLE_ENTRY_V3')
           AND column_name = UPPER ('t09_cum_dcm_tax');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/


DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
                  := 'ALTER TABLE DFN_NTP.T09_TXN_SINGLE_ENTRY_V3
ADD (
  t09_act_cma_tax NUMBER (18, 5) 
)
';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('DFN_NTP')
           AND table_name = UPPER ('T09_TXN_SINGLE_ENTRY_V3')
           AND column_name = UPPER ('t09_act_cma_tax');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/



DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
                  := 'ALTER TABLE DFN_NTP.T09_TXN_SINGLE_ENTRY_V3
ADD (
  t09_act_cpp_tax NUMBER (18, 5) 
)
';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('DFN_NTP')
           AND table_name = UPPER ('T09_TXN_SINGLE_ENTRY_V3')
           AND column_name = UPPER ('t09_act_cpp_tax');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/


DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
                  := 'ALTER TABLE DFN_NTP.T09_TXN_SINGLE_ENTRY_V3
ADD (
  t09_act_dcm_tax NUMBER (18, 5) 
)
';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('DFN_NTP')
           AND table_name = UPPER ('T09_TXN_SINGLE_ENTRY_V3')
           AND column_name = UPPER ('t09_act_dcm_tax');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/


DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
                  := 'ALTER TABLE DFN_NTP.T09_TXN_SINGLE_ENTRY_V3
ADD (
  t09_cum_act_cma_tax NUMBER (18, 5) 
)
';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('DFN_NTP')
           AND table_name = UPPER ('T09_TXN_SINGLE_ENTRY_V3')
           AND column_name = UPPER ('t09_cum_act_cma_tax');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
                  := 'ALTER TABLE DFN_NTP.T09_TXN_SINGLE_ENTRY_V3
ADD (
  t09_cum_act_cpp_tax NUMBER (18, 5) 
)
';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('DFN_NTP')
           AND table_name = UPPER ('T09_TXN_SINGLE_ENTRY_V3')
           AND column_name = UPPER ('t09_cum_act_cpp_tax');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/


DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
                  := 'ALTER TABLE DFN_NTP.T09_TXN_SINGLE_ENTRY_V3
ADD (
  t09_cum_act_dcm_tax NUMBER (18, 5) 
)
';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('DFN_NTP')
           AND table_name = UPPER ('T09_TXN_SINGLE_ENTRY_V3')
           AND column_name = UPPER ('t09_cum_act_dcm_tax');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

/* Formatted on 19-Feb-2020 14:55:21 (QP5 v5.206) */
DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
                  := 'ALTER TABLE DFN_NTP.T09_TXN_SINGLE_ENTRY_V3
ADD (
  t09_cma_commission NUMBER (18, 5)
)
';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('DFN_NTP')
           AND table_name = UPPER ('T09_TXN_SINGLE_ENTRY_V3')
           AND column_name = UPPER ('t09_cma_commission');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

/* Formatted on 19-Feb-2020 14:55:21 (QP5 v5.206) */
DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
                  := 'ALTER TABLE DFN_NTP.T09_TXN_SINGLE_ENTRY_V3
ADD (
  t09_cpp_commission NUMBER (18, 5)
)
';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('DFN_NTP')
           AND table_name = UPPER ('T09_TXN_SINGLE_ENTRY_V3')
           AND column_name = UPPER ('t09_cpp_commission');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/


/* Formatted on 19-Feb-2020 14:55:21 (QP5 v5.206) */
DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
                  := 'ALTER TABLE DFN_NTP.T09_TXN_SINGLE_ENTRY_V3
ADD (
  t09_dcm_commission NUMBER (18, 5)
)
';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('DFN_NTP')
           AND table_name = UPPER ('T09_TXN_SINGLE_ENTRY_V3')
           AND column_name = UPPER ('t09_dcm_commission');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

/* Formatted on 19-Feb-2020 14:55:21 (QP5 v5.206) */
DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
                  := 'ALTER TABLE DFN_NTP.T09_TXN_SINGLE_ENTRY_V3
ADD (
  t09_cma_cum_commission NUMBER (18, 5)
)
';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('DFN_NTP')
           AND table_name = UPPER ('T09_TXN_SINGLE_ENTRY_V3')
           AND column_name = UPPER ('t09_cma_cum_commission');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/



/* Formatted on 19-Feb-2020 14:55:21 (QP5 v5.206) */
DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
                  := 'ALTER TABLE DFN_NTP.T09_TXN_SINGLE_ENTRY_V3
ADD (
  t09_cpp_cum_commission NUMBER (18, 5)
)
';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('DFN_NTP')
           AND table_name = UPPER ('T09_TXN_SINGLE_ENTRY_V3')
           AND column_name = UPPER ('t09_cpp_cum_commission');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/



/* Formatted on 19-Feb-2020 14:55:21 (QP5 v5.206) */
DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
                  := 'ALTER TABLE DFN_NTP.T09_TXN_SINGLE_ENTRY_V3
ADD (
  t09_dcm_cum_commission NUMBER (18, 5)
)
';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('DFN_NTP')
           AND table_name = UPPER ('T09_TXN_SINGLE_ENTRY_V3')
           AND column_name = UPPER ('t09_dcm_cum_commission');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/


DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
                  := 'ALTER TABLE DFN_NTP.T09_TXN_SINGLE_ENTRY_V3
ADD (
  t09_exec_cma_tax NUMBER (18, 5)
)
';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('DFN_NTP')
           AND table_name = UPPER ('T09_TXN_SINGLE_ENTRY_V3')
           AND column_name = UPPER ('t09_exec_cma_tax');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/


DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
                  := 'ALTER TABLE DFN_NTP.T09_TXN_SINGLE_ENTRY_V3
ADD (
  t09_exec_cpp_tax NUMBER (18, 5)
)
';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('DFN_NTP')
           AND table_name = UPPER ('T09_TXN_SINGLE_ENTRY_V3')
           AND column_name = UPPER ('t09_exec_cpp_tax');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
                  := 'ALTER TABLE DFN_NTP.T09_TXN_SINGLE_ENTRY_V3
ADD (
  t09_exec_dcm_tax NUMBER (18, 5)
)
';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('DFN_NTP')
           AND table_name = UPPER ('T09_TXN_SINGLE_ENTRY_V3')
           AND column_name = UPPER ('t09_exec_dcm_tax');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/


DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
                  := 'ALTER TABLE DFN_NTP.T09_TXN_SINGLE_ENTRY_V3
ADD (
  t09_exec_act_cma_tax NUMBER (18, 5)
)
';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('DFN_NTP')
           AND table_name = UPPER ('T09_TXN_SINGLE_ENTRY_V3')
           AND column_name = UPPER ('t09_exec_act_cma_tax');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
                  := 'ALTER TABLE DFN_NTP.T09_TXN_SINGLE_ENTRY_V3
ADD (
  t09_exec_act_cpp_tax NUMBER (18, 5)
)
';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('DFN_NTP')
           AND table_name = UPPER ('T09_TXN_SINGLE_ENTRY_V3')
           AND column_name = UPPER ('t09_exec_act_cpp_tax');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/


DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
                  := 'ALTER TABLE DFN_NTP.T09_TXN_SINGLE_ENTRY_V3
ADD (
  t09_exec_act_dcm_tax NUMBER (18, 5)
)
';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('DFN_NTP')
           AND table_name = UPPER ('T09_TXN_SINGLE_ENTRY_V3')
           AND column_name = UPPER ('t09_exec_act_dcm_tax');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/


DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
                  := 'ALTER TABLE DFN_NTP.T09_TXN_SINGLE_ENTRY_V3
ADD (
  t09_exec_cma_comission NUMBER (18, 5)
)
';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('DFN_NTP')
           AND table_name = UPPER ('T09_TXN_SINGLE_ENTRY_V3')
           AND column_name = UPPER ('t09_exec_cma_comission');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
                  := 'ALTER TABLE DFN_NTP.T09_TXN_SINGLE_ENTRY_V3
ADD (
  t09_exec_cpp_comission NUMBER (18, 5)
)
';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('DFN_NTP')
           AND table_name = UPPER ('T09_TXN_SINGLE_ENTRY_V3')
           AND column_name = UPPER ('t09_exec_cpp_comission');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
                  := 'ALTER TABLE DFN_NTP.T09_TXN_SINGLE_ENTRY_V3
ADD (
  t09_exec_dcm_comission NUMBER (18, 5)
)
';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('DFN_NTP')
           AND table_name = UPPER ('T09_TXN_SINGLE_ENTRY_V3')
           AND column_name = UPPER ('t09_exec_dcm_comission');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

ALTER TABLE dfn_ntp.t09_txn_single_entry_v3
 ADD (
  t09_orig_exg_tax NUMBER (20, 5),
  t09_orig_brk_tax NUMBER (20, 5)
 )
/

ALTER TABLE dfn_ntp.t09_txn_single_entry_v3
 ADD (
  t09_fixing_price NUMBER (18, 5),
  t09_m2m_gain NUMBER (18, 5),
  t09_initial_margin_charge NUMBER (18, 5),
  t09_notional_value NUMBER (18, 5)
 )
/

ALTER TABLE dfn_ntp.t09_txn_single_entry_v3 
 ADD (
  T09_UNIQUE_KEY VARCHAR2 (200 BYTE)
 )
/


ALTER TABLE dfn_ntp.t09_txn_single_entry_v3
ADD (
  t09_maintain_margin_charge NUMBER (18, 5),
  t09_cum_initial_margin_charge NUMBER (18, 5),
  t09_exec_initial_margin_charge NUMBER (18, 5),
  t09_cum_maintain_margin_charge NUMBER (18, 5),
  t09_exe_maintain_margin_charge NUMBER (18, 5),
  t09_maintain_margin_block NUMBER (18, 5),
  t09_cum_maintain_margin_block NUMBER (18, 5),
  t09_cash_maintain_margin_block NUMBER (18, 5),
  t09_cash_maintain_margin_charg NUMBER (18, 5),
  t09_cash_initial_margin_charge NUMBER (18, 5)
)
/


ALTER TABLE dfn_ntp.t09_txn_single_entry_v3
 ADD (
  t09_long_holdings NUMBER (18, 0)
)
/

ALTER TABLE dfn_ntp.t09_txn_single_entry_v3
 ADD (
  t09_hld_maintain_margin_block NUMBER (18, 5),
  t09_hld_maintain_margin_charg NUMBER (18, 5)
)
/

ALTER TABLE dfn_ntp.T09_TXN_SINGLE_ENTRY_V3 
 ADD (
  T09_ORDER_AVG_PRICE NUMBER (18, 5)
 )
/
COMMENT ON COLUMN dfn_ntp.T09_TXN_SINGLE_ENTRY_V3.T09_ORDER_AVG_PRICE IS 'Average Price For Order'
/

ALTER TABLE dfn_ntp.T09_TXN_SINGLE_ENTRY_V3 
 ADD (
  t09_loan_amount NUMBER (18, 5) 
 )
/
COMMENT ON COLUMN dfn_ntp.T09_TXN_SINGLE_ENTRY_V3.t09_loan_amount IS 'u06_loan_amount'
/

ALTER TABLE dfn_ntp.t09_txn_single_entry_v3 
 MODIFY (
  t09_symbol_code_m20 VARCHAR(50),
  t09_base_symbol_code_m20 VARCHAR(50)
)
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
                  := 'ALTER TABLE dfn_ntp.T09_TXN_SINGLE_ENTRY_V3 
 ADD (
  t09_withdr_overdrawn_amt NUMBER (18, 5)
 )
';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_ntp')
           AND table_name = UPPER ('T09_TXN_SINGLE_ENTRY_V3')
           AND column_name = UPPER ('t09_withdr_overdrawn_amt');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
                  := 'ALTER TABLE dfn_ntp.T09_TXN_SINGLE_ENTRY_V3 
 ADD (
  t09_incident_overdrawn_amt NUMBER (18, 5)
 )';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_ntp')
           AND table_name = UPPER ('T09_TXN_SINGLE_ENTRY_V3')
           AND column_name = UPPER ('t09_incident_overdrawn_amt');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

COMMENT ON COLUMN dfn_ntp.T09_TXN_SINGLE_ENTRY_V3.t09_withdr_overdrawn_amt IS 'u06_withdr_overdrawn_amt'
/
COMMENT ON COLUMN dfn_ntp.T09_TXN_SINGLE_ENTRY_V3.t09_incident_overdrawn_amt IS 'u06_incident_overdrawn_amt'
/

ALTER TABLE dfn_ntp.T09_TXN_SINGLE_ENTRY_V3 
 ADD (
  T09_CONTRACT_ID_T75 NUMBER (18, 0)
 )
/

ALTER TABLE dfn_ntp.T09_TXN_SINGLE_ENTRY_V3 
RENAME COLUMN T09_ORDER_AVG_PRICE TO T09_HOLDING_AVG_PRICE
/

ALTER TABLE dfn_ntp.T09_TXN_SINGLE_ENTRY_V3 
RENAME COLUMN T09_AVG_COST TO T09_HOLDING_AVG_COST
/

ALTER TABLE dfn_ntp.T09_TXN_SINGLE_ENTRY_V3 
 ADD (
  T09_AVG_COST NUMBER (18)
 )
/

truncate table dfn_ntp.t09_txn_single_entry_v3;
commit;

ALTER TABLE dfn_ntp.T09_TXN_SINGLE_ENTRY_V3 
 MODIFY (
  T09_LOCKSEQ NUMBER (20, 0)
 )
/

ALTER TABLE dfn_ntp.T09_TXN_SINGLE_ENTRY_V3
    DROP COLUMN t09_institute_id_m02
/

ALTER TABLE dfn_ntp.t09_txn_single_entry_v3
ADD (
  t09_negotiated_request_id_t85 NUMBER (18)
)
/

DECLARE
    l_count       NUMBER := 0;
    l_ddl_temp    VARCHAR2 (1000)
        := 'ALTER TABLE dfn_ntp.t09_txn_single_entry_v3 ADD (t09_master_ref_temp VARCHAR2 (100))';
    l_dml         VARCHAR2 (1000)
        := 'UPDATE dfn_ntp.t09_txn_single_entry_v3 SET t09_master_ref_temp = t09_master_ref';
    l_ddl_alter   VARCHAR2 (1000)
        := 'ALTER TABLE dfn_ntp.t09_txn_single_entry_v3 MODIFY ( t09_master_ref VARCHAR2 (100))';
    l_dml_1       VARCHAR2 (1000)
        := 'UPDATE dfn_ntp.t09_txn_single_entry_v3 SET t09_master_ref = t09_master_ref_temp';
    l_ddl_del     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_ntp.t09_txn_single_entry_v3 DROP COLUMN t09_master_ref_temp';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
    WHERE     owner = UPPER ('dfn_ntp')
           AND table_name = UPPER ('t09_txn_single_entry_v3')
           AND column_name = UPPER ('t09_master_ref');

    IF l_count = 1
    THEN
        EXECUTE IMMEDIATE l_ddl_temp;

        EXECUTE IMMEDIATE l_dml;


        UPDATE dfn_ntp.t09_txn_single_entry_v3
           SET t09_master_ref = NULL;

        COMMIT;

        EXECUTE IMMEDIATE l_ddl_alter;

        EXECUTE IMMEDIATE l_dml_1;

        COMMIT;

        EXECUTE IMMEDIATE l_ddl_del;
    END IF;
END;
 /

ALTER TABLE dfn_ntp.T09_TXN_SINGLE_ENTRY_V3 
 ADD (
  T09_TRANSFER_SIDE NUMBER (2) DEFAULT 1
 )
/
COMMENT ON COLUMN dfn_ntp.T09_TXN_SINGLE_ENTRY_V3.T09_TRANSFER_SIDE IS 'Cash/Holding Transfer Side Withdraw = 1 And Deposit = 2'
/

ALTER TABLE dfn_ntp.T09_TXN_SINGLE_ENTRY_V3 
 ADD (
  T09_NO_OF_APPROVAL NUMBER (2),
  T09_CURRENT_APPROVAL_LEVEL NUMBER (2),
  T09_FUNCTION_ID_M88 NUMBER (10),
  T09_FINAL_APPROVAL NUMBER (2)
 )
/

ALTER TABLE dfn_ntp.T09_TXN_SINGLE_ENTRY_V3 
 ADD (
  T09_BULK_ID VARCHAR2 (50)
 )
/
COMMENT ON COLUMN dfn_ntp.T09_TXN_SINGLE_ENTRY_V3.T09_BULK_ID IS 'for handle bulk and other txns'
/


ALTER TABLE dfn_ntp.T09_TXN_SINGLE_ENTRY_V3 
 ADD (
  T09_TXN_TYPE NUMBER (2)
 )
/

ALTER TABLE dfn_ntp.T09_TXN_SINGLE_ENTRY_V3 
 ADD (
  T09_BOARD_CODE_M54 VARCHAR2 (6)
 )
/
ALTER TABLE dfn_ntp.T09_TXN_SINGLE_ENTRY_V3 
 ADD (
  T09_SHORT_SELL_ENABLE NUMBER (2, 0) DEFAULT 0
 )
/

ALTER TABLE dfn_ntp.T09_TXN_SINGLE_ENTRY_V3 
 ADD (
  t09_status_id NUMBER (3)
 )
/
COMMENT ON COLUMN dfn_ntp.T09_TXN_SINGLE_ENTRY_V3.t09_status_id IS 'for log t06 cash / t12  holding / t20 pledge status id'
/
ALTER TABLE dfn_ntp.T09_TXN_SINGLE_ENTRY_V3 
 ADD (
  T09_NARRATION_LANG VARCHAR2 (1000)
 )
/

ALTER TABLE dfn_ntp.t09_txn_single_entry_v3
 MODIFY (
  t09_board_code_m54 VARCHAR2 (10 BYTE)

 )
/

ALTER TABLE dfn_ntp.t09_txn_single_entry_v3 
 ADD (
  t09_CUM_ONLINE_SEL_ORDER_VALUE NUMBER (18, 5),
  t09_CUM_ONLINE_BUY_ORDER_VALUE NUMBER (18, 5),
  T09_BYPASS_RMS_VALIDATION NUMBER (1) DEFAULT 0
 )
 /
 COMMENT ON COLUMN dfn_ntp.t09_txn_single_entry_v3.T09_BYPASS_RMS_VALIDATION IS '0 - NO, 1 - YES'
/

ALTER TABLE dfn_ntp.T09_TXN_SINGLE_ENTRY_V3 
 ADD (
  T09_INTEGRATION_EXT_REF_NO NUMBER (20)
 )
/

CREATE INDEX dfn_ntp.idx_t09_bulk_id
    ON dfn_ntp.t09_txn_single_entry_v3 (t09_bulk_id ASC)
/

COMMENT ON COLUMN dfn_ntp.T09_TXN_SINGLE_ENTRY_V3.T09_CUM_ONLINE_BUY_ORDER_VALUE IS 'u06_cum_online_buy_order_value'
/

COMMENT ON COLUMN dfn_ntp.T09_TXN_SINGLE_ENTRY_V3.T09_CUM_ONLINE_SEL_ORDER_VALUE IS 'u06_cum_online_sel_order_value'
/



DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_ntp.t09_txn_single_entry_v3 ADD (  t09_algo_commission NUMBER (18, 5) )';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_ntp')
           AND table_name = UPPER ('t09_txn_single_entry_v3')
           AND column_name = UPPER ('t09_algo_commission');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_ntp.t09_txn_single_entry_v3 ADD (  t09_algo_tax NUMBER (18, 5) )';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_ntp')
           AND table_name = UPPER ('t09_txn_single_entry_v3')
           AND column_name = UPPER ('t09_algo_tax');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_ntp.t09_txn_single_entry_v3 ADD (  t09_algo_cum_commission NUMBER (18, 5) )';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_ntp')
           AND table_name = UPPER ('t09_txn_single_entry_v3')
           AND column_name = UPPER ('t09_algo_cum_commission');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_ntp.t09_txn_single_entry_v3 ADD (  t09_algo_cum_tax NUMBER (18, 5) )';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_ntp')
           AND table_name = UPPER ('t09_txn_single_entry_v3')
           AND column_name = UPPER ('t09_algo_cum_tax');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_ntp.t09_txn_single_entry_v3 ADD (  t09_exec_algo_commission NUMBER (18, 5) )';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_ntp')
           AND table_name = UPPER ('t09_txn_single_entry_v3')
           AND column_name = UPPER ('t09_exec_algo_commission');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_ntp.t09_txn_single_entry_v3 ADD (  t09_exec_algo_tax NUMBER (18, 5) )';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_ntp')
           AND table_name = UPPER ('t09_txn_single_entry_v3')
           AND column_name = UPPER ('t09_exec_algo_tax');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

ALTER TABLE dfn_ntp.t09_txn_single_entry_v3 MODIFY (  t09_algo_commission DEFAULT 0 )
/
ALTER TABLE dfn_ntp.t09_txn_single_entry_v3 MODIFY (  t09_algo_tax DEFAULT 0 )
/
ALTER TABLE dfn_ntp.t09_txn_single_entry_v3 MODIFY (  t09_algo_cum_commission DEFAULT 0 )
/
ALTER TABLE dfn_ntp.t09_txn_single_entry_v3 MODIFY (  t09_algo_cum_tax DEFAULT 0 )
/
ALTER TABLE dfn_ntp.t09_txn_single_entry_v3 MODIFY (  t09_exec_algo_commission DEFAULT 0 )
/
ALTER TABLE dfn_ntp.t09_txn_single_entry_v3 MODIFY (  t09_exec_algo_tax DEFAULT 0 )
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_ntp.t09_txn_single_entry_v3 RENAME COLUMN t09_algo_commission TO t09_other_commission';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_ntp')
           AND table_name = UPPER ('t09_txn_single_entry_v3')
           AND column_name = UPPER ('t09_algo_commission');

    IF l_count = 1
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_ntp.t09_txn_single_entry_v3 RENAME COLUMN t09_algo_tax TO t09_other_tax';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_ntp')
           AND table_name = UPPER ('t09_txn_single_entry_v3')
           AND column_name = UPPER ('t09_algo_tax');

    IF l_count = 1
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_ntp.t09_txn_single_entry_v3 RENAME COLUMN t09_algo_cum_commission TO t09_other_cum_commission';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_ntp')
           AND table_name = UPPER ('t09_txn_single_entry_v3')
           AND column_name = UPPER ('t09_algo_cum_commission');

    IF l_count = 1
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/


DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_ntp.t09_txn_single_entry_v3 RENAME COLUMN t09_algo_cum_tax TO t09_other_cum_tax';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_ntp')
           AND table_name = UPPER ('t09_txn_single_entry_v3')
           AND column_name = UPPER ('t09_algo_cum_tax');

    IF l_count = 1
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/


DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_ntp.t09_txn_single_entry_v3 RENAME COLUMN t09_exec_algo_commission TO t09_exec_other_commission';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_ntp')
           AND table_name = UPPER ('t09_txn_single_entry_v3')
           AND column_name = UPPER ('t09_exec_algo_commission');

    IF l_count = 1
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/


DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_ntp.t09_txn_single_entry_v3 RENAME COLUMN t09_exec_algo_tax TO t09_exec_other_tax';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_ntp')
           AND table_name = UPPER ('t09_txn_single_entry_v3')
           AND column_name = UPPER ('t09_exec_algo_tax');

    IF l_count = 1
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

