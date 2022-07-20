CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_commission_structures
(
    m23_id,
    m23_commission_type,
    m23_created_by_id_u17,
    m23_created_date,
    m23_modified_by_id_u17,
    m23_modified_date,
    m23_status_id_v01,
    m23_status_changed_by_id_u17,
    m23_min_commission,
    m23_currency_id_m03,
    m23_instrument_type_v09,
    m23_instrument_type_id_v09,
    m23_commission_group_id_m22,
    comm_type,
    m23_vat_percentage,
    m23_vat_charge_type_m124,
    instrument_type,
    m23_currency_code_m03,
    status,
    m23_from,
    m23_to,
    m23_percentage,
    m23_flat_commission,
    vat_charge_type
)
AS
    ( ( (SELECT a.m23_id,
                a.m23_commission_type,
                a.m23_created_by_id_u17,
                a.m23_created_date,
                a.m23_modified_by_id_u17,
                a.m23_modified_date,
                a.m23_status_id_v01,
                a.m23_status_changed_by_id_u17,
                a.m23_min_commission,
                a.m23_currency_id_m03,
                a.m23_instrument_type_v09,
                a.m23_instrument_type_id_v09,
                a.m23_commission_group_id_m22,
                com.m124_description AS comm_type,
                a.m23_vat_percentage,
                a.m23_vat_charge_type_m124,
                instrument_type.v09_description AS instrument_type,
                a.m23_currency_code_m03,
                status_list.v01_description AS status,
                a.m23_from,
                a.m23_to,
                a.m23_percentage,
                a.m23_flat_commission,
                vat.m124_description AS vat_charge_type
           FROM m23_commission_slabs a
                LEFT JOIN v09_instrument_types instrument_type
                    ON a.m23_instrument_type_v09 = instrument_type.v09_code
                LEFT JOIN vw_status_list status_list
                    ON a.m23_status_id_v01 = status_list.v01_id
                LEFT JOIN m124_commission_types vat
                    ON a.m23_vat_charge_type_m124 = vat.m124_value
                LEFT JOIN m124_commission_types com
                    ON a.m23_commission_type = com.m124_value)));
/
