CREATE OR REPLACE VIEW dfn_ntp.VW_CUSTODY_CHARGES_GROUP_SLAB
(
m167_id,
m167_custody_group_id_m166,
m167_instrument_type_code_v09,
m167_from,
m167_to,
m167_per_share_charge,
m167_fixed_charge,
m167_currency_id_m03,
m167_currency_code_m03,
m167_created_by_id_u17,
m167_created_date,
m167_modified_by_id_u17,
m167_modified_date,
m167_status_id_v01,
m167_status_changed_by_id_u17,
m167_status_changed_date,
status_description,
created_by_full_name,
modified_by_full_name,
status_changed_by_full_name
)
AS
SELECT m167.m167_id,
       m167.m167_custody_group_id_m166,
       m167.m167_instrument_type_code_v09,
       m167.m167_from,
       m167.m167_to,
       m167.m167_per_share_charge,
       m167.m167_fixed_charge,
       m167.m167_currency_id_m03,
       m167.m167_currency_code_m03,
       m167_created_by_id_u17,
       m167_created_date,
       m167_modified_by_id_u17,
       m167_modified_date,
       m167_status_id_v01,
       m167_status_changed_by_id_u17,
       m167_status_changed_date,
       status_list.v01_description         AS status_description,
       u17_created_by.u17_full_name        AS created_by_full_name,
       u17_modified_by.u17_full_name       AS modified_by_full_name,
       u17_status_changed_by.u17_full_name AS status_changed_by_full_name
  FROM m167_custody_charges_slab m167
  LEFT JOIN u17_employee u17_created_by
    ON m167.m167_created_by_id_u17 = u17_created_by.u17_id
  LEFT JOIN u17_employee u17_modified_by
    ON m167.m167_modified_by_id_u17 = u17_modified_by.u17_id
  LEFT JOIN u17_employee u17_status_changed_by
    ON m167.m167_status_changed_by_id_u17 = u17_status_changed_by.u17_id
  LEFT JOIN vw_status_list status_list
    ON m167.m167_status_id_v01 = status_list.v01_id;



