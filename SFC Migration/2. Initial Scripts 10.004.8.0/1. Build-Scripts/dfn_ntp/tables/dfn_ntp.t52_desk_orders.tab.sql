-- Table DFN_NTP.T52_DESK_ORDERS

CREATE TABLE dfn_ntp.t52_desk_orders
(
    t52_order_id                 NUMBER (18, 0),
    t52_orig_order_id            NUMBER (18, 0),
    t52_orderno                  NUMBER (18, 0),
    t52_customer_id_u01          NUMBER (18, 0),
    t52_trading_acc_id_u07       VARCHAR2 (50),
    t52_trading_acntno_u07       VARCHAR2 (50),
    t52_tenant_code              VARCHAR2 (15),
    t52_cash_acc_id_u06          NUMBER (10, 0),
    t52_channel_id_v29           NUMBER (2, 0),
    t52_exchange_code_m01        VARCHAR2 (10),
    t52_symbol_code_m20          VARCHAR2 (25),
    t52_ord_type_id_v06          VARCHAR2 (2),
    t52_side                     NUMBER (1, 0),
    t52_quantity                 NUMBER (10, 0) DEFAULT 0,
    t52_price                    NUMBER (18, 5),
    t52_avgpx                    NUMBER (18, 5) DEFAULT 0,
    t52_tif_id_v10               NUMBER (2, 0),
    t52_expiry_date              DATE,
    t52_min_quantity             NUMBER (10, 0) DEFAULT 0,
    t52_maxfloor                 NUMBER (10, 0) DEFAULT 0,
    t52_status_id_v30            CHAR (1),
    t52_remarks                  VARCHAR2 (500),
    t52_value                    NUMBER (18, 5),
    t52_netvalue                 NUMBER (18, 5),
    t52_netsettle                NUMBER (18, 5),
    t52_cum_value                NUMBER (18, 5),
    t52_cum_netvalue             NUMBER (18, 5),
    t52_cum_netsettle            NUMBER (18, 5),
    t52_issue_stl_rate           NUMBER (18, 5),
    t52_cum_quantity             NUMBER (10, 0) DEFAULT 0,
    t52_leavesqty                NUMBER (10, 0) DEFAULT 0,
    t52_transacttime             DATE,
    t52_commission               NUMBER (18, 5),
    t52_cum_commission           NUMBER (18, 5),
    t52_avgcost                  NUMBER (18, 5) DEFAULT 0,
    t52_exg_commission           NUMBER (18, 5) DEFAULT 0,
    t52_cum_exg_commission       NUMBER (18, 5),
    t52_tax                      NUMBER (18, 5),
    t52_cum_tax                  NUMBER (18, 5),
    t52_instrument_type          VARCHAR2 (20) DEFAULT 0,
    t52_remote_clorderid         VARCHAR2 (50),
    t52_remote_origclorderid     VARCHAR2 (50),
    t52_remote_symbol            VARCHAR2 (20),
    t52_remote_tag_22            VARCHAR2 (2),
    t52_remote_accountno         VARCHAR2 (20),
    t52_remote_tag_11001         VARCHAR2 (50),
    t52_remote_tag_48            VARCHAR2 (20),
    t52_remote_tag_100           VARCHAR2 (20),
    t52_remote_tag_207           VARCHAR2 (20),
    t52_fixmsgtype               VARCHAR2 (5),
    t52_fix_ver                  VARCHAR2 (10),
    t52_tag_56                   VARCHAR2 (20),
    t52_tag_50                   VARCHAR2 (20),
    t52_tag_57                   VARCHAR2 (20),
    t52_tag_18                   VARCHAR2 (1),
    t52_tag_115                  VARCHAR2 (10),
    t52_exec_broker_id_m26       NUMBER (5, 0),
    t52_custodian_id_m26         NUMBER (5, 0),
    t52_text                     VARCHAR2 (1000),
    t52_created_by               NUMBER (20, 0),
    t52_created_date             DATE,
    t52_last_updated_by          NUMBER (20, 0),
    t52_last_updated_date        DATE,
    t52_cum_child_qty            NUMBER (10, 0),
    t52_internall_order_status   CHAR (1),
    t52_auto_release_status      NUMBER (1, 0) DEFAULT -1,
    t52_desk_order_type          NUMBER (1, 0) DEFAULT -1,
    t52_bucket_pro_rata_per      NUMBER (3, 0) DEFAULT 0,
    t52_bucket_order_ref         NUMBER (18, 0) DEFAULT -1,
    t52_bucket_id                NUMBER (18, 0) DEFAULT 0,
    t52_swap_tag                 NUMBER (1, 0) DEFAULT 0,
    t52_approved_by              NUMBER (20, 0),
    t52_discount                 NUMBER (18, 5),
    t52_cum_discount             NUMBER (18, 5),
    t52_dealer_id_u17            NUMBER (10, 0)
)
/

