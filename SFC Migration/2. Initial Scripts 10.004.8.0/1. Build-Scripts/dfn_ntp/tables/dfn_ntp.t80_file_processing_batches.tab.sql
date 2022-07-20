CREATE TABLE dfn_ntp.t80_file_processing_batches
(
    t80_id                         NUMBER (10, 0),
    t80_config_id_m40              NUMBER (10, 0),
    t80_job_time                   TIMESTAMP (6),
    t80_created_by_id_u17          NUMBER (10, 0),
    t80_created_date               DATE,
    t80_modified_by_id_u17         NUMBER (10, 0),
    t80_modified_date              DATE,
    t80_status_id_v01              NUMBER (5, 0),
    t80_status_changed_by_id_u17   NUMBER (10, 0),
    t80_status_changed_date        DATE,
    t80_custom_type                VARCHAR2 (1 BYTE) DEFAULT 1
)
/



ALTER TABLE dfn_ntp.t80_file_processing_batches
ADD CONSTRAINT t80_pk PRIMARY KEY (t80_id)
/

ALTER TABLE dfn_ntp.t80_file_processing_batches
  ADD (t80_mismatch NUMBER(2),
       t80_batch_type NUMBER(1),
       t80_description VARCHAR2(200 BYTE),
       t80_primary_institute_id_m02 NUMBER(20),
       t80_file_date DATE,
       t80_cancel_reason varchar2(2000 BYTE)
       )
/

COMMENT ON COLUMN dfn_ntp.t80_file_processing_batches.t80_mismatch IS
    '0 - No Mismatch, 1 - Mismatch'
/	

COMMENT ON COLUMN dfn_ntp.t80_file_processing_batches.t80_batch_type IS
    '1- Auto 2- Manual'
/
	   