CREATE TABLE dfn_ntp.t501_payment_detail_c
(
    t501_id                        NUMBER (20, 0) NOT NULL,
    t501_cash_transaction_id_t06   NUMBER (18, 0),
    t501_symbol_code_m20           VARCHAR2 (100 BYTE),
    t501_record_date               DATE,
    t501_nin_number                VARCHAR2 (100 BYTE),
    t501_investor_name             VARCHAR2 (100 BYTE),
    t501_nationality               VARCHAR2 (100 BYTE),
    t501_investor_type             VARCHAR2 (100 BYTE),
    t501_account_code              VARCHAR2 (100 BYTE),
    t501_iban                      VARCHAR2 (100 BYTE),
    t501_broker_code_m150          VARCHAR2 (100 BYTE),
    t501_broker_name               VARCHAR2 (100 BYTE),
    t501_current_balance           NUMBER (18, 5),
    t501_ownership_percentage      VARCHAR2 (100 BYTE),
    t501_event_type                VARCHAR2 (100 BYTE),
    t501_entitlement_type          VARCHAR2 (100 BYTE),
    t501_payment_amount            NUMBER (18, 5),
    t501_tax_amount                NUMBER (18, 5),
    t501_currency_code_m03         VARCHAR2 (100 BYTE),
    t501_payment_status            VARCHAR2 (100 BYTE),
    t501_payment_date              DATE,
    t501_payment_confirm           VARCHAR2 (100 BYTE),
    t501_payment_session_id_t500   NUMBER (20, 0),
    t501_cash_account_id_u06       NUMBER (18, 0),
    t501_no_of_approval            NUMBER (3, 0),
    t501_is_approval_completed     NUMBER (2, 0),
    t501_current_approval_level    NUMBER (3, 0),
    t501_next_status               NUMBER (3, 0),
    t501_created_date              DATE,
    t501_last_updated_date         DATE,
    t501_status_id_v01             NUMBER (5, 0),
    t501_comment                   VARCHAR2 (2000 BYTE),
    t501_created_by_id_u17         NUMBER (18, 0),
    t501_last_updated_by_id_u17    NUMBER (18, 0),
    t501_custom_type               VARCHAR2 (50 BYTE) DEFAULT 1,
    t501_institute_id_m02          NUMBER (3, 0) DEFAULT 1,
    t501_customer_id_u01           NUMBER (18, 0)
)
SEGMENT CREATION IMMEDIATE
NOPARALLEL
LOGGING
MONITORING
/



ALTER TABLE dfn_ntp.t501_payment_detail_c
    ADD CONSTRAINT pk_t501 PRIMARY KEY (t501_id) USING INDEX
/

ALTER TABLE dfn_ntp.T501_PAYMENT_DETAIL_C 
 ADD (
  T501_CURRENT_STATUS NUMBER (2) DEFAULT 1
 )
/
COMMENT ON COLUMN T501_PAYMENT_DETAIL_C.T501_CURRENT_STATUS IS 'For OMS Purposes'
/

ALTER TABLE dfn_ntp.t501_payment_detail_c
 MODIFY (
  t501_investor_name VARCHAR2 (200 BYTE)
 )
/

ALTER TABLE dfn_ntp.t501_payment_detail_c
 ADD (
  t501_code_m97 VARCHAR2 (10),
  t501_exchange_code_m01 VARCHAR2 (10)
 )
/

COMMENT ON COLUMN dfn_ntp.t501_payment_detail_c.t501_code_m97 IS '''DIVDND'''
/

COMMENT ON COLUMN dfn_ntp.t501_payment_detail_c.t501_exchange_code_m01 IS
    '''TDWL'''
/