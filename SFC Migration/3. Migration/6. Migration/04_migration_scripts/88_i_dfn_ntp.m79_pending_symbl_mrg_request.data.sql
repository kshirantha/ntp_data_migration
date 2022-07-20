DECLARE
    l_pending_symbl_mrg_req_id   NUMBER;
    l_sqlerrm                    VARCHAR2 (4000);
BEGIN
    SELECT NVL (MAX (m79_id), 0)
      INTO l_pending_symbl_mrg_req_id
      FROM dfn_ntp.m79_pending_symbl_mrg_request;

    DELETE FROM error_log
          WHERE mig_table = 'M79_PENDING_SYMBL_MRG_REQUEST';

    FOR i
        IN (SELECT m196.m196_id,
                   m77_map.new_symbol_margin_grp_id,
                   m20_map.new_symbol_id,
                   m20.m20_symbol_code,
                   m02_map.new_institute_id,
                   m196.m196_mariginability,
                   m196.m196_marginable_per,
                   map01.map01_ntp_id,
                   NVL (u17_status_changed_by.new_employee_id, 0)
                       AS status_changed_by_new_id,
                   NVL (m196_status_changed_date, SYSDATE)
                       AS status_changed_date,
                   m20.m20_exchange_code_m01,
                   m20.m20_exchange_id_m01,
                   m79_map.new_pending_sy_mg_req_id
              FROM mubasher_oms.m196_pendng_symbl_mrg_requests@mubasher_db_link m196,
                   map01_approval_status_v01 map01,
                   dfn_ntp.m20_symbol m20,
                   m77_symbol_margin_grp_mappings m77_map,
                   m20_symbol_mappings m20_map,
                   m02_institute_mappings m02_map,
                   u17_employee_mappings u17_status_changed_by,
                   m79_pending_sy_mg_req_mappings m79_map
             WHERE     m196.m196_status_id = map01.map01_oms_id
                   AND m196.m196_symbol_id = m20_map.old_symbol_id(+)
                   AND m20_map.new_symbol_id = m20.m20_id(+)
                   AND m196.m196_sym_margin_group =
                           m77_map.old_symbol_margin_grp_id(+)
                   AND m196.m196_institution = m02_map.old_institute_id
                   AND m196.m196_status_changed_by =
                           u17_status_changed_by.old_employee_id(+)
                   AND m196.m196_id = m79_map.old_pending_sy_mg_req_id(+))
    LOOP
        BEGIN
            IF i.new_symbol_id IS NULL
            THEN
                raise_application_error (-20001,
                                         'Symbol Not Available',
                                         TRUE);
            END IF;

            -- [Discussed Point by Janaka]
            /*IF i.new_symbol_margin_grp_id IS NULL
            THEN
                raise_application_error (-20001,
                                         'Symbol Margin Group Not Available',
                                         TRUE);
            END IF;*/

            IF i.new_pending_sy_mg_req_id IS NULL
            THEN
                l_pending_symbl_mrg_req_id := l_pending_symbl_mrg_req_id + 1;

                INSERT
                  INTO dfn_ntp.m79_pending_symbl_mrg_request (
                           m79_id,
                           m79_sym_margin_group,
                           m79_symbol_id_m20,
                           m79_symbol_code_m20,
                           m79_institution_m02,
                           m79_mariginability,
                           m79_marginable_per,
                           m79_status_id_v01,
                           m79_status_changed_by_id_u17,
                           m79_status_changed_date,
                           m79_exchange_code_m01,
                           m79_custom_type,
                           m79_exchange_id_m01,
                           m79_update_source)
                VALUES (l_pending_symbl_mrg_req_id, -- m79_id
                        i.new_symbol_margin_grp_id, -- m79_sym_margin_group
                        i.new_symbol_id, -- m79_symbol_id_m20
                        i.m20_symbol_code, -- m79_symbol_code_m20
                        i.new_institute_id, -- m79_institution_m02
                        i.m196_mariginability, -- m79_mariginability
                        i.m196_marginable_per, -- m79_marginable_per
                        i.map01_ntp_id, -- m79_status_id_v01
                        i.status_changed_by_new_id, -- m79_status_changed_by_id_u17
                        i.status_changed_date, -- m79_status_changed_date
                        i.m20_exchange_code_m01, -- m79_exchange_code_m01
                        '1', -- m79_custom_type
                        i.m20_exchange_id_m01, -- m79_exchange_id_m01
                        0 -- m79_update_source | Not Available
                         );

                INSERT INTO m79_pending_sy_mg_req_mappings
                     VALUES (i.m196_id, l_pending_symbl_mrg_req_id);
            ELSE
                UPDATE dfn_ntp.m79_pending_symbl_mrg_request
                   SET m79_sym_margin_group = i.new_symbol_margin_grp_id, -- m79_sym_margin_group
                       m79_symbol_id_m20 = i.new_symbol_id, -- m79_symbol_id_m20
                       m79_symbol_code_m20 = i.m20_symbol_code, -- m79_symbol_code_m20
                       m79_institution_m02 = i.new_institute_id, -- m79_institution_m02
                       m79_mariginability = i.m196_mariginability, -- m79_mariginability
                       m79_marginable_per = i.m196_marginable_per, -- m79_marginable_per
                       m79_status_id_v01 = i.map01_ntp_id, -- m79_status_id_v01
                       m79_status_changed_by_id_u17 =
                           i.status_changed_by_new_id, -- m79_status_changed_by_id_u17
                       m79_status_changed_date = i.status_changed_date, -- m79_status_changed_date
                       m79_exchange_code_m01 = i.m20_exchange_code_m01, -- m79_exchange_code_m01
                       m79_exchange_id_m01 = i.m20_exchange_id_m01 -- m79_exchange_id_m01
                 WHERE m79_id = i.new_pending_sy_mg_req_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'M79_PENDING_SYMBL_MRG_REQUEST',
                                i.m196_id,
                                CASE
                                    WHEN i.new_pending_sy_mg_req_id IS NULL
                                    THEN
                                        l_pending_symbl_mrg_req_id
                                    ELSE
                                        i.new_pending_sy_mg_req_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_pending_sy_mg_req_id IS NULL
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