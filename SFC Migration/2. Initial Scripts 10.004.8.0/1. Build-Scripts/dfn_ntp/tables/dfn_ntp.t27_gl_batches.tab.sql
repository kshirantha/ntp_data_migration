-- Table DFN_NTP.T27_GL_BATCHES

CREATE TABLE dfn_ntp.t27_gl_batches
(
    t27_id                  NUMBER (10, 0),
    t27_institute_id_m02    NUMBER (5, 0),
    t27_date                DATE,
    t27_event_cat_id_m136   NUMBER (5, 0),
    t27_created_by_id_u17   NUMBER (10, 0),
    t27_created_date        DATE,
    t27_status_id_v01       NUMBER (20, 0)
)
/

-- Constraints for  DFN_NTP.T27_GL_BATCHES


  ALTER TABLE dfn_ntp.t27_gl_batches ADD CONSTRAINT pk_t27 PRIMARY KEY (t27_id)
  USING INDEX  ENABLE
/

  ALTER TABLE dfn_ntp.t27_gl_batches MODIFY (t27_id NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.t27_gl_batches MODIFY (t27_institute_id_m02 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.t27_gl_batches MODIFY (t27_date NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.t27_gl_batches MODIFY (t27_event_cat_id_m136 NOT NULL ENABLE)
/



-- End of DDL Script for Table DFN_NTP.T27_GL_BATCHES

ALTER TABLE dfn_ntp.t27_gl_batches
 MODIFY (
  t27_id NUMBER (5, 0)
 )
/

ALTER TABLE dfn_ntp.t27_gl_batches
 ADD (
  t27_status_changed_by_id_u17 NUMBER (10),
  t27_status_changed_date DATE
 )
/

CREATE INDEX dfn_ntp.idx_t27_date
    ON dfn_ntp.t27_gl_batches (t27_date)
/

alter table dfn_ntp.T27_GL_BATCHES
	add T27_CUSTOM_TYPE varchar2(50) default 1
/

ALTER TABLE dfn_ntp.t27_gl_batches
 MODIFY (
  t27_id NUMBER (10, 0)

 )
/

CREATE INDEX dfn_ntp.idx_t27_status_id_v01
    ON dfn_ntp.t27_gl_batches (t27_status_id_v01)
/

CREATE INDEX dfn_ntp.idx_t27_event_cat_id_m136
    ON dfn_ntp.t27_gl_batches (t27_event_cat_id_m136)
/
