-- Table DFN_NTP.A09_FUNCTION_APPROVAL_LOG

CREATE TABLE dfn_ntp.a09_function_approval_log
(
    a09_id                  NUMBER (18, 0),
    a09_function_id_m88     NUMBER (5, 0),
    a09_function_name_m88   VARCHAR2 (50),
    a09_request_id          NUMBER (18, 0),
    a09_status_id_v01       NUMBER (5, 0),
    a09_action_by_id_u17    NUMBER (5, 0),
    a09_action_date         TIMESTAMP (7),
    a09_created_by_id_u17   NUMBER (5, 0),
    a09_created_date        DATE,
    a09_narration           VARCHAR2 (100),
    a09_reject_reason       VARCHAR2 (100)
)
/

-- Constraints for  DFN_NTP.A09_FUNCTION_APPROVAL_LOG


  ALTER TABLE dfn_ntp.a09_function_approval_log MODIFY (a09_id NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.a09_function_approval_log MODIFY (a09_function_id_m88 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.a09_function_approval_log MODIFY (a09_function_name_m88 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.a09_function_approval_log MODIFY (a09_request_id NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.a09_function_approval_log MODIFY (a09_status_id_v01 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.a09_function_approval_log MODIFY (a09_action_by_id_u17 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.a09_function_approval_log MODIFY (a09_action_date NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.a09_function_approval_log MODIFY (a09_created_by_id_u17 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.a09_function_approval_log MODIFY (a09_created_date NOT NULL ENABLE)
/



-- Comments for  DFN_NTP.A09_FUNCTION_APPROVAL_LOG

COMMENT ON COLUMN dfn_ntp.a09_function_approval_log.a09_function_id_m88 IS
    'fk_from_m88'
/
COMMENT ON COLUMN dfn_ntp.a09_function_approval_log.a09_request_id IS
    'fk from x - pending changes table'
/
COMMENT ON COLUMN dfn_ntp.a09_function_approval_log.a09_action_by_id_u17 IS
    'fk from u17'
/
COMMENT ON COLUMN dfn_ntp.a09_function_approval_log.a09_created_by_id_u17 IS
    'fk from u17'
/
-- End of DDL Script for Table DFN_NTP.A09_FUNCTION_APPROVAL_LOG

alter table dfn_ntp.A09_FUNCTION_APPROVAL_LOG
	add A09_CUSTOM_TYPE varchar2(50) default 1
/

CREATE INDEX dfn_ntp.idx_a09_action_by_id_u17
    ON dfn_ntp.a09_function_approval_log (a09_action_by_id_u17)
/

CREATE INDEX dfn_ntp.idx_a09_status_id_v01
    ON dfn_ntp.a09_function_approval_log (a09_status_id_v01)
/

ALTER TABLE dfn_ntp.a09_function_approval_log
 MODIFY (
  a09_action_date NULL,
  a09_created_date NULL
 )
/

ALTER TABLE dfn_ntp.A09_FUNCTION_APPROVAL_LOG
 MODIFY (
  A09_ACTION_BY_ID_U17 NUMBER (10, 0),
  A09_CREATED_BY_ID_U17 NUMBER (10, 0)

 )
/

CREATE INDEX dfn_ntp.idx_a09_request_id
    ON dfn_ntp.a09_function_approval_log (a09_request_id ASC)
/

CREATE INDEX dfn_ntp.idx_a09_function_id_m88
    ON dfn_ntp.a09_function_approval_log (a09_function_id_m88 ASC)
/