-- Constraints for  DFN_NTP.T52_DESK_ORDERS


  ALTER TABLE dfn_ntp.t52_desk_orders MODIFY (t52_order_id NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.t52_desk_orders MODIFY (t52_cash_acc_id_u06 NOT NULL ENABLE)
/

-- Indexes for  DFN_NTP.T52_DESK_ORDERS


CREATE INDEX dfn_ntp.idx_t52_orderno
    ON dfn_ntp.t52_desk_orders (t52_orderno)
/

CREATE UNIQUE INDEX dfn_ntp.idx_t52_order_id
    ON dfn_ntp.t52_desk_orders (t52_order_id)
/

CREATE INDEX dfn_ntp.idx_t52_orig_order_id
    ON dfn_ntp.t52_desk_orders (t52_orig_order_id)
/

CREATE INDEX dfn_ntp.idx_t52_customer_id_u01
    ON dfn_ntp.t52_desk_orders (t52_customer_id_u01)
/

CREATE INDEX dfn_ntp.idx_t52_trading_acntno_u07
    ON dfn_ntp.t52_desk_orders (t52_trading_acntno_u07)
/

ALTER TABLE dfn_ntp.t52_desk_orders
 MODIFY (
  t52_order_id VARCHAR2 (18 BYTE) DEFAULT NULL,
  t52_orig_order_id VARCHAR2 (18 BYTE) DEFAULT NULL,
  t52_orderno VARCHAR2 (18 BYTE) DEFAULT NULL

 )
/

-- End of DDL Script for Table DFN_NTP.T52_DESK_ORDERS
ALTER TABLE dfn_ntp.T52_DESK_ORDERS 
 ADD (
  t52_app_server_id VARCHAR2 (2 BYTE)
 )
/

ALTER TABLE dfn_ntp.t52_desk_orders
 ADD (
  t52_institution_id_m02 NUMBER (3)
 )
/

ALTER TABLE dfn_ntp.t52_desk_orders
    MODIFY (t52_institution_id_m02 DEFAULT 1)
/

ALTER TABLE dfn_ntp.t52_desk_orders
 ADD (
  t52_symbol_id_m20 NUMBER (10),
  t52_exchange_id_m01 NUMBER (10)
 )
/

COMMENT ON COLUMN dfn_ntp.t52_desk_orders.t52_internall_order_status IS
    'Same Order Statuses'
/
COMMENT ON COLUMN dfn_ntp.t52_desk_orders.t52_auto_release_status IS
    'Same Order Statuses'
/
COMMENT ON COLUMN dfn_ntp.t52_desk_orders.t52_desk_order_type IS
    '1 : Auto Care | 2 - Self Managed'
/

ALTER TABLE dfn_ntp.t52_desk_orders
 ADD (
  t52_market_code_m29 VARCHAR2 (6 BYTE)
 )
/

DECLARE 
	l_count NUMBER := 0; 
	l_ddl VARCHAR2 (1000) 
		:= 'ALTER TABLE dfn_ntp.t52_desk_orders ADD (  t52_board_code_m54 VARCHAR2 (10) )'; 
BEGIN 
	SELECT COUNT (*) 
	INTO l_count 
	FROM all_tab_columns 
	WHERE owner = UPPER ('dfn_ntp') 
		AND table_name = UPPER ('t52_desk_orders') 
		AND column_name = UPPER ('t52_board_code_m54'); 
		
	IF l_count = 0 
	THEN 
		EXECUTE IMMEDIATE l_ddl; 
	END IF; 
END; 
/