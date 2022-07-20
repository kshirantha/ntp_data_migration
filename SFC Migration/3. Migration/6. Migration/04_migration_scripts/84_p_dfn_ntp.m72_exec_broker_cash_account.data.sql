DECLARE
    l_exec_brk_cash_acc   NUMBER;
    l_sqlerrm             VARCHAR2 (4000);
BEGIN
    SELECT NVL (MAX (m72_id), 0)
      INTO l_exec_brk_cash_acc
      FROM dfn_ntp.m72_exec_broker_cash_account;

    DELETE FROM error_log
          WHERE mig_table = 'M72_EXEC_BROKER_CASH_ACCOUNT';

    FOR i
        IN (SELECT ex03_id,
                   ex03_accountno,
                   m26.new_executing_broker_id,
                   ex03_currency,
                   ex03_balance,
                   ex03_blocked_amount,
                   ex03_od_limit,
                   NVL (u17_od_approved.new_employee_id, 0)
                       AS od_approved_by_new_id,
                   NVL (ex03_od_approved_date, SYSDATE) AS od_approved_date,
                   NVL (u17_created.new_employee_id, 0) AS created_by_new_id,
                   NVL (ex03_created_date, SYSDATE) AS created_date,
                   u17_last_updated.new_employee_id AS last_updated_by_new_id,
                   ex03_lastupdated_date AS last_updated_date,
                   map01.map01_ntp_id,
                   NVL (u17_status_changed.new_employee_id, 0)
                       AS status_changed_by_new_id,
                   NVL (ex03_status_changed_date, SYSDATE)
                       AS status_changed_date,
                   ex03_pending_withdr,
                   ex03_pending_depost,
                   ex03_agent_acc_no,
                   m03.m03_id,
                   ex03_swift_acc,
                   m72_map.new_exec_brk_cash_acc_id
              FROM mubasher_oms.ex03_exe_inst_cash_account@mubasher_db_link ex03,
                   mubasher_oms.ex01_executing_institution@mubasher_db_link ex01,
                   m26_executing_broker_mappings m26,
                   map01_approval_status_v01 map01,
                   dfn_ntp.m03_currency m03,
                   u17_employee_mappings u17_created,
                   u17_employee_mappings u17_last_updated,
                   u17_employee_mappings u17_status_changed,
                   u17_employee_mappings u17_od_approved,
                   m72_exec_brk_cash_acc_mappings m72_map
             WHERE     ex03.ex03_execution_instituion = ex01.ex01_id
                   AND ex03.ex03_status_id = map01.map01_oms_id
                   AND ex03.ex03_currency = m03.m03_code
                   AND ex03.ex03_execution_instituion =
                           m26.old_executing_broker_id
                   AND ex03.ex03_created_by = u17_created.old_employee_id(+)
                   AND ex03.ex03_lastupdated_by =
                           u17_last_updated.old_employee_id(+)
                   AND ex03.ex03_status_changed_by =
                           u17_status_changed.old_employee_id(+)
                   AND ex03.ex03_od_approved_by =
                           u17_od_approved.old_employee_id(+)
                   AND ex01.ex01_type IN (3)
                   AND ex03.ex03_id = m72_map.old_exec_brk_cash_acc_id(+))
    LOOP
        BEGIN
            IF i.new_exec_brk_cash_acc_id IS NULL
            THEN
                l_exec_brk_cash_acc := l_exec_brk_cash_acc + 1;

                INSERT
                  INTO dfn_ntp.m72_exec_broker_cash_account (
                           m72_id,
                           m72_accountno,
                           m72_exec_broker_id_m26,
                           m72_account_type,
                           m72_currency_code_m03,
                           m72_balance,
                           m72_blocked_amount,
                           m72_od_limit,
                           m72_od_approved_by_id_u17,
                           m72_od_approved_date,
                           m72_created_by_id_u17,
                           m72_created_date,
                           m72_lastupdated_by_id_u17,
                           m72_lastupdated_date,
                           m72_status_id_v01,
                           m72_status_changed_by_id_u17,
                           m72_status_changed_date,
                           m72_pending_withdr,
                           m72_pending_depost,
                           m72_swift_acc,
                           m72_agent_acc_no,
                           m72_currency_id_m03,
                           m72_custom_type,
                           m72_is_default)
                VALUES (l_exec_brk_cash_acc, -- m72_id
                        i.ex03_accountno, -- m72_accountno
                        i.new_executing_broker_id, -- m72_exec_broker_id_m26
                        0, -- m72_account_type [No Implementation in NTP]
                        i.ex03_currency, -- m72_currency_code_m03
                        i.ex03_balance, -- m72_balance
                        i.ex03_blocked_amount, -- m72_blocked_amount
                        i.ex03_od_limit, -- m72_od_limit
                        i.od_approved_by_new_id, -- m72_od_approved_by_id_u17
                        i.od_approved_date, -- m72_od_approved_date
                        i.created_by_new_id, -- m72_created_by_id_u17
                        i.created_date, -- m72_created_date
                        i.last_updated_by_new_id, -- m72_lastupdated_by_id_u17
                        i.last_updated_date, -- m72_lastupdated_date
                        i.map01_ntp_id, -- m72_status_id_v01
                        i.status_changed_by_new_id, --m72_status_changed_by_id_u17
                        i.status_changed_date, -- m72_status_changed_date
                        i.ex03_pending_withdr, -- m72_pending_withdr
                        i.ex03_pending_depost, -- m72_pending_depost
                        i.ex03_swift_acc, -- m72_swift_acc
                        i.ex03_agent_acc_no, -- m72_agent_acc_no
                        i.m03_id, -- m72_currency_id_m03
                        '1', -- m72_custom_type
                        NULL -- m72_is_default | Not Available
                            );

                INSERT INTO m72_exec_brk_cash_acc_mappings
                     VALUES (i.ex03_id, l_exec_brk_cash_acc);
            ELSE
                UPDATE dfn_ntp.m72_exec_broker_cash_account
                   SET m72_accountno = i.ex03_accountno, -- m72_accountno
                       m72_exec_broker_id_m26 = i.new_executing_broker_id, -- m72_exec_broker_id_m26
                       m72_currency_code_m03 = i.ex03_currency, -- m72_currency_code_m03
                       m72_balance = i.ex03_balance, -- m72_balance
                       m72_blocked_amount = i.ex03_blocked_amount, -- m72_blocked_amount
                       m72_od_limit = i.ex03_od_limit, -- m72_od_limit
                       m72_od_approved_by_id_u17 = i.od_approved_by_new_id, -- m72_od_approved_by_id_u17
                       m72_od_approved_date = i.od_approved_date, -- m72_od_approved_date
                       m72_lastupdated_by_id_u17 =
                           NVL (i.last_updated_by_new_id, 0), -- m72_lastupdated_by_id_u17
                       m72_lastupdated_date =
                           NVL (i.last_updated_date, SYSDATE), -- m72_lastupdated_date
                       m72_status_id_v01 = i.map01_ntp_id, -- m72_status_id_v01
                       m72_status_changed_by_id_u17 =
                           i.status_changed_by_new_id, --m72_status_changed_by_id_u17
                       m72_status_changed_date = i.status_changed_date, -- m72_status_changed_date
                       m72_pending_withdr = i.ex03_pending_withdr, -- m72_pending_withdr
                       m72_pending_depost = i.ex03_pending_depost, -- m72_pending_depost
                       m72_swift_acc = i.ex03_swift_acc, -- m72_swift_acc
                       m72_agent_acc_no = i.ex03_agent_acc_no, -- m72_agent_acc_no
                       m72_currency_id_m03 = i.m03_id -- m72_currency_id_m03
                 WHERE m72_id = i.new_exec_brk_cash_acc_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'M72_EXEC_BROKER_CASH_ACCOUNT',
                                i.ex03_id,
                                CASE
                                    WHEN i.new_exec_brk_cash_acc_id IS NULL
                                    THEN
                                        l_exec_brk_cash_acc
                                    ELSE
                                        i.new_exec_brk_cash_acc_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_exec_brk_cash_acc_id IS NULL
                                    THEN
                                        'INSERT'
                                    ELSE
                                        'UPDATE'
                                END,
                                SYSDATE);
        END;
    END LOOP;
END;
/