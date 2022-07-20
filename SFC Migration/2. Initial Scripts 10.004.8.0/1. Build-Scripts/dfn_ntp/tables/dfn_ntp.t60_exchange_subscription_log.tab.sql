CREATE TABLE dfn_ntp.t60_exchange_subscription_log
(
    t60_id                           NUMBER (18, 0) NOT NULL,
    t60_customer_id_u01              NUMBER (18, 0),
    t60_customer_login_u09           NUMBER (18, 0),
    t60_cash_acc_id_u06              NUMBER (10, 0),
    t60_exchange_product_id_m153     NUMBER (10, 0),
    t60_subfee_waiveof_grp_id_m154   NUMBER (10, 0),
    t60_from_date                    DATE,
    t60_to_date                      DATE,
    t60_status                       NUMBER (2, 0),
    t60_no_of_months                 NUMBER (2, 0) DEFAULT 0,
    t60_exchange_fee                 NUMBER (18, 5) DEFAULT 0,
    t60_vat_exchange_fee             NUMBER (18, 5) DEFAULT 0,
    t60_reject_reason                VARCHAR2 (100 BYTE),
    t60_datetime                     DATE DEFAULT SYSDATE
)
/



ALTER TABLE dfn_ntp.t60_exchange_subscription_log
    ADD CONSTRAINT t60_pk PRIMARY KEY (t60_id) USING INDEX
/

COMMENT ON COLUMN dfn_ntp.t60_exchange_subscription_log.t60_status IS
    '0 - Suspend | 1 - Approved | 2 - Downgraded | 3 - rejected'
/

ALTER TABLE dfn_ntp.t60_exchange_subscription_log 
 ADD (
  t60_institute_id_m02 NUMBER (3, 0)
 )
/

ALTER TABLE dfn_ntp.t60_exchange_subscription_log 
 ADD (
  t60_exg_subscription_id_t57 NUMBER (18, 0)
 )
/

CREATE INDEX dfn_ntp.idx_t60_to_date
    ON dfn_ntp.t60_exchange_subscription_log (t60_to_date DESC)
/

CREATE INDEX dfn_ntp.idx_t60_datetime
    ON dfn_ntp.t60_exchange_subscription_log (t60_datetime DESC)
/


ALTER TABLE dfn_ntp.t60_exchange_subscription_log
 ADD (
  t60_exchange_fee_waiveof_amnt NUMBER (18, 5)
 )
/