-- INSTITUTIONS ============================================================================================================

MERGE INTO dfn_ntp.m02_institute m02
     USING (SELECT m02.m02_id,
                   NVL (u17_created.new_employee_id, 0) AS created_by_new_id,
                   NVL (u17_approved.new_employee_id, 0)
                       AS approved_by_new_id
              FROM dfn_ntp.m02_institute m02,
                   u17_employee_mappings u17_created,
                   u17_employee_mappings u17_approved
             WHERE     m02.m02_id > 0
                   AND m02.m02_created_by_id_u17 =
                           u17_created.old_employee_id(+)
                   AND m02.m02_approved_by_id_u17 =
                           u17_approved.old_employee_id(+)) action_by
        ON (m02.m02_id = action_by.m02_id)
WHEN MATCHED
THEN
    UPDATE SET
        m02.m02_created_by_id_u17 = action_by.created_by_new_id,
        m02.m02_approved_by_id_u17 = action_by.approved_by_new_id;

COMMIT;

-- EMPLOYEE DEPARTMENTS =====================================================================================================

MERGE INTO dfn_ntp.m12_employee_department m12
     USING (SELECT m12.m12_id,
                   NVL (u17_created.new_employee_id, 0) AS created_by_new_id,
                   NVL (u17_modified.new_employee_id, 0) AS modifed_by_new_id,
                   NVL (u17_status_changed.new_employee_id, 0)
                       AS status_changed_by_new_id
              FROM dfn_ntp.m12_employee_department m12,
                   u17_employee_mappings u17_created,
                   u17_employee_mappings u17_modified,
                   u17_employee_mappings u17_status_changed
             WHERE     m12.m12_id > 0
                   AND m12.m12_created_by_id_u17 =
                           u17_created.old_employee_id(+)
                   AND m12.m12_modified_by_id_u17 =
                           u17_modified.old_employee_id(+)
                   AND m12.m12_status_changed_by_id_u17 =
                           u17_status_changed.old_employee_id(+)) action_by
        ON (m12.m12_id = action_by.m12_id)
WHEN MATCHED
THEN
    UPDATE SET
        m12.m12_created_by_id_u17 = action_by.created_by_new_id,
        m12.m12_modified_by_id_u17 = action_by.modifed_by_new_id,
        m12.m12_status_changed_by_id_u17 = action_by.status_changed_by_new_id;

COMMIT;

-- EMPLOYEES ================================================================================================================

MERGE INTO dfn_ntp.u17_employee u17
     USING (SELECT u17.u17_id,
                   NVL (u17_created.new_employee_id, 0) AS created_by_new_id,
                   NVL (u17_modified.new_employee_id, 0) AS modifed_by_new_id,
                   NVL (u17_status_changed.new_employee_id, 0)
                       AS status_changed_by_new_id
              FROM dfn_ntp.u17_employee u17,
                   u17_employee_mappings u17_created,
                   u17_employee_mappings u17_modified,
                   u17_employee_mappings u17_status_changed
             WHERE     u17.u17_id > 0
                   AND u17.u17_created_by_id_u17 =
                           u17_created.old_employee_id(+)
                   AND u17.u17_modified_by_id_u17 =
                           u17_modified.old_employee_id(+)
                   AND u17.u17_status_changed_by_u17 =
                           u17_status_changed.old_employee_id(+)) action_by
        ON (u17.u17_id = action_by.u17_id)
WHEN MATCHED
THEN
    UPDATE SET
        u17.u17_created_by_id_u17 = action_by.created_by_new_id,
        u17.u17_modified_by_id_u17 = action_by.modifed_by_new_id,
        u17.u17_status_changed_by_u17 = action_by.status_changed_by_new_id;

COMMIT;