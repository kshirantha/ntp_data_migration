CREATE OR REPLACE FORCE VIEW dfn_ntp.a10_entity_status_history_all
(
    a10_id,
    a10_approval_entity_id,
    a10_entity_pk,
    a10_approval_status_id_v01,
    a10_status_changed_by_id_u17,
    a10_status_changed_date
)
AS
    SELECT a10_id,
           a10_approval_entity_id,
           a10_entity_pk,
           a10_approval_status_id_v01,
           a10_status_changed_by_id_u17,
           a10_status_changed_date
      FROM dfn_ntp.a10_entity_status_history
    UNION ALL
    SELECT a10_id,
           a10_approval_entity_id,
           a10_entity_pk,
           a10_approval_status_id_v01,
           a10_status_changed_by_id_u17,
           a10_status_changed_date
      FROM dfn_arc.a10_entity_status_history
/
