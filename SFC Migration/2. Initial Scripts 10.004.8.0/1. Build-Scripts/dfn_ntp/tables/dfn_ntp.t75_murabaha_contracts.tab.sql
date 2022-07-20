CREATE TABLE dfn_ntp.t75_murabaha_contracts
(
    t75_id                         NUMBER (10, 0) NOT NULL,
    t75_contract_no                VARCHAR2 (200 BYTE) NOT NULL,
    t75_loan_amount                NUMBER (20, 5) NOT NULL,
    t75_customer_cash_ac_id_u06    NUMBER (10, 0) NOT NULL,
    t75_agent_trading_ac_id_u07    NUMBER (10, 0) NOT NULL,
    t75_basket_id_m181             NUMBER (10, 0) NOT NULL,
    t75_auto_sell                  NUMBER (1, 0) DEFAULT 0,
    t75_profit_percentage          NUMBER (10, 5),
    t75_fund_by_client             NUMBER (1, 0) DEFAULT 0,
    t75_profit_amount              NUMBER (20, 5),
    t75_loan_utilization           NUMBER (18, 5),
    t75_created_by_id_u17          NUMBER (10, 0),
    t75_created_date               DATE DEFAULT SYSDATE,
    t75_modified_by_id_u17         NUMBER (10, 0),
    t75_modified_date              DATE,
    t75_status_id_v01              NUMBER (2, 0),
    t75_status_changed_by_id_u17   NUMBER (10, 0),
    t75_status_changed_date        DATE,
    t75_brokerage_agent_account    VARCHAR2 (20 BYTE),
    t75_expiry_date                DATE,
    t75_profit_as_percentage       NUMBER (1, 0) DEFAULT 0,
    t75_actual_profit_amount       NUMBER (18, 5) DEFAULT 0,
    t75_amortized_profit_amount    NUMBER (18, 5) DEFAULT 0,
    t75_close_status               NUMBER (1, 0) DEFAULT 0
)
SEGMENT CREATION IMMEDIATE
NOPARALLEL
LOGGING
MONITORING
/



ALTER TABLE dfn_ntp.t75_murabaha_contracts
ADD CONSTRAINT t75_id_pk PRIMARY KEY (t75_id)
USING INDEX
/

COMMENT ON COLUMN dfn_ntp.t75_murabaha_contracts.t75_agent_trading_ac_id_u07 IS
    'fk from u07'
/
COMMENT ON COLUMN dfn_ntp.t75_murabaha_contracts.t75_auto_sell IS
    '1=Auto sell, 0=No'
/
COMMENT ON COLUMN dfn_ntp.t75_murabaha_contracts.t75_basket_id_m181 IS
    'fk from m181'
/
COMMENT ON COLUMN dfn_ntp.t75_murabaha_contracts.t75_brokerage_agent_account IS
    'fk from u05'
/
COMMENT ON COLUMN dfn_ntp.t75_murabaha_contracts.t75_close_status IS
    '1=CLOSE'
/
COMMENT ON COLUMN dfn_ntp.t75_murabaha_contracts.t75_created_by_id_u17 IS
    'fk from u17'
/
COMMENT ON COLUMN dfn_ntp.t75_murabaha_contracts.t75_customer_cash_ac_id_u06 IS
    'fk from u06'
/
COMMENT ON COLUMN dfn_ntp.t75_murabaha_contracts.t75_fund_by_client IS
    '1=Fund by Client, 0=No'
/
COMMENT ON COLUMN dfn_ntp.t75_murabaha_contracts.t75_id IS 'pk'
/
COMMENT ON COLUMN dfn_ntp.t75_murabaha_contracts.t75_loan_utilization IS
    'Utilized loan amount'
/
COMMENT ON COLUMN dfn_ntp.t75_murabaha_contracts.t75_modified_by_id_u17 IS
    'fk from u17'
/
COMMENT ON COLUMN dfn_ntp.t75_murabaha_contracts.t75_profit_as_percentage IS
    '0 - As amount | 1 - As percentage'
/
COMMENT ON COLUMN dfn_ntp.t75_murabaha_contracts.t75_status_changed_by_id_u17 IS
    'fk from u17'
/
COMMENT ON COLUMN dfn_ntp.t75_murabaha_contracts.t75_status_id_v01 IS
    'fk from v01'
