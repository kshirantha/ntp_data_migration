CREATE TABLE dfn_ntp.t45_pending_ca_cash_adjustment
(
    t45_id                         NUMBER (5, 0),
    t45_id_t41                     NUMBER (5, 0),
    t45_fx_rate_t43                NUMBER (18, 5),
    t45_amnt_in_txn_currency_t43   NUMBER (18, 5),
    t45_is_approved                NUMBER (1, 0),
    t45_id_t44                     NUMBER (10, 0),
    t45_amnt_in_stl_currency_t43   NUMBER (18, 5),
    t45_tax_amount_t43             NUMBER (18, 5),
    t45_id_m143                    NUMBER (5, 0),
    t45_custom_type                VARCHAR2 (50 BYTE) DEFAULT 1,
    t45_institute_id_m02           NUMBER (3, 0) DEFAULT 1
)
/

ALTER TABLE dfn_ntp.t45_pending_ca_cash_adjustment
 MODIFY (
  t45_id_t41 NUMBER (15, 0)
 )
/
