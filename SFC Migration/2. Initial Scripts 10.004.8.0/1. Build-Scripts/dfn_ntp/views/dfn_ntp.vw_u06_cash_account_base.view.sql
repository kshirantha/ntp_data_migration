CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_u06_cash_account_base
(
    u06_id,
    u06_institute_id_m02,
    u06_customer_id_u01,
    u06_customer_no_u01,
    u06_display_name_u01,
    u06_default_id_no_u01,
    u06_currency_code_m03,
    u06_balance,
    u06_blocked,
    u06_open_buy_blocked,
    u06_payable_blocked,
    u06_manual_trade_blocked,
    u06_manual_full_blocked,
    u06_manual_transfer_blocked,
    u06_receivable_amount,
    u06_is_default,
    u06_created_by_id_u17,
    u06_created_date,
    u06_status_id_v01,
    u06_modified_by_id_u17,
    u06_modified_date,
    u06_status_changed_by_id_u17,
    u06_status_changed_date,
    u06_last_activity_date,
    u06_display_name,
    u06_currency_id_m03,
    u06_margin_enabled,
    u06_external_ref_no,
    u06_pending_deposit,
    u06_pending_withdraw,
    u06_primary_od_limit,
    u06_primary_start,
    u06_primary_expiry,
    u06_secondary_od_limit,
    u06_secondary_start,
    u06_secondary_expiry,
    u06_investment_account_no,
    u06_transfer_limit_grp_id_m177,
    u06_order_limit_grp_id_m176,
    u06_cum_transfer_value,
    u06_dbseqid,
    u06_margin_due,
    u06_margin_block,
    u06_ordexecseq,
    u06_pending_restriction,
    u06_group_bp_enable,
    u06_inactive_dormant_date,
    u06_inactive_drmnt_status_v01,
    u06_margin_product_id_u23,
    u06_account_type_v01,
    u06_iban_no,
    u06_vat_waive_off,
    u06_charges_group_m117,
    u06_net_receivable,
    u06_status_changed_reason,
    cash_for_trade,
    cash_for_withdraw,
    total_cash_balance,
    od_limit_today,
    buying_power,
    u06_discunt_charges_group_m165,
    u06_mutual_fund_account,
    u06_maintain_margin_charged,
    u06_maintain_margin_block,
    u06_initial_margin,
    u06_accrued_interest,
    u06_loan_amount,
    u06_other_commsion_grp_id_m22,
    u06_sub_waive_grp_id_m154_c
)
AS
    SELECT u06_id,
           u06_institute_id_m02,
           u06_customer_id_u01,
           u06_customer_no_u01,
           u06_display_name_u01,
           u06_default_id_no_u01,
           u06_currency_code_m03,
           u06_balance,
           u06_blocked,
           u06_open_buy_blocked,
           u06_payable_blocked,
           u06_manual_trade_blocked,
           u06_manual_full_blocked,
           u06_manual_transfer_blocked,
           u06_receivable_amount,
           u06_is_default,
           u06_created_by_id_u17,
           u06_created_date,
           u06_status_id_v01,
           u06_modified_by_id_u17,
           u06_modified_date,
           u06_status_changed_by_id_u17,
           u06_status_changed_date,
           u06_last_activity_date,
           u06_display_name,
           u06_currency_id_m03,
           u06_margin_enabled,
           u06_external_ref_no,
           u06_pending_deposit,
           u06_pending_withdraw,
           u06_primary_od_limit,
           u06_primary_start,
           u06_primary_expiry,
           u06_secondary_od_limit,
           u06_secondary_start,
           u06_secondary_expiry,
           u06_investment_account_no,
           u06_transfer_limit_grp_id_m177,
           u06_order_limit_grp_id_m176,
           u06_cum_transfer_value,
           u06_dbseqid,
           u06_margin_due,
           u06_margin_block,
           u06_ordexecseq,
           u06_pending_restriction,
           u06_group_bp_enable,
           u06_inactive_dormant_date,
           u06_inactive_drmnt_status_v01,
           u06_margin_product_id_u23,
           u06_account_type_v01,
           u06_iban_no,
           u06_vat_waive_off,
           u06_charges_group_m117,
           u06_net_receivable,
           u06_status_changed_reason,
           (  u06_balance
            - u06_receivable_amount
            - u06_blocked
            - u06_manual_trade_blocked
            - u06_manual_full_blocked)
               AS cash_for_trade,
           fn_available_cash_for_withdraw (u06_balance,
                                           u06_blocked,
                                           u06_manual_transfer_blocked,
                                           u06_manual_full_blocked,
                                           u06_loan_amount,
                                           u06_net_receivable_include,
                                           u06_net_receivable,
                                           u06_open_buy_blocked,
                                           u06_receivable_amount,
                                           m02.m02_add_rcvbl_for_bp)
               AS cash_for_withdraw,
           (u06_balance + u06_payable_blocked - u06_receivable_amount)
               AS total_cash_balance,
           (  CASE
                  WHEN     TRUNC (NVL (u06_primary_start, SYSDATE)) <=
                               TRUNC (SYSDATE)
                       AND TRUNC (NVL (u06_primary_expiry, SYSDATE)) >=
                               TRUNC (SYSDATE)
                  THEN
                      NVL (u06_primary_od_limit, 0)
                  ELSE
                      0
              END
            + CASE
                  WHEN     TRUNC (NVL (u06_secondary_start, SYSDATE)) <=
                               TRUNC (SYSDATE)
                       AND TRUNC (NVL (u06_secondary_expiry, SYSDATE)) >=
                               TRUNC (SYSDATE)
                  THEN
                      NVL (u06_secondary_od_limit, 0)
                  ELSE
                      0
              END)
               AS od_limit_today,
           CASE
               WHEN (CASE
                         WHEN u06_margin_enabled = 1
                         THEN
                             (  u06_balance
                              - u06_receivable_amount
                              - u06_blocked
                              - u06_manual_trade_blocked
                              - u06_manual_full_blocked)
                         ELSE
                               (  CASE
                                      WHEN     TRUNC (
                                                   NVL (u06_primary_start,
                                                        SYSDATE)) <=
                                                   TRUNC (SYSDATE)
                                           AND TRUNC (
                                                   NVL (u06_primary_expiry,
                                                        SYSDATE)) >=
                                                   TRUNC (SYSDATE)
                                      THEN
                                          NVL (u06_primary_od_limit, 0)
                                      ELSE
                                          0
                                  END
                                + CASE
                                      WHEN     TRUNC (
                                                   NVL (u06_secondary_start,
                                                        SYSDATE)) <=
                                                   TRUNC (SYSDATE)
                                           AND TRUNC (
                                                   NVL (u06_secondary_expiry,
                                                        SYSDATE)) >=
                                                   TRUNC (SYSDATE)
                                      THEN
                                          NVL (u06_secondary_od_limit, 0)
                                      ELSE
                                          0
                                  END)
                             + (  u06_balance
                                - u06_receivable_amount
                                - u06_blocked
                                - u06_manual_trade_blocked
                                - u06_manual_full_blocked)
                     END) < 0
               THEN
                   0
               ELSE
                   (CASE
                        WHEN u06_margin_enabled = 1
                        THEN
                            (  u06_balance
                             - u06_receivable_amount
                             - u06_blocked
                             - u06_manual_trade_blocked
                             - u06_manual_full_blocked)
                        ELSE
                              (  CASE
                                     WHEN     TRUNC (
                                                  NVL (u06_primary_start,
                                                       SYSDATE)) <=
                                                  TRUNC (SYSDATE)
                                          AND TRUNC (
                                                  NVL (u06_primary_expiry,
                                                       SYSDATE)) >=
                                                  TRUNC (SYSDATE)
                                     THEN
                                         NVL (u06_primary_od_limit, 0)
                                     ELSE
                                         0
                                 END
                               + CASE
                                     WHEN     TRUNC (
                                                  NVL (u06_secondary_start,
                                                       SYSDATE)) <=
                                                  TRUNC (SYSDATE)
                                          AND TRUNC (
                                                  NVL (u06_secondary_expiry,
                                                       SYSDATE)) >=
                                                  TRUNC (SYSDATE)
                                     THEN
                                         NVL (u06_secondary_od_limit, 0)
                                     ELSE
                                         0
                                 END)
                            + (  u06_balance
                               - u06_receivable_amount
                               - u06_blocked
                               - u06_manual_trade_blocked
                               - u06_manual_full_blocked)
                    END)
           END
               AS buying_power,
           u06_discunt_charges_group_m165,
           u06_mutual_fund_account,
           u06_maintain_margin_charged,
           u06_maintain_margin_block,
           u06_initial_margin,
           u06_accrued_interest,
           u06_loan_amount,
           u06_other_commsion_grp_id_m22,
           u06_sub_waive_grp_id_m154_c
      FROM     u06_cash_account
           JOIN
               m02_institute m02
           ON u06_institute_id_m02 = m02.m02_id
/