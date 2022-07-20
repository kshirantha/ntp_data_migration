CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_t22_order_audit_trail
(
    t22_id,
    t22_cl_ord_id_t01,
    t22_ord_no_t01,
    t22_date_time,
    t22_status_id_v30,
    t22_exchange_message_id,
    t22_performed_by_id_u17,
    t22_institution_id_m02,
    order_status_description,
    order_status_description_lang,
    performed_by
)
AS
    SELECT t22.t22_id,
           t22.t22_cl_ord_id_t01,
           t22.t22_ord_no_t01,
           t22.t22_date_time,
           t22.t22_status_id_v30,
           t22.t22_exchange_message_id,
           t22.t22_performed_by_id_u17,
           t22.t22_institution_id_m02,
           v30.v30_description AS order_status_description,
           v30.v30_description_lang AS order_status_description_lang,
           u17.u17_full_name AS performed_by
      FROM t22_order_audit t22
           JOIN v30_order_status v30
               ON t22.t22_status_id_v30 = v30.v30_status_id
           LEFT JOIN u17_employee u17
               ON t22.t22_performed_by_id_u17 = u17.u17_id;
/
