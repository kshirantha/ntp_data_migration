DECLARE
    l_stk_concentration_grp_id   NUMBER;
    l_default_exg_id             NUMBER;
    l_default_exg_code           VARCHAR2 (10);
    l_sqlerrm                    VARCHAR2 (4000);
BEGIN
    SELECT VALUE
      INTO l_default_exg_code
      FROM migration_params
     WHERE code = 'DEFAULT_EXG_CODE';

    SELECT m01.m01_id
      INTO l_default_exg_id
      FROM dfn_ntp.m01_exchanges m01
     WHERE m01.m01_exchange_code = l_default_exg_code;

    SELECT NVL (MAX (m75_id), 0)
      INTO l_stk_concentration_grp_id
      FROM dfn_ntp.m75_stock_concentration_group;

    DELETE FROM error_log
          WHERE mig_table = 'M75_STOCK_CONCENTRATION_GROUP';

    FOR i
        IN (SELECT m265.m265_stock_concentration,
                   m02_map.new_institute_id,
                   m75_map.new_stk_conc_grp_id
              FROM (SELECT DISTINCT m265_stock_concentration
                      FROM mubasher_oms.m265_margin_products@mubasher_db_link
                     WHERE m265_stock_concentration IS NOT NULL) m265,
                   m02_institute_mappings m02_map, -- [Cross Join - Repeating for each Institution]
                   m75_stk_conc_grp_mappings m75_map
             WHERE     m265.m265_stock_concentration IS NOT NULL
                   AND m265.m265_stock_concentration =
                           m75_map.global_concentration_pct(+)
                   AND m02_map.new_institute_id = m75_map.new_institute_id(+))
    LOOP
        BEGIN
            IF i.new_stk_conc_grp_id IS NULL
            THEN
                l_stk_concentration_grp_id := l_stk_concentration_grp_id + 1;

                INSERT
                  INTO dfn_ntp.m75_stock_concentration_group (
                           m75_id,
                           m75_institute_id_m02,
                           m75_type,
                           m75_description,
                           m75_additional_details,
                           m75_status_id_v01,
                           m75_exchange_id_m01,
                           m75_exchange_code_m01,
                           m75_created_by_id_u17,
                           m75_created_date,
                           m75_modified_by_id_u17,
                           m75_modified_date,
                           m75_status_changed_by_id_u17,
                           m75_status_changed_date,
                           m75_custom_type,
                           m75_global_concentration_pct)
                VALUES (l_stk_concentration_grp_id, -- m75_id
                        i.new_institute_id, -- m75_institute_id_m02
                        1, -- m75_type | 1 : Margin
                        'Grp Value : ' || i.m265_stock_concentration, -- m75_description
                        NULL, -- m75_additional_details
                        2, -- m75_status_id_v01
                        l_default_exg_id, -- m75_exchange_id_m01
                        l_default_exg_code, -- m75_exchange_code_m01
                        0, -- m75_created_by_id_u17
                        SYSDATE, -- m75_created_date
                        NULL, -- m75_modified_by_id_u17
                        NULL, -- m75_modified_date
                        0, -- m75_status_changed_by_id_u17
                        SYSDATE, -- m75_status_changed_date
                        '1', -- m75_custom_type
                        i.m265_stock_concentration -- m75_global_concentration_pct
                                                  );

                INSERT INTO m75_stk_conc_grp_mappings
                     VALUES (
                                i.m265_stock_concentration,
                                l_stk_concentration_grp_id,
                                i.new_institute_id);
            ELSE
                UPDATE dfn_ntp.m75_stock_concentration_group
                   SET m75_description =
                           'Grp Value : ' || i.m265_stock_concentration, -- m75_description
                       m75_modified_by_id_u17 = 0, -- m75_modified_by_id_u17
                       m75_modified_date = SYSDATE -- m75_modified_date
                 WHERE m75_id = i.new_stk_conc_grp_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'M75_STOCK_CONCENTRATION_GROUP',
                                'Value : ' || i.m265_stock_concentration,
                                CASE
                                    WHEN i.new_stk_conc_grp_id IS NULL
                                    THEN
                                        l_stk_concentration_grp_id
                                    ELSE
                                        i.new_stk_conc_grp_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_stk_conc_grp_id IS NULL
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
