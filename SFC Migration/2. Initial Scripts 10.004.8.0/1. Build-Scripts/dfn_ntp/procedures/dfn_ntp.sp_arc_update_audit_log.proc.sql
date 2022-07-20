CREATE OR REPLACE PROCEDURE dfn_ntp.sp_arc_update_audit_log (
    pa14_audit_type         IN a14_arc_table_log.a14_audit_type%TYPE,
    pa14_arc_table_id_m38   IN a14_arc_table_log.a14_arc_table_id_m38%TYPE,
    pa14_status             IN a14_arc_table_log.a14_status%TYPE,
    pa14_narration          IN a14_arc_table_log.a14_narration%TYPE)
IS
    l_a14_id   a14_arc_table_log.a14_id%TYPE;
BEGIN
    l_a14_id :=
        fn_get_next_sequnce (pseq_name => 'M38_ARC_TABLE_CONFIGURATION');

    INSERT INTO dfn_ntp.a14_arc_table_log (a14_id,
                                           a14_arc_table_id_m38,
                                           a14_timestamp,
                                           a14_status,
                                           a14_narration,
                                           a14_audit_type)
         VALUES (l_a14_id,
                 pa14_arc_table_id_m38,
                 SYSDATE,
                 pa14_status,
                 pa14_narration,
                 pa14_audit_type);
END;
/
