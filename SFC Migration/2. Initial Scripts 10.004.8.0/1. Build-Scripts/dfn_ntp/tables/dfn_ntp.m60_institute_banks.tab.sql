-- Table DFN_NTP.M60_INSTITUTE_BANKS

CREATE TABLE dfn_ntp.m60_institute_banks
(
    m60_id                   NUMBER (10, 0),
    m60_institute_id_m02     NUMBER (10, 0),
    m60_bank_id_m16          NUMBER (5, 0),
    m60_created_by_id_u17    NUMBER (10, 0),
    m60_created_date         DATE,
    m60_modified_by_id_u17   NUMBER (10, 0),
    m60_modified_date        DATE,
    m60_is_default           NUMBER (1, 0)
)
/

-- Constraints for  DFN_NTP.M60_INSTITUTE_BANKS


  ALTER TABLE dfn_ntp.m60_institute_banks MODIFY (m60_id NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m60_institute_banks MODIFY (m60_institute_id_m02 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m60_institute_banks MODIFY (m60_bank_id_m16 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m60_institute_banks MODIFY (m60_created_by_id_u17 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m60_institute_banks MODIFY (m60_created_date NOT NULL ENABLE)
/



-- End of DDL Script for Table DFN_NTP.M60_INSTITUTE_BANKS

alter table dfn_ntp.M60_INSTITUTE_BANKS
	add M60_CUSTOM_TYPE varchar2(50) default 1
/
