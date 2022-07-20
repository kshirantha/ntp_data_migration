CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_u50_kyc_ecdd_annual_review
(
    u50_id,
    u50_customer_id_u01,
    u50_client_visit_date,
    u50_cdd_medium,
    cdd_medium_type,
    u50_cdd_date,
    u50_next_update_due,
    u50_last_update_mub,
    u50_is_ecdd_required,
    ecdd_required,
    u50_is_ecdd_completed,
    ecdd_completed,
    u50_cac_approval_date,
    u50_ecdd_staff_updating_kyc,
    u50_ecdd_staff_ext_no,
    u50_call_time,
    u50_status_id_v01,
    u50_status_changed_by_id_u17,
    status_changed_by_name,
    u50_status_changed_date,
    u50_created_by_id_u17,
    created_by_name,
    u50_created_date,
    status,
    u50_modified_by_id_u17,
    modified_by_name,
    u50_modified_date
)
AS
    SELECT u50.u50_id,
           u50.u50_customer_id_u01,
           u50.u50_client_visit_date,
           u50.u50_cdd_medium,
           CASE u50.u50_cdd_medium
               WHEN -1 THEN 'None'
               WHEN 1 THEN 'Face-to-face'
               WHEN 2 THEN 'Online'
           END
               AS cdd_medium_type,
           u50.u50_cdd_date,
           u50.u50_next_update_due,
           u50.u50_last_update_mub,
           u50.u50_is_ecdd_required,
           CASE u50.u50_is_ecdd_required
               WHEN -1 THEN 'None'
               WHEN 1 THEN 'No'
               WHEN 2 THEN 'Yes'
           END
               AS ecdd_required,
           u50.u50_is_ecdd_completed,
           CASE u50.u50_is_ecdd_completed
               WHEN -1 THEN 'None'
               WHEN 1 THEN 'No'
               WHEN 2 THEN 'Yes'
           END
               AS ecdd_completed,
           u50.u50_cac_approval_date,
           u50.u50_ecdd_staff_updating_kyc,
           u50.u50_ecdd_staff_ext_no,
           u50.u50_call_time,
           u50.u50_status_id_v01,
           u50.u50_status_changed_by_id_u17,
           statuschangedby.u17_full_name AS status_changed_by_name,
           u50.u50_status_changed_date,
           u50.u50_created_by_id_u17,
           createdby.u17_full_name AS created_by_name,
           u50.u50_created_date,
           status.v01_description AS status,
           u50.u50_modified_by_id_u17,
           modifiedby.u17_full_name AS modified_by_name,
           u50.u50_modified_date
      FROM u50_kyc_ecdd_annual_review u50,
           vw_status_list status,
           u17_employee createdby,
           u17_employee modifiedby,
           u17_employee statuschangedby
     WHERE     u50.u50_status_id_v01 = status.v01_id
           AND u50.u50_created_by_id_u17 = createdby.u17_id
           AND u50.u50_modified_by_id_u17 = modifiedby.u17_id(+)
           AND u50.u50_status_changed_by_id_u17 = statuschangedby.u17_id
/