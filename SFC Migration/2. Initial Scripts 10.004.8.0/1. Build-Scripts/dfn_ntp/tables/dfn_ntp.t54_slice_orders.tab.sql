CREATE TABLE dfn_ntp.t54_slice_orders
(
    t54_ordid                 NUMBER (22, 0) NOT NULL,
    t54_order                 VARCHAR2 (3000 BYTE),
    t54_condition             VARCHAR2 (100 BYTE),
    t54_order_status          VARCHAR2 (2 BYTE),
    t54_exec_type             NUMBER (2, 0) DEFAULT -1,
    t54_create_date           DATE,
    t54_triggered_date        DATE,
    t54_expired_date          DATE,
    t54_ord_qty               NUMBER (10, 0) DEFAULT -1,
    t54_ord_qty_sent          NUMBER (10, 0) DEFAULT 0,
    t54_portfoliono           VARCHAR2 (20 BYTE),
    t54_user_id               NUMBER (10, 0),
    t54_block_size            NUMBER (10, 0) DEFAULT -1,
    t54_trig_interval         NUMBER (10, 0) DEFAULT -1,
    t54_last_block_status     CHAR (1 BYTE),
    t54_ord_reject_reason     VARCHAR2 (500 BYTE),
    t54_exchange              VARCHAR2 (20 BYTE),
    t54_interval_type         NUMBER (2, 0) DEFAULT 0,
    t54_start_time            DATE,
    t54_ord_qty_filled        NUMBER (10, 0) DEFAULT 0,
    t54_ord_qty_part_filled   NUMBER (10, 0) DEFAULT 0,
    t54_max_percentage_vol    NUMBER (10, 0) DEFAULT 0,
    t54_min_percentage_vol    NUMBER (10, 0) DEFAULT 0,
    t54_would_level           NUMBER (18, 5) DEFAULT 0,
    t54_limit_price           NUMBER (18, 5) DEFAULT 0,
    t54_max_orders            NUMBER (10, 0) DEFAULT 0,
    t54_renewal_percentage    NUMBER (10, 0) DEFAULT 0,
    t54_queued_ord_count      NUMBER (10, 0) DEFAULT 0,
    t54_limit_condition       VARCHAR2 (100 BYTE),
    t54_would_condition       VARCHAR2 (100 BYTE),
    t54_symbol                VARCHAR2 (25 BYTE),
    t54_renew_quantity        NUMBER (10, 0) DEFAULT 0,
    t54_inst_service_id       NUMBER (2, 0) DEFAULT 0,
    t54_instrument_type       VARCHAR2 (5 BYTE) DEFAULT 0,
    t54_customer_id           NUMBER (18, 0),
    t54_mubasher_no           VARCHAR2 (20 BYTE),
    t54_routingac             VARCHAR2 (50 BYTE),
    t54_algorithm_id          VARCHAR2 (20 BYTE),
    t54_thirdparty_mre        NUMBER (1, 0) DEFAULT 0,
    t54_algo_start_time       DATE,
    t54_algo_end_time         DATE,
    t54_participation_perc    NUMBER (18, 5) DEFAULT 0,
    t54_min_order_amount      NUMBER (10, 0) DEFAULT -1,
    t54_behind_perc           NUMBER (18, 5) DEFAULT 0,
    t54_kickoff_perc          NUMBER (18, 5) DEFAULT 0,
    t54_aggressive_chase      NUMBER (18, 5) DEFAULT 0,
    t54_shadowing_depth       NUMBER (10, 0) DEFAULT -1,
    t54_opening               NUMBER (10, 0) DEFAULT -1,
    t54_closing               NUMBER (10, 0) DEFAULT -1,
    t54_waves                 NUMBER (10, 0) DEFAULT -1,
    t54_would_price           NUMBER (18, 5) DEFAULT -1,
    t54_perc_at_open          NUMBER (18, 5) DEFAULT 0,
    t54_perc_at_close         NUMBER (18, 5) DEFAULT 0,
    t54_style                 NUMBER (10, 0) DEFAULT -1,
    t54_slices                NUMBER (10, 0) DEFAULT -1,
    t54_strategy_status       NUMBER (5, 0) DEFAULT -1,
    t54_orig_ord_id           NUMBER (18, 0) DEFAULT -1,
    t54_order_no              NUMBER (18, 0),
    t54_accumulate_volume     NUMBER (10, 0) DEFAULT 0,
    t54_close_simulation      NUMBER (10, 0) DEFAULT 0,
    t54_orderid               VARCHAR2 (40 BYTE),
    t54_execid                VARCHAR2 (100 BYTE),
    t54_cum_ordnetvalue       NUMBER (18, 5),
    t54_channel               NUMBER (2, 0),
    t54_ordertype             CHAR (1 BYTE),
    t54_exec_broker_inst      NUMBER (10, 0) DEFAULT 0,
    t54_custodian_inst_id     NUMBER (10, 0) DEFAULT 0,
    t54_timeinforce           NUMBER (2, 0),
    t54_desk_order_ref        VARCHAR2 (18 BYTE) DEFAULT 0,
    t54_desk_order_number     VARCHAR2 (18 BYTE) DEFAULT 0,
    t54_price                 NUMBER (25, 10) DEFAULT 0,
    t54_side                  NUMBER (5, 0),
    t54_ord_type_id_v06       VARCHAR2 (2 BYTE),
    t54_currency              VARCHAR2 (5 BYTE),
    t54_cond_type             VARCHAR2 (5 BYTE),
    t54_institution_id_m02    NUMBER (3, 0) DEFAULT 1,
    t54_symbol_id_m20         NUMBER (10, 0)
)
/

