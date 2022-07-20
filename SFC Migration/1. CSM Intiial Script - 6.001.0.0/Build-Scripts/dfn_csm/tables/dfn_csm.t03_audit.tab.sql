CREATE TABLE dfn_csm.t03_audit
(
    t03_date           DATE DEFAULT SYSDATE NOT NULL,
    t03_user_id        NUMBER (10, 0),
    t03_activity_id    NUMBER (5, 0) NOT NULL,
    t03_description    VARCHAR2 (2000 BYTE),
    t03_reference_no   VARCHAR2 (400 BYTE)
)
SEGMENT CREATION DEFERRED
NOPARALLEL
LOGGING
MONITORING
/



COMMENT ON COLUMN dfn_csm.t03_audit.t03_date IS 'Date'
/



