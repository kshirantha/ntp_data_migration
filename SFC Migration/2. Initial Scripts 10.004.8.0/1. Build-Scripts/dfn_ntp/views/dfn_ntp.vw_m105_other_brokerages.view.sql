CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_m105_other_brokerages
(
    m105_id,
    m105_broker_code,
    m105_broker_name,
    m105_address,
    m105_exchange_id_m01,
    m105_created_by_id_u17,
    m105_created_date,
    m105_modified_by_id_u17,
    m105_modified_date,
    m105_status_id_v01,
    m105_status_changed_by_id_u17,
    m105_status_changed_date,
    m105_institute_id_m02,
    created_by,
    status_changed_by,
    modified_by,
    status,
    exchange_code
)
AS
    ( ( ( (SELECT m105.m105_id,
                  m105.m105_broker_code,
                  m105.m105_broker_name,
                  m105.m105_address,
                  m105.m105_exchange_id_m01,
                  m105.m105_created_by_id_u17,
                  m105.m105_created_date,
                  m105.m105_modified_by_id_u17,
                  m105.m105_modified_date,
                  m105.m105_status_id_v01,
                  m105.m105_status_changed_by_id_u17,
                  m105.m105_status_changed_date,
                  m105.m105_institute_id_m02,
                  u17_created_by.u17_full_name AS created_by,
                  u17_status_changed_by.u17_full_name AS status_changed_by,
                  u17_modified_by.u17_full_name AS modified_by,
                  vw_status_list.v01_description AS status,
                  m01_exchange_code.m01_exchange_code AS exchange_code
             FROM m105_other_brokerages m105
                  LEFT JOIN u17_employee u17_created_by
                      ON m105.m105_created_by_id_u17 = u17_created_by.u17_id
                  LEFT JOIN u17_employee u17_status_changed_by
                      ON m105.m105_status_changed_by_id_u17 =
                             u17_status_changed_by.u17_id
                  LEFT JOIN u17_employee u17_modified_by
                      ON m105.m105_modified_by_id_u17 =
                             u17_modified_by.u17_id
                  LEFT JOIN vw_status_list
                      ON m105.m105_status_id_v01 = vw_status_list.v01_id
                  LEFT JOIN m01_exchanges m01_exchange_code
                      ON m105.m105_exchange_id_m01 = m01_exchange_code.m01_id))));
/
