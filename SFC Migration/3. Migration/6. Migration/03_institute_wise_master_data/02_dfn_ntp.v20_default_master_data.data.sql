-- Primary Institute

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

    SELECT NVL (MAX (v20_id), 0)
      INTO l_max_id
      FROM dfn_ntp.v20_default_master_data;

    FOR i
        IN (SELECT v20.*, existing.v20_id AS update_key
              FROM dfn_ntp.v20_default_master_data v20,
                   (SELECT v20_id, v20_tag
                      FROM dfn_ntp.v20_default_master_data
                     WHERE     v20_primary_institute_id_m02 =
                                   l_primary_institute_id
                           AND v20_institute_id_m02 IS NULL) existing
             WHERE     v20.v20_primary_institute_id_m02 = 0
                   AND v20.v20_institute_id_m02 IS NULL
                   AND v20.v20_tag = existing.v20_tag(+))
    LOOP
        IF i.update_key IS NULL
        THEN
            l_max_id := l_max_id + 1;

            INSERT INTO dfn_ntp.v20_default_master_data
                 VALUES (l_max_id,
                         i.v20_description,
                         i.v20_value,
                         NULL,
                         l_primary_institute_id,
                         i.v20_tag,
                         i.v20_type,
                         i.v20_is_configurable,
                         i.v20_custom_type,
                         i.v20_modified_by_id_u17);
        ELSE
            UPDATE dfn_ntp.v20_default_master_data
               SET v20_description = i.v20_description,
                   v20_value = i.v20_value,
                   v20_institute_id_m02 = NULL,
                   v20_primary_institute_id_m02 = l_primary_institute_id,
                   v20_tag = i.v20_tag,
                   v20_type = i.v20_type,
                   v20_is_configurable = i.v20_is_configurable,
                   v20_custom_type = i.v20_custom_type,
                   v20_modified_by_id_u17 = i.v20_modified_by_id_u17
             WHERE v20_id = i.update_key;
        END IF;
    END LOOP;
END;
/

-- Other Institutions

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

    SELECT NVL (MAX (v20_id), 0)
      INTO l_max_id
      FROM dfn_ntp.v20_default_master_data;

    FOR i
        IN (SELECT m02.m02_id, v20.*, existing.v20_id AS update_key
              FROM dfn_ntp.m02_institute m02,
                   dfn_ntp.v20_default_master_data v20,
                   (SELECT v20_id, v20_tag
                      FROM dfn_ntp.v20_default_master_data
                     WHERE     v20_institute_id_m02 = l_primary_institute_id
                           AND v20_primary_institute_id_m02 IS NULL) existing
             WHERE     m02.m02_primary_institute_id_m02 =
                           l_primary_institute_id
                   AND v20.v20_primary_institute_id_m02 IS NULL
                   AND v20.v20_institute_id_m02 = 0
                   AND v20.v20_tag = existing.v20_tag(+))
    LOOP
        IF i.update_key IS NULL
        THEN
            l_max_id := l_max_id + 1;

            INSERT INTO dfn_ntp.v20_default_master_data
                 VALUES (l_max_id,
                         i.v20_description,
                         i.v20_value,
                         i.m02_id,
                         NULL,
                         i.v20_tag,
                         i.v20_type,
                         i.v20_is_configurable,
                         i.v20_custom_type,
                         i.v20_modified_by_id_u17);
        ELSE
            UPDATE dfn_ntp.v20_default_master_data
               SET v20_description = i.v20_description,
                   v20_value = i.v20_value,
                   v20_institute_id_m02 = i.m02_id,
                   v20_primary_institute_id_m02 = NULL,
                   v20_tag = i.v20_tag,
                   v20_type = i.v20_type,
                   v20_is_configurable = i.v20_is_configurable,
                   v20_custom_type = i.v20_custom_type,
                   v20_modified_by_id_u17 = i.v20_modified_by_id_u17
             WHERE v20_id = i.update_key AND v20_institute_id_m02 = i.m02_id;
        END IF;
    END LOOP;
END;
/
