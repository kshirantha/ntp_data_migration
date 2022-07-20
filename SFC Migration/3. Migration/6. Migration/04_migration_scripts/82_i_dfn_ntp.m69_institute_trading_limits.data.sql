DECLARE
    l_inst_trading_limit_id   NUMBER;
    l_sqlerrm                 VARCHAR2 (4000);
BEGIN
    SELECT NVL (MAX (m69_id), 0)
      INTO l_inst_trading_limit_id
      FROM dfn_ntp.m69_institute_trading_limits;

    DELETE FROM error_log
          WHERE mig_table = 'M69_INSTITUTE_TRADING_LIMITS';

    FOR i
        IN (SELECT m02_map.new_institute_id,
                   m109.m109_od_limit,
                   m109.m109_avail_od_limit,
                   m109.m109_margin_limit,
                   m109.m109_avail_margin_limit,
                   NVL (m109.m109_last_updated_date, SYSDATE)
                       AS last_updated_date,
                   NVL (u17_last_update.new_employee_id, 0)
                       AS new_last_updated_by_id,
                   m109.m109_mrg_call_notify_lvl,
                   m109.m109_mrg_call_remind_lvl,
                   m109.m109_mrg_call_liquid_lvl,
                   m109_institution_id,
                   m05.m05_derivative_limit,
                   m05.m05_derivative_limit_util,
                   m69.m69_id
              FROM mubasher_oms.m109_institution_trd_limits@mubasher_db_link m109,
                   mubasher_oms.m05_branches@mubasher_db_link m05,
                   m02_institute_mappings m02_map,
                   u17_employee_mappings u17_last_update,
                   dfn_ntp.m69_institute_trading_limits m69
             WHERE     m109.m109_institution_id = m02_map.old_institute_id
                   AND m109.m109_institution_id = m05.m05_branch_id
                   AND m109.m109_last_updated_by =
                           u17_last_update.old_employee_id(+)
                   AND m02_map.new_institute_id =
                           m69.m69_institution_id_m02(+))
    LOOP
        BEGIN
            IF i.m69_id IS NULL
            THEN
                l_inst_trading_limit_id := l_inst_trading_limit_id + 1;

                INSERT
                  INTO dfn_ntp.m69_institute_trading_limits (
                           m69_id,
                           m69_institution_id_m02,
                           m69_od_limit,
                           m69_avail_od_limit,
                           m69_margin_limit,
                           m69_avail_margin_limit,
                           m69_last_updated_date,
                           m69_last_updated_by_id_u17,
                           m69_custom_type,
                           m69_order_value_per_day,
                           m69_order_volume_per_day,
                           m69_default_currency_code_m03,
                           m69_default_currency_id_m03,
                           m69_derivative_limit,
                           m69_derivative_limit_utilized)
                VALUES (l_inst_trading_limit_id, -- m69_id
                        i.new_institute_id, -- m69_institution_id_m02
                        i.m109_od_limit, -- m69_od_limit
                        i.m109_avail_od_limit, -- m69_avail_od_limit
                        i.m109_margin_limit, -- m69_margin_limit
                        i.m109_avail_margin_limit, -- m69_avail_margin_limit
                        i.last_updated_date, -- m69_last_updated_date
                        i.new_last_updated_by_id, -- m69_last_updated_by_id_u17
                        '1', -- m69_custom_type
                        NULL, --  m69_order_value_per_day | Not Available
                        NULL, -- m69_order_volume_per_day | Not Available
                        NULL, -- m69_default_currency_code_m03 | Not Available
                        NULL, -- m69_default_currency_id_m03  | Not Available
                        i.m05_derivative_limit, -- m69_derivative_limit
                        i.m05_derivative_limit_util -- m69_derivative_limit_utilized
                                                   );
            ELSE
                UPDATE dfn_ntp.m69_institute_trading_limits
                   SET m69_institution_id_m02 = i.new_institute_id, -- m69_institution_id_m02
                       m69_od_limit = i.m109_od_limit, -- m69_od_limit
                       m69_avail_od_limit = i.m109_avail_od_limit, -- m69_avail_od_limit
                       m69_margin_limit = i.m109_margin_limit, -- m69_margin_limit
                       m69_avail_margin_limit = i.m109_avail_margin_limit, -- m69_avail_margin_limit
                       m69_last_updated_date = i.last_updated_date, -- m69_last_updated_date
                       m69_last_updated_by_id_u17 = i.new_last_updated_by_id, -- m69_last_updated_by_id_u17
                       m69_derivative_limit = i.m05_derivative_limit, -- m69_derivative_limit
                       m69_derivative_limit_utilized =
                           i.m05_derivative_limit_util -- m69_derivative_limit_utilized
                 WHERE m69_id = i.m69_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'M69_INSTITUTE_TRADING_LIMITS',
                                i.m109_institution_id,
                                CASE
                                    WHEN i.m69_id IS NULL
                                    THEN
                                        l_inst_trading_limit_id
                                    ELSE
                                        i.m69_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.m69_id IS NULL THEN 'INSERT'
                                    ELSE 'UPDATE'
                                END,
                                SYSDATE);
        END;
    END LOOP;
END;
/
