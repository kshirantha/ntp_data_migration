DECLARE
    l_emp_dept_id   NUMBER;
    l_sqlerrm       VARCHAR2 (4000);
BEGIN
    SELECT NVL (MAX (m12_id), 0)
      INTO l_emp_dept_id
      FROM dfn_ntp.m12_employee_department;

    DELETE FROM error_log
          WHERE mig_table = 'M12_EMPLOYEE_DEPARTMENT';

    FOR i
        IN (SELECT m02_map.new_institute_id,
                   m28.m28_id,
                   m28.m28_institution_id,
                   m28.m28_department_name,
                   NVL (m28.m28_created_by, 0) AS created_by, -- Updated Later from 999 Script
                   NVL (m28.m28_created_date, SYSDATE) AS created_date,
                   map01.map01_ntp_id,
                   m28.m28_modified_by, -- Updated Later from 999 Script
                   m28.m28_modified_date,
                   NVL (m28.m28_status_changed_by, 0) AS status_changed_by, -- Updated Later from 999 Script
                   NVL (m28.m28_status_changed_date, SYSDATE)
                       AS status_changed_date,
                   m12_map.new_emp_dep_id
              FROM mubasher_oms.m28_departments@mubasher_db_link m28,
                   map01_approval_status_v01 map01,
                   m02_institute_mappings m02_map,
                   m12_emp_dep_mappings m12_map
             WHERE     m28.m28_status_id = map01.map01_oms_id
                   AND m02_map.old_institute_id = m28.m28_institution_id
                   AND m28.m28_id = m12_map.old_emp_dep_id(+))
    LOOP
        BEGIN
            IF i.new_emp_dep_id IS NULL
            THEN
                l_emp_dept_id := l_emp_dept_id + 1;

                INSERT
                  INTO dfn_ntp.m12_employee_department (
                           m12_id,
                           m12_institute_id_m02,
                           m12_name,
                           m12_created_by_id_u17,
                           m12_created_date,
                           m12_status_id_v01,
                           m12_modified_by_id_u17,
                           m12_modified_date,
                           m12_status_changed_by_id_u17,
                           m12_status_changed_date,
                           m12_external_ref,
                           m12_code,
                           m12_name_lang,
                           m12_custom_type)
                VALUES (l_emp_dept_id, -- m12_id
                        i.new_institute_id, -- m12_institute_id_m02
                        i.m28_department_name, -- m12_name
                        i.created_by, -- m12_created_by_id_u17
                        i.created_date, -- m12_created_date
                        i.map01_ntp_id, -- m12_status_id_v01
                        i.m28_modified_by, -- m12_modified_by_id_u17
                        i.m28_modified_date, -- m12_modified_date
                        i.status_changed_by, -- m12_status_changed_by_id_u17
                        i.status_changed_date, -- m12_status_changed_date
                        i.m28_id, -- m12_external_ref
                        NULL, -- m12_code | Not Available
                        i.m28_department_name, -- m12_name_lang
                        '1' -- m12_custom_type
                           );

                INSERT INTO m12_emp_dep_mappings
                     VALUES (i.m28_id, l_emp_dept_id);
            ELSE
                UPDATE dfn_ntp.m12_employee_department
                   SET m12_institute_id_m02 = i.new_institute_id, -- m12_institute_id_m02
                       m12_name = i.m28_department_name, -- m12_name
                       m12_status_id_v01 = i.map01_ntp_id, -- m12_status_id_v01
                       m12_modified_by_id_u17 = NVL (i.m28_modified_by, 0), -- m12_modified_by_id_u17
                       m12_modified_date = NVL (i.m28_modified_date, SYSDATE), -- m12_modified_date
                       m12_status_changed_by_id_u17 = i.status_changed_by, -- m12_status_changed_by_id_u17
                       m12_status_changed_date = i.status_changed_date, -- m12_status_changed_date
                       m12_external_ref = i.m28_id, -- m12_external_ref
                       m12_name_lang = i.m28_department_name -- m12_name_lang
                 WHERE m12_id = i.new_emp_dep_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'M12_EMPLOYEE_DEPARTMENT',
                                i.m28_id,
                                CASE
                                    WHEN i.new_emp_dep_id IS NULL
                                    THEN
                                        l_emp_dept_id
                                    ELSE
                                        i.new_emp_dep_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_emp_dep_id IS NULL
                                    THEN
                                        'INSERT'
                                    ELSE
                                        'UPDATE'
                                END,
                                SYSDATE);
        END;
    END LOOP;
END;
/
