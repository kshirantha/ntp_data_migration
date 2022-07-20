CREATE TABLE dfn_ntp.t47_dealer_commission
(
    t47_dealer_id_u17           NUMBER (10, 0) NOT NULL,
    t47_exchange_id_m01         NUMBER (5, 0),
    t47_exchange_code_m01       VARCHAR2 (10 BYTE),
    t47_txn_currency_code_m03   VARCHAR2 (10 BYTE),
    t47_settle_date             DATE NOT NULL,
    t47_charged_commission      NUMBER (25, 10),
    t47_dealer_commission       NUMBER (25, 10)
)
/

ALTER TABLE dfn_ntp.t47_dealer_commission
 ADD (
  t47_total_commission NUMBER (25, 10)
 )
/
ALTER TABLE dfn_ntp.t47_dealer_commission
 ADD (
  t47_commission_type_id_v01 NUMBER (2, 0)
 )
/
