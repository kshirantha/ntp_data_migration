-- Table DFN_NTP.M78_SYMBOL_MARGINABILITY

CREATE TABLE dfn_ntp.m78_symbol_marginability
(
    m78_id                         NUMBER (20, 0),
    m78_symbol_id_m20              NUMBER (10, 0),
    m78_symbol_code_m20            VARCHAR2 (50),
    m78_institution_id_m02         NUMBER (10, 0),
    m78_mariginability             NUMBER (1, 0) DEFAULT 0,
    m78_marginable_per             NUMBER (6, 3),
    m78_sym_margin_group_m77       NUMBER (5, 0),
    m78_status_id_v01              NUMBER (10, 0),
    m78_status_changed_date        DATE,
    m78_status_changed_by_id_u17   NUMBER (10, 0),
    m78_created_date               DATE,
    m78_created_by_id_u17          NUMBER (10, 0),
    m78_last_updated_date          DATE,
    m78_last_updated_by_id_u17     NUMBER (10, 0),
    m78_exchange_id_m01            NUMBER (5, 0),
    m78_exchange_code_m01          VARCHAR2 (10)
)
/

-- Constraints for  DFN_NTP.M78_SYMBOL_MARGINABILITY


  ALTER TABLE dfn_ntp.m78_symbol_marginability MODIFY (m78_id NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m78_symbol_marginability MODIFY (m78_symbol_id_m20 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m78_symbol_marginability MODIFY (m78_institution_id_m02 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m78_symbol_marginability MODIFY (m78_mariginability NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m78_symbol_marginability MODIFY (m78_marginable_per NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m78_symbol_marginability MODIFY (m78_status_id_v01 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m78_symbol_marginability MODIFY (m78_status_changed_date NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m78_symbol_marginability MODIFY (m78_status_changed_by_id_u17 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m78_symbol_marginability MODIFY (m78_created_date NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m78_symbol_marginability MODIFY (m78_created_by_id_u17 NOT NULL ENABLE)
/



-- Comments for  DFN_NTP.M78_SYMBOL_MARGINABILITY

COMMENT ON COLUMN dfn_ntp.m78_symbol_marginability.m78_mariginability IS
    '1=YES, 0=NO'
/
COMMENT ON COLUMN dfn_ntp.m78_symbol_marginability.m78_sym_margin_group_m77 IS
    'Symbol marginability group, fk from m77'
/
COMMENT ON TABLE dfn_ntp.m78_symbol_marginability IS
    'This table has margin trading information for each symbol for each institution'
/
-- End of DDL Script for Table DFN_NTP.M78_SYMBOL_MARGINABILITY

alter table dfn_ntp.M78_SYMBOL_MARGINABILITY
	add M78_CUSTOM_TYPE varchar2(50) default 1
/
