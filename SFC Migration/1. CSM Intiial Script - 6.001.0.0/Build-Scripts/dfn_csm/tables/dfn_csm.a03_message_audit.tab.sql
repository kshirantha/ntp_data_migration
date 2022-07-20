CREATE TABLE dfn_csm.a03_message_audit
(
    a03_id             NUMBER (10, 0),
    a03_protocol       NUMBER (2, 0),
    a03_message        VARCHAR2 (3000 BYTE),
    a03_message_type   VARCHAR2 (100 BYTE),
    a03_timestamp      DATE,
    a03_in_out         NUMBER (2, 0)
)
SEGMENT CREATION DEFERRED
NOPARALLEL
LOGGING
MONITORING
/



COMMENT ON COLUMN dfn_csm.a03_message_audit.a03_in_out IS '1-IN, 2-OUT'
/
COMMENT ON COLUMN dfn_csm.a03_message_audit.a03_protocol IS '1-ISO, 2-FIXML'
/



DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'DROP TABLE dfn_csm.a03_message_audit';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tables
     WHERE     owner = UPPER ('dfn_csm')
           AND table_name = UPPER ('a03_message_audit');

    IF l_count = 1
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

CREATE TABLE dfn_csm.a03_message_audit
(
    a03_id             NUMBER (10, 0),
    a03_protocol       NUMBER (2, 0),
    a03_message        VARCHAR2 (3000 BYTE),
    a03_message_type   VARCHAR2 (100 BYTE),
    a03_timestamp      DATE,
    a03_in_out         NUMBER (2, 0)
)
/





COMMENT ON COLUMN dfn_csm.a03_message_audit.a03_in_out IS '1-IN, 2-OUT'
/
COMMENT ON COLUMN dfn_csm.a03_message_audit.a03_protocol IS '1-ISO, 2-FIXML'
/

ALTER TABLE DFN_CSM.A03_MESSAGE_AUDIT ADD (A03_MESSAGE_CLOB CLOB);
UPDATE DFN_CSM.A03_MESSAGE_AUDIT SET A03_MESSAGE_CLOB = A03_MESSAGE;
ALTER TABLE DFN_CSM.A03_MESSAGE_AUDIT DROP COLUMN A03_MESSAGE;
ALTER TABLE DFN_CSM.A03_MESSAGE_AUDIT RENAME COLUMN A03_MESSAGE_CLOB TO A03_MESSAGE;