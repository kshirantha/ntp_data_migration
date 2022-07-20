DECLARE
    l_sukuk_coup_pmnt_id   NUMBER;
    l_sqlerrm              VARCHAR2 (4000);
BEGIN
    SELECT NVL (MAX (m1001_id), 0)
      INTO l_sukuk_coup_pmnt_id
      FROM dfn_ntp.m1001_sukuk_coupon_payment;

    DELETE FROM error_log
          WHERE mig_table = 'M1001_SUKUK_COUPON_PAYMENT';

    FOR i
        IN (SELECT m286.m286_id,
                   u06_map.new_cash_account_id AS cash_acc_id,
                   m286.m286_principal,
                   m286.m286_rate,
                   m286.m286_days_per_year,
                   m286.m286_period_days,
                   m286.m286_total_coupon,
                   u17_created_by.new_employee_id AS created_by_new_id,
                   m286.m286_created_date AS created_date,
                   u17_modified_by.new_employee_id AS modified_by_new_id,
                   m286.m286_modified_date AS modified_date,
                   NVL (u17_modified_by.new_employee_id,
                        u17_created_by.new_employee_id)
                       AS status_changed_by_new_id,
                   NVL (m286.m286_modified_date, m286.m286_created_date)
                       AS status_changed_date,
                   CASE
                       WHEN m286.m286_status_id IN (0, 1) THEN 1 -- PENDING
                       WHEN m286.m286_status_id = 2 THEN 2 -- APPROVED
                       WHEN m286.m286_status_id = 3 THEN 19 -- CANCELLED
                   END
                       AS status_id,
                   m1001_map.new_sukuk_coup_pmnt_id
              FROM mubasher_oms.m286_sukuk_coupon_payment@mubasher_db_link m286,
                   u06_cash_account_mappings u06_map,
                   u17_employee_mappings u17_created_by,
                   u17_employee_mappings u17_modified_by,
                   m1001_skuk_coup_pmnt_mappings m1001_map
             WHERE     m286.m286_debit_ac_id = u06_map.old_cash_account_id(+)
                   AND m286.m286_created_by =
                           u17_created_by.old_employee_id(+)
                   AND m286.m286_modified_by =
                           u17_modified_by.old_employee_id(+)
                   AND m286.m286_id = m1001_map.old_sukuk_coup_pmnt_id(+))
    LOOP
        BEGIN
            IF i.new_sukuk_coup_pmnt_id IS NULL
            THEN
                l_sukuk_coup_pmnt_id := l_sukuk_coup_pmnt_id + 1;

                INSERT
                  INTO dfn_ntp.m1001_sukuk_coupon_payment (
                           m1001_id,
                           m1001_cash_acc_id_u06,
                           m1001_principal,
                           m1001_rate,
                           m1001_days_per_year,
                           m1001_period_days,
                           m1001_is_manual,
                           m1001_total_coupon,
                           m1001_created_by_id_u17,
                           m1001_created_date,
                           m1001_modified_by_id_u17,
                           m1001_modified_date,
                           m1001_status_id_v01,
                           m1001_status_changed_by_id_u17,
                           m1001_status_changed_date,
                           m1001_custom_type)
                VALUES (l_sukuk_coup_pmnt_id, -- m1001_id
                        i.cash_acc_id, -- m1001_cash_acc_id_u06
                        i.m286_principal, -- m1001_principal
                        i.m286_rate, -- m1001_rate
                        i.m286_days_per_year, -- m1001_days_per_year
                        i.m286_period_days, -- m1001_period_days
                        NULL, -- m1001_is_manual | Not Available
                        i.m286_total_coupon, -- m1001_total_coupon
                        i.created_by_new_id, -- m1001_created_by_id_u17
                        i.created_date, -- m1001_created_date
                        i.modified_by_new_id, -- m1001_modified_by_id_u17
                        i.modified_date, -- m1001_modified_date
                        i.status_id, -- m1001_status_id_v01
                        i.status_changed_by_new_id, -- m1001_status_changed_by_id_u17
                        i.status_changed_date, -- m1001_status_changed_date
                        '1' -- m1001_custom_type
                           );

                INSERT
                  INTO m1001_skuk_coup_pmnt_mappings (old_sukuk_coup_pmnt_id,
                                                      new_sukuk_coup_pmnt_id)
                VALUES (i.m286_id, l_sukuk_coup_pmnt_id);
            ELSE
                UPDATE dfn_ntp.m1001_sukuk_coupon_payment
                   SET m1001_cash_acc_id_u06 = i.cash_acc_id, -- m1001_cash_acc_id_u06
                       m1001_principal = i.m286_principal, -- m1001_principal
                       m1001_rate = i.m286_rate, -- m1001_rate
                       m1001_days_per_year = i.m286_days_per_year, -- m1001_days_per_year
                       m1001_period_days = i.m286_period_days, -- m1001_period_days
                       m1001_total_coupon = i.m286_total_coupon, -- m1001_total_coupon
                       m1001_created_by_id_u17 = i.created_by_new_id, -- m1001_created_by_id_u17
                       m1001_created_date = i.created_date, -- m1001_created_date
                       m1001_modified_by_id_u17 = i.modified_by_new_id, -- m1001_modified_by_id_u17
                       m1001_modified_date = i.modified_date, -- m1001_modified_date
                       m1001_status_id_v01 = i.status_id, -- m1001_status_id_v01
                       m1001_status_changed_by_id_u17 = i.modified_by_new_id, -- m1001_status_changed_by_id_u17
                       m1001_status_changed_date = i.status_changed_date -- m1001_status_changed_date
                 WHERE m1001_id = i.new_sukuk_coup_pmnt_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'M1001_SUKUK_COUPON_PAYMENT',
                                i.m286_id,
                                CASE
                                    WHEN i.new_sukuk_coup_pmnt_id IS NULL
                                    THEN
                                        l_sukuk_coup_pmnt_id
                                    ELSE
                                        i.new_sukuk_coup_pmnt_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_sukuk_coup_pmnt_id IS NULL
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