ALTER TABLE dfn_ntp.t54_slice_orders
ADD CONSTRAINT pk_slice PRIMARY KEY (t54_ordid)
USING INDEX
/

COMMENT ON COLUMN dfn_ntp.t54_slice_orders.t54_accumulate_volume IS
    '1-Yes; 0-No'
/
COMMENT ON COLUMN dfn_ntp.t54_slice_orders.t54_algo_end_time IS
    'ThirdParty Algo End time'
/
COMMENT ON COLUMN dfn_ntp.t54_slice_orders.t54_algo_start_time IS
    'ThirdParty Algo Start time'
/
COMMENT ON COLUMN dfn_ntp.t54_slice_orders.t54_algorithm_id IS
    'Algorithm ID for thirdparty MRE'
/
COMMENT ON COLUMN dfn_ntp.t54_slice_orders.t54_close_simulation IS
    '1-Yes; 0-No'
/
COMMENT ON COLUMN dfn_ntp.t54_slice_orders.t54_closing IS '0:Default 1:yes'
/
COMMENT ON COLUMN dfn_ntp.t54_slice_orders.t54_condition IS
    'condition to be evaluate'
/
COMMENT ON COLUMN dfn_ntp.t54_slice_orders.t54_customer_id IS 'fk from  m01'
/
COMMENT ON COLUMN dfn_ntp.t54_slice_orders.t54_desk_order_ref IS '-1'
/
COMMENT ON COLUMN dfn_ntp.t54_slice_orders.t54_exchange IS
    'order for which exchange'
/
COMMENT ON COLUMN dfn_ntp.t54_slice_orders.t54_exec_type IS
    '0=all at once,1= after fill(iceberg),2=at interval'
/
COMMENT ON COLUMN dfn_ntp.t54_slice_orders.t54_last_block_status IS
    'last block status- can be used for validation'
/
COMMENT ON COLUMN dfn_ntp.t54_slice_orders.t54_opening IS '0:Default 1:yes'
/
COMMENT ON COLUMN dfn_ntp.t54_slice_orders.t54_order IS 'fix order'
/
COMMENT ON COLUMN dfn_ntp.t54_slice_orders.t54_order_no IS
    'Initial Order number'
/
COMMENT ON COLUMN dfn_ntp.t54_slice_orders.t54_order_status IS
    'fix ord status'
/
COMMENT ON COLUMN dfn_ntp.t54_slice_orders.t54_ordid IS 'slice order id'
/
COMMENT ON COLUMN dfn_ntp.t54_slice_orders.t54_orig_ord_id IS
    'Original Order ID'
/
COMMENT ON COLUMN dfn_ntp.t54_slice_orders.t54_routingac IS 'U06_EXCHANGE_AC'
/
COMMENT ON COLUMN dfn_ntp.t54_slice_orders.t54_style IS
    '0:Normal(Default) 1:Aggressive 2:Passive'
/
COMMENT ON COLUMN dfn_ntp.t54_slice_orders.t54_thirdparty_mre IS
    '1-ThirdParty MRE; 0-Default'
/
COMMENT ON COLUMN dfn_ntp.t54_slice_orders.t54_trig_interval IS
    'slice trig interval'
/

ALTER TABLE dfn_ntp.t54_slice_orders
 MODIFY (
  t54_mubasher_no VARCHAR2 (25 BYTE)

 )
/

ALTER TABLE dfn_ntp.t54_slice_orders
 MODIFY (
  t54_mubasher_no VARCHAR2 (50 BYTE)
 )
/