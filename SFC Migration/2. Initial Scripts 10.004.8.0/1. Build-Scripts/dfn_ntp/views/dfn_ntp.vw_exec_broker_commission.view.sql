CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_exec_broker_commission
(
	m34_start,
	m34_end,
	m34_percent,
	m34_flat_comm,
	m34_min_comm,
	m34_exec_broker_id_m26,
	m34_exchange_code_m01,
	m34_exchange_id_m01,
	m34_instrument_type,
	m34_instrument_type_id_v09,
	m34_type,
	commission_type,
	m34_currency_code_m03,
	m34_currency_id_m03,
	m34_id,
	m34_created_by_id_u17,
	m34_created_date,
	m34_modified_by_id_u17,
	m34_modified_date,
	m34_vat_charge_type_m124,
	m34_vat_percentage,
	vat_charge_type,
	m34_category,
	category
)
AS
	(SELECT a.m34_start,
			a.m34_end,
			a.m34_percent,
			a.m34_flat_comm,
			a.m34_min_comm,
			a.m34_exec_broker_id_m26,
			a.m34_exchange_code_m01,
			a.m34_exchange_id_m01,
			a.m34_instrument_type,
			a.m34_instrument_type_id_v09,
			a.m34_type,
			com.m124_description AS commission_type,
			a.m34_currency_code_m03,
			a.m34_currency_id_m03,
			a.m34_id,
			a.m34_created_by_id_u17,
			a.m34_created_date,
			a.m34_modified_by_id_u17,
			a.m34_modified_date,
			a.m34_vat_charge_type_m124,
			a.m34_vat_percentage,
			vat.m124_description AS vat_charge_type,
			a.m34_category,
			CASE a.m34_category
				WHEN 1 THEN 'CMA'
				WHEN 2 THEN 'CCP'
				WHEN 3 THEN 'DCM/GCM'
				ELSE 'Exchange/Exec.Br'
			END AS category
	 FROM m34_exec_broker_commission a
		  LEFT JOIN m124_commission_types vat
			  ON a.m34_vat_charge_type_m124 = vat.m124_value
		  LEFT JOIN m124_commission_types com ON a.m34_type = com.m124_value)
/
