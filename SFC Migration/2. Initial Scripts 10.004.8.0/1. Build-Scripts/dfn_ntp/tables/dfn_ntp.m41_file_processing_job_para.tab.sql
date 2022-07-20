CREATE TABLE dfn_ntp.m41_file_processing_job_para
(
    m41_id              NUMBER,
    m41_config_id_m40   NUMBER,
    m41_key             VARCHAR2 (50 BYTE),
    m41_value           VARCHAR2 (500 BYTE),
    m41_custom_type     VARCHAR2 (50 BYTE) DEFAULT 1
)
/


ALTER TABLE dfn_ntp.m41_file_processing_job_para
ADD CONSTRAINT m41_pk PRIMARY KEY (m41_id)
/
