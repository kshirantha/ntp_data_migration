-- Table DFN_NTP.M44_INSTITUTION_ENTITLEMENTS

CREATE TABLE dfn_ntp.m44_institution_entitlements
(
    m44_id                   NUMBER (10, 0),
    m44_institution_id_m02   NUMBER (10, 0),
    m44_entitlement_id_v04   NUMBER (10, 0)
)
/

-- Constraints for  DFN_NTP.M44_INSTITUTION_ENTITLEMENTS


  ALTER TABLE dfn_ntp.m44_institution_entitlements ADD CONSTRAINT m44_pk PRIMARY KEY (m44_id)
  USING INDEX  ENABLE
/

  ALTER TABLE dfn_ntp.m44_institution_entitlements MODIFY (m44_id NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m44_institution_entitlements MODIFY (m44_institution_id_m02 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m44_institution_entitlements MODIFY (m44_entitlement_id_v04 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m44_institution_entitlements ADD CONSTRAINT uk_m44 UNIQUE (m44_institution_id_m02, m44_entitlement_id_v04)
  USING INDEX  ENABLE
/



-- End of DDL Script for Table DFN_NTP.M44_INSTITUTION_ENTITLEMENTS

alter table dfn_ntp.M44_INSTITUTION_ENTITLEMENTS
	add M44_CUSTOM_TYPE varchar2(50) default 1
/
