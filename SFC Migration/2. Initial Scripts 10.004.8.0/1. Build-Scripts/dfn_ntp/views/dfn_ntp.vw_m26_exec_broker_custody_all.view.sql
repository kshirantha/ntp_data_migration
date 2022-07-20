CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_m26_exec_broker_custody_all
(
    m26_id,
    m26_name,
    m26_pobox,
    m26_street_address_1,
    m26_street_address_2,
    m26_city_id_m06,
    m26_zip,
    m26_office_tel_1,
    m26_office_tel_2,
    m26_fax,
    m26_email,
    m26_type,
    type_,
    entity_type,
    m26_created_by_id_u17,
    created_by_full_name,
    m26_created_date,
    m26_lastupdated_by_id_u17,
    m26_lastupdated_date,
    m26_status_id_v01,
    status,
    m26_status_changed_by_id_u17,
    status_changed_by_full_name,
    m26_status_changed_date,
    m26_sid,
    m26_fix_tag_50,
    m26_fix_tag_142,
    m26_fix_tag_57,
    m26_fix_tag_115,
    m26_fix_tag_116,
    m26_fix_tag_128,
    m26_fix_tag_22,
    m26_fix_tag_109,
    m26_fix_tag_100,
    m26_country_id_m05,
    m26_institution_id_m02,
    m26_trans_chrg_grp_id_m166,
    m26_hold_chrg_grp_id_m166,
    m26_pled_in_chrg_grp_id_m166,
    m26_pled_out_chrg_grp_id_m166,
    m26_shar_tran_chrg_grp_id_m166
)
AS
    SELECT a.m26_id,
           a.m26_name,
           a.m26_pobox,
           a.m26_street_address_1,
           a.m26_street_address_2,
           a.m26_city_id_m06,
           a.m26_zip,
           a.m26_office_tel_1,
           a.m26_office_tel_2,
           a.m26_fax,
           a.m26_email,
           a.m26_type,
           CASE a.m26_type
               WHEN 1 THEN 'Broker'
               WHEN 2 THEN 'Custody'
               WHEN 3 THEN 'Broker-Custody'
           END
               AS type_,
           CASE a.m26_type
               WHEN 1 THEN 'Broker'
               WHEN 2 THEN 'Custody'
               WHEN 3 THEN 'Broker-Custody'
           END
               AS entity_type,
           a.m26_created_by_id_u17,
           u17_created_by.u17_full_name AS created_by_full_name,
           a.m26_created_date,
           a.m26_lastupdated_by_id_u17,
           a.m26_lastupdated_date,
           a.m26_status_id_v01,
           vw_status_list.v01_description AS status,
           a.m26_status_changed_by_id_u17,
           u17_status_changed_by.u17_full_name AS status_changed_by_full_name,
           a.m26_status_changed_date,
           a.m26_sid,
           a.m26_fix_tag_50,
           a.m26_fix_tag_142,
           a.m26_fix_tag_57,
           a.m26_fix_tag_115,
           a.m26_fix_tag_116,
           a.m26_fix_tag_128,
           a.m26_fix_tag_22,
           a.m26_fix_tag_109,
           a.m26_fix_tag_100,
           a.m26_country_id_m05,
           a.m26_institution_id_m02,
           a.m26_trans_chrg_grp_id_m166,
           a.m26_hold_chrg_grp_id_m166,
           a.m26_pled_in_chrg_grp_id_m166,
           a.m26_pled_out_chrg_grp_id_m166,
           a.m26_shar_tran_chrg_grp_id_m166
      FROM m26_executing_broker a
           LEFT JOIN u17_employee u17_created_by
               ON a.m26_created_by_id_u17 = u17_created_by.u17_id
           LEFT JOIN u17_employee u17_status_changed_by
               ON a.m26_status_changed_by_id_u17 =
                      u17_status_changed_by.u17_id
           LEFT JOIN vw_status_list
               ON a.m26_status_id_v01 = vw_status_list.v01_id
/
