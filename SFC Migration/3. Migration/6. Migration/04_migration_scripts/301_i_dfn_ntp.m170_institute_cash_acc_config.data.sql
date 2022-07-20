DECLARE
    l_ins_cash_acc_con_id   NUMBER;
    l_sqlerrm               VARCHAR2 (4000);
BEGIN
    SELECT NVL (MAX (m170_id), 0)
      INTO l_ins_cash_acc_con_id
      FROM dfn_ntp.m170_institute_cash_acc_config;

    DELETE FROM error_log
          WHERE mig_table = 'M170_INSTITUTE_CASH_ACC_CONFIG';

    FOR i
        IN (SELECT m379.m379_id,
                   m379.m379_currency,
                   m03.m03_id,
                   u06_map.new_cash_account_id,
                   m379.m379_branch_id,
                   m02_map.new_institute_id,
                   NVL (u17_created.new_employee_id, 0) AS created_by,
                   NVL (m379.m379_created_date, SYSDATE) AS created_date,
                   u17_modified.new_employee_id AS modified_by,
                   m379.m379_modified_date AS modified_date,
                   map01.map01_ntp_id,
                   m170_map.new_ins_cash_acc_con_id
              FROM mubasher_oms.m379_paying_agents@mubasher_db_link m379,
                   dfn_ntp.m03_currency m03,
                   m02_institute_mappings m02_map,
                   u06_cash_account_mappings u06_map,
                   map01_approval_status_v01 map01,
                   u17_employee_mappings u17_created,
                   u17_employee_mappings u17_modified,
                   m170_ins_cash_acc_con_mappings m170_map
             WHERE     m379.m379_branch_id = m02_map.old_institute_id
                   AND m379.m379_cash_account_id =
                           u06_map.old_cash_account_id
                   AND m379.m379_currency = m03.m03_code
                   AND NVL (m379.m379_status_id, 2) = map01.map01_oms_id(+) -- Discussed Solution with Sandamal
                   AND m379.m379_created_by = u17_created.old_employee_id(+)
                   AND m379.m379_modified_by =
                           u17_modified.old_employee_id(+)
                   AND m379.m379_id = m170_map.old_ins_cash_acc_con_id(+))
    LOOP
        BEGIN
            IF i.map01_ntp_id IS NULL
            THEN
                raise_application_error (-20001, 'Status Invalid', TRUE);
            END IF;

            IF i.new_ins_cash_acc_con_id IS NULL
            THEN
                l_ins_cash_acc_con_id := l_ins_cash_acc_con_id + 1;

                INSERT
                  INTO dfn_ntp.m170_institute_cash_acc_config (
                           m170_id,
                           m170_institute_id_m02,
                           m170_currency_id_m03,
                           m170_currency_code_m03,
                           m170_cash_account_id_u06,
                           m170_status_id_v01,
                           m170_created_by_id_u17,
                           m170_created_date,
                           m170_modified_by_id_u17,
                           m170_modified_date,
                           m170_status_changed_by_id_u17,
                           m170_status_changed_date)
                VALUES (l_ins_cash_acc_con_id, -- m170_id
                        i.new_institute_id, -- m170_institute_id_m02
                        i.m03_id, -- m170_currency_id_m03
                        i.m379_currency, -- m170_currency_code_m03
                        i.new_cash_account_id, -- m170_cash_account_id_u06
                        i.map01_ntp_id, -- m170_status_id_v01
                        i.created_by, -- m170_created_by_id_u17
                        i.created_date, -- m170_created_date
                        i.modified_by, -- m170_modified_by_id_u17
                        i.modified_date, -- m170_modified_date
                        i.created_by, -- m170_status_changed_by_id_u17
                        i.created_date -- m170_status_changed_date
                                      );

                INSERT
                  INTO m170_ins_cash_acc_con_mappings (old_ins_cash_acc_con_id,
                                                       new_ins_cash_acc_con_id)
                VALUES (i.m379_id, l_ins_cash_acc_con_id);
            ELSE
                UPDATE dfn_ntp.m170_institute_cash_acc_config
                   SET m170_institute_id_m02 = i.new_institute_id, -- m170_institute_id_m02
                       m170_currency_id_m03 = i.m03_id, -- m170_currency_id_m03
                       m170_currency_code_m03 = i.m379_currency, -- m170_currency_code_m03
                       m170_cash_account_id_u06 = i.new_cash_account_id, -- m170_cash_account_id_u06
                       m170_status_id_v01 = i.map01_ntp_id, -- m170_status_id_v01
                       m170_modified_by_id_u17 = NVL (i.modified_by, 0), -- m170_modified_by_id_u17
                       m170_modified_date = NVL (i.modified_date, SYSDATE), -- m170_modified_date
                       m170_status_changed_by_id_u17 = i.created_by, -- m170_status_changed_by_id_u17
                       m170_status_changed_date = i.created_date -- m170_status_changed_date
                 WHERE m170_id = i.new_ins_cash_acc_con_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'M170_INSTITUTE_CASH_ACC_CONFIG',
                                i.m379_id,
                                CASE
                                    WHEN i.new_ins_cash_acc_con_id IS NULL
                                    THEN
                                        l_ins_cash_acc_con_id
                                    ELSE
                                        i.new_ins_cash_acc_con_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_ins_cash_acc_con_id IS NULL
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