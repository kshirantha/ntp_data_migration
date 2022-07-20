-- Foreign Key for  DFN_NTP.U17_EMPLOYEE


  ALTER TABLE dfn_ntp.u17_employee ADD CONSTRAINT fk_u17_m02_id FOREIGN KEY (u17_institution_id_m02)
   REFERENCES dfn_ntp.m02_institute (m02_id) ENABLE
/

  ALTER TABLE dfn_ntp.u17_employee ADD CONSTRAINT fku17_employ41482 FOREIGN KEY (u17_type_id_m11)
   REFERENCES dfn_ntp.m11_employee_type (m11_id) ENABLE
/

  ALTER TABLE dfn_ntp.u17_employee ADD CONSTRAINT fku17_employ520060 FOREIGN KEY (u17_department_id_m12)
   REFERENCES dfn_ntp.m12_employee_department (m12_id) ENABLE
/
-- End of REF DDL Script for Table DFN_NTP.U17_EMPLOYEE
