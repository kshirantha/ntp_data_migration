CREATE OR REPLACE PROCEDURE dfn_ntp.sp_generate_accounting_entries_b (
    pm136_id IN NUMBER                      -- 1- IB GL Daily | 2- LB GL Daily
                      )
IS
    l_pkey     NUMBER := 0;
    l_status   v01_system_master_data.v01_id%TYPE;
BEGIN
    DELETE FROM t30_gl_txn_candidates
          WHERE t30_batch_id_t27 IN
                    (SELECT t27_id
                       FROM t27_gl_batches
                      WHERE     t27_event_cat_id_m136 = pm136_id
                            AND t27_status_id_v01 != 2);

    DELETE t28_gl_record_wise_entries
     WHERE t28_batch_id_t27 IN
               (SELECT t27_id
                  FROM t27_gl_batches
                 WHERE     t27_event_cat_id_m136 = pm136_id
                       AND t27_status_id_v01 != 2);

    DELETE t29_gl_column_wise_entries
     WHERE t29_batch_id_t27 IN
               (SELECT t27_id
                  FROM t27_gl_batches
                 WHERE     t27_event_cat_id_m136 = pm136_id
                       AND t27_status_id_v01 != 2);

    DELETE FROM t27_gl_batches
          WHERE t27_event_cat_id_m136 = pm136_id AND t27_status_id_v01 != 2;

    sp_gl_process (pdate                    => TRUNC (func_get_eod_date),
                   pm136_id                 => pm136_id,
                   pt27_created_by_id_u17   => 1,
                   pt27_id                  => 0,             --For Regenerate
                   paction                  => 1, --1 - Generate | 2 - Regenerate
                   pkey                     => l_pkey);

    SELECT NVL (MAX (t27_status_id_v01), 31)
      INTO l_status
      FROM t27_gl_batches
     WHERE t27_id = l_pkey;

    IF l_status = 1
    THEN                                                             --Pending
        UPDATE t27_gl_batches
           SET t27_status_id_v01 = 2                                --Approved
         WHERE t27_id = l_pkey;
    ELSE
        NULL;                      --ToDo SFC SMS Integration for job failiure
    END IF;
END;
/