-- Foreign Key for  DFN_NTP.M79_PENDING_SYMBL_MRG_REQUEST


  ALTER TABLE dfn_ntp.m79_pending_symbl_mrg_request ADD CONSTRAINT m79_sym_margin_group_m77_fk FOREIGN KEY (m79_sym_margin_group)
   REFERENCES dfn_ntp.m77_symbol_marginability_grps (m77_id) ENABLE
/
-- End of REF DDL Script for Table DFN_NTP.M79_PENDING_SYMBL_MRG_REQUEST
