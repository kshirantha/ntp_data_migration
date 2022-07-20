DECLARE
    l_broker_id                  NUMBER;
    l_primary_institute_id       NUMBER;
    l_cust_corporate_action_id   NUMBER;
    l_sqlerrm                    VARCHAR2 (4000);
BEGIN
    SELECT VALUE
      INTO l_broker_id
      FROM migration_params
     WHERE code = 'BROKERAGE_ID';

    SELECT m150.m150_primary_institute_id_m02
      INTO l_primary_institute_id
      FROM dfn_ntp.m150_broker m150
     WHERE m150.m150_id = l_broker_id;

    SELECT NVL (MAX (m141_id), 0)
      INTO l_cust_corporate_action_id
      FROM dfn_ntp.m141_cust_corporate_action;

    DELETE FROM error_log
          WHERE mig_table = 'M141_CUST_CORPORATE_ACTION';

    FOR i
        IN (SELECT m272.m272_id,
                   m272.m272_action_number,
                   m272.m272_action_type,
                   m272.m272_description,
                   map01.map01_ntp_id,
                   m20.m20_symbol_code,
                   m20.m20_id,
                   m20.m20_exchange_code_m01,
                   m20.m20_exchange_id_m01,
                   m26_map.new_executing_broker_id,
                   m72_map.new_exec_brk_cash_acc_id,
                   m272.m272_pay_date,
                   m272.m272_ex_date,
                   m272.m272_value_date,
                   m272.m272_narration,
                   NVL (u17_created.new_employee_id, 0) AS created_by,
                   NVL (m272.m272_created_date, SYSDATE) AS created_date,
                   u17_modified.new_employee_id AS modifed_by_new_id,
                   m272.m272_modified_date AS modified_date,
                   NVL (u17_status_changed.new_employee_id, 0)
                       AS status_changed_by_new_id,
                   NVL (m272.m272_status_changed_date, SYSDATE)
                       AS status_changed_date,
                   m02_map.new_institute_id,
                   m141_map.new_cust_corp_action_id
              FROM mubasher_oms.m272_corporate_actions@mubasher_db_link m272,
                   map01_approval_status_v01 map01,
                   m20_symbol_mappings m20_map,
                   (SELECT m20_id,
                           m20_symbol_code,
                           m20_exchange_id_m01,
                           m20_exchange_code_m01
                      FROM dfn_ntp.m20_symbol
                     WHERE m20_institute_id_m02 = l_primary_institute_id) m20,
                   m26_executing_broker_mappings m26_map,
                   m72_exec_brk_cash_acc_mappings m72_map,
                   u17_employee_mappings u17_created,
                   u17_employee_mappings u17_modified,
                   u17_employee_mappings u17_status_changed,
                   m02_institute_mappings m02_map,
                   m141_cust_corp_action_mappings m141_map
             WHERE     m272.m272_status_id = map01.map01_oms_id
                   AND m272.m272_symbol = m20_map.old_symbol_id(+)
                   AND m20_map.new_symbol_id = m20.m20_id(+)
                   AND m272.m272_custodian = m26_map.old_executing_broker_id
                   AND m272.m272_custody_acc_no =
                           m72_map.old_exec_brk_cash_acc_id(+)
                   AND m272.m272_inst_id = m02_map.old_institute_id
                   AND m272.m272_created_by = u17_created.old_employee_id(+)
                   AND m272.m272_modified_by =
                           u17_modified.old_employee_id(+)
                   AND m272.m272_status_changed_by =
                           u17_status_changed.old_employee_id(+)
                   AND m272.m272_id = m141_map.old_cust_corp_action_id(+))
    LOOP
        BEGIN
            IF i.new_cust_corp_action_id IS NULL
            THEN
                l_cust_corporate_action_id := l_cust_corporate_action_id + 1;

                INSERT
                  INTO dfn_ntp.m141_cust_corporate_action (
                           m141_id,
                           m141_template_id_m140,
                           m141_description,
                           m141_exchange_id_m01,
                           m141_exchange_code_m01,
                           m141_symbol_id_m20,
                           m141_symbol_code_m20,
                           m141_custodian_id_m26,
                           m141_custodian_acc_id_m72,
                           m141_coupon_date,
                           m141_announcement_date,
                           m141_ex_date,
                           m141_record_date,
                           m141_pay_date,
                           m141_narration,
                           m141_notify_on_announce_date,
                           m141_notify_on_ex_date,
                           m141_notify_on_record_date,
                           m141_notify_on_pay_date,
                           m141_no_of_payments,
                           m141_created_by_id_u17,
                           m141_created_date,
                           m141_modified_by_id_u17,
                           m141_modified_date,
                           m141_status_id_v01,
                           m141_status_changed_by_id_u17,
                           m141_status_changed_date,
                           m141_external_ref,
                           m141_institute_id_m02,
                           m141_custom_type)
                VALUES (l_cust_corporate_action_id, -- m141_id
                        i.m272_action_type, -- m141_template_id_m140 | [SAME IDs] Discussed with Mathes & Sandamal : Use the same code for just one institution and no need to go for multi institution change
                        i.m272_description, -- m141_description
                        i.m20_exchange_id_m01, -- m141_exchange_id_m01
                        i.m20_exchange_code_m01, -- m141_exchange_code_m01
                        i.m20_id, -- m141_symbol_id_m20
                        i.m20_symbol_code, -- m141_symbol_code_m20
                        i.new_executing_broker_id, -- m141_custodian_id_m26
                        i.new_exec_brk_cash_acc_id, -- m141_custodian_acc_id_m72
                        NULL, -- m141_coupon_date
                        i.m272_ex_date, -- m141_announcement_date | Janaka : If Null Persist Ex Date
                        i.m272_ex_date, -- m141_ex_date
                        i.m272_value_date, -- m141_record_date
                        i.m272_pay_date, -- m141_pay_date
                        i.m272_narration, -- m141_narration
                        0, -- m141_notify_on_announce_date | Not Available
                        0, -- m141_notify_on_ex_date | Not Available
                        0, -- m141_notify_on_record_date | Not Available
                        0, -- m141_notify_on_pay_date | Not Available
                        1, -- m141_no_of_payments | Not Available (1 - SFC Implementation)
                        i.created_by, -- m141_created_by_id_u17
                        i.created_date, -- m141_created_date
                        i.modifed_by_new_id, -- m141_modified_by_id_u17
                        i.modified_date, -- m141_modified_date
                        i.map01_ntp_id, -- m141_status_id_v01
                        i.status_changed_by_new_id, -- m141_status_changed_by_id_u17
                        i.status_changed_date, -- m141_status_changed_date
                        i.m272_id, -- m141_external_ref
                        i.new_institute_id, -- m141_institute_id_m02
                        '1' -- m141_custom_type
                           );

                INSERT
                  INTO m141_cust_corp_action_mappings (old_cust_corp_action_id,
                                                       new_cust_corp_action_id)
                VALUES (i.m272_id, l_cust_corporate_action_id);
            ELSE
                UPDATE dfn_ntp.m141_cust_corporate_action
                   SET m141_template_id_m140 = i.m272_action_type, -- m141_template_id_m140 | [SAME IDs] Discussed with Mathes & Sandamal : Use the same code for just one institution and no need to go for multi institution change
                       m141_description = i.m272_description, -- m141_description
                       m141_exchange_id_m01 = i.m20_exchange_id_m01, -- m141_exchange_id_m01
                       m141_exchange_code_m01 = i.m20_exchange_code_m01, -- m141_exchange_code_m01
                       m141_symbol_id_m20 = i.m20_id, -- m141_symbol_id_m20
                       m141_symbol_code_m20 = i.m20_symbol_code, -- m141_symbol_code_m20
                       m141_custodian_id_m26 = i.new_executing_broker_id, -- m141_custodian_id_m26
                       m141_custodian_acc_id_m72 = i.new_exec_brk_cash_acc_id, -- m141_custodian_acc_id_m72
                       m141_announcement_date = i.m272_ex_date, -- m141_announcement_date | Janaka : If Null Persist Ex Date
                       m141_ex_date = i.m272_ex_date, -- m141_ex_date
                       m141_record_date = i.m272_value_date, -- m141_record_date
                       m141_pay_date = i.m272_pay_date, -- m141_pay_date
                       m141_narration = i.m272_narration, -- m141_narration
                       m141_modified_by_id_u17 = NVL (i.modifed_by_new_id, 0), -- m141_modified_by_id_u17
                       m141_modified_date = NVL (i.modified_date, SYSDATE), -- m141_modified_date
                       m141_status_id_v01 = i.map01_ntp_id, -- m141_status_id_v01
                       m141_status_changed_by_id_u17 =
                           i.status_changed_by_new_id, -- m141_status_changed_by_id_u17
                       m141_status_changed_date = i.status_changed_date, -- m141_status_changed_date
                       m141_external_ref = i.m272_id, -- m141_external_ref
                       m141_institute_id_m02 = i.new_institute_id -- m141_institute_id_m02
                 WHERE m141_id = i.new_cust_corp_action_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'M141_CUST_CORPORATE_ACTION',
                                i.m272_id,
                                CASE
                                    WHEN i.new_cust_corp_action_id IS NULL
                                    THEN
                                        l_cust_corporate_action_id
                                    ELSE
                                        i.new_cust_corp_action_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_cust_corp_action_id IS NULL
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