/
ALTER TABLE dfn_ntp.t75_murabaha_contracts
ADD CONSTRAINT fk_t75_customer_cash_ac_id_u06 FOREIGN KEY (t75_customer_cash_ac_id_u06)
REFERENCES dfn_ntp.u06_cash_account (u06_id)
/
ALTER TABLE dfn_ntp.t75_murabaha_contracts
ADD CONSTRAINT fk_t75_agent_trading_ac_id_u07 FOREIGN KEY (
  t75_agent_trading_ac_id_u07)
REFERENCES dfn_ntp.u07_trading_account (u07_id)
/
ALTER TABLE dfn_ntp.t75_murabaha_contracts
ADD CONSTRAINT fk_t75_created_by_id_u17 FOREIGN KEY (t75_created_by_id_u17)
REFERENCES dfn_ntp.u17_employee (u17_id)
/
ALTER TABLE dfn_ntp.t75_murabaha_contracts
ADD CONSTRAINT fk_t75_modified_by_id_u17 FOREIGN KEY (t75_modified_by_id_u17)
REFERENCES dfn_ntp.u17_employee (u17_id)
/
ALTER TABLE dfn_ntp.t75_murabaha_contracts
ADD CONSTRAINT fk_t75_status_changed_by_u17 FOREIGN KEY (t75_status_changed_by_id_u17)
REFERENCES dfn_ntp.u17_employee (u17_id)
/

ALTER TABLE dfn_ntp.T75_MURABAHA_CONTRACTS 
 ADD (
  T75_CUSTOMER_TRDNG_AC_ID_U07 NUMBER (10, 0) NOT NULL
 )
/
COMMENT ON COLUMN dfn_ntp.T75_MURABAHA_CONTRACTS.T75_CUSTOMER_TRDNG_AC_ID_U07 IS 'fk from u07'
/

ALTER TABLE dfn_ntp.t75_murabaha_contracts
 MODIFY (
  t75_profit_percentage NUMBER (18, 5)

 )
/

ALTER TABLE dfn_ntp.t75_murabaha_contracts
 MODIFY (
  t75_status_id_v01 NUMBER (5, 0)

 )
/


ALTER TABLE dfn_ntp.T75_MURABAHA_CONTRACTS 
 ADD (
  T75_CURRENT_APPROVAL_LEVEL NUMBER (5, 0),
  T75_NEXT_STATUS NUMBER (5, 0),
  T75_NO_OF_APPROVAL NUMBER (2, 0),
  T75_COMMENT VARCHAR2 (2000 BYTE),
  T75_IS_APPROVAL_COMPLETED NUMBER (1, 0) DEFAULT 0,
  T75_CUSTOM_TYPE VARCHAR2 (50 BYTE) DEFAULT 1,
  T75_CURRENCY_CODE_M03 CHAR (3 BYTE) NOT NULL,
  T75_INSTITUTION_ID_M02 NUMBER (10, 0),
  T75_STP_EXG_FEE NUMBER (18, 5),
  T75_STP_BRK_FEE NUMBER (18, 5),
  T75_STP_EXG_VAT NUMBER (18, 5),
  T75_STP_BRK_VAT NUMBER (18, 5),
  T75_CSHTRN_BRK_FEE NUMBER (18, 5),
  T75_CSHTRN_BRK_VAT NUMBER (18, 5),
  T75_CUSTOMER_Id_U01 NUMBER (18, 0),
  T75_CUST_MRGIN_TRDNG_ID_U23 NUMBER (18, 0)
 )
/
COMMENT ON COLUMN dfn_ntp.T75_MURABAHA_CONTRACTS.T75_STP_EXG_FEE IS 'STP Exchange Fee'
/
COMMENT ON COLUMN dfn_ntp.T75_MURABAHA_CONTRACTS.T75_STP_BRK_FEE IS 'STP Broker Fee'
/
COMMENT ON COLUMN dfn_ntp.T75_MURABAHA_CONTRACTS.T75_STP_EXG_VAT IS 'STP Exchange Vat'
/
COMMENT ON COLUMN dfn_ntp.T75_MURABAHA_CONTRACTS.T75_STP_BRK_VAT IS 'STP Broker Vat'
/
COMMENT ON COLUMN dfn_ntp.T75_MURABAHA_CONTRACTS.T75_CSHTRN_BRK_FEE IS 'CSHTRN Broker Fee'
/
COMMENT ON COLUMN dfn_ntp.T75_MURABAHA_CONTRACTS.T75_CSHTRN_BRK_VAT IS 'CSHTRN Broker Vat'
/



