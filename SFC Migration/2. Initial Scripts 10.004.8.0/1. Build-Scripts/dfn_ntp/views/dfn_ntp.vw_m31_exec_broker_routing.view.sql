CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_m31_exec_broker_routing
(
    m31_id,
    m31_exchange_code_m01,
    m31_exchange_id_m01,
    m31_routing_data_id_m19,
    connection_alias,
    created_by_name,
    modified_by_name,
    status_changed_by_name,
    is_active,
    v01_description,
    v01_description_lang,
    m31_status_id_v01,
    m31_type,
    type_text,
    last_session_request,
    m31_is_active,
    session_status,
    last_eod_date,
    last_preopened_date,
    connection_status,
    market_status,
    m31_fix_tag_50,
    m31_fix_tag_142,
    m31_fix_tag_57,
    m31_fix_tag_115,
    m31_fix_tag_116,
    m31_fix_tag_128,
    m31_fix_tag_22,
    m31_fix_tag_109,
    m31_fix_tag_100,
    m31_fix_tag_49,
    m31_fix_tag_56,
    m31_exec_broker_id_m26,
    m31_institute_id,
    m29_id,
    exec_broker_name,
    m29_current_mkt_status_id_v19,
    m29_manual_suspend,
    suspend_status,
    m31_board_code_m54,
    m54_id,
    m31_custom_message
)
AS
    SELECT m31.m31_id,
           m31.m31_exchange_code_m01,
           m31.m31_exchange_id_m01,
           m31.m31_routing_data_id_m19,
           m19.m19_connection_alias AS connection_alias,
           u17_created.u17_full_name AS created_by_name,
           u17_modified.u17_full_name AS modified_by_name,
           u17_status_changed.u17_full_name AS status_changed_by_name,
           CASE
               WHEN m31.m31_is_active = 1 THEN 'Yes'
               WHEN m31.m31_is_active = 0 THEN 'No'
           END
               AS is_active,
           status_list.v01_description,
           status_list.v01_description_lang,
           m31.m31_status_id_v01,
           m31.m31_type,
           CASE
               WHEN m31.m31_type = 1 THEN 'Other'
               WHEN m31.m31_type = 2 THEN 'U-Message'
           END
               AS type_text,
           m01.m01_last_market_status_req_dat AS last_session_request,
           m31.m31_is_active,
           m54.m54_exg_brd_status_id_v19 AS session_status,
           m54.m54_last_eod_date AS last_eod_date,
           m54.m54_last_preopened_date AS last_preopened_date,
           CASE
               WHEN m19.m19_connection_status = 0 THEN 'Disconnected'
               WHEN m19.m19_connection_status = 1 THEN 'Connected'
           END
               AS connection_status,
           v19.v19_status AS market_status,
           m31.m31_fix_tag_50,
           m31.m31_fix_tag_142,
           m31.m31_fix_tag_57,
           m31.m31_fix_tag_115,
           m31.m31_fix_tag_116,
           m31.m31_fix_tag_128,
           m31.m31_fix_tag_22,
           m31.m31_fix_tag_109,
           m31.m31_fix_tag_100,
           m31.m31_fix_tag_49,
           m31.m31_fix_tag_56,
           m31.m31_exec_broker_id_m26,
           m31.m31_institute_id,
           m29.m29_id AS m29_id,
           m26.m26_name AS exec_broker_name,
           m29.m29_current_mkt_status_id_v19,
           m29.m29_manual_suspend,
           CASE
               WHEN m29.m29_manual_suspend = 1 THEN 'Yes'
               WHEN m29.m29_manual_suspend = 0 THEN 'No'
           END
               AS suspend_status,
           m31.m31_board_code_m54,
           m54.m54_id,
           m31.m31_custom_message
      FROM m31_exec_broker_routing m31
           LEFT JOIN vw_status_list status_list
               ON m31.m31_status_id_v01 = status_list.v01_id
           LEFT JOIN vw_m26_exec_broker m26
               ON m31.m31_exec_broker_id_m26 = m26.m26_id
           LEFT JOIN m19_routing_data m19
               ON m31.m31_routing_data_id_m19 = m19.m19_id
           LEFT JOIN m01_exchanges m01
               ON m31.m31_exchange_id_m01 = m01.m01_id
           LEFT JOIN u17_employee u17_created
               ON m31.m31_created_by_id_u17 = u17_created.u17_id
           LEFT JOIN u17_employee u17_modified
               ON m31.m31_modified_by_id_u17 = u17_modified.u17_id
           LEFT JOIN u17_employee u17_status_changed
               ON m31.m31_status_changed_by_id_u17 =
                      u17_status_changed.u17_id
           LEFT JOIN m29_markets m29
               ON     m31.m31_exchange_id_m01 = m29.m29_exchange_id_m01
                  AND m31.m31_market_code = m29.m29_market_code
           LEFT JOIN m54_boards m54
               ON     m31.m31_board_code_m54 = m54.m54_code
                  AND m31.m31_exchange_id_m01 = m54.m54_exchange_id_m01
           LEFT JOIN v19_board_status v19
               ON m54.m54_exg_brd_status_id_v19 = v19.v19_id
/
