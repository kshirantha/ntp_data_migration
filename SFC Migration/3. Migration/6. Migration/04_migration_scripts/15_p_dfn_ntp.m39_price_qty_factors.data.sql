DECLARE
    l_broker_id              NUMBER;
    l_primary_institute_id   NUMBER;
    l_price_qty_factor_id    NUMBER;
    l_sqlerrm                VARCHAR2 (4000);
BEGIN
    SELECT VALUE
      INTO l_broker_id
      FROM migration_params
     WHERE code = 'BROKERAGE_ID';

    SELECT m150.m150_primary_institute_id_m02
      INTO l_primary_institute_id
      FROM dfn_ntp.m150_broker m150
     WHERE m150.m150_id = l_broker_id;

    SELECT NVL (MAX (m39_id), 0)
      INTO l_price_qty_factor_id
      FROM dfn_ntp.m39_price_qty_factors;

    DELETE FROM error_log
          WHERE mig_table = 'M39_PRICE_QTY_FACTORS';

    FOR i
        IN (SELECT m258.m258_id,
                   m258.m258_description,
                   m258.m258_type,
                   CASE
                       WHEN m258_type = 1 THEN m258_multiply_factor
                       ELSE 1
                   END
                       AS lot_size,
                   CASE
                       WHEN m258.m258_type = 0 AND m258.m258_percentage = 1
                       THEN
                           m258_multiply_factor / 100
                       WHEN m258.m258_type = 0 AND m258.m258_percentage = 0
                       THEN
                           m258_multiply_factor
                       ELSE
                           1
                   END
                       AS price_ratio,
                   NVL (u17_created.new_employee_id, 0) AS created_by,
                   NVL (m258.m258_created_date, SYSDATE) AS created_date,
                   map01.map01_ntp_id,
                   m39_map.new_price_qty_factors_id
              FROM mubasher_oms.m258_price_types@mubasher_db_link m258,
                   map01_approval_status_v01 map01,
                   u17_employee_mappings u17_created,
                   m39_price_qty_factors_mappings m39_map
             WHERE     m258.m258_status = map01.map01_oms_id
                   AND m258.m258_created_by = u17_created.old_employee_id(+)
                   AND m258.m258_id = m39_map.old_price_qty_factors_id(+))
    LOOP
        BEGIN
            IF i.new_price_qty_factors_id IS NULL
            THEN
                l_price_qty_factor_id := l_price_qty_factor_id + 1;

                INSERT
                  INTO dfn_ntp.m39_price_qty_factors (
                           m39_id,
                           m39_name,
                           m39_name_lang,
                           m39_institute_id_m02,
                           m39_price_ratio,
                           m39_lot_size,
                           m39_status_id_v01,
                           m39_created_by_id_u17,
                           m39_created_date,
                           m39_modified_by_id_u17,
                           m39_modified_date,
                           m39_status_changed_by_id_u17,
                           m39_status_changed_date,
                           m39_custom_type)
                VALUES (l_price_qty_factor_id, -- m39_id
                        i.m258_description, -- m39_name
                        i.m258_description, -- m39_name_lang
                        l_primary_institute_id, -- m39_institute_id_m02
                        i.price_ratio, -- m39_price_ratio
                        i.lot_size, -- m39_lot_size
                        i.map01_ntp_id, -- m39_status_id_v01
                        i.created_by, -- m39_created_by_id_u17
                        i.created_date, -- m39_created_date
                        NULL, -- m39_modified_by_id_u17
                        NULL, -- m39_modified_date
                        i.created_by, -- m39_status_changed_by_id_u17
                        i.created_date, -- m39_status_changed_date
                        '1' -- m39_custom_type
                           );

                INSERT
                  INTO m39_price_qty_factors_mappings (
                           old_price_qty_factors_id,
                           new_price_qty_factors_id)
                VALUES (i.m258_id, l_price_qty_factor_id);
            ELSE
                UPDATE dfn_ntp.m39_price_qty_factors
                   SET m39_name = i.m258_description, -- m39_name
                       m39_name_lang = i.m258_description, -- m39_name_lang
                       m39_price_ratio = i.price_ratio, -- m39_price_ratio
                       m39_lot_size = i.lot_size, -- m39_lot_size
                       m39_status_id_v01 = i.map01_ntp_id, -- m39_status_id_v01
                       m39_status_changed_by_id_u17 = i.created_by, -- m39_status_changed_by_id_u17
                       m39_status_changed_date = i.created_date, -- m39_status_changed_date
                       m39_modified_by_id_u17 = 0, -- m39_modified_by_id_u17
                       m39_modified_date = SYSDATE -- m39_modified_date
                 WHERE m39_id = i.new_price_qty_factors_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'M39_PRICE_QTY_FACTORS',
                                i.m258_id,
                                CASE
                                    WHEN i.new_price_qty_factors_id IS NULL
                                    THEN
                                        l_price_qty_factor_id
                                    ELSE
                                        i.new_price_qty_factors_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_price_qty_factors_id IS NULL
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