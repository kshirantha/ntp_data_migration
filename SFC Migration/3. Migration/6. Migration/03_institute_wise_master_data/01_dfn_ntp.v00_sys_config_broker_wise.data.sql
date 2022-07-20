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

    SELECT NVL (MAX (v00_id), 0)
      INTO l_max_id
      FROM dfn_ntp.v00_sys_config_broker_wise;

    FOR i
        IN (SELECT v00.*, existing.v00_id AS update_key
              FROM dfn_ntp.v00_sys_config_broker_wise v00,
                   (SELECT v00_id, v00_key
                      FROM dfn_ntp.v00_sys_config_broker_wise
                     WHERE v00_primary_institution_id_m02 =
                               l_primary_institute_id) existing
             WHERE     v00.v00_primary_institution_id_m02 = 0
                   AND v00.v00_key = existing.v00_key(+))
    LOOP
        IF i.update_key IS NULL
        THEN
            l_max_id := l_max_id + 1;

            INSERT INTO dfn_ntp.v00_sys_config_broker_wise
                 VALUES (l_max_id,
                         i.v00_value,
                         i.v00_description,
                         i.v00_key,
                         i.v00_status_id_v01,
                         i.v00_status_changed_by_id_u17,
                         i.v00_status_changed_date,
                         i.v00_modified_by_id_u17,
                         i.v00_modified_date,
                         i.v00_type,
                         i.v00_custom_type,
                         l_primary_institute_id,
                         i.v00_is_send_to_client);
        ELSE
            UPDATE dfn_ntp.v00_sys_config_broker_wise v00
               SET v00_value = i.v00_value,
                   v00_description = i.v00_description,
                   v00_status_id_v01 = i.v00_status_id_v01,
                   v00_status_changed_by_id_u17 =
                       i.v00_status_changed_by_id_u17,
                   v00_status_changed_date = i.v00_status_changed_date,
                   v00_modified_by_id_u17 = i.v00_modified_by_id_u17,
                   v00_modified_date = i.v00_modified_date,
                   v00_type = i.v00_type,
                   v00_primary_institution_id_m02 = l_primary_institute_id,
                   v00_is_send_to_client = i.v00_is_send_to_client
             WHERE v00_id = i.update_key;
        END IF;
    END LOOP;
END;
/