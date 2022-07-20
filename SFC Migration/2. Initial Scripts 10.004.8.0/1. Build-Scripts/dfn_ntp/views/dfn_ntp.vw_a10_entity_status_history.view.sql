CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_a10_entity_status_history
(
    a10_id,
    a10_approval_entity_id,
    a10_entity_pk,
    a10_approval_status_id_v01,
    a10_status_changed_by_id_u17,
    a10_status_changed_date,
    status_changed_by_full_name,
    status_description
)
AS
    SELECT a10_id,
           a10_approval_entity_id,
           a10_entity_pk,
           a10_approval_status_id_v01,
           a10_status_changed_by_id_u17,
           a10_status_changed_date,
           u17.u17_full_name AS status_changed_by_full_name,
           status_list.v01_description AS status_description
      FROM a10_entity_status_history_all a10
           LEFT JOIN u17_employee u17
               ON a10.a10_status_changed_by_id_u17 = u17.u17_id
           LEFT JOIN vw_status_list status_list
               ON a10.a10_approval_status_id_v01 = status_list.v01_id
/
