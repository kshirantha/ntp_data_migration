CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_m176_order_limit_group
(
    m176_id,
    m176_group_name,
    m176_buy_order_limit,
    m176_sell_order_limit,
    m176_frequency_id_v01,
    transaction_limit_frequency,
    m176_is_default,
    is_default,
    m176_status_id_v01,
    status,
    m176_created_by_id_u17,
    created_by_full_name,
    m176_created_date,
    m176_status_changed_by_id_u17,
    status_changed_by_full_name,
    m176_status_changed_date,
    m176_modified_by_id_u17,
    modified_by_full_name,
    m176_modified_date,
    m176_institute_id_m02,
    institute,
    m176_enable_category_limit,
    m176_online_buy_order_limit,
    m176_online_sell_order_limit,
    m176_offline_buy_order_limit,
    m176_offline_sell_order_limit
)
AS
    SELECT m176.m176_id,
           m176.m176_group_name,
           m176.m176_buy_order_limit,
           m176.m176_sell_order_limit,
           m176.m176_frequency_id_v01,
           CASE
               WHEN m176.m176_frequency_id_v01 = 1 THEN 'Cumulative'
               WHEN m176.m176_frequency_id_v01 = 2 THEN 'Per Transaction'
           END
               AS transaction_limit_frequency,
           m176.m176_is_default,
           CASE
               WHEN m176.m176_is_default = 0 THEN 'No'
               WHEN m176.m176_is_default = 1 THEN 'Yes'
           END
               AS is_default,
           m176.m176_status_id_v01,
           vw_status_list.v01_description AS status,
           m176.m176_created_by_id_u17,
           createdby.u17_full_name AS created_by_full_name,
           m176.m176_created_date,
           m176.m176_status_changed_by_id_u17,
           statuschangedby.u17_full_name AS status_changed_by_full_name,
           m176.m176_status_changed_date,
           m176.m176_modified_by_id_u17,
           modifiedby.u17_full_name AS modified_by_full_name,
           m176.m176_modified_date,
           m176.m176_institute_id_m02,
           institute.m02_name AS institute,
           m176.m176_enable_category_limit,
           m176.m176_online_buy_order_limit,
           m176.m176_online_sell_order_limit,
           m176.m176_offline_buy_order_limit,
           m176.m176_offline_sell_order_limit
      FROM m176_order_limit_group m176
           LEFT JOIN vw_status_list
               ON m176.m176_status_id_v01 = vw_status_list.v01_id
           LEFT JOIN u17_employee createdby
               ON m176.m176_created_by_id_u17 = createdby.u17_id
           LEFT JOIN u17_employee statuschangedby
               ON m176.m176_status_changed_by_id_u17 = statuschangedby.u17_id
           LEFT JOIN u17_employee modifiedby
               ON m176.m176_modified_by_id_u17 = modifiedby.u17_id
           LEFT JOIN m02_institute institute
               ON m176.m176_institute_id_m02 = institute.m02_id
/