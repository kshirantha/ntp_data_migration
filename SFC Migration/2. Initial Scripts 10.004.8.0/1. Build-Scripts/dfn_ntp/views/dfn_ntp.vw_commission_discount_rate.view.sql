CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_commission_discount_rate
(
    m25_id,
    m25_discount_group_id_m24,
    m25_channel_id_v29,
    m25_instrument_type_id_v09,
    m25_instrument_type_code_v09,
    m25_percentage,
    m25_flat_discount,
    m25_currency_id_m03,
    m25_currency_code_m03,
    m25_starting_date,
    m25_ending_date,
    m25_created_by_id_u17,
    m25_created_date,
    m25_modified_by_id_u17,
    m25_modified_date,
    m25_is_active,
    m25_from,
    m25_to,
    m25_disc_type,
    m25_frequency,
    m25_status_id_v01,
    m25_status_changed_by_id_u17,
    m25_status_changed_date,
    commission_frequency,
    is_active,
    instrument_type,
    status,
    discount_group,
	comm_type
)
AS
    SELECT m25.m25_id,
           m25.m25_discount_group_id_m24,
           m25.m25_channel_id_v29,
           m25.m25_instrument_type_id_v09,
           m25.m25_instrument_type_code_v09,
           m25.m25_percentage,
           m25.m25_flat_discount,
           m25.m25_currency_id_m03,
           m25.m25_currency_code_m03,
           m25.m25_starting_date,
           m25.m25_ending_date,
           m25.m25_created_by_id_u17,
           m25.m25_created_date,
           m25.m25_modified_by_id_u17,
           m25.m25_modified_date,
           m25.m25_is_active,
           m25.m25_from,
           m25.m25_to,
           m25.m25_disc_type,
           m25.m25_frequency,
           m25.m25_status_id_v01,
           m25.m25_status_changed_by_id_u17,
           m25.m25_status_changed_date,
           CASE m25.m25_frequency
               WHEN 1 THEN 'Realtime'
               WHEN 2 THEN 'EOD'
           END
               AS commission_frequency,
           CASE m25.m25_is_active WHEN 0 THEN 'No' WHEN 1 THEN 'Yes' END
               AS is_active,
           instrument_type.v09_description AS instrument_type,
           status_list.v01_description AS status,
           discount_group.m24_name AS discount_group,
		   m124.m124_description as comm_type
      FROM m25_commission_discount_slabs m25
           LEFT JOIN v09_instrument_types instrument_type
               ON m25.m25_instrument_type_id_v09 = instrument_type.v09_id
           LEFT JOIN m24_commission_discount_group discount_group
               ON m25.m25_discount_group_id_m24 = discount_group.m24_id
		   LEFT JOIN m124_commission_types m124
			   ON m25.m25_disc_type = m124.m124_value
           LEFT JOIN vw_status_list status_list
               ON m25.m25_status_id_v01 = status_list.v01_id;
/
