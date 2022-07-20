-- Table DFN_NTP.R06_CASH_ACCOUNT_TMP

CREATE TABLE dfn_ntp.r06_cash_account_tmp
(
    u06_id                NUMBER (10, 0),
    u06_payable_blocked   NUMBER (25, 10)
)
/

-- Constraints for  DFN_NTP.R06_CASH_ACCOUNT_TMP


  ALTER TABLE dfn_ntp.r06_cash_account_tmp MODIFY (u06_id NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.r06_cash_account_tmp MODIFY (u06_payable_blocked NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.r06_cash_account_tmp ADD CONSTRAINT pk_r06_cash_account_tmp PRIMARY KEY (u06_id)
  USING INDEX  ENABLE
/



-- End of DDL Script for Table DFN_NTP.R06_CASH_ACCOUNT_TMP
