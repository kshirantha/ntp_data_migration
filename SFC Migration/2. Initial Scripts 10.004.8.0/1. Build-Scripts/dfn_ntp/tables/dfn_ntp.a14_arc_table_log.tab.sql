CREATE TABLE dfn_ntp.a14_arc_table_log
(
    a14_id                 NUMBER (18, 0) NOT NULL,
    a14_arc_table_id_m38   NUMBER (5, 0) NOT NULL,
    a14_timestamp          DATE,
    a14_status             NUMBER (1, 0),
    a14_narration          VARCHAR2 (4000 BYTE)
)
/



ALTER TABLE dfn_ntp.a14_arc_table_log
ADD CONSTRAINT a14_pk PRIMARY KEY (a14_id)
USING INDEX
/

COMMENT ON COLUMN dfn_ntp.a14_arc_table_log.a14_status IS
    '0 - Failed | 1 - Success | 2 - Partially Executed with Errors'
/

ALTER TABLE dfn_ntp.a14_arc_table_log
 ADD (
  a14_audit_type NUMBER (1)
 )
/
COMMENT ON COLUMN dfn_ntp.a14_arc_table_log.a14_audit_type IS
    '1 - INFO | 2 - ERROR'
/
