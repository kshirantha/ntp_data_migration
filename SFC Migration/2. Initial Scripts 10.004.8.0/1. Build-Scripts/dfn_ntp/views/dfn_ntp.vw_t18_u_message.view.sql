CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_t18_u_message
(
   t18_id,
   t18_member_code_9700,
   t18_reference_no_9701,
   t18_account_type_9702,
   t18_client_type_9703,
   t18_from_nin_9704,
   t18_bank_acc_type_9705,
   t18_bank_acc_no_9706,
   t18_acc_owner_name_9707,
   t18_acc_number_9708,
   t18_acc_create_rspn_9709,
   t18_address_9711,
   t18_city_9712,
   t18_postal_code_9713,
   t18_country_9714,
   t18_gender_9715,
   t18_name_9716,
   t18_acc_delete_rspn_9717,
   t18_acc_change_rspn_9718,
   t18_pledge_type_9722,
   t18_pledgor_member_code_9723,
   t18_pledgor_acct_no_9724,
   t18_pledge_total_value_9725,
   t18_pledge_member_code_9726,
   t18_pledgecall_mem_code_9727,
   t18_pledgecall_acc_no_9728,
   t18_pledge_src_trans_no_9729,
   t18_trans_rspn_9730,
   t18_movement_type_9731,
   t18_seller_member_code_9732,
   t18_seller_acct_no_9733,
   t18_seller_nin_9734,
   t18_buyer_member_code_9735,
   t18_buyer_acct_no_9736,
   t18_buyer_nin_9737,
   t18_customer_id_u01,
   t18_trading_account_id_u07,
   t18_effective_date_9744,
   t18_return_date_9745,
   t18_transact_time_60,
   t18_created_date,
   t18_rspn_date,
   t18_u_message_type,
   t18_u_message_status,
   t18_u_message_reject_reason,
   t18_symbol,
   t18_institute_id_m02,
   requested_by,
   MESSAGE_TYPE,
   u01_customer_no,
   message_status,
   u07_display_name,
   t18_foreign_acc_no_9770,
   t18_foreign_acc_name_9771,
   t18_foreign_acc_iban_9772,
   t18_foreign_bank_name_9773,
   t18_foreign_bank_add_9774,
   t18_foreign_bank_swift_9775,
   t18_foreign_bank_aba_9776
)
AS
   SELECT t18.t18_id,
          t18.t18_member_code_9700,
          t18.t18_reference_no_9701,
          t18.t18_account_type_9702,
          t18.t18_client_type_9703,
          t18.t18_from_nin_9704,
          t18.t18_bank_acc_type_9705,
          t18.t18_bank_acc_no_9706,
          t18.t18_acc_owner_name_9707,
          t18.t18_acc_number_9708,
          t18.t18_acc_create_rspn_9709,
          t18.t18_address_9711,
          t18.t18_city_9712,
          t18.t18_postal_code_9713,
          t18.t18_country_9714,
          t18.t18_gender_9715,
          t18.t18_name_9716,
          t18.t18_acc_delete_rspn_9717,
          t18.t18_acc_change_rspn_9718,
          t18.t18_pledge_type_9722,
          t18.t18_pledgor_member_code_9723,
          t18.t18_pledgor_acct_no_9724,
          t18.t18_pledge_total_value_9725,
          t18.t18_pledge_member_code_9726,
          t18.t18_pledgecall_mem_code_9727,
          t18.t18_pledgecall_acc_no_9728,
          t18.t18_pledge_src_trans_no_9729,
          t18.t18_trans_rspn_9730,
          t18.t18_movement_type_9731,
          t18.t18_seller_member_code_9732,
          t18.t18_seller_acct_no_9733,
          t18.t18_seller_nin_9734,
          t18.t18_buyer_member_code_9735,
          t18.t18_buyer_acct_no_9736,
          t18.t18_buyer_nin_9737,
          t18.t18_customer_id_u01,
          t18.t18_trading_account_id_u07,
          t18.t18_effective_date_9744,
          t18.t18_return_date_9745,
          t18.t18_transact_time_60,
          t18.t18_created_date,
          t18.t18_rspn_date,
          t18.t18_u_message_type,
          t18.t18_u_message_status,
          t18.t18_u_message_reject_reason,
          t18.t18_symbol,
          t18.t18_institute_id_m02,
          u17.u17_full_name AS requested_by,
          CASE
             WHEN SUBSTR (t18_u_message_type, 0, 3) = 'U10'
             THEN
                'Create Account'
             WHEN SUBSTR (t18_u_message_type, 0, 3) = 'U12'
             THEN
                'View Account'
             WHEN SUBSTR (t18_u_message_type, 0, 3) = 'U14'
             THEN
                'Change Account'
             WHEN SUBSTR (t18_u_message_type, 0, 3) = 'U16'
             THEN
                'Disable Account'
             WHEN SUBSTR (t18_u_message_type, 0, 3) = 'U18'
             THEN
                'Portfolio Inquiry'
             WHEN SUBSTR (t18_u_message_type, 0, 3) = 'U20'
             THEN
                'Pledge/Unpledge'
             WHEN SUBSTR (t18_u_message_type, 0, 3) = 'U22'
             THEN
                'Security Transfer Request'
             WHEN SUBSTR (t18_u_message_type, 0, 3) = 'U26'
             THEN
                'Account Closure'
             WHEN SUBSTR (t18_u_message_type, 0, 3) = 'U31'
             THEN
                'Custodian Trade Reject'
          END
             AS MESSAGE_TYPE,
          u01.u01_customer_no,
          CASE
             WHEN t18_u_message_status = 0 THEN 'Pending'
             WHEN t18_u_message_status = 1 THEN 'Sent to Exchange'
             WHEN t18_u_message_status = 2 THEN 'Completed'
             WHEN t18_u_message_status = 3 THEN 'Exchange Rejected'
             WHEN t18_u_message_status = 4 THEN 'Account Created'
             WHEN t18_u_message_status = 5 THEN 'Success but OMS not Sync'
          END
             AS message_status,
          u07.u07_display_name,
          t18.t18_foreign_acc_no_9770,
          t18.t18_foreign_acc_name_9771,
          t18.t18_foreign_acc_iban_9772,
          t18.t18_foreign_bank_name_9773,
          t18.t18_foreign_bank_add_9774,
          t18.t18_foreign_bank_swift_9775,
          t18.t18_foreign_bank_aba_9776
     FROM t18_c_umessage t18
          INNER JOIN u17_employee u17 ON t18.t18_employee_id_u17 = u17.u17_id
          LEFT JOIN u07_trading_account u07
             ON t18.t18_trading_account_id_u07 = u07.u07_id
          LEFT JOIN u01_customer u01 ON t18.t18_customer_id_u01 = u01.u01_id;
/