CREATE TABLE dfn_ntp.t68_bond_contract
(
    t68_id                          NUMBER (20, 0),
    t68_issued_bond_id_m171         NUMBER (10, 0),
    t68_transaction_date            DATE,
    t68_settlement_date             DATE,
    t68_sub_asset_type              NUMBER (10, 0),
    t68_bond_type                   NUMBER (10, 0),
    t68_bond_issue_date             DATE,
    t68_nominal_value               NUMBER (25, 5),
    t68_premium_discount_amount     NUMBER (25, 5),
    t68_interest_rate               NUMBER (10, 5),
    t68_accrued_days                NUMBER (10, 0),
    t68_accrued_interest            NUMBER (25, 5),
    t68_maturity_date               DATE,
    t68_period                      NUMBER (10, 0),
    t68_contract_value              NUMBER (25, 5),
    t68_last_payment_date           DATE,
    t68_next_payment_date           DATE,
    t68_quantity                    NUMBER (25, 0),
    t68_buyer_customer_id_u01       NUMBER (10, 0),
    t68_buyer_cash_acc_id_u06       NUMBER (10, 0),
    t68_buyer_currency_code_m03     CHAR (3 BYTE),
    t68_buyer_trading_acc_id_u07    NUMBER (10, 0),
    t68_buyer_gross_settl_amount    NUMBER (25, 5),
    t68_buyer_commission_id_m169    NUMBER (10, 0),
    t68_buyer_commission_amount     NUMBER (25, 5),
    t68_buyer_vat_amount            NUMBER (25, 5),
    t68_buyer_net_settl_amount      NUMBER (25, 5),
    t68_seller_customer_id_u01      NUMBER (10, 0),
    t68_seller_cash_acc_id_u06      NUMBER (10, 0),
    t68_seller_currency_code_m03    CHAR (3 BYTE),
    t68_seller_trading_acc_id_u07   NUMBER (10, 0),
    t68_seller_gross_settl_amount   NUMBER (25, 5),
    t68_seller_commission_id_m169   NUMBER (10, 0),
    t68_seller_commission_amount    NUMBER (25, 5),
    t68_seller_vat_amount           NUMBER (25, 5),
    t68_seller_net_settl_amount     NUMBER (25, 5),
    t68_created_by_id_u17           NUMBER (20, 0),
    t68_created_date                DATE,
    t68_modified_by_id_u17          NUMBER (20, 0),
    t68_modified_date               DATE,
    t68_status_id_v01               NUMBER (20, 0),
    t68_status_changed_by_id_u17    NUMBER (10, 0),
    t68_status_changed_date         DATE,
    t68_custom_type                 VARCHAR2 (50 BYTE) DEFAULT 1,
    t68_institute_id_m02            NUMBER (10, 0),
    t68_bond_currency_code_m03      CHAR (3 BYTE)
)
/



ALTER TABLE dfn_ntp.t68_bond_contract
ADD CONSTRAINT t68_pk UNIQUE (t68_id)
USING INDEX
/