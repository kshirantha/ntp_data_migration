-- Table DFN_NTP.R08_ORDER_AUDIT

CREATE TABLE dfn_ntp.r08_order_audit
(
    unique_key                    VARCHAR2 (255 CHAR),
    avg_cost                      FLOAT (126),
    avg_price                     FLOAT (126),
    balance                       FLOAT (126),
    balance_diff                  FLOAT (126),
    buy_pending                   NUMBER (19, 0),
    cash_acntid                   NUMBER (10, 0),
    cash_balance_orig             FLOAT (126),
    cash_block                    FLOAT (126),
    cash_block_diff               FLOAT (126),
    cash_block_in_acnt            FLOAT (126),
    cash_block_in_acnt_orig       FLOAT (126),
    cash_open_by_block            FLOAT (126),
    cash_payable_block_orig       FLOAT (126),
    cash_receivable_amount_orig   FLOAT (126),
    cash_settlement_date          DATE,
    cl_ordid                      VARCHAR2 (255 CHAR),
    commission                    FLOAT (126),
    commission_diff               FLOAT (126),
    cum_commission                FLOAT (126),
    cum_order_net_settle          FLOAT (126),
    cum_order_net_value           FLOAT (126),
    cum_order_value               FLOAT (126),
    cum_qty                       NUMBER (19, 0),
    custodian_id                  VARCHAR2 (255 CHAR),
    execid                        VARCHAR2 (255 CHAR),
    fx_rate                       FLOAT (126),
    holding_block                 NUMBER (19, 0),
    holding_entry_key             VARCHAR2 (255 CHAR),
    holding_settlement_date       DATE,
    last_price                    FLOAT (126),
    last_shares                   NUMBER (19, 0),
    leaves_qty                    NUMBER (19, 0),
    net_holding                   NUMBER (19, 0),
    open_buy_block                FLOAT (126),
    open_buy_block_orig           FLOAT (126),
    ordid                         VARCHAR2 (255 CHAR),
    order_net_settle              FLOAT (126),
    order_net_settle_diff         FLOAT (126),
    order_net_value               FLOAT (126),
    order_net_value_diff          FLOAT (126),
    order_value                   FLOAT (126),
    order_value_diff              FLOAT (126),
    orig_cl_ordid                 VARCHAR2 (255 CHAR),
    payable_block                 FLOAT (126),
    payable_diff                  FLOAT (126),
    payable_holding               NUMBER (19, 0),
    pre_order_cum_commission      FLOAT (126),
    pre_order_cum_value           FLOAT (126),
    pre_order_qty                 NUMBER (19, 0),
    price                         FLOAT (126),
    quantity                      NUMBER (19, 0),
    receivable_amount             FLOAT (126),
    receivable_diff               FLOAT (126),
    receivable_holding            NUMBER (19, 0),
    sell_pending                  NUMBER (19, 0),
    side                          NUMBER (10, 0),
    status                        CHAR (1 CHAR),
    symbol                        VARCHAR2 (255 CHAR),
    symbol_id                     VARCHAR2 (255 CHAR),
    tenant_code                   VARCHAR2 (255 CHAR),
    trading_account               VARCHAR2 (255 CHAR),
    weighted_avg_cost             FLOAT (126),
    weighted_avg_price            FLOAT (126),
    broker_tax                    FLOAT (22),
    exchange_tax                  FLOAT (22),
    amt_in_settle_curr            FLOAT (22),
    db_seq_id                     VARCHAR2 (22),
    exchange_code                 VARCHAR2 (22),
    symbol_code                   VARCHAR2 (22)
)
/

-- Constraints for  DFN_NTP.R08_ORDER_AUDIT


  ALTER TABLE dfn_ntp.r08_order_audit ADD CONSTRAINT pk_r08_order_audit PRIMARY KEY (unique_key)
  USING INDEX  ENABLE
/

  ALTER TABLE dfn_ntp.r08_order_audit MODIFY (avg_cost NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.r08_order_audit MODIFY (avg_price NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.r08_order_audit MODIFY (balance NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.r08_order_audit MODIFY (balance_diff NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.r08_order_audit MODIFY (buy_pending NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.r08_order_audit MODIFY (cash_acntid NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.r08_order_audit MODIFY (cash_balance_orig NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.r08_order_audit MODIFY (cash_block NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.r08_order_audit MODIFY (cash_block_diff NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.r08_order_audit MODIFY (cash_block_in_acnt NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.r08_order_audit MODIFY (cash_block_in_acnt_orig NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.r08_order_audit MODIFY (cash_open_by_block NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.r08_order_audit MODIFY (cash_payable_block_orig NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.r08_order_audit MODIFY (cash_receivable_amount_orig NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.r08_order_audit MODIFY (commission NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.r08_order_audit MODIFY (commission_diff NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.r08_order_audit MODIFY (cum_commission NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.r08_order_audit MODIFY (cum_order_net_settle NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.r08_order_audit MODIFY (cum_order_net_value NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.r08_order_audit MODIFY (cum_order_value NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.r08_order_audit MODIFY (cum_qty NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.r08_order_audit MODIFY (fx_rate NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.r08_order_audit MODIFY (holding_block NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.r08_order_audit MODIFY (last_price NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.r08_order_audit MODIFY (last_shares NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.r08_order_audit MODIFY (leaves_qty NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.r08_order_audit MODIFY (net_holding NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.r08_order_audit MODIFY (open_buy_block NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.r08_order_audit MODIFY (open_buy_block_orig NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.r08_order_audit MODIFY (order_net_settle NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.r08_order_audit MODIFY (order_net_settle_diff NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.r08_order_audit MODIFY (order_net_value NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.r08_order_audit MODIFY (order_net_value_diff NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.r08_order_audit MODIFY (order_value NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.r08_order_audit MODIFY (order_value_diff NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.r08_order_audit MODIFY (payable_block NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.r08_order_audit MODIFY (payable_diff NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.r08_order_audit MODIFY (payable_holding NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.r08_order_audit MODIFY (pre_order_cum_commission NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.r08_order_audit MODIFY (pre_order_cum_value NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.r08_order_audit MODIFY (pre_order_qty NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.r08_order_audit MODIFY (price NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.r08_order_audit MODIFY (quantity NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.r08_order_audit MODIFY (receivable_amount NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.r08_order_audit MODIFY (receivable_diff NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.r08_order_audit MODIFY (receivable_holding NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.r08_order_audit MODIFY (sell_pending NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.r08_order_audit MODIFY (side NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.r08_order_audit MODIFY (status NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.r08_order_audit MODIFY (weighted_avg_cost NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.r08_order_audit MODIFY (weighted_avg_price NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.r08_order_audit MODIFY (unique_key NOT NULL ENABLE)
/



-- End of DDL Script for Table DFN_NTP.R08_ORDER_AUDIT
