CREATE TABLE dfn_ntp.t35_post_trade_sources
    (t35_id                         NUMBER(10,0) NOT NULL,
    t35_request_id_t34             NUMBER(10,0),
    t35_allocated_qty              NUMBER(18,0),
    t35_original_qty               NUMBER(18,0),
    t35_allocated_value            NUMBER(18,5),
    t35_original_value             NUMBER(18,5),
    t35_order_no                   VARCHAR2(50 BYTE),
    t35_execution_id_t02           VARCHAR2(50 BYTE),
    t35_client_order_id_t01        VARCHAR2(50 BYTE),
    t35_cash_acnt_id_u06           NUMBER(10,0),
    t35_trd_acnt_id_u07            NUMBER(10,0),
    t35_cash_diff                  NUMBER(18,5),
    t35_source_symbol              VARCHAR2(50 BYTE),
    t35_price                      NUMBER(18,5),
    t35_inst_id_m02                NUMBER(5,0),
    t35_cash_settle_date           DATE,
    t35_holding_settle_date        DATE,
    t35_custom_type                NUMBER(1,0))
/


ALTER TABLE dfn_ntp.t35_post_trade_sources
ADD CONSTRAINT t35_pk PRIMARY KEY (t35_id)
/
