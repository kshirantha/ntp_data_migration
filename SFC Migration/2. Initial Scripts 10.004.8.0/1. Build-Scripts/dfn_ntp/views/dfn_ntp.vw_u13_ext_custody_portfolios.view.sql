CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_u13_ext_custody_portfolios
(
    u13_id,
    u13_exchange_acc,
    u13_id_no,
    u13_exg_broker_id_m105,
    u13_customer_id_u01,
    exchange_account,
    m105_exchange_id_m01,
    exchange_code,
    u13_name,
    template_name,
    u13_modified_by_id_u17,
    u13_modified_date,
    u13_created_by_id_u17,
    u13_created_date,
    broker_name,
    broker_code,
    member_code,
    u13_status_id_v01,
    status_description,
    status_description_lang,
    u13_status_changed_by_id_u17,
    u13_status_changed_date,
    customer_no,
    external_ref,
    full_name,
    full_name_lang,
    created_by_name,
    modified_by_name,
    status_changed_by_name
)
AS
    SELECT u13.u13_id,
           u13.u13_exchange_acc,
           u13.u13_id_no,
           u13.u13_exg_broker_id_m105,
           u13.u13_customer_id_u01,
           NULL AS exchange_account,
           m105.m105_exchange_id_m01,
           m01.m01_exchange_code AS exchange_code,
           u13.u13_name,
           u13.u13_name AS template_name,
           u13.u13_modified_by_id_u17,
           u13.u13_modified_date,
           u13.u13_created_by_id_u17,
           u13.u13_created_date,
           m105.m105_broker_name AS broker_name,
           m105.m105_broker_code AS broker_code,
           m105.m105_broker_name || ' - ' || m105.m105_broker_code
               AS member_code,
           u13.u13_status_id_v01,
           status_list.v01_description AS status_description,
           status_list.v01_description_lang AS status_description_lang,
           u13.u13_status_changed_by_id_u17,
           u13.u13_status_changed_date,
           u01.u01_customer_no AS customer_no,
           u01.u01_external_ref_no AS external_ref,
           u01.u01_full_name AS full_name,
           u01.u01_full_name_lang AS full_name_lang,
           u17_created_by.u17_full_name AS created_by_name,
           u17_modified_by.u17_full_name AS modified_by_name,
           u17_status_changed_by.u17_full_name AS status_changed_by_name
      FROM u13_ext_custody_portfolios u13
           LEFT JOIN u17_employee u17_created_by
               ON u13.u13_created_by_id_u17 = u17_created_by.u17_id
           LEFT JOIN u17_employee u17_modified_by
               ON u13.u13_modified_by_id_u17 = u17_modified_by.u17_id
           LEFT JOIN u17_employee u17_status_changed_by
               ON u13.u13_status_changed_by_id_u17 =
                      u17_status_changed_by.u17_id
           LEFT JOIN vw_status_list status_list
               ON u13.u13_status_id_v01 = status_list.v01_id
           LEFT JOIN u01_customer u01
               ON u13.u13_customer_id_u01 = u01.u01_id
           LEFT JOIN m105_other_brokerages m105
               ON u13.u13_exg_broker_id_m105 = m105.m105_id
           LEFT JOIN m01_exchanges m01
               ON m105.m105_exchange_id_m01 = m01.m01_id
/
