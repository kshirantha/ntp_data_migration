DECLARE
    l_emp_trd_limit_id   NUMBER;
    l_sqlerrm            VARCHAR2 (4000);
BEGIN
    SELECT NVL (MAX (m50_id), 0)
      INTO l_emp_trd_limit_id
      FROM dfn_ntp.m50_employee_trd_limits;

    DELETE FROM error_log
          WHERE mig_table = 'M50_EMPLOYEE_TRD_LIMITS';

    FOR i
        IN (SELECT u17_map.new_employee_id,
                   m108.m108_od_limit,
                   m108.m108_deault_currency,
                   NVL (u17_last_updated.new_employee_id, 0)
                       AS last_updated_by_new_id,
                   NVL (m108.m108_last_updated_date, SYSDATE)
                       AS last_updated_date,
                   m108.m108_max_order_value,
                   m108.m108_price_tolerence,
                   m03.m03_id,
                   m108.m108_employee_id,
                   m50.m50_id,
                   m06.m06_approvable_order_limit,
                   m06.m06_approvable_overdraw_limit
              FROM mubasher_oms.m108_employee_trd_limits@mubasher_db_link m108
                   JOIN mubasher_oms.m06_employees@mubasher_db_link m06
                       ON m108.m108_employee_id = m06.m06_id
                   JOIN u17_employee_mappings u17_map
                       ON m108.m108_employee_id = u17_map.old_employee_id
                   LEFT JOIN dfn_ntp.m03_currency m03
                       ON m108.m108_deault_currency = m03.m03_code
                   LEFT JOIN u17_employee_mappings u17_last_updated
                       ON m108.m108_last_updated_by =
                              u17_last_updated.old_employee_id
                   LEFT JOIN dfn_ntp.m50_employee_trd_limits m50
                       ON u17_map.new_employee_id = m50.m50_employee_id_u17)
    LOOP
        BEGIN
            IF i.m50_id IS NULL
            THEN
                l_emp_trd_limit_id := l_emp_trd_limit_id + 1;

                INSERT
                  INTO dfn_ntp.m50_employee_trd_limits (
                           m50_employee_id_u17,
                           m50_approvable_order_limit,
                           m50_approvable_overdraw_limit,
                           m50_bp_exceed_limit,
                           m50_breach_coverage_ratio,
                           m50_default_currency_code_m03,
                           m50_last_updated_by_id_u17,
                           m50_last_updated_date,
                           m50_max_order_value,
                           m50_price_tolerence,
                           m50_default_currency_id_m03,
                           m50_status_id_v01,
                           m50_status_changed_by_id_u17,
                           m50_status_changed_date,
                           m50_custom_type,
                           m50_id,
                           m50_order_value_per_day,
                           m50_order_volume_per_day)
                VALUES (i.new_employee_id, -- m50_employee_id_u17
                        i.m06_approvable_order_limit, -- m50_approvable_order_limit
                        i.m06_approvable_overdraw_limit, -- m50_approvable_overdraw_limit
                        0, -- m50_bp_exceed_limit | Not Available
                        NULL, -- m50_breach_coverage_ratio | Not Available
                        i.m108_deault_currency, -- m50_default_currency_code_m03
                        i.last_updated_by_new_id, -- m50_last_updated_by_id_u17
                        i.last_updated_date, -- m50_last_updated_date
                        i.m108_max_order_value, -- m50_max_order_value
                        i.m108_price_tolerence, -- m50_price_tolerence
                        i.m03_id, -- m50_default_currency_id_m03
                        2, -- m50_status_id_v01
                        i.last_updated_by_new_id, -- m50_status_changed_by_id_u17
                        SYSDATE, -- m50_status_changed_date
                        '1', -- m50_custom_type
                        l_emp_trd_limit_id, -- m50_id
                        NULL, --m50_order_value_per_day | Not Available
                        NULL -- m50_order_volume_per_day | Not Available
                            );
            ELSE
                UPDATE dfn_ntp.m50_employee_trd_limits
                   SET m50_approvable_order_limit =
                           i.m06_approvable_order_limit, -- m50_approvable_order_limit
                       m50_approvable_overdraw_limit =
                           i.m06_approvable_overdraw_limit, -- m50_approvable_overdraw_limit
                       m50_default_currency_code_m03 = i.m108_deault_currency, -- m50_default_currency_code_m03
                       m50_last_updated_by_id_u17 = i.last_updated_by_new_id, -- m50_last_updated_by_id_u17
                       m50_last_updated_date = i.last_updated_date, -- m50_last_updated_date
                       m50_max_order_value = i.m108_max_order_value, -- m50_max_order_value
                       m50_price_tolerence = i.m108_price_tolerence, -- m50_price_tolerence
                       m50_default_currency_id_m03 = i.m03_id, -- m50_default_currency_id_m03
                       m50_status_changed_by_id_u17 = i.last_updated_by_new_id -- m50_status_changed_by_id_u17
                 WHERE m50_id = i.m50_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'M50_EMPLOYEE_TRD_LIMITS',
                                i.m108_employee_id,
                                CASE
                                    WHEN i.new_employee_id IS NULL
                                    THEN
                                        l_emp_trd_limit_id
                                    ELSE
                                        i.new_employee_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_employee_id IS NULL
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
