-- Table DFN_NTP.M119_SHARIA_SYMBOL

CREATE TABLE dfn_ntp.m119_sharia_symbol
(
    m119_id                     NUMBER (10, 0),
    m119_institute_id_m02       NUMBER (5, 0),
    m119_exchange_id_m01        NUMBER (5, 0),
    m119_exchange_code_m01      VARCHAR2 (10),
    m119_symbol_id_m20          NUMBER (5, 0),
    m119_symbol_code_m20        VARCHAR2 (50),
    m119_created_by_id_u17      NUMBER (10, 0),
    m119_created_date           DATE,
    m119_sharia_group_id_m120   NUMBER (5, 0)
)
/

-- Constraints for  DFN_NTP.M119_SHARIA_SYMBOL


  ALTER TABLE dfn_ntp.m119_sharia_symbol ADD CONSTRAINT pk_m119_sharia_symbol PRIMARY KEY (m119_id)
  USING INDEX  ENABLE
/

  ALTER TABLE dfn_ntp.m119_sharia_symbol MODIFY (m119_id NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m119_sharia_symbol MODIFY (m119_institute_id_m02 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m119_sharia_symbol MODIFY (m119_exchange_id_m01 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m119_sharia_symbol MODIFY (m119_exchange_code_m01 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m119_sharia_symbol MODIFY (m119_symbol_id_m20 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m119_sharia_symbol MODIFY (m119_symbol_code_m20 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m119_sharia_symbol MODIFY (m119_sharia_group_id_m120 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m119_sharia_symbol ADD CONSTRAINT uk_m119_sharia_symbol UNIQUE (m119_institute_id_m02, m119_exchange_id_m01, m119_symbol_id_m20, m119_sharia_group_id_m120)
  USING INDEX  ENABLE
/



-- End of DDL Script for Table DFN_NTP.M119_SHARIA_SYMBOL

alter table dfn_ntp.M119_SHARIA_SYMBOL
	add M119_CUSTOM_TYPE varchar2(50) default 1
/

ALTER TABLE dfn_ntp.m119_sharia_symbol MODIFY (m119_symbol_id_m20 NUMBER (10))
/
