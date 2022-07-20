CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_customer_identification
(
    u05_id,
    u05_identity_type_id_m15,
    u05_customer_id_u01,
    u05_id_no,
    u05_issue_date,
    u05_issue_location_id_m14,
    u05_expiry_date,
    u05_is_default,
    u05_created_by_id_u17,
    u05_created_date,
    u05_status_id_v01,
    u05_modified_by_id_u17,
    u05_modified_date,
    u05_status_changed_by_id_u17,
    u05_status_changed_date
)
AS
    (SELECT a.u05_id,
            a.u05_identity_type_id_m15,
            a.u05_customer_id_u01,
            a.u05_id_no,
            a.u05_issue_date,
            a.u05_issue_location_id_m14,
            a.u05_expiry_date,
            a.u05_is_default,
            a.u05_created_by_id_u17,
            a.u05_created_date,
            a.u05_status_id_v01,
            a.u05_modified_by_id_u17,
            a.u05_modified_date,
            a.u05_status_changed_by_id_u17,
            a.u05_status_changed_date
       FROM u05_customer_identification a);
/
