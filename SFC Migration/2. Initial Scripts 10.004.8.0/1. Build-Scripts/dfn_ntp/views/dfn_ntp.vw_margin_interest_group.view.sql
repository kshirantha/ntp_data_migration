CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_margin_interest_group
(
    m74_id,
    m74_description,
    m74_institution_m02,
    m74_additional_details,
    m74_add_or_sub_rate,
    m74_net_rate,
    m74_flat_fee,
    m74_currency_id_m03,
    m74_currency_code_m03,
    m74_saibor_basis_group_id_m65,
    m74_add_or_sub_to_saibor_rate,
    m74_created_by_id_u17,
    created_by_full_name,
    m74_created_date,
    m74_modified_by_id_u17,
    modified_by_full_name,
    m74_modified_date,
    m74_status_id_v01,
    status,
    m74_status_changed_by_id_u17,
    status_changed_by_full_name,
    m74_status_changed_date,
    m74_interest_basis,
    interest_basis_desc,
    m74_capitalization_frequency,
    capitalization_frequency_desc,
    m65_tax
)
AS
    SELECT m74.m74_id,
           m74.m74_description,
           m74.m74_institution_m02,
           m74.m74_additional_details,
           m74.m74_add_or_sub_rate,
           m74.m74_net_rate,
           m74.m74_flat_fee,
           m74.m74_currency_id_m03,
           m74.m74_currency_code_m03,
           m74.m74_saibor_basis_group_id_m65,
           m74.m74_add_or_sub_to_saibor_rate,
           m74.m74_created_by_id_u17,
           u17_created_by.u17_full_name AS created_by_full_name,
           m74.m74_created_date,
           m74.m74_modified_by_id_u17,
           u17_modified_by.u17_full_name AS modified_by_full_name,
           m74.m74_modified_date,
           m74.m74_status_id_v01,
           vw_status_list.v01_description AS status,
           m74.m74_status_changed_by_id_u17,
           u17_status_changed_by.u17_full_name AS status_changed_by_full_name,
           m74.m74_status_changed_date,
           m74.m74_interest_basis,
           DECODE (m74.m74_interest_basis,
                   1, 'Utilized Limit',
                   2, 'Max Limit')
               AS interest_basis_desc,
           m74.m74_capitalization_frequency,
           DECODE (m74.m74_capitalization_frequency,
                   1, 'End of Month',
                   2, 'Daily')
               AS capitalization_frequency_desc,
           m65.m65_tax
      FROM m74_margin_interest_group m74
           LEFT JOIN u17_employee u17_created_by
               ON m74.m74_created_by_id_u17 = u17_created_by.u17_id
           LEFT JOIN u17_employee u17_status_changed_by
               ON m74.m74_status_changed_by_id_u17 =
                      u17_status_changed_by.u17_id
           LEFT JOIN u17_employee u17_modified_by
               ON m74.m74_modified_by_id_u17 = u17_modified_by.u17_id
           LEFT JOIN vw_status_list
               ON m74.m74_status_id_v01 = vw_status_list.v01_id
           JOIN m65_saibor_basis_rates m65
               ON m74.m74_saibor_basis_group_id_m65 = m65.m65_id
/