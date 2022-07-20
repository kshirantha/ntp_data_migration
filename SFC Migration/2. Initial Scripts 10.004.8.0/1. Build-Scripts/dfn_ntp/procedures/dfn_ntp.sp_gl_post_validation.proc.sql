CREATE OR REPLACE PROCEDURE dfn_ntp.sp_gl_post_validation (
    pt27_id       IN     t27_gl_batches.t27_id%TYPE,
    pm136_type    IN     m136_gl_event_categories.m136_type%TYPE,
    pdifference      OUT NUMBER)
IS
BEGIN
    IF pm136_type = 0                                             --0 - Record
    THEN
        SELECT SUM (t28_dr) - SUM (t28_cr)
          INTO pdifference
          FROM t28_gl_record_wise_entries
         WHERE t28_batch_id_t27 = pt27_id;
    ELSIF pm136_type = 1                                          --1 - Column
    THEN
        SELECT   SUM (t29_dr1 + t29_dr2 + t29_dr3 + t29_dr4 + t29_dr5)
               - SUM (t29_cr1 + t29_cr2 + t29_cr3 + t29_cr4 + t29_cr5)
          INTO pdifference
          FROM t29_gl_column_wise_entries
         WHERE t29_id = pt27_id;
    END IF;
END;
/
