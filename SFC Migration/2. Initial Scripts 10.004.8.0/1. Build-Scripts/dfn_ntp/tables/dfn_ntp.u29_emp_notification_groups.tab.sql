CREATE TABLE dfn_ntp.u29_emp_notification_groups
(
    u29_id                          NUMBER (15, 0) NOT NULL,
    u29_employee_id_u17             NUMBER (10, 0) NOT NULL,
    u29_notification_group_id_m52   NUMBER (10, 0) NOT NULL,
    u29_assigned_by_id_u17          NUMBER (10, 0) NOT NULL,
    u29_assigned_date               DATE NOT NULL,
    u29_status_id_v01               NUMBER (5, 0) NOT NULL,
    u29_status_changed_by_id_u17    NUMBER (10, 0),
    u29_status_changed_date         DATE,
    u29_custom_type                 VARCHAR2 (50 BYTE) DEFAULT 1
)
/



ALTER TABLE dfn_ntp.u29_emp_notification_groups
ADD CONSTRAINT pk_u29_id PRIMARY KEY (u29_id)
USING INDEX
/

COMMENT ON TABLE dfn_ntp.u29_emp_notification_groups IS
    'this table keeps all the notification groups assigned to an employee(u17)'
/
COMMENT ON COLUMN dfn_ntp.u29_emp_notification_groups.u29_assigned_by_id_u17 IS
    'Assigned by'
/
COMMENT ON COLUMN dfn_ntp.u29_emp_notification_groups.u29_assigned_date IS
    'Assigned Date'
/
COMMENT ON COLUMN dfn_ntp.u29_emp_notification_groups.u29_employee_id_u17 IS
    'FK from u17'
/
COMMENT ON COLUMN dfn_ntp.u29_emp_notification_groups.u29_id IS 'PK'
/
COMMENT ON COLUMN dfn_ntp.u29_emp_notification_groups.u29_notification_group_id_m52 IS
    'fk from m52'
/
COMMENT ON COLUMN dfn_ntp.u29_emp_notification_groups.u29_status_id_v01 IS
    'Approval status'
/