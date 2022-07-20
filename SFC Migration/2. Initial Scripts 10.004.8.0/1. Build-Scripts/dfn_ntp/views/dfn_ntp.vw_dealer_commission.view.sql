CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_dealer_commission
(
    u17_id,
    u17_full_name,
    u17_institution_id_m02,
    u17_dealer_cmsn_grp_id_m162,
    t47_exchange_id_m01,
    t47_exchange_code_m01,
    t47_txn_currency_code_m03,
    t47_settle_date,
    t47_charged_commission,
    t47_dealer_commission,
    t47_total_commission,
    commission_type,
    commission_type_lang,
    t47_commission_type_id_v01
)
AS
    SELECT u17.u17_id,
           u17.u17_full_name,
           u17.u17_institution_id_m02,
           u17.u17_dealer_cmsn_grp_id_m162,
           t47.t47_exchange_id_m01,
           t47.t47_exchange_code_m01,
           t47.t47_txn_currency_code_m03,
           t47.t47_settle_date,
           t47.t47_charged_commission,
           t47.t47_dealer_commission,
           t47.t47_total_commission,
           v01.v01_description AS commission_type,
           v01.v01_description_lang AS commission_type_lang,
           t47.t47_commission_type_id_v01
      FROM t47_dealer_commission t47
           JOIN u17_employee u17
               ON t47.t47_dealer_id_u17 = u17.u17_id
           LEFT JOIN (SELECT v01_id, v01_description, v01_description_lang
                        FROM v01_system_master_data
                       WHERE v01_type = 76) v01
               ON t47.t47_commission_type_id_v01 = v01.v01_id
/