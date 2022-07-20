CREATE OR REPLACE FORCE VIEW dfn_ntp.t22_order_audit_all
(
    t22_id,
    t22_cl_ord_id_t01,
    t22_ord_no_t01,
    t22_date_time,
    t22_status_id_v30,
    t22_exchange_message_id,
    t22_performed_by_id_u17,
    t22_tenant_code,
    t22_institution_id_m02
)
AS
    SELECT t22_id,
           t22_cl_ord_id_t01,
           t22_ord_no_t01,
           t22_date_time,
           t22_status_id_v30,
           t22_exchange_message_id,
           t22_performed_by_id_u17,
           t22_tenant_code,
           t22_institution_id_m02
      FROM dfn_ntp.t22_order_audit
    UNION ALL
    SELECT t22_id,
           t22_cl_ord_id_t01,
           t22_ord_no_t01,
           t22_date_time,
           t22_status_id_v30,
           t22_exchange_message_id,
           t22_performed_by_id_u17,
           t22_tenant_code,
           t22_institution_id_m02
      FROM dfn_arc.t22_order_audit
/
