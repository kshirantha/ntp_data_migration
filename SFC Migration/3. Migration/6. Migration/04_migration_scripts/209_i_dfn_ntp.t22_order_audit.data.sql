DECLARE
    l_ord_audit_id   NUMBER;
    l_sqlerrm        VARCHAR2 (4000);
BEGIN
    SELECT NVL (MAX (t22_id), 0)
      INTO l_ord_audit_id
      FROM dfn_ntp.t22_order_audit;

    DELETE FROM error_log
          WHERE mig_table = 'T22_ORDER_AUDIT';

    FOR i
        IN (SELECT t22_id,
                   t01_map.new_cl_order_id,
                   t01.t01_ord_no,
                   t22_date_time,
                   t22_order_status, -- [SAME IDs]
                   t22_exchange_message_id,
                   NVL (u17_performed.new_employee_id, 0)
                       AS performed_by_new_id,
                   t01.t01_tenant_code,
                   t01.t01_institution_id_m02,
                   t22_map.new_order_audit_id
              FROM mubasher_oms.t22_order_audit@mubasher_db_link t22,
                   t01_order_mappings t01_map,
                   dfn_ntp.t01_order t01,
                   u17_employee_mappings u17_performed,
                   t22_order_audit_mappings t22_map
             WHERE     t22.t22_performed_by =
                           u17_performed.old_employee_id(+)
                   AND t22.t22_t01_cl_order_id = t01_map.old_cl_order_id
                   AND t01.t01_cl_ord_id = t01_map.new_cl_order_id
                   AND t22.t22_id = t22_map.old_order_audit_id(+))
    LOOP
        BEGIN
            IF i.new_order_audit_id IS NULL
            THEN
                l_ord_audit_id := l_ord_audit_id + 1;

                INSERT INTO t22_order_audit_mappings
                     VALUES (i.t22_id, l_ord_audit_id);

                INSERT INTO dfn_ntp.t22_order_audit (t22_id,
                                                     t22_cl_ord_id_t01,
                                                     t22_ord_no_t01,
                                                     t22_date_time,
                                                     t22_status_id_v30,
                                                     t22_exchange_message_id,
                                                     t22_performed_by_id_u17,
                                                     t22_tenant_code,
                                                     t22_institution_id_m02,
                                                     t22_naration,
                                                     t22_sequence_id_t02)
                     VALUES (l_ord_audit_id, -- t22_id
                             i.new_cl_order_id, -- t22_cl_ord_id_t01
                             i.t01_ord_no, -- t22_ord_no_t01
                             i.t22_date_time, -- t22_date_time
                             i.t22_order_status, --t22_status_id_v30
                             i.t22_exchange_message_id, -- t22_exchange_message_id
                             i.performed_by_new_id, -- t22_performed_by_id_u17
                             i.t01_tenant_code, -- t22_tenant_code
                             i.t01_institution_id_m02, -- t22_institution_id_m02
                             NULL, -- t22_naration | Not Available
                             NULL -- t22_sequence_id_t02 | Not Available
                                 );
            ELSE
                UPDATE dfn_ntp.t22_order_audit
                   SET t22_cl_ord_id_t01 = i.new_cl_order_id, -- t22_cl_ord_id_t01
                       t22_ord_no_t01 = i.t01_ord_no, -- t22_ord_no_t01
                       t22_date_time = i.t22_date_time, -- t22_date_time
                       t22_status_id_v30 = i.t22_order_status, --t22_status_id_v30
                       t22_exchange_message_id = i.t22_exchange_message_id, -- t22_exchange_message_id
                       t22_performed_by_id_u17 = i.performed_by_new_id, -- t22_performed_by_id_u17
                       t22_tenant_code = i.t01_tenant_code, -- t22_tenant_code
                       t22_institution_id_m02 = i.t01_institution_id_m02 -- t22_institution_id_m02
                 WHERE t22_id = i.new_order_audit_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'T22_ORDER_AUDIT',
                                i.t22_id,
                                CASE
                                    WHEN i.new_order_audit_id IS NULL
                                    THEN
                                        l_ord_audit_id
                                    ELSE
                                        i.new_order_audit_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_order_audit_id IS NULL
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

BEGIN
    dfn_ntp.sp_stat_gather ('T22_ORDER_AUDIT');
END;
/
