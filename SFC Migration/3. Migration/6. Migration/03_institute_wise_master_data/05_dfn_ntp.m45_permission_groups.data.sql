-- User Groups Except System User's Administrator Group

DECLARE
    l_max_id                 NUMBER;
    l_latest_broker_id       NUMBER;
    l_primary_institute_id   NUMBER;
BEGIN
    SELECT MAX (m150.m150_id)
      INTO l_latest_broker_id
      FROM dfn_ntp.m150_broker m150;

    SELECT m150.m150_primary_institute_id_m02
      INTO l_primary_institute_id
      FROM dfn_ntp.m150_broker m150
     WHERE m150.m150_id = l_latest_broker_id;

    SELECT NVL (MAX (m45_id), 0)
      INTO l_max_id
      FROM dfn_ntp.m45_permission_groups;

    FOR i
        IN (  SELECT m02.m02_id,
                     m02.m02_code,
                     m45.*,
                     m45_existing.m45_id AS existing_group_id
                FROM dfn_ntp.m02_institute m02,
                     dfn_ntp.m45_permission_groups m45,
                     dfn_ntp.m45_permission_groups m45_existing
               WHERE     m02.m02_primary_institute_id_m02 =
                             l_primary_institute_id
                     AND m45.m45_institute_id_m02 = 0
                     AND m45.m45_group_name <> 'Administrators'
                     AND m02.m02_id = m45_existing.m45_institute_id_m02(+)
                     AND m45.m45_group_name = m45_existing.m45_group_name(+)
            ORDER BY m02.m02_id, m45.m45_id)
    LOOP
        IF i.existing_group_id IS NULL
        THEN
            l_max_id := l_max_id + 1;

            INSERT INTO dfn_ntp.m45_permission_groups
                 VALUES (l_max_id,
                         i.m45_group_name,
                         i.m45_group_enabled,
                         i.m45_created_date,
                         i.m45_created_by_id_u17,
                         i.m02_id,
                         i.m45_modified_by_id_u17,
                         i.m45_modified_date,
                         i.m45_status_id_v01,
                         i.m45_status_changed_by_id_u17,
                         i.m45_status_changed_date,
                         i.m45_editable,
                         i.m45_is_root_inst_only,
                         i.m45_custom_type);
        ELSE
            UPDATE dfn_ntp.m45_permission_groups
               SET m45_group_enabled = i.m45_group_enabled,
                   m45_created_date = i.m45_created_date,
                   m45_created_by_id_u17 = i.m45_created_by_id_u17,
                   m45_modified_by_id_u17 = i.m45_modified_by_id_u17,
                   m45_modified_date = i.m45_modified_date,
                   m45_status_id_v01 = i.m45_status_id_v01,
                   m45_status_changed_by_id_u17 =
                       i.m45_status_changed_by_id_u17,
                   m45_status_changed_date = i.m45_status_changed_date,
                   m45_editable = i.m45_editable,
                   m45_is_root_inst_only = i.m45_is_root_inst_only
             WHERE m45_id = i.existing_group_id;
        END IF;
    END LOOP;
END;
/