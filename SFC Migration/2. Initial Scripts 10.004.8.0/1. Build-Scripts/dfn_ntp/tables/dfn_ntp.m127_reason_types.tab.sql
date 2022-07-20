-- Table DFN_NTP.M127_REASON_TYPES

CREATE TABLE dfn_ntp.m127_reason_types
(
    m127_id               NUMBER (10, 0),
    m127_type_text        VARCHAR2 (200),
    m127_type_text_lang   VARCHAR2 (200)
)
/

-- Constraints for  DFN_NTP.M127_REASON_TYPES


  ALTER TABLE dfn_ntp.m127_reason_types ADD CONSTRAINT pk_m127 PRIMARY KEY (m127_id)
  USING INDEX  ENABLE
/

  ALTER TABLE dfn_ntp.m127_reason_types MODIFY (m127_id NOT NULL ENABLE)
/



-- End of DDL Script for Table DFN_NTP.M127_REASON_TYPES
