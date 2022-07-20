CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_cust_charge_discounts
(
    m164_id,
    m164_flat_discount,
    m164_discount_percentage,
    m164_status_id_v01,
    status,
    m164_created_by_id_u17,
    m164_created_date,
    m164_status_changed_by_id_u17,
    m164_status_changed_date,
    m164_modified_date,
    m164_modified_by_id_u17,
    m164_custom_type,
    m164_institute_id_m02,
    m164_discount_group_id_m165,
    m164_currency_code_m03,
    m164_currency_id_m03,
    m164_charge_code_m97,
    fee_type_description
)
AS
    SELECT m164.m164_id,
           m164.m164_flat_discount,
           m164.m164_discount_percentage,
           m164.m164_status_id_v01,
           status_list.v01_description AS status,
           m164.m164_created_by_id_u17,
           m164.m164_created_date,
           m164.m164_status_changed_by_id_u17,
           m164.m164_status_changed_date,
           m164.m164_modified_date,
           m164.m164_modified_by_id_u17,
           m164.m164_custom_type,
           m164.m164_institute_id_m02,
           m164.m164_discount_group_id_m165,
           m164.m164_currency_code_m03,
           m164.m164_currency_id_m03,
           m164.m164_charge_code_m97,
           m97.m97_description AS fee_type_description
      FROM m164_cust_charge_discounts m164,
           vw_status_list status_list,
           m97_transaction_codes m97
     WHERE     m164.m164_status_id_v01 = status_list.v01_id
           AND m164.m164_charge_code_m97 = m97.m97_code(+)
/