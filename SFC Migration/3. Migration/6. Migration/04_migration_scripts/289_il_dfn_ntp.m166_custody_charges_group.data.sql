DECLARE
    l_custody_charges_group_id   NUMBER;
    l_sqlerrm                    VARCHAR2 (4000);
BEGIN
    SELECT NVL (MAX (m166_id), 0)
      INTO l_custody_charges_group_id
      FROM dfn_ntp.m166_custody_charges_group;

    DELETE FROM error_log
          WHERE mig_table = 'M166_CUSTODY_CHARGES_GROUP';

    FOR i
        IN (SELECT m336.m336_id,
                   m336.m336_group_name,
                   m336.m336_minimum_fee,
                   m336.m336_maximum_fee,
                   CASE
                       WHEN m336.m336_period = 1 THEN 3
                       WHEN m336.m336_period = 2 THEN 4
                   END
                       AS period,
                   m336.m336_no_of_days,
                   map01.map01_ntp_id,
                   NVL (u17_status_changed.new_employee_id, 0)
                       AS status_changed_by,
                   NVL (m336.m336_status_changed_date, SYSDATE)
                       AS status_changed_date,
                   NVL (u17_created.new_employee_id, 0) AS created_by,
                   NVL (m336.m336_created_date, SYSDATE) AS created_date,
                   u17_modified.new_employee_id AS modified_by,
                   m336.m336_modified_date AS modified_date,
                   m02_map.new_institute_id,
                   m166_map.new_cstdy_chrgs_grp_id
              FROM mubasher_oms.m336_custodian_fee_groups@mubasher_db_link m336,
                   map01_approval_status_v01 map01,
                   m02_institute_mappings m02_map, -- [Cross Join - Repeating for each Institution]
                   u17_employee_mappings u17_created,
                   u17_employee_mappings u17_modified,
                   u17_employee_mappings u17_status_changed,
                   m166_cstdy_chrgs_grp_mappings m166_map
             WHERE     m336.m336_status_id = map01.map01_oms_id
                   AND m336.m336_created_by = u17_created.old_employee_id(+)
                   AND m336.m336_modified_by =
                           u17_modified.old_employee_id(+)
                   AND m336.m336_status_changed_by =
                           u17_status_changed.old_employee_id(+)
                   AND m336.m336_id = m166_map.old_cstdy_chrgs_grp_id(+)
                   AND m02_map.new_institute_id =
                           m166_map.new_institute_id(+))
    LOOP
        BEGIN
            IF i.new_cstdy_chrgs_grp_id IS NULL
            THEN
                l_custody_charges_group_id := l_custody_charges_group_id + 1;

                INSERT
                  INTO dfn_ntp.m166_custody_charges_group (
                           m166_id,
                           m166_name,
                           m166_description,
                           m166_trans_charg_freq_v01,
                           m166_holding_charg_freq_v01,
                           m166_bill_trans_charg_freq_v01,
                           m166_type_v01,
                           m166_created_by_id_u17,
                           m166_created_date,
                           m166_modified_by_id_u17,
                           m166_modified_date,
                           m166_status_id_v01,
                           m166_status_changed_by_id_u17,
                           m166_status_changed_date,
                           m166_custom_type,
                           m166_institute_id_m02)
                VALUES (l_custody_charges_group_id, -- m166_id
                        i.m336_group_name, -- m166_name
                        i.m336_group_name, -- m166_description
                        i.period, -- m166_trans_charg_freq_v01
                        i.period, -- m166_holding_charg_freq_v01
                        i.period, -- m166_bill_trans_charg_freq_v01
                        1, -- m166_type_v01 | Not Available( 1 - Custody Transactions)
                        i.created_by, -- m166_created_by_id_u17
                        i.created_date, -- m166_created_date
                        i.modified_by, -- m166_modified_by_id_u17
                        i.modified_date, -- m166_modified_date
                        i.map01_ntp_id, -- m166_status_id_v01
                        i.status_changed_by, -- m166_status_changed_by_id_u17
                        i.status_changed_date, -- m166_status_changed_date
                        '1', -- m166_custom_type
                        i.new_institute_id -- m166_institute_id_m02
                                          );

                INSERT
                  INTO m166_cstdy_chrgs_grp_mappings (
                           old_cstdy_chrgs_grp_id,
                           new_cstdy_chrgs_grp_id,
                           new_institute_id)
                VALUES (
                           i.m336_id,
                           l_custody_charges_group_id,
                           i.new_institute_id);
            ELSE
                UPDATE dfn_ntp.m166_custody_charges_group
                   SET m166_name = i.m336_group_name, -- m166_name
                       m166_description = i.m336_group_name, -- m166_description
                       m166_trans_charg_freq_v01 = i.period, -- m166_trans_charg_freq_v01
                       m166_holding_charg_freq_v01 = i.period, -- m166_holding_charg_freq_v01
                       m166_bill_trans_charg_freq_v01 = i.period, -- m166_bill_trans_charg_freq_v01
                       m166_modified_by_id_u17 = NVL (i.modified_by, 0), -- m166_modified_by_id_u17
                       m166_modified_date = NVL (i.modified_date, SYSDATE), -- m166_modified_date
                       m166_status_id_v01 = i.map01_ntp_id, -- m166_status_id_v01
                       m166_status_changed_by_id_u17 = i.status_changed_by, -- m166_status_changed_by_id_u17
                       m166_status_changed_date = i.status_changed_date -- m166_status_changed_date
                 WHERE m166_id = i.new_cstdy_chrgs_grp_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'M166_CUSTODY_CHARGES_GROUP',
                                i.m336_id,
                                CASE
                                    WHEN i.new_cstdy_chrgs_grp_id IS NULL
                                    THEN
                                        l_custody_charges_group_id
                                    ELSE
                                        i.new_cstdy_chrgs_grp_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_cstdy_chrgs_grp_id IS NULL
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

