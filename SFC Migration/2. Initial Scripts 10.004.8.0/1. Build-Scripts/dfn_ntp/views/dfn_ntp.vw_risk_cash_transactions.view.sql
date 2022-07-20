CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_risk_cash_transactions
(
    t06_id,
    t06_cash_acc_id_u06,
    t06_code,
    action,
    t06_date,
    t06_from_cust_id_u01,
    t06_narration,
    t06_payment_method,
    payment_method,
    t06_transaction_currency_m03,
    t06_amt_in_txn_currency,
    t06_settle_currency_rate_m04,
    t06_cheque_no,
    t06_cheque_date,
    t06_settlement_date,
    t06_beneficiary_id_u08,
    t06_other_cash_acc_id_u06,
    t06_entered_by_id_u17,
    t06_entered_date,
    t06_last_changed_by_id_u17,
    t06_last_changed_date,
    t06_cash_log_acc_id_u30,
    t06_status_id,
    t06_bank_id_m93,
    t06_acc_name,
    t06_branch,
    t06_type_id,
    t06_chk_printed_by,
    t06_chk_printed_date,
    t06_extrnl_ref,
    t06_request_channel,
    t06_location,
    t06_auto_generate,
    t06_available_buy_power,
    t06_online_ft,
    t06_ft_status,
    t06_message_type,
    t06_stp_type,
    t06_stp_status,
    t06_stp_narration,
    t06_cust_bank_acc_id,
    t06_settlement_key,
    t06_txn_type,
    t06_reversed_by_id_u17,
    t06_reversed_date,
    t06_payment_initiated_time,
    t06_settle_currency_code_m03,
    t06_amt_in_settle_currency,
    t06_related_txn_id,
    t06_overdrawn_amt,
    t06_poa_id_u47,
    t06_exchange_fee,
    t06_broker_fee,
    t06_thirdparty_fee,
    t06_to_cash_acc_id,
    t06_client_channel_id_v29,
    t06_sub_login_id_u09,
    t06_sub_login_name,
    t06_b2b_txn_id_m97,
    t06_bypass_txn_restriction,
    t06_third_party_txn_id,
    t06_is_live,
    t06_no_of_approval,
    t06_current_approval_level,
    t06_deposit_bank_id_m16,
    t06_deposit_bank_no,
    from_transaction_id,
    to_transaction_id,
    u06_display_name,
    u06_currency_code_m03,
    u06_investment_account_no,
    basecurrency,
    u06_balance_from,
    u06_external_ref_no,
    to_cash_acc_id,
    u06_balance_to,
    to_u06_investment_acc_no,
    u06_currency_to,
    rec_u06_external_reference,
    u01_id,
    custid,
    u01_external_ref_no,
    custname,
    custnamelang,
    u01_preferred_lang_id_v01,
    u01_nationality_id_m05,
    u01_customer_no,
    m97_description,
    custbank,
    cust_bank_swift_code,
    enteredby,
    lastchangedby,
    m02_id,
    m02_code,
    bankaccount,
    our_bank_account,
    our_bank_branch,
    our_bank_address,
    ourbank,
    our_bank_swift_code,
    cust_trans_bank_name,
    cust_trans_bank_swift_code,
    status,
    online_ft_status,
    available_buy_power,
    stp_type_detail,
    t06_stp_status_detail,
    u08_account_no,
    u08_account_type_v01_id,
    account_type,
    u08_account_name,
    t06_brk_vat,
    t06_exg_vat,
    t06_is_allow_overdraw
)
AS
    SELECT t06.t06_id,
           t06.t06_cash_acc_id_u06,
           t06.t06_code,
           CASE t06.t06_code
               WHEN 'CSHTRN' THEN 'Transfer'
               WHEN 'REVBUY' THEN 'Reverse Buy'
               WHEN 'SUBFEE' THEN 'Subscription Fee'
               WHEN 'DEPOST' THEN 'Deposit'
               WHEN 'WITHDR' THEN 'Withdraw'
           END
               AS action,
           t06.t06_date,
           t06.t06_from_cust_id_u01,
           t06.t06_narration,
           t06.t06_payment_method,
           CASE t06.t06_payment_method
               WHEN '1' THEN 'Cash'
               WHEN '2' THEN 'Cheque'
               WHEN '3' THEN 'Transfer'
           END
               AS payment_method,
           u06.u06_currency_code_m03 AS t06_transaction_currency_m03, -- Need to Populate by OMS Side
           t06.t06_amt_in_txn_currency,
           t06.t06_settle_currency_rate_m04,
           t06.t06_cheque_no,
           t06.t06_cheque_date,
           t06.t06_settlement_date,
           t06.t06_beneficiary_id_u08,
           t06.t06_other_cash_acc_id_u06,
           t06.t06_entered_by_id_u17,
           t06.t06_entered_date,
           t06.t06_last_changed_by_id_u17,
           t06.t06_last_changed_date,
           t06.t06_cash_log_acc_id_u30,
           t06.t06_status_id,
           t06.t06_bank_id_m93,
           t06.t06_acc_name,
           t06.t06_branch,
           t06.t06_type_id,
           t06.t06_chk_printed_by,
           t06.t06_chk_printed_date,
           t06.t06_extrnl_ref,
           t06.t06_req_media AS t06_request_channel,
           t06.t06_location,
           t06.t06_auto_generate,
           t06.t06_available_buy_power,
           t06.t06_online_ft,
           t06.t06_ft_status,
           t06.t06_message_type,
           t06.t06_stp_type,
           t06.t06_stp_status,
           t06.t06_stp_narration,
           t06.t06_cust_bank_acc_id,
           t06.t06_settlement_key,
           t06.t06_txn_type,
           t06.t06_reversed_by_id_u17,
           t06.t06_reversed_date,
           t06.t06_payment_initiated_time,
           t06.t06_settle_currency_code_m03,
           t06.t06_amt_in_settle_currency,
           t06.t06_related_txn_id,
           t06.t06_overdrawn_amt,
           t06.t06_poa_id_u47,
           t06.t06_exchange_fee,
           t06.t06_broker_fee,
           t06.t06_thirdparty_fee,
           t06.t06_to_cash_acc_id,
           t06.t06_client_channel_id_v29,
           t06.t06_sub_login_id_u09,
           t06.t06_sub_login_name,
           t06.t06_b2b_txn_id_m97,
           t06.t06_bypass_txn_restriction,
           t06.t06_third_party_txn_id,
           t06.t06_is_live,
           t06.t06_no_of_approval,
           t06.t06_current_approval_level,
           t06.t06_deposit_bank_id_m16,
           t06.t06_deposit_bank_no,
           t06.t06_id AS from_transaction_id,
           NULL AS to_transaction_id,
           u06.u06_display_name,
           u06.u06_currency_code_m03,
           u06.u06_investment_account_no,
           u06.u06_currency_code_m03 AS basecurrency,
           (  u06.u06_balance
            + u06.u06_pending_deposit
            - u06.u06_pending_withdraw)
               AS u06_balance_from,
           u06.u06_external_ref_no,
           t06.t06_to_cash_acc_id AS to_cash_acc_id,
           (  u06_to.u06_balance
            + u06_to.u06_pending_deposit
            - u06_to.u06_pending_withdraw)
               AS u06_balance_to,
           u06_to.u06_investment_account_no AS to_u06_investment_acc_no,
           u06_to.u06_currency_code_m03 AS u06_currency_to,
           u06_to.u06_external_ref_no AS rec_u06_external_reference,
           u01.u01_id,
           u01.u01_customer_no AS custid,
           u01.u01_external_ref_no,
           u01.u01_full_name AS custname,
           TRIM (
                  TRIM (
                         TRIM (
                                NVL (u01.u01_first_name_lang, '')
                             || ' '
                             || NVL (u01.u01_second_name_lang, ''))
                      || ' '
                      || NVL (u01.u01_third_name_lang, ''))
               || ' '
               || NVL (u01.u01_last_name_lang, ''))
               AS custnamelang,
           u01.u01_preferred_lang_id_v01,
           u01.u01_nationality_id_m05,
           u01.u01_customer_no,
           m97.m97_description,
           DECODE (t06.t06_payment_method,
                   'Transfer', m16_cust_bank.m16_name,
                   NULL)
               AS custbank,
           m16_cust_bank.m16_swift_code AS cust_bank_swift_code,
           u17e.u17_full_name AS enteredby,
           u17_status_changed.u17_full_name AS lastchangedby,
           m02.m02_id,
           m02.m02_code,
           m93.m93_accountno AS bankaccount,
           m93.m93_accountno AS our_bank_account,
           m93.m93_branch_name AS our_bank_branch,
           (   NVL2 (m93.m93_acc_address_1,
                     m93.m93_acc_address_1 || ', ',
                     '')
            || NVL (m93.m93_acc_address_2, ''))
               AS our_bank_address,
           m16_omini_bank.m16_name AS ourbank,
           m16_omini_bank.m16_swift_code AS our_bank_swift_code,
           CASE
               WHEN t06.t06_payment_method = 'Transfer' THEN m16.m16_name
               ELSE ''
           END
               AS cust_trans_bank_name,
           m16.m16_swift_code AS cust_trans_bank_swift_code,
           sts.v01_description AS status,
           CASE t06.t06_online_ft
               WHEN 1 THEN 'PROCESSING'
               WHEN 2 THEN 'SIGNATURE1 APPROVED'
               WHEN 3 THEN 'SIGNATURE2 APPROVED'
               WHEN 4 THEN 'COMPLETED'
               WHEN 5 THEN 'CANCELLED'
               ELSE 'N/A'
           END
               AS online_ft_status,
           CASE t06.t06_available_buy_power
               WHEN 0 THEN 'FALSE'
               WHEN 1 THEN 'TRUE'
           END
               AS available_buy_power,
           CASE
               WHEN t06.t06_stp_type = 1 THEN 'DUBAI BANK'
               WHEN t06.t06_stp_type = 2 THEN 'SWIFT'
           END
               AS stp_type_detail,
           CASE
               WHEN t06.t06_stp_status = 1 THEN 'NEW'
               WHEN t06.t06_stp_status = 2 THEN 'SIGNATURE1 APPROVED'
               WHEN t06.t06_stp_status = 3 THEN 'PROCESSING'
               WHEN t06.t06_stp_status = 4 THEN 'SENT'
               WHEN t06.t06_stp_status = 5 THEN 'FAILED FROM OMS'
               WHEN t06.t06_stp_status = 6 THEN 'ACKNOWLEDGE BY SWIFT'
               WHEN t06.t06_stp_status = 7 THEN 'BANK HAS RECEIVED'
               WHEN t06.t06_stp_status = 8 THEN 'FAILED FROM SWIFT'
               WHEN t06.t06_stp_status = 9 THEN 'EXECUTED IN BANK'
               WHEN t06.t06_stp_status = 10 THEN 'FAILED IN BANK'
           END
               AS t06_stp_status_detail,
           u08.u08_account_no,
           u08_account_type_v01_id,
           CASE u08_account_type_v01_id
               WHEN 0 THEN 'Current'
               WHEN 1 THEN 'Saving'
               WHEN 2 THEN 'Investment'
               WHEN 3 THEN 'Joint'
               WHEN 26 THEN 'Check'
           END
               AS account_type,
           u08_account_name,
           NVL (t06_brk_vat, 0) AS t06_brk_vat,
           NVL (t06_exg_vat, 0) AS t06_exg_vat,
           t06.t06_is_allow_overdraw
      FROM t06_cash_transaction t06
           JOIN u06_cash_account u06
               ON t06.t06_cash_acc_id_u06 = u06.u06_id
           LEFT JOIN u06_cash_account u06_to
               ON t06.t06_to_cash_acc_id = u06_to.u06_id
           JOIN u01_customer u01
               ON u06.u06_customer_id_u01 = u01.u01_id
           JOIN vw_m97_cash_txn_codes_base m97
               ON t06.t06_code = m97.m97_code
           LEFT JOIN m93_bank_accounts m93
               ON t06.t06_bank_id_m93 = m93.m93_id
           LEFT JOIN m16_bank m16
               ON m93.m93_bank_id_m16 = m16.m16_id
           LEFT JOIN m16_bank m16_cust_bank
               ON t06.t06_cust_bank_acc_id = m16_cust_bank.m16_id
           LEFT JOIN m16_bank m16_omini_bank
               ON m93.m93_bank_id_m16 = m16_omini_bank.m16_id
           JOIN m02_institute m02
               ON u06.u06_institute_id_m02 = m02.m02_id
           JOIN u17_employee u17e
               ON t06.t06_entered_by_id_u17 = u17e.u17_id
           JOIN u17_employee u17_status_changed
               ON t06.t06_last_changed_by_id_u17 = u17_status_changed.u17_id
           LEFT JOIN u08_customer_beneficiary_acc u08
               ON t06.t06_beneficiary_id_u08 = u08.u08_id
           JOIN vw_status_list sts
               ON t06.t06_status_id = sts.v01_id
           JOIN (SELECT m53_approval_levels
                   FROM m53_approval_required_tables m53
                  WHERE m53.m53_id = 1006) m53
               ON t06.t06_current_approval_level =
                      m53.m53_approval_levels - 1
/
