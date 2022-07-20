CREATE TABLE dfn_csm.m04_aud_activity
(
    m04_id              NUMBER (5, 0) NOT NULL,
    m04_activity_name   VARCHAR2 (100 BYTE)
)
SEGMENT CREATION DEFERRED
NOPARALLEL
LOGGING
MONITORING
/



ALTER TABLE dfn_csm.m04_aud_activity
ADD CONSTRAINT pk_m04_id PRIMARY KEY (m04_id)
USING INDEX
/

COMMENT ON COLUMN dfn_csm.m04_aud_activity.m04_id IS 'PK'
/


