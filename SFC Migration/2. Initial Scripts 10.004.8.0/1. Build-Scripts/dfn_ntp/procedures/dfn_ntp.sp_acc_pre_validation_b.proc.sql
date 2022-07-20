CREATE OR REPLACE PROCEDURE dfn_ntp.sp_acc_pre_validation_b (
    pm136_id IN NUMBER                      -- 1- IB GL Daily | 2- LB GL Daily
                      )
IS
    l_pkey     NUMBER := 0;
    l_status   v01_system_master_data.v01_id%TYPE;
BEGIN
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

    IF l_status != 1
    THEN                                                             --Pending
        NULL;                      --ToDo SFC SMS Integration for job failiure
    END IF;
END;
/
