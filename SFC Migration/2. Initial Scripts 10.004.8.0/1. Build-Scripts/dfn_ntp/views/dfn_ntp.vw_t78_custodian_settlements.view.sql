CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_t78_custodian_settlements
(
    t78_id,
    t78_custodian_id_m26,
    t78_exchange_code_m01,
    t78_created_datetime,
    t78_settlement_date,
    t78_currency_code_m03,
    t78_exchange_commission,
    t78_brokerage_commission,
    t78_exchange_commission_vat,
    t78_brokerage_commission_vat,
    t78_tot_recived_from_custodian,
    receivable_from_custodian,
    pending_from_custodian,
    t78_status,
    t78_status_changed_by_id_u17,
    t78_status_changed_date,
    t78_recived_procesed_by_id_u17,
    t78_recived_processed_date,
    t78_institute_id_m02,
    t78_custom_type,
    status_changed_by,
    recived_procesed_by,
    status,
    m26_name
)
AS
    SELECT a.t78_id,
           a.t78_custodian_id_m26,
           a.t78_exchange_code_m01,
           a.t78_created_datetime,
           a.t78_settlement_date,
           a.t78_currency_code_m03,
           a.t78_exchange_commission,
           a.t78_brokerage_commission,
           a.t78_exchange_commission_vat,
           a.t78_brokerage_commission_vat,
           a.t78_tot_recived_from_custodian,
             a.t78_exchange_commission
           + a.t78_brokerage_commission
           + a.t78_exchange_commission_vat
           + a.t78_brokerage_commission_vat
               AS receivable_from_custodian,
             a.t78_exchange_commission
           + a.t78_brokerage_commission
           + a.t78_exchange_commission_vat
           + a.t78_brokerage_commission_vat
           - a.t78_tot_recived_from_custodian
               AS pending_from_custodian,
           a.t78_status,
           a.t78_status_changed_by_id_u17,
           a.t78_status_changed_date,
           a.t78_recived_procesed_by_id_u17,
           a.t78_recived_processed_date,
           a.t78_institute_id_m02,
           a.t78_custom_type,
           u17_status_changed_by.u17_full_name AS status_changed_by,
           u17.u17_full_name AS recived_procesed_by,
           vw_status_list.v01_description AS status,
           m26.m26_name
      FROM t78_custodian_wise_settlements a
           LEFT JOIN u17_employee u17_status_changed_by
               ON a.t78_status_changed_by_id_u17 =
                      u17_status_changed_by.u17_id
           LEFT JOIN u17_employee u17
               ON a.t78_recived_procesed_by_id_u17 = u17.u17_id
           LEFT JOIN vw_status_list ON a.t78_status = vw_status_list.v01_id
           LEFT JOIN m26_executing_broker m26
               ON a.t78_custodian_id_m26 = m26.m26_id
/