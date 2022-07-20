CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_dc_id_types
(
    m15_id,
    m15_name,
    m15_name_lang,
    m15_account_frozen_type,
    m15_frozen_days,
    m15_applicable_acc_type_id_v01,
    m15_created_by_id_u17,
    m15_created_date,
    m15_status_id_v01,
    m15_modified_by_id_u17,
    m15_modified_date,
    m15_status_changed_by_id_u17,
    m15_status_changed_date,
    m15_external_ref
)
AS
    SELECT m15_id,
           m15_name,
           m15_name_lang,
           m15_account_frozen_type,
           m15_frozen_days,
           m15_applicable_acc_type_id_v01,
           m15_created_by_id_u17,
           m15_created_date,
           m15_status_id_v01,
           m15_modified_by_id_u17,
           m15_modified_date,
           m15_status_changed_by_id_u17,
           m15_status_changed_date,
           m15_external_ref
      FROM m15_identity_type;
/
