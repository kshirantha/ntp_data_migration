CREATE OR REPLACE FUNCTION dfn_ntp.fn_get_city_id_by_name (
    pm06_name                IN m06_city.m06_name%TYPE,
    pm06_country_id_m05      IN m06_city.m06_country_id_m05%TYPE,
    pm06_created_by_id_u17   IN m06_city.m06_created_by_id_u17%TYPE)
    RETURN NUMBER
IS
    l_m06_id   m06_city.m06_id%TYPE;
BEGIN
    SELECT NVL (MAX (m06_id), -1)
      INTO l_m06_id
      FROM m06_city
     WHERE     m06_country_id_m05 = pm06_country_id_m05
           AND UPPER (m06_name) = UPPER (pm06_name);

    IF l_m06_id != -1
    THEN
        RETURN l_m06_id;
    END IF;

    SELECT NVL (MAX (m06_id), -1)
      INTO l_m06_id
      FROM m06_city
     WHERE     m06_country_id_m05 = pm06_country_id_m05
           AND UPPER (m06_name_lang) = UPPER (pm06_name);

    IF l_m06_id != -1
    THEN
        RETURN l_m06_id;
    END IF;

    l_m06_id := fn_get_next_sequnce (pseq_name => 'M06_CITY');

    INSERT INTO m06_city (m06_id,
                          m06_country_id_m05,
                          m06_name,
                          m06_name_lang,
                          m06_created_by_id_u17,
                          m06_created_date,
                          m06_status_id_v01)
         VALUES (l_m06_id,                                            --m06_id
                 pm06_country_id_m05,                     --m06_country_id_m05
                 pm06_name,                                         --m06_name
                 pm06_name,                                    --m06_name_lang
                 pm06_created_by_id_u17,               --m06_created_by_id_u17
                 SYSDATE,                                   --m06_created_date
                 2                                         --m06_status_id_v01
                  );

    RETURN l_m06_id;
END;
/

