CREATE TABLE dfn_ntp.t57_exchange_subscription_data
(
    t57_id                           NUMBER (18, 0) NOT NULL,
    t57_customer_id_u01              NUMBER (18, 0),
    t57_customer_login_u09           NUMBER (18, 0),
    t57_exchange_product_id_m153     NUMBER (10, 0),
    t57_subfee_waiveof_grp_id_m154   NUMBER (10, 0),
    t57_from_date                    DATE,
    t57_to_date                      DATE,
    t57_status                       NUMBER (2, 0),
    t57_no_of_months                 NUMBER (2, 0) DEFAULT 0,
    t57_exchange_fee                 NUMBER (18, 5) DEFAULT 0,
    t57_vat_exchange_fee             NUMBER (18, 5) DEFAULT 0,
    t57_reject_reason                VARCHAR2 (100 BYTE),
    t57_datetime                     DATE DEFAULT SYSDATE
)
/



ALTER TABLE dfn_ntp.t57_exchange_subscription_data
    ADD CONSTRAINT t57_pk PRIMARY KEY (t57_id) USING INDEX
/

COMMENT ON COLUMN dfn_ntp.t57_exchange_subscription_data.t57_status IS
    '0 - Suspend | 1 - Approved | 2 - Downgraded | 3 - rejected'
/

ALTER TABLE dfn_ntp.t57_exchange_subscription_data
 ADD (
  t57_institute_id_m02 NUMBER (3, 0)
 )
/

ALTER TABLE dfn_ntp.t57_exchange_subscription_data
 ADD (
  t57_exchange_fee_waiveof_amnt NUMBER (18, 5)
 )
/