CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_m93_bank_accounts
(
	m93_id,
	m93_account_type_id_v01,
	account_type,
	m93_bank_id_m16,
	bank_name,
	swift_code,
	m93_accountno,
	m93_acc_owner_name,
	m93_acc_address_1,
	m93_acc_address_2,
	m93_currency_id_m03,
	m93_currency_code_m03,
	m93_branch_name,
	m93_contact_name,
	m93_contact_numbers,
	m93_iban_no,
	m93_bban_no,
	m93_online_trans_type_id_v01,
	m93_allow_deposit,
	m93_allow_withdraw,
	m93_allow_charge,
	m93_allow_refund,
	m93_balance,
	m93_blocked_amount,
	m93_od_limit,
	m93_institution_id_m02,
	institution_code,
	m93_stp_account,
	m93_stp_acc_rank,
	m93_acc_country,
	m93_is_default_omnibus,
	is_default,
	m93_is_visible,
	m93_online_trans_fee,
	m93_status_id_v01,
	status,
	m93_created_by_id_u17,
	created_by_name,
	m93_created_date,
	m93_modified_by_id_u17,
	modified_by_name,
	m93_modified_date,
	m93_status_changed_by_id_u17,
	status_changed_by_name,
	m93_status_changed_date,
	m93_eod_settle_ac_type_id_v01
)
AS
	SELECT m93.m93_id,
		   m93.m93_account_type_id_v01,
		   v01_account_type.v01_description
			   AS account_type,
		   m93.m93_bank_id_m16,
		   m16_bank.m16_name
			   AS bank_name,
		   m16_bank.m16_swift_code
			   AS swift_code,
		   m93.m93_accountno,
		   m93.m93_acc_owner_name,
		   m93.m93_acc_address_1,
		   m93.m93_acc_address_2,
		   m93.m93_currency_id_m03,
		   m93.m93_currency_code_m03,
		   m93.m93_branch_name,
		   m93.m93_contact_name,
		   m93.m93_contact_numbers,
		   m93.m93_iban_no,
		   m93.m93_bban_no,
		   m93.m93_online_trans_type_id_v01,
		   m93.m93_allow_deposit,
		   m93.m93_allow_withdraw,
		   m93.m93_allow_charge,
		   m93.m93_allow_refund,
		   m93.m93_balance,
		   m93.m93_blocked_amount,
		   m93.m93_od_limit,
		   m93.m93_institution_id_m02,
		   m02.m02_code
			   AS institution_code,
		   m93.m93_stp_account,
		   m93.m93_stp_acc_rank,
		   m93.m93_acc_country,
		   m93.m93_is_default_omnibus,
		   CASE m93.m93_is_default_omnibus WHEN 0 THEN 'No' ELSE 'Yes' END
			   AS is_default,
		   m93.m93_is_visible,
		   m93.m93_online_trans_fee,
		   m93.m93_status_id_v01,
		   vw_status_list.v01_description
			   AS status,
		   m93.m93_created_by_id_u17,
		   u17_created_by.u17_full_name
			   AS created_by_name,
		   m93.m93_created_date,
		   m93.m93_modified_by_id_u17,
		   u17_modified_by.u17_full_name
			   AS modified_by_name,
		   m93.m93_modified_date,
		   m93.m93_status_changed_by_id_u17,
		   u17_status_changed_by.u17_full_name
			   AS status_changed_by_name,
		   m93.m93_status_changed_date,
		   m93_eod_settle_ac_type_id_v01
	FROM m93_bank_accounts m93
		 LEFT JOIN u17_employee u17_created_by
			 ON m93.m93_created_by_id_u17 = u17_created_by.u17_id
		 LEFT JOIN u17_employee u17_status_changed_by
			 ON m93.m93_status_changed_by_id_u17 =
				u17_status_changed_by.u17_id
		 LEFT JOIN u17_employee u17_modified_by
			 ON m93.m93_modified_by_id_u17 = u17_modified_by.u17_id
		 LEFT JOIN vw_status_list
			 ON m93.m93_status_id_v01 = vw_status_list.v01_id
		 LEFT JOIN m16_bank ON m93.m93_bank_id_m16 = m16_bank.m16_id
		 LEFT JOIN m02_institute m02 ON m93_institution_id_m02 = m02.m02_id
		 LEFT JOIN v01_system_master_data v01_account_type
			 ON 	m93.m93_account_type_id_v01 = v01_account_type.v01_id
				AND v01_account_type.v01_type = 43
/
