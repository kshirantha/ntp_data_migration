CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_m171_bond_issue_list
(
    m171_id,
    m171_name,
    m171_otc_trad_instrument_m168,
    m171_issue_date,
    m171_maturity_date,
    m171_bond_type_v01,
    m171_nominal_value,
    m171_discount_or_premium_pct,
    m171_discount_or_premium_amnt,
    m171_principal_amount,
    m171_issue_quantity,
    m171_no_of_payments_v01,
    m171_interest_rate_type_v01,
    m171_interest_rate,
    m171_interest_day_basis_v01,
    m171_institute_id_m02,
    m171_status_id_v01,
    m171_created_by_id_u17,
    m171_created_date,
    m171_modified_by_id_u17,
    m171_modified_date,
    m171_status_changed_by_id_u17,
    m171_status_changed_date,
    m171_custom_type,
    bondtype,
    interest_rate_type,
    no_of_payment,
    interest_day_basis,
    created_by_name,
    modified_by_name,
    status_changed_by_name,
    status,
    m168_short_name,
    m168_code,
    m168_sub_asset_type_id_v08,
    m168_security_currency_id_m03,
    m03_code,
    sub_asset_type
)
AS
    SELECT a.m171_id,
           a.m171_name,
           a.m171_otc_trad_instrument_m168,
           a.m171_issue_date,
           a.m171_maturity_date,
           a.m171_bond_type_v01,
           a.m171_nominal_value,
           a.m171_discount_or_premium_pct,
           a.m171_discount_or_premium_amnt,
           a.m171_principal_amount,
           a.m171_issue_quantity,
           a.m171_no_of_payments_v01,
           a.m171_interest_rate_type_v01,
           a.m171_interest_rate,
           a.m171_interest_day_basis_v01,
           a.m171_institute_id_m02,
           a.m171_status_id_v01,
           a.m171_created_by_id_u17,
           a.m171_created_date,
           a.m171_modified_by_id_u17,
           a.m171_modified_date,
           a.m171_status_changed_by_id_u17,
           a.m171_status_changed_date,
           a.m171_custom_type,
           bondtype.v01_description AS bondtype,
           interest_rate_type.v01_description AS interest_rate_type,
           no_of_payment.v01_description AS no_of_payment,
           interest_day_basis.v01_description AS interest_day_basis,
           u17_created.u17_full_name AS created_by_name,
           u17_modified.u17_full_name AS modified_by_name,
           u17_status_changed.u17_full_name AS status_changed_by_name,
           status_list.v01_description AS status,
           m168_short_name,
           m168.m168_code,
           m168.m168_sub_asset_type_id_v08,
           m168.m168_security_currency_id_m03,
           m03.m03_code,
           sub_asset_types.v08_description AS sub_asset_type
      FROM m171_bond_issue_config a
           JOIN m168_otc_trading_instruments m168
               ON a.m171_otc_trad_instrument_m168 = m168.m168_id
           JOIN vw_status_list status_list
               ON a.m171_status_id_v01 = status_list.v01_id
           JOIN v01_system_master_data bondtype
               ON     bondtype.v01_type = 66
                  AND a.m171_bond_type_v01 = bondtype.v01_id
           JOIN v01_system_master_data interest_rate_type
               ON     interest_rate_type.v01_type = 67
                  AND a.m171_interest_rate_type_v01 =
                          interest_rate_type.v01_id
           JOIN v01_system_master_data no_of_payment
               ON     no_of_payment.v01_type = 70
                  AND a.m171_no_of_payments_v01 = no_of_payment.v01_id
           JOIN v01_system_master_data interest_day_basis
               ON     interest_day_basis.v01_type = 71
                  AND a.m171_interest_day_basis_v01 =
                          interest_day_basis.v01_id
           JOIN u17_employee u17_created
               ON a.m171_created_by_id_u17 = u17_created.u17_id
           LEFT JOIN u17_employee u17_modified
               ON a.m171_modified_by_id_u17 = u17_modified.u17_id
           LEFT JOIN u17_employee u17_status_changed
               ON a.m171_status_changed_by_id_u17 = u17_status_changed.u17_id
           LEFT JOIN v08_sub_asset_type sub_asset_types
               ON m168.m168_sub_asset_type_id_v08 = sub_asset_types.v08_id
           LEFT JOIN m03_currency m03
               ON m168.m168_security_currency_id_m03 = m03.m03_id
/