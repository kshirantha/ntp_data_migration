CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_m122_exchange_tick_sizes
(
    m122_id,
    m122_exchange_id_m01,
    m122_exchange_code_m01,
    m122_range_low,
    m122_range_high,
    m122_price_unit,
    m122_currency_id_m03,
    m122_currency_code_m03,
    m122_instrument_type_id_v09,
    m122_instrument_type_code_v09,
    instrument_type,
    m122_status_id_v01,
    status,
    modified_by_name,
    created_by_name,
    status_changed_by_name,
    m01_institute_id_m02
)
AS
    SELECT a.m122_id,
           a.m122_exchange_id_m01,
           a.m122_exchange_code_m01,
           a.m122_range_low,
           a.m122_range_high,
           a.m122_price_unit,
           a.m122_currency_id_m03,
           a.m122_currency_code_m03,
           a.m122_instrument_type_id_v09,
           a.m122_instrument_type_code_v09,
           v09.v09_description AS instrument_type,
           a.m122_status_id_v01,
           status.v01_description AS status,
           modifiedby.u17_full_name AS modified_by_name,
           createdby.u17_full_name AS created_by_name,
           statuschangedby.u17_full_name AS status_changed_by_name,
           m01.m01_institute_id_m02
      FROM m122_exchange_tick_sizes a,
           v09_instrument_types v09,
           u17_employee createdby,
           u17_employee modifiedby,
           u17_employee statuschangedby,
           vw_status_list status,
           m01_exchanges m01
     WHERE     a.m122_instrument_type_id_v09 = v09.v09_id
           AND a.m122_status_id_v01 = status.v01_id
           AND a.m122_created_by_id_u17 = createdby.u17_id
           AND a.m122_modified_by_id_u17 = modifiedby.u17_id(+)
           AND a.m122_status_changed_by_id_u17 = statuschangedby.u17_id
           AND a.m122_exchange_id_m01 = m01.m01_id
/