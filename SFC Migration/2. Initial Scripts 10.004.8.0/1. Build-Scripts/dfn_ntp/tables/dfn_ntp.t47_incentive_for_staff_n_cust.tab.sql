CREATE TABLE dfn_ntp.t47_incentive_for_staff_n_cust
(
   t47_staff_or_customer_id       NUMBER (10, 0),
   t47_exchange_id_m01            NUMBER (5, 0),
   t47_exchange_code_m01          VARCHAR2 (10 BYTE),
   t47_txn_currency_code_m03      VARCHAR2 (10 BYTE),
   t47_settle_date                DATE NOT NULL,
   t47_broker_commission          NUMBER (25, 10),
   t47_total_commission           NUMBER (25, 10),
   t47_commission_type_id_v01     NUMBER (2, 0),
   t47_incentive                  NUMBER (25, 10),
   t47_group_type_id_v01          NUMBER (2, 0),
   t47_frequency_id_v01           NUMBER (2, 0),
   t47_from_date                  DATE,
   t47_to_date                    DATE,
   t47_order_id                   VARCHAR2 (50 BYTE),
   t47_created_datetime           DATE DEFAULT SYSDATE,
   t47_incentive_group_id_m162    NUMBER
)
/

COMMENT ON COLUMN dfn_ntp.t47_incentive_for_staff_n_cust.t47_commission_type_id_v01 IS
   '1 - Total Commission, 2 - Broker Commission'
/
COMMENT ON COLUMN dfn_ntp.t47_incentive_for_staff_n_cust.t47_frequency_id_v01 IS
   '1 - Per Transaction, 2 - Daily, 3 - Weekly, 4 - Fortnightly, 5 -Monthly'
/
COMMENT ON COLUMN dfn_ntp.t47_incentive_for_staff_n_cust.t47_group_type_id_v01 IS
   '1 - Relationship Manager, 2 - Dealer, 3 - Introducing Broker, 4 - Referral Customer'
/

ALTER TABLE dfn_ntp.t47_incentive_for_staff_n_cust
 ADD (
  t47_custom_type VARCHAR2 (50) DEFAULT 1
 )
/