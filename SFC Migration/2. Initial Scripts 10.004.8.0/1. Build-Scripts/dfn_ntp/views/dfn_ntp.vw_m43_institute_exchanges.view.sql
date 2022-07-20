CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_m43_institute_exchanges
(
    m43_id,
    m43_custodian_id_m26,
    custodian_name,
    m43_institute_id_m02,
    m43_exchange_code_m01,
    m43_exchange_id_m01,
    m43_executing_broker_id_m26,
    executing_broker_name,
    m43_status_id_v01,
    status_description,
    status_description_lang,
    m43_created_by_id_u17,
    created_by_full_name,
    m43_created_date,
    m43_modified_by_id_u17,
    modified_by_full_name,
    m43_modified_date,
    m43_status_changed_by_id_u17,
    status_changed_by_full_name,
    m43_status_changed_date
)
AS
    SELECT m43.m43_id,
           m43.m43_custodian_id_m26,
           m26_custody.m26_name AS custodian_name,
           m43.m43_institute_id_m02,
           m43.m43_exchange_code_m01,
           m43.m43_exchange_id_m01,
           m43.m43_executing_broker_id_m26,
           m26_exec_broker.m26_sid || '-' || m26_exec_broker.m26_name
               AS executing_broker_name,
           m43.m43_status_id_v01,
           status_list.v01_description AS status_description,
           status_list.v01_description_lang AS status_description_lang,
           m43.m43_created_by_id_u17,
           u17_created_by.u17_full_name AS created_by_full_name,
           m43.m43_created_date,
           m43.m43_modified_by_id_u17,
           u17_modified_by.u17_full_name AS modified_by_full_name,
           m43.m43_modified_date,
           m43.m43_status_changed_by_id_u17,
           u17_status_changed_by.u17_full_name AS status_changed_by_full_name,
           m43.m43_status_changed_date
      FROM m43_institute_exchanges m43
           LEFT JOIN vw_m26_custody m26_custody
               ON m43.m43_custodian_id_m26 = m26_custody.m26_id
           LEFT JOIN vw_m26_exec_broker m26_exec_broker
               ON m43.m43_executing_broker_id_m26 = m26_exec_broker.m26_id
           LEFT JOIN u17_employee u17_modified_by
               ON m43.m43_modified_by_id_u17 = u17_modified_by.u17_id
           LEFT JOIN u17_employee u17_created_by
               ON m43.m43_modified_by_id_u17 = u17_created_by.u17_id
           LEFT JOIN u17_employee u17_status_changed_by
               ON m43.m43_modified_by_id_u17 = u17_status_changed_by.u17_id
           LEFT JOIN vw_status_list status_list
               ON m43.m43_status_id_v01 = status_list.v01_id
/