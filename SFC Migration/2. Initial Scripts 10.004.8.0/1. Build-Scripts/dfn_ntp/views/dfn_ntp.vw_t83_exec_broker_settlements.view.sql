CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_t83_exec_broker_settlements
(
    t83_id,
    t83_exec_broker_id_m26,
    t83_created_datetime,
    t83_settlement_date,
    t83_currency_code_m03,
    t83_order_value,
    t83_exchange_commission,
    t83_brokerage_commission,
    t83_exchange_commission_vat,
    t83_brokerage_commission_vat,
    t83_tot_recived_from_exec_brok,
    receivable_from_exec_broker,
    pending_from_exec_broker,
    t83_status_id_v01,
    t83_status_changed_by_id_u17,
    t83_status_changed_date,
    t83_recived_procesed_by_id_u17,
    t83_recived_processed_date,
    t83_institute_id_m02,
    t83_custom_type,
    status_changed_by,
    recived_procesed_by,
    status,
    m26_name
)
AS
    SELECT a.t83_id,
           a.t83_exec_broker_id_m26,
           a.t83_created_datetime,
           a.t83_settlement_date,
           a.t83_currency_code_m03,
           a.t83_order_value,
           a.t83_exchange_commission,
           a.t83_brokerage_commission,
           a.t83_exchange_commission_vat,
           a.t83_brokerage_commission_vat,
           a.t83_tot_recived_from_exec_brok,
             a.t83_exchange_commission
           + a.t83_brokerage_commission
           + a.t83_exchange_commission_vat
           + a.t83_brokerage_commission_vat
               AS receivable_from_exec_broker,
             a.t83_exchange_commission
           + a.t83_brokerage_commission
           + a.t83_exchange_commission_vat
           + a.t83_brokerage_commission_vat
           - a.t83_tot_recived_from_exec_brok
               AS pending_from_exec_broker,
           a.t83_status_id_v01,
           a.t83_status_changed_by_id_u17,
           a.t83_status_changed_date,
           a.t83_recived_procesed_by_id_u17,
           a.t83_recived_processed_date,
           a.t83_institute_id_m02,
           a.t83_custom_type,
           u17_status_changed_by.u17_full_name AS status_changed_by,
           u17.u17_full_name AS recived_procesed_by,
           vw_status_list.v01_description AS status,
           m26.m26_name
      FROM t83_exec_broker_wise_settlmnt a
           LEFT JOIN u17_employee u17_status_changed_by
               ON a.t83_status_changed_by_id_u17 =
                      u17_status_changed_by.u17_id
           LEFT JOIN u17_employee u17
               ON a.t83_recived_procesed_by_id_u17 = u17.u17_id
           LEFT JOIN vw_status_list
               ON a.t83_status_id_v01 = vw_status_list.v01_id
           LEFT JOIN m26_executing_broker m26
               ON a.t83_exec_broker_id_m26 = m26.m26_id
/
