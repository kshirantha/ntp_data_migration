DECLARE
    l_change_account_request_id   NUMBER;
    l_sqlerrm                     VARCHAR2 (4000);
BEGIN
    SELECT NVL (MAX (t502_id), 0)
      INTO l_change_account_request_id
      FROM dfn_ntp.t502_change_account_requests_c;

    DELETE FROM error_log
          WHERE mig_table = 'T502_CHANGE_ACCOUNT_REQUESTS_C';

    FOR i
        IN (SELECT t81.t81_id,
                   u07_map_from.new_trading_account_id,
                   u07.u07_cash_account_id_u06,
                   u07.u07_institute_id_m02,
                   u06_map_to.new_cash_account_id,
                   map01.map01_ntp_id,
                   NVL (u17_entered.new_employee_id, 0) AS entered_by_new_id,
                   t81.t81_entered_time AS entered_date, -- NULL Value Not Replaced with SYSDATE for Transaction Tables for Logical Reasons
                   t502_map.new_t502_change_acc_req_id,
                   CASE
                       WHEN map01.map01_ntp_id = 6
                       THEN
                           t81.t81_l1_approved_by
                       WHEN map01.map01_ntp_id IN (3, 7)
                       THEN
                           t81.t81_l2_approved_by
                   END
                       AS last_changed_by,
                   CASE
                       WHEN map01.map01_ntp_id = 6
                       THEN
                           t81.t81_l1_approved_time
                       WHEN map01.map01_ntp_id IN (3, 7)
                       THEN
                           t81.t81_l2_approved_time
                   END
                       AS last_changed_date, -- NULL Value Not Replaced with SYSDATE for Transaction Tables for Logical Reasons
                   CASE
                       WHEN map01.map01_ntp_id IN (3, 7) THEN 2
                       WHEN map01.map01_ntp_id = 6 THEN 1
                       ELSE 0
                   END
                       AS current_approval_level
              FROM mubasher_oms.t81_change_account_requests@mubasher_db_link t81,
                   map01_approval_status_v01 map01,
                   u07_trading_account_mappings u07_map_from,
                   dfn_ntp.u07_trading_account u07,
                   u06_cash_account_mappings u06_map_to,
                   u17_employee_mappings u17_entered,
                   u17_employee_mappings u17_l1_by,
                   u17_employee_mappings u17_l2_by,
                   t502_change_acc_req_c_mappings t502_map
             WHERE     t81.t81_status = map01.map01_oms_id
                   AND t81.t81_security_acc_id =
                           u07_map_from.old_trading_account_id(+)
                   AND u07_map_from.old_trading_account_id = u07.u07_id(+)
                   AND t81.t81_target_cash_acc_id =
                           u06_map_to.old_cash_account_id(+)
                   AND t81.t81_entered_by = u17_entered.old_employee_id(+)
                   AND t81.t81_l1_approved_by = u17_l1_by.old_employee_id(+)
                   AND t81.t81_l2_approved_by = u17_l2_by.old_employee_id(+)
                   AND t81.t81_id = t502_map.old_t502_change_acc_req_id(+))
    LOOP
        BEGIN
            IF i.new_trading_account_id IS NULL
            THEN
                raise_application_error (
                    -20001,
                    'From Trading Account Not Available',
                    TRUE);
            END IF;

            IF i.new_cash_account_id IS NULL
            THEN
                raise_application_error (-20001,
                                         'To Cash Account Not Available',
                                         TRUE);
            END IF;

            IF i.new_t502_change_acc_req_id IS NULL
            THEN
                l_change_account_request_id := l_change_account_request_id + 1;

                INSERT
                  INTO dfn_ntp.t502_change_account_requests_c (
                           t502_id,
                           t502_from_trading_acc_id_u07,
                           t502_from_cash_acc_id_u06,
                           t502_target_cash_acc_id_u06,
                           t502_status_id_v01,
                           t502_institute_id_m02,
                           t502_entered_by_id_u17,
                           t502_entered_date,
                           t502_last_changed_by_id_u17,
                           t502_last_changed_date,
                           t502_current_approval_level,
                           t502_custom_type)
                VALUES (l_change_account_request_id, -- t502_id
                        i.new_trading_account_id, -- t502_from_trading_acc_id_u07
                        i.u07_cash_account_id_u06, -- t502_from_cash_acc_id_u06
                        i.new_cash_account_id, -- t502_target_cash_acc_id_u06
                        i.map01_ntp_id, -- t502_status_id_v01
                        i.u07_institute_id_m02, -- t502_institute_id_m02
                        i.entered_by_new_id, -- t502_entered_by_id_u17
                        i.entered_date, -- t502_entered_date
                        i.last_changed_by, -- t502_last_changed_by_id_u17
                        i.last_changed_date, -- t502_last_changed_date
                        i.current_approval_level, -- t502_current_approval_level
                        '1' -- t502_custom_type
                           );

                INSERT
                  INTO t502_change_acc_req_c_mappings (
                           old_t502_change_acc_req_id,
                           new_t502_change_acc_req_id)
                VALUES (i.t81_id, l_change_account_request_id);
            ELSE
                UPDATE dfn_ntp.t502_change_account_requests_c
                   SET t502_from_trading_acc_id_u07 = i.new_trading_account_id, -- t502_from_trading_acc_id_u07
                       t502_from_cash_acc_id_u06 = i.u07_cash_account_id_u06, -- t502_from_cash_acc_id_u06
                       t502_target_cash_acc_id_u06 = i.new_cash_account_id, -- t502_target_cash_acc_id_u06
                       t502_status_id_v01 = i.map01_ntp_id, -- t502_status_id_v01
                       t502_institute_id_m02 = i.u07_institute_id_m02, -- t502_institute_id_m02
                       t502_entered_by_id_u17 = i.entered_by_new_id, -- t502_entered_by_id_u17
                       t502_entered_date = i.entered_date, -- t502_entered_date
                       t502_last_changed_by_id_u17 = i.last_changed_by, -- t502_last_changed_by_id_u17
                       t502_last_changed_date = i.last_changed_date, -- t502_last_changed_date
                       t502_current_approval_level = i.current_approval_level -- t502_current_approval_level
                 WHERE t502_id = i.new_t502_change_acc_req_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'T502_CHANGE_ACCOUNT_REQUESTS_C',
                                i.t81_id,
                                CASE
                                    WHEN i.new_t502_change_acc_req_id IS NULL
                                    THEN
                                        l_change_account_request_id
                                    ELSE
                                        i.new_t502_change_acc_req_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_t502_change_acc_req_id IS NULL
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
