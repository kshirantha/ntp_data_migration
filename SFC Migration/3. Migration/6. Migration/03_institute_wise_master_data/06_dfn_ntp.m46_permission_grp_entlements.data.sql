-- User Groups Except System User's Administrator Group

DECLARE
    l_max_id   NUMBER;
BEGIN
    SELECT NVL (MAX (m46_id), 0)
      INTO l_max_id
      FROM dfn_ntp.m46_permission_grp_entlements;

    FOR i
        IN (SELECT m45.m45_id,
                   m45.m45_institute_id_m02,
                   m46_dt.*,
                   m46_existing.m46_id AS existing_group_task_id
              FROM dfn_ntp.m45_permission_groups m45,
                   (SELECT m45.m45_group_name, m46.*
                      FROM dfn_ntp.m46_permission_grp_entlements m46,
                           dfn_ntp.m45_permission_groups m45
                     WHERE     m45_group_name <> 'Administrators'
                           AND m45.m45_institute_id_m02 = 0
                           AND m46.m46_group_id_m45 = m45.m45_id) m46_dt,
                   dfn_ntp.m46_permission_grp_entlements m46_existing
             WHERE     m45.m45_group_name = m46_dt.m45_group_name
                   AND m45.m45_institute_id_m02 <> 0
                   AND m45.m45_id = m46_existing.m46_group_id_m45(+)
                   AND m46_dt.m46_task_id_v04 =
                           m46_existing.m46_task_id_v04(+))
    LOOP
        IF i.existing_group_task_id IS NULL
        THEN
            l_max_id := l_max_id + 1;

            INSERT INTO dfn_ntp.m46_permission_grp_entlements
                 VALUES (l_max_id,
                         i.m45_id,
                         i.m46_task_id_v04,
                         i.m46_added_by_id_u17,
                         i.m46_added_date,
                         i.m46_l1_by_id_u17,
                         i.m46_l1_date,
                         i.m46_l2_by_id_u17,
                         i.m46_l2_date,
                         i.m46_status_id_v01,
                         i.m46_status_changed_by_id_u17,
                         i.m46_status_changed_date,
                         i.m46_custom_type);
        ELSE
            UPDATE dfn_ntp.m46_permission_grp_entlements
               SET m46_added_by_id_u17 = i.m46_added_by_id_u17,
                   m46_added_date = i.m46_added_date,
                   m46_l1_by_id_u17 = i.m46_l1_by_id_u17,
                   m46_l1_date = i.m46_l1_date,
                   m46_l2_by_id_u17 = i.m46_l2_by_id_u17,
                   m46_l2_date = i.m46_l2_date,
                   m46_status_id_v01 = i.m46_status_id_v01,
                   m46_status_changed_by_id_u17 =
                       i.m46_status_changed_by_id_u17,
                   m46_status_changed_date = i.m46_status_changed_date
             WHERE m46_id = i.existing_group_task_id;
        END IF;
    END LOOP;
END;
/