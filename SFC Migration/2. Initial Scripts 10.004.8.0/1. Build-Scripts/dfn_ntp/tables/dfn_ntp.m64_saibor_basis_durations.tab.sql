-- Table DFN_NTP.M64_SAIBOR_BASIS_DURATIONS

CREATE TABLE dfn_ntp.m64_saibor_basis_durations
(
    m64_id         NUMBER (10, 0),
    m64_duration   NVARCHAR2 (200)
)
/

-- Constraints for  DFN_NTP.M64_SAIBOR_BASIS_DURATIONS


  ALTER TABLE dfn_ntp.m64_saibor_basis_durations ADD CONSTRAINT m64_pk PRIMARY KEY (m64_id)
  USING INDEX  ENABLE
/

  ALTER TABLE dfn_ntp.m64_saibor_basis_durations MODIFY (m64_id NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m64_saibor_basis_durations MODIFY (m64_duration NOT NULL ENABLE)
/



-- End of DDL Script for Table DFN_NTP.M64_SAIBOR_BASIS_DURATIONS
