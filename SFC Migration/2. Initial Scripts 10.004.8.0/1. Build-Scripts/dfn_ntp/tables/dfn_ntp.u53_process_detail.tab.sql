-- Table DFN_NTP.U53_PROCESS_DETAIL

CREATE TABLE dfn_ntp.u53_process_detail
(
    u53_id                  NUMBER (18, 0),
    u53_code                VARCHAR2 (10),
    u53_description         VARCHAR2 (1000),
    u53_data                BLOB,
    u53_position_date       DATE,
    u53_compressed          NUMBER (1, 0) DEFAULT 0,
    u53_status_id_v01       NUMBER (5, 0),
    u53_updated_by_id_u17   NUMBER (10, 0),
    u53_updated_date_time   DATE,
    u53_failed_reason       VARCHAR2 (4000)
)
/

-- Constraints for  DFN_NTP.U53_PROCESS_DETAIL


  ALTER TABLE dfn_ntp.u53_process_detail MODIFY (u53_id NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.u53_process_detail MODIFY (u53_code NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.u53_process_detail MODIFY (u53_updated_by_id_u17 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.u53_process_detail MODIFY (u53_updated_date_time NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.u53_process_detail MODIFY (u53_status_id_v01 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.u53_process_detail ADD CONSTRAINT u53_id_pk PRIMARY KEY (u53_id)
  USING INDEX  ENABLE
/

  ALTER TABLE dfn_ntp.u53_process_detail ADD CONSTRAINT uq_u53_code UNIQUE (u53_code)
  USING INDEX  ENABLE
/



-- Comments for  DFN_NTP.U53_PROCESS_DETAIL

COMMENT ON COLUMN dfn_ntp.u53_process_detail.u53_id IS 'PK'
/
COMMENT ON COLUMN dfn_ntp.u53_process_detail.u53_data IS 'Binary Data'
/
COMMENT ON COLUMN dfn_ntp.u53_process_detail.u53_compressed IS
    '0 = Regular | 1 = Compressed'
/
COMMENT ON TABLE dfn_ntp.u53_process_detail IS 'Binary Data Table'
/
-- End of DDL Script for Table DFN_NTP.U53_PROCESS_DETAIL

ALTER TABLE dfn_ntp.U53_PROCESS_DETAIL 
 ADD (
  u53_primary_institute_id_m02 NUMBER (3, 0)  DEFAULT 1
 )
/

ALTER TABLE dfn_ntp.u53_process_detail DROP CONSTRAINT uq_u53_code DROP INDEX
/

ALTER TABLE dfn_ntp.u53_process_detail ADD CONSTRAINT uq_u53_code UNIQUE (u53_code,u53_primary_institute_id_m02)
  USING INDEX  ENABLE
/
