-- Table DFN_NTP.R02_FIX_LOG_RECON

CREATE TABLE dfn_ntp.r02_fix_log_recon
(
    unique_key   VARCHAR2 (100),
    data         VARCHAR2 (3500)
)
/

-- Constraints for  DFN_NTP.R02_FIX_LOG_RECON


  ALTER TABLE dfn_ntp.r02_fix_log_recon MODIFY (unique_key NOT NULL ENABLE)
/



-- End of DDL Script for Table DFN_NTP.R02_FIX_LOG_RECON
