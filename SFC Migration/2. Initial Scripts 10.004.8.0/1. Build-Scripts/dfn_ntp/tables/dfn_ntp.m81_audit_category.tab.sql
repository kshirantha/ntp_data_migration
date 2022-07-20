-- Table DFN_NTP.M81_AUDIT_CATEGORY

CREATE TABLE dfn_ntp.m81_audit_category
(
    m81_id               NUMBER (5, 0),
    m81_category         VARCHAR2 (100),
    m81_channel_id_v29   NUMBER (5, 0)
)
/

-- Constraints for  DFN_NTP.M81_AUDIT_CATEGORY


  ALTER TABLE dfn_ntp.m81_audit_category MODIFY (m81_id NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m81_audit_category MODIFY (m81_category NOT NULL ENABLE)
/



-- Comments for  DFN_NTP.M81_AUDIT_CATEGORY

COMMENT ON COLUMN dfn_ntp.m81_audit_category.m81_id IS 'Category ID'
/
COMMENT ON COLUMN dfn_ntp.m81_audit_category.m81_category IS 'Audit Categpry'
/
COMMENT ON COLUMN dfn_ntp.m81_audit_category.m81_channel_id_v29 IS
    'Channel ID (FK from M21)'
/
COMMENT ON TABLE dfn_ntp.m81_audit_category IS 'Audit Category'
/
-- End of DDL Script for Table DFN_NTP.M81_AUDIT_CATEGORY
