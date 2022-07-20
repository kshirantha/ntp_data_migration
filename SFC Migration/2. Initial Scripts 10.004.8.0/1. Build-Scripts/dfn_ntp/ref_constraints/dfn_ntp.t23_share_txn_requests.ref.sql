-- Foreign Key for  DFN_NTP.T23_SHARE_TXN_REQUESTS


  ALTER TABLE dfn_ntp.t23_share_txn_requests ADD CONSTRAINT fk_t23_processed FOREIGN KEY (t23_processed_by_id_u17)
   REFERENCES dfn_ntp.u17_employee (u17_id) ENABLE
/

  ALTER TABLE dfn_ntp.t23_share_txn_requests ADD CONSTRAINT fk_t23_trading_acc FOREIGN KEY (t23_trading_acc_id_u07)
   REFERENCES dfn_ntp.u07_trading_account (u07_id) ENABLE
/

  ALTER TABLE dfn_ntp.t23_share_txn_requests ADD CONSTRAINT fk_t23_symbol_id FOREIGN KEY (t23_symbol_id_m20)
   REFERENCES dfn_ntp.m20_symbol (m20_id) ENABLE
/

  ALTER TABLE dfn_ntp.t23_share_txn_requests ADD CONSTRAINT fk_t23_status_changed FOREIGN KEY (t23_status_changed_by_id_u17)
   REFERENCES dfn_ntp.u17_employee (u17_id) ENABLE
/
-- End of REF DDL Script for Table DFN_NTP.T23_SHARE_TXN_REQUESTS
