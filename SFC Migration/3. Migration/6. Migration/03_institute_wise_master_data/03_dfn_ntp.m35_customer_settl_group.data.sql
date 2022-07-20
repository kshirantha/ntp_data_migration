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

    SELECT NVL (MAX (m35_id), 0)
      INTO l_max_id
      FROM dfn_ntp.m35_customer_settl_group;

    FOR i
        IN (SELECT m02.m02_id, m35.*, existing.m35_id AS update_key
              FROM dfn_ntp.m02_institute m02,
                   dfn_ntp.m35_customer_settl_group m35,
                   (SELECT m35_id, m35_institute_id_m02
                      FROM dfn_ntp.m35_customer_settl_group
                     WHERE m35_institute_id_m02 > 0) existing
             WHERE     m02.m02_primary_institute_id_m02 =
                           l_primary_institute_id
                   AND m35.m35_institute_id_m02 = 0
                   AND m02.m02_id = existing.m35_institute_id_m02(+))
    LOOP
        IF i.update_key IS NULL
        THEN
            l_max_id := l_max_id + 1;

            INSERT INTO dfn_ntp.m35_customer_settl_group
                 VALUES (l_max_id,
                         i.m35_description,
                         i.m35_description_lang,
                         i.m35_status_id_v01,
                         i.m35_created_by_id_u17,
                         i.m35_created_date,
                         i.m35_modified_by_id_u17,
                         i.m35_modified_date,
                         i.m35_status_changed_by_id_u17,
                         i.m35_additional_details,
                         i.m35_status_changed_date,
                         i.m35_custom_type,
                         i.m02_id,
                         i.m35_is_default);
        ELSE
            UPDATE dfn_ntp.m35_customer_settl_group
               SET m35_description = i.m35_description,
                   m35_description_lang = i.m35_description_lang,
                   m35_status_id_v01 = i.m35_status_id_v01,
                   m35_created_by_id_u17 = i.m35_created_by_id_u17,
                   m35_created_date = i.m35_created_date,
                   m35_modified_by_id_u17 = i.m35_modified_by_id_u17,
                   m35_modified_date = i.m35_modified_date,
                   m35_status_changed_by_id_u17 =
                       i.m35_status_changed_by_id_u17,
                   m35_additional_details = i.m35_additional_details,
                   m35_status_changed_date = i.m35_status_changed_date,
                   m35_custom_type = i.m35_custom_type,
                   m35_institute_id_m02 = i.m02_id,
                   m35_is_default = i.m35_is_default
             WHERE m35_id = i.update_key;
        END IF;
    END LOOP;
END;
/