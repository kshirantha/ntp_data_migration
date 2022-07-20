DECLARE
    l_max_id                 NUMBER;
    l_broker_id              NUMBER;
    l_primary_institute_id   NUMBER;
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
      INTO l_max_id
      FROM dfn_ntp.m39_price_qty_factors;

    FOR i
        IN (SELECT m39.*,
                   existing.m39_id AS update_key,
                   existing.m39_name update_name,
                   existing.m39_price_ratio AS update_price_ratio,
                   existing.m39_lot_size AS update_lot_size
              FROM dfn_ntp.m39_price_qty_factors m39,
                   (SELECT m39_id,
                           m39_name,
                           m39_price_ratio,
                           m39_lot_size
                      FROM dfn_ntp.m39_price_qty_factors
                     WHERE m39_institute_id_m02 = l_primary_institute_id) existing
             WHERE     m39.m39_institute_id_m02 = 0
                   AND m39.m39_name = existing.m39_name(+)
                   AND m39.m39_price_ratio = existing.m39_price_ratio(+)
                   AND m39.m39_lot_size = existing.m39_lot_size(+))
    LOOP
        IF i.update_key IS NULL
        THEN
            l_max_id := l_max_id + 1;

            INSERT INTO dfn_ntp.m39_price_qty_factors
                 VALUES (l_max_id,
                         i.m39_name,
                         i.m39_name_lang,
                         l_primary_institute_id,
                         i.m39_price_ratio,
                         i.m39_lot_size,
                         i.m39_status_id_v01,
                         i.m39_created_by_id_u17,
                         i.m39_created_date,
                         i.m39_modified_by_id_u17,
                         i.m39_modified_date,
                         i.m39_status_changed_by_id_u17,
                         i.m39_status_changed_date,
                         i.m39_custom_type);
        ELSE
            UPDATE dfn_ntp.m39_price_qty_factors
               SET m39_name = i.m39_name,
                   m39_name_lang = i.m39_name_lang,
                   m39_institute_id_m02 = l_primary_institute_id,
                   m39_price_ratio = i.m39_price_ratio,
                   m39_lot_size = i.m39_lot_size,
                   m39_status_id_v01 = i.m39_status_id_v01,
                   m39_created_by_id_u17 = i.m39_created_by_id_u17,
                   m39_created_date = i.m39_created_date,
                   m39_modified_by_id_u17 = i.m39_modified_by_id_u17,
                   m39_modified_date = i.m39_modified_date,
                   m39_status_changed_by_id_u17 =
                       i.m39_status_changed_by_id_u17,
                   m39_status_changed_date = i.m39_status_changed_date,
                   m39_custom_type = i.m39_custom_type
             WHERE m39_id = i.update_key;
        END IF;
    END LOOP;
END;
/