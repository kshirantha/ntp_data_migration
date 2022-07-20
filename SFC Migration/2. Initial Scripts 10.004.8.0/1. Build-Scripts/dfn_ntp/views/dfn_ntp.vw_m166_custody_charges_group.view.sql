CREATE OR REPLACE VIEW dfn_ntp.VW_M166_CUSTODY_CHARGES_GROUP 
(
       m166_id,
       m166_name,
       m166_description,
       m166_trans_charg_freq_v01,
       trans_charge_freq,
       m166_holding_charg_freq_v01,
       holding_charge_freq,
       m166_bill_trans_charg_freq_v01,
       bill_trans_charge_freq,
       m166_type_v01,
       m166_type,
       m166_institute_id_m02,
       m166_created_by_id_u17,
       m166_created_date,
       m166_modified_by_id_u17,
       m166_modified_date,
       m166_status_id_v01,
       m166_status_changed_by_id_u17,
       m166_status_changed_date,
       status_description,
       created_by_full_name,
       modified_by_full_name,
       status_changed_by_full_name
)
AS
SELECT m166_id,
       m166_name,
       m166_description,
       m166_trans_charg_freq_v01,
       transchargfreqv01.v01_description     AS trans_charge_freq,
       m166.m166_holding_charg_freq_v01,
       holdingchargfreqv01.v01_description   AS holding_charge_freq,
       m166_bill_trans_charg_freq_v01,
       billtranschargfreqv01.v01_description AS bill_trans_charge_freq,
       m166_type_v01,
       billtransactivityv01.v01_description  AS m166_type,
       m166.m166_institute_id_m02,
       m166_created_by_id_u17,
       m166_created_date,
       m166_modified_by_id_u17,
       m166_modified_date,
       m166_status_id_v01,
       m166_status_changed_by_id_u17,
       m166_status_changed_date,
       status_list.v01_description           AS status_description,
       u17_created_by.u17_full_name          AS created_by_full_name,
       u17_modified_by.u17_full_name         AS modified_by_full_name,
       u17_status_changed_by.u17_full_name   AS status_changed_by_full_name
  FROM m166_custody_charges_group m166
  LEFT JOIN u17_employee u17_created_by
    ON m166.m166_created_by_id_u17 = u17_created_by.u17_id
  LEFT JOIN u17_employee u17_modified_by
    ON m166.m166_modified_by_id_u17 = u17_modified_by.u17_id
  LEFT JOIN u17_employee u17_status_changed_by
    ON m166.m166_status_changed_by_id_u17 = u17_status_changed_by.u17_id
  LEFT JOIN vw_status_list status_list
    ON m166.m166_status_id_v01 = status_list.v01_id
  LEFT JOIN v01_system_master_data transchargfreqv01
    ON ( transchargfreqv01.v01_id = m166.m166_trans_charg_freq_v01 and transchargfreqv01.v01_type = 64 )
  LEFT JOIN v01_system_master_data holdingchargfreqv01
    ON ( holdingchargfreqv01.v01_id = m166.m166_holding_charg_freq_v01 and holdingchargfreqv01.v01_type = 64 )
  LEFT JOIN v01_system_master_data billtranschargfreqv01
    ON ( billtranschargfreqv01.v01_id = m166.m166_bill_trans_charg_freq_v01 and billtranschargfreqv01.v01_type = 64 )
  LEFT JOIN v01_system_master_data billtransactivityv01
    ON ( billtransactivityv01.v01_id = m166.m166_type_v01 and billtransactivityv01.v01_type = 63 )
/