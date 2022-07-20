DECLARE
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

    FOR i
        IN (SELECT m126.*,
                   existing.m126_primary_institute_id AS update_institute,
                   existing.m126_rule_key AS update_key
              FROM dfn_ntp.m126_rules m126,
                   (SELECT m126_rule_key, m126_primary_institute_id
                      FROM dfn_ntp.m126_rules
                     WHERE m126_primary_institute_id = l_primary_institute_id) existing
             WHERE     m126.m126_primary_institute_id = 0
                   AND m126.m126_rule_key = existing.m126_rule_key(+))
    LOOP
        IF i.update_key IS NULL
        THEN
            INSERT INTO dfn_ntp.m126_rules
                 VALUES (i.m126_rule_type_id,
                         i.m126_rule_key,
                         i.m126_rule,
                         i.m126_passed_msg,
                         i.m126_failed_msg,
                         l_primary_institute_id);
        ELSE
            UPDATE dfn_ntp.m126_rules
               SET m126_rule_type_id = i.m126_rule_type_id,
                   m126_rule = i.m126_rule,
                   m126_passed_msg = i.m126_passed_msg,
                   m126_failed_msg = i.m126_failed_msg,
                   m126_primary_institute_id = l_primary_institute_id
             WHERE     m126_rule_key = i.update_key
                   AND m126_primary_institute_id = i.update_institute;
        END IF;
    END LOOP;
END;
/
