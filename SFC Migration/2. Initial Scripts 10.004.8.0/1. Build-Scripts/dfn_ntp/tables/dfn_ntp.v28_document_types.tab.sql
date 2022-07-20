-- Table DFN_NTP.V28_DOCUMENT_TYPES

CREATE TABLE dfn_ntp.v28_document_types
(
    v28_id            NUMBER (2, 0),
    v28_description   VARCHAR2 (75),
    v28_code          VARCHAR2 (20)
)
/

-- Constraints for  DFN_NTP.V28_DOCUMENT_TYPES


  ALTER TABLE dfn_ntp.v28_document_types MODIFY (v28_id NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.v28_document_types MODIFY (v28_description NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.v28_document_types MODIFY (v28_code NOT NULL ENABLE)
/



-- End of DDL Script for Table DFN_NTP.V28_DOCUMENT_TYPES
