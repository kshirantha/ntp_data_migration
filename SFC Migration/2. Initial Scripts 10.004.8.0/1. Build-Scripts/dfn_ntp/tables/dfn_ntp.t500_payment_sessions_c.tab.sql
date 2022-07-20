CREATE TABLE dfn_ntp.t500_payment_sessions_c
(
    t500_id                         NUMBER (20, 0) NOT NULL,
    t500_date                       DATE NOT NULL,
    t500_symbol_code_m20            VARCHAR2 (10 BYTE) NOT NULL,
    t500_file_name                  VARCHAR2 (50 BYTE) NOT NULL,
    t500_status_id_v01              NUMBER (5, 0) NOT NULL,
    t500_uploaded_by_id_u17         NUMBER (5, 0) NOT NULL,
    t500_uploaded_date              DATE NOT NULL,
    t500_validated_by_id_u17        NUMBER (5, 0),
    t500_validated_date             DATE,
    t500_processed_by_id_u17        NUMBER (5, 0),
    t500_processed_date             DATE,
    t500_custom_type                VARCHAR2 (50 BYTE) DEFAULT 1,
    t500_institute_id_m02           NUMBER (3, 0) DEFAULT 1,
    t500_current_approval_level     NUMBER (3, 0),
    t500_status_changed_by_id_u17   NUMBER (5, 0),
    t500_status_changed_date        DATE
)
SEGMENT CREATION IMMEDIATE
NOPARALLEL
LOGGING
MONITORING
/



ALTER TABLE dfn_ntp.t500_payment_sessions_c
    ADD CONSTRAINT pk_t500 PRIMARY KEY (t500_id) USING INDEX
/