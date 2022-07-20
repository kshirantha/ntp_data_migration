-- Foreign Key for  DFN_NTP.M12_EMPLOYEE_DEPARTMENT


  ALTER TABLE dfn_ntp.m12_employee_department ADD CONSTRAINT fkm12_employ260031 FOREIGN KEY (m12_institute_id_m02)
   REFERENCES dfn_ntp.m02_institute (m02_id) ENABLE
/
-- End of REF DDL Script for Table DFN_NTP.M12_EMPLOYEE_DEPARTMENT
