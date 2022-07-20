-- Table DFN_NTP.R05_ORDER_AUDIT_RECON

CREATE TABLE dfn_ntp.r05_order_audit_recon
(
    unique_key   VARCHAR2 (100),
    data         VARCHAR2 (3000)
)
/

-- Constraints for  DFN_NTP.R05_ORDER_AUDIT_RECON


  ALTER TABLE dfn_ntp.r05_order_audit_recon MODIFY (unique_key NOT NULL ENABLE)
/



-- End of DDL Script for Table DFN_NTP.R05_ORDER_AUDIT_RECON
