-- Foreign Key for  DFN_NTP.U53_PROCESS_DETAIL


  ALTER TABLE dfn_ntp.u53_process_detail ADD CONSTRAINT fk_u53_uploaded_by FOREIGN KEY (u53_updated_by_id_u17)
   REFERENCES dfn_ntp.u17_employee (u17_id) ENABLE
/
-- End of REF DDL Script for Table DFN_NTP.U53_PROCESS_DETAIL
