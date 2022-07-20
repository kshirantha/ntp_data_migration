DECLARE
    l_count                    NUMBER := 0;
    l_next_primary_institute   NUMBER := 0;
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM dfn_ntp.m150_broker
     WHERE m150_code = 'SFC';

    SELECT MAX (m02_id) + 1
      INTO l_next_primary_institute
      FROM dfn_ntp.m02_institute;

    IF l_count = 0
    THEN
        INSERT INTO dfn_ntp.m150_broker (m150_id,
                                         m150_description,
                                         m150_created_by_id_u17,
                                         m150_created_date,
                                         m150_modified_by_id_u17,
                                         m150_modified_date,
                                         m150_status_id_v01,
                                         m150_status_changed_by_id_u17,
                                         m150_status_changed_date,
                                         m150_code,
                                         m150_custom_type,
                                         m150_primary_institute_id_m02)
             VALUES ( (SELECT MAX (m150_id) + 1 FROM dfn_ntp.m150_broker),
                     'Saudi Franci Capital',
                     0,
                     SYSDATE,
                     NULL,
                     NULL,
                     2,
                     0,
                     SYSDATE,
                     'SFC',
                     '1',
                     l_next_primary_institute);

        INSERT INTO migration_params (code, VALUE)
             VALUES (
                        'BROKERAGE_ID',
                        (SELECT MAX (m150_id) FROM dfn_ntp.m150_broker));

        INSERT INTO migration_params (code, VALUE)
             VALUES ('BROKERAGE_NAME', 'SFC');
    END IF;
END;
/