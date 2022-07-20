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

    SELECT NVL (MAX (u53_id), 0)
      INTO l_max_id
      FROM dfn_ntp.u53_process_detail;

    FOR i
        IN (SELECT u53.*, existing.u53_id AS update_key
              FROM dfn_ntp.u53_process_detail u53,
                   (SELECT u53_id, u53_code
                      FROM dfn_ntp.u53_process_detail
                     WHERE u53_primary_institute_id_m02 =
                               l_primary_institute_id) existing
             WHERE     u53.u53_primary_institute_id_m02 = 0
                   AND u53.u53_code = existing.u53_code(+))
    LOOP
        IF i.update_key IS NULL
        THEN
            l_max_id := l_max_id + 1;

            INSERT INTO dfn_ntp.u53_process_detail
                 VALUES (l_max_id,
                         i.u53_code,
                         i.u53_description,
                         i.u53_data,
                         i.u53_position_date,
                         i.u53_compressed,
                         i.u53_status_id_v01,
                         i.u53_updated_by_id_u17,
                         i.u53_updated_date_time,
                         i.u53_failed_reason,
                         l_primary_institute_id);
        ELSE
            UPDATE dfn_ntp.u53_process_detail
               SET u53_code = i.u53_code,
                   u53_description = i.u53_description,
                   u53_data = i.u53_data,
                   u53_position_date = i.u53_position_date,
                   u53_compressed = i.u53_compressed,
                   u53_status_id_v01 = i.u53_status_id_v01,
                   u53_updated_by_id_u17 = i.u53_updated_by_id_u17,
                   u53_updated_date_time = i.u53_updated_date_time,
                   u53_failed_reason = i.u53_failed_reason,
                   u53_primary_institute_id_m02 = l_primary_institute_id
             WHERE u53_id = i.update_key;
        END IF;
    END LOOP;
END;
/