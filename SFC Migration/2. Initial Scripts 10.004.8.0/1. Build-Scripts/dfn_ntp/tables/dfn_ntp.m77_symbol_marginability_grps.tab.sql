-- Table DFN_NTP.M77_SYMBOL_MARGINABILITY_GRPS

CREATE TABLE dfn_ntp.m77_symbol_marginability_grps
(
    m77_id                         NUMBER (20, 0),
    m77_institution_m02            NUMBER (10, 0),
    m77_name                       VARCHAR2 (255),
    m77_additional_details         VARCHAR2 (4000),
    m77_allow_online_cash_out      NUMBER (1, 0) DEFAULT 0,
    m77_category_percentage_a      NUMBER (5, 2) DEFAULT 0,
    m77_category_percentage_b      NUMBER (5, 2) DEFAULT 0,
    m77_category_percentage_c      NUMBER (5, 2) DEFAULT 0,
    m77_category_percentage_d      NUMBER (5, 2) DEFAULT 0,
    m77_category_percentage_e      NUMBER (5, 2) DEFAULT 0,
    m77_category_percentage_f      NUMBER (5, 2) DEFAULT 0,
    m77_is_default                 NUMBER (1, 0) DEFAULT 0,
    m77_status_id_v01              NUMBER (10, 0),
    m77_status_changed_date        DATE,
    m77_status_changed_by_id_u17   NUMBER (10, 0),
    m77_created_date               DATE,
    m77_created_by_id_u17          NUMBER (10, 0),
    m77_last_updated_date          DATE,
    m77_last_updated_by_id_u17     NUMBER (10, 0),
    m77_mrg_call_notify_lvl        NUMBER (22, 0) DEFAULT 0,
    m77_mrg_call_remind_lvl        NUMBER (22, 0) DEFAULT 0,
    m77_mrg_call_liquid_lvl        NUMBER (22, 0) DEFAULT 0
)
/

-- Constraints for  DFN_NTP.M77_SYMBOL_MARGINABILITY_GRPS


  ALTER TABLE dfn_ntp.m77_symbol_marginability_grps ADD CONSTRAINT m77_symbol_marginability_pk PRIMARY KEY (m77_id)
  USING INDEX  ENABLE
/

  ALTER TABLE dfn_ntp.m77_symbol_marginability_grps MODIFY (m77_id NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m77_symbol_marginability_grps MODIFY (m77_institution_m02 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m77_symbol_marginability_grps MODIFY (m77_name NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m77_symbol_marginability_grps MODIFY (m77_status_id_v01 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m77_symbol_marginability_grps MODIFY (m77_status_changed_date NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m77_symbol_marginability_grps MODIFY (m77_status_changed_by_id_u17 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m77_symbol_marginability_grps MODIFY (m77_created_date NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m77_symbol_marginability_grps MODIFY (m77_created_by_id_u17 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m77_symbol_marginability_grps MODIFY (m77_mrg_call_notify_lvl NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m77_symbol_marginability_grps MODIFY (m77_mrg_call_remind_lvl NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m77_symbol_marginability_grps MODIFY (m77_mrg_call_liquid_lvl NOT NULL ENABLE)
/



-- Comments for  DFN_NTP.M77_SYMBOL_MARGINABILITY_GRPS

COMMENT ON COLUMN dfn_ntp.m77_symbol_marginability_grps.m77_id IS 'pk'
/
COMMENT ON COLUMN dfn_ntp.m77_symbol_marginability_grps.m77_institution_m02 IS
    'Institution Id, fk from m02'
/
COMMENT ON COLUMN dfn_ntp.m77_symbol_marginability_grps.m77_name IS
    'Marginability group name'
/
COMMENT ON COLUMN dfn_ntp.m77_symbol_marginability_grps.m77_additional_details IS
    'Additional details about the Marginability group'
/
COMMENT ON COLUMN dfn_ntp.m77_symbol_marginability_grps.m77_allow_online_cash_out IS
    '1=Yes, 0=No, will control the ability to execute cash out transaction via online channel'
/
COMMENT ON COLUMN dfn_ntp.m77_symbol_marginability_grps.m77_is_default IS
    '1 - Yes | 0 - No'
/
-- End of DDL Script for Table DFN_NTP.M77_SYMBOL_MARGINABILITY_GRPS

alter table dfn_ntp.M77_SYMBOL_MARGINABILITY_GRPS
	add M77_CUSTOM_TYPE varchar2(50) default 1
/

ALTER TABLE dfn_ntp.M77_SYMBOL_MARGINABILITY_GRPS 
 ADD (
  M77_GLOBAL_MARGINABLE_PER NUMBER (6, 3)
 )
/
