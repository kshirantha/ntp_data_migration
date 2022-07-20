-- Table DFN_NTP.A10_ENTITY_STATUS_HISTORY

CREATE TABLE dfn_ntp.a10_entity_status_history
(
    a10_id                         NUMBER (20, 0),
    a10_approval_entity_id         NUMBER (20, 0),
    a10_entity_pk                  VARCHAR2 (255),
    a10_approval_status_id_v01     NUMBER (20, 0),
    a10_status_changed_by_id_u17   NUMBER (20, 0),
    a10_status_changed_date        DATE
)
/

-- Constraints for  DFN_NTP.A10_ENTITY_STATUS_HISTORY


  ALTER TABLE dfn_ntp.a10_entity_status_history ADD CONSTRAINT a10_pk PRIMARY KEY (a10_id)
  USING INDEX  ENABLE
/

  ALTER TABLE dfn_ntp.a10_entity_status_history MODIFY (a10_id NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.a10_entity_status_history MODIFY (a10_approval_entity_id NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.a10_entity_status_history MODIFY (a10_entity_pk NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.a10_entity_status_history MODIFY (a10_approval_status_id_v01 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.a10_entity_status_history MODIFY (a10_status_changed_by_id_u17 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.a10_entity_status_history MODIFY (a10_status_changed_date NOT NULL ENABLE)
/



-- End of DDL Script for Table DFN_NTP.A10_ENTITY_STATUS_HISTORY

CREATE INDEX dfn_ntp.idx_a10_stat_changed_by_id_u17
    ON dfn_ntp.a10_entity_status_history (a10_status_changed_by_id_u17)
/
