CREATE TABLE dfn_ntp.t36_post_trade_destination
    (t36_id                         NUMBER(10,0) NOT NULL,
    t36_request_id_t34             NUMBER(10,0),
    t36_trd_acnt_id_u07            NUMBER(10,0),
    t36_cash_acnt_id_u06           NUMBER(10,0),
    t36_custodian_id_m26           NUMBER(10,0),
    t36_allocated_qty              NUMBER(18,0),
    t36_price                      NUMBER(18,5),
    t36_customer_commission        NUMBER(18,5),
    t36_exchange_commission        NUMBER(18,5),
    t36_customer_tax               NUMBER(18,5),
    t36_exchange_tax               NUMBER(18,5),
    t36_order_value                NUMBER(18,5),
    t36_order_net_value            NUMBER(18,5),
    t36_rate                       NUMBER(18,5),
    t36_side                       NUMBER(10,0),
    t36_order_type                 VARCHAR2(10 BYTE),
    t36_exchange                   VARCHAR2(10 BYTE),
    t36_dealer_id                  VARCHAR2(10 BYTE),
    t36_symbol                     VARCHAR2(50 BYTE),
    t36_inst_id_m02                NUMBER(5,0),
    t36_cash_settle_date           DATE,
    t36_holding_settle_date        DATE,
    t36_custom_type                NUMBER(1,0))
/


ALTER TABLE dfn_ntp.t36_post_trade_destination
ADD CONSTRAINT t36_pk PRIMARY KEY (t36_id)
/

ALTER TABLE dfn_ntp.t36_post_trade_destination
 ADD (
  t36_accrued_interest NUMBER (18, 5)
 )
/
