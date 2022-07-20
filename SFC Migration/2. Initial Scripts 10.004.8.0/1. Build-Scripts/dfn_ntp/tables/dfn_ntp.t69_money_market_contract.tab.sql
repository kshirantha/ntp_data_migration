CREATE TABLE dfn_ntp.t69_money_market_contract
(
    t69_id                         NUMBER (18, 0) NOT NULL,
    t69_contract_type_id_v01       NUMBER (3, 0),
    t69_transaction_date           DATE,
    t69_settlement_date            DATE,
    t69_principal_value            NUMBER (18, 5),
    t69_interest_rate              NUMBER (5, 2),
    t69_period                     NUMBER (5, 0),
    t69_maturity_amount            NUMBER (18, 5),
    t69_penalty_interest_rate      NUMBER (5, 2),
    t69_collateral_type_id_v01     NUMBER (3, 0),
    t69_bond_symbol_id_m171        NUMBER (5, 0),
    t69_symbol_id_m20              NUMBER (5, 0),
    t69_quantity                   NUMBER (10, 0),
    t69_l_cash_acnt_id_u06         NUMBER (10, 0),
    t69_b_cash_acnt_id_u06         NUMBER (10, 0),
    t69_l_currency_code_m03        CHAR (3 BYTE),
    t69_b_currency_code_m03        CHAR (3 BYTE),
    t69_l_currency_id_m03          NUMBER (5, 0),
    t69_b_currency_id_m03          NUMBER (5, 0),
    t69_l_customer_id_u01          NUMBER (18, 0),
    t69_b_customer_id_u01          NUMBER (18, 0),
    t69_l_gross_settle_amount      NUMBER (18, 5),
    t69_b_gross_settle_amount      NUMBER (18, 5),
    t69_l_otc_commission_id_m169   NUMBER (10, 0),
    t69_b_otc_commission_id_m169   NUMBER (10, 0),
    t69_l_commission_amount        NUMBER (18, 5),
    t69_b_commission_amount        NUMBER (18, 5),
    t69_l_vat_amount               NUMBER (18, 5),
    t69_b_vat_amount               NUMBER (18, 5),
    t69_l_net_settle_amount        NUMBER (18, 5),
    t69_b_net_settle_amount        NUMBER (18, 5),
    t69_created_by_id_u17          NUMBER (20, 0),
    t69_created_date               DATE,
    t69_modified_by_id_u17         NUMBER (20, 0),
    t69_modified_date              DATE,
    t69_status_id_v01              NUMBER (20, 0),
    t69_status_changed_by_id_u17   NUMBER (10, 0),
    t69_status_changed_date        DATE,
    t69_custom_type                VARCHAR2 (50 BYTE) DEFAULT 1,
    t69_institute_id_m02           NUMBER (10, 0),
    t69_currency_code_m03          CHAR (3 BYTE),
    t69_currency_id_m03            NUMBER (10, 0),
    t69_maturity_date              DATE
)
/



ALTER TABLE dfn_ntp.t69_money_market_contract
ADD CONSTRAINT t69_pk PRIMARY KEY (t69_id)
USING INDEX
/

COMMENT ON COLUMN dfn_ntp.t69_money_market_contract.t69_b_gross_settle_amount IS
    'principal value + interest*period(days)'
/
COMMENT ON COLUMN dfn_ntp.t69_money_market_contract.t69_b_net_settle_amount IS
    'gross settlement + commission + vat'
/
COMMENT ON COLUMN dfn_ntp.t69_money_market_contract.t69_collateral_type_id_v01 IS
    'V01 Type 68'
/
COMMENT ON COLUMN dfn_ntp.t69_money_market_contract.t69_contract_type_id_v01 IS
    '1 - Clean Cash | 2 - Repurchase agreement'
/
COMMENT ON COLUMN dfn_ntp.t69_money_market_contract.t69_id IS 'PK'
/
COMMENT ON COLUMN dfn_ntp.t69_money_market_contract.t69_l_gross_settle_amount IS
    'principal value + interest*period(days)'
/
COMMENT ON COLUMN dfn_ntp.t69_money_market_contract.t69_l_net_settle_amount IS
    'gross settlement + commission + vat'
/
COMMENT ON COLUMN dfn_ntp.t69_money_market_contract.t69_maturity_amount IS
    'principal value + interest'
/
COMMENT ON COLUMN dfn_ntp.t69_money_market_contract.t69_period IS 'Days'
/
COMMENT ON COLUMN dfn_ntp.t69_money_market_contract.t69_principal_value IS
    'Lender currency is applied'
/
COMMENT ON COLUMN dfn_ntp.t69_money_market_contract.t69_transaction_date IS
    'V01 Type 69'
/

ALTER TABLE dfn_ntp.t69_money_market_contract MODIFY (t69_symbol_id_m20 NUMBER (10))
/
