CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_corp_act_template_details
(
    m141_id,
    m141_description,
    m140_cash_adjustment_req,
    m140_cash_adj_type,
    cash_adj_type,
    m140_amount_type,
    m140_hold_adjustment_req,
    m140_hold_adj_type,
    hold_adj_type,
    m140_hold_adj_ratio_req,
    m140_hold_adj_par_val_req,
    m140_charge_req,
    m140_nostro_account_req,
    m140_hold_payment_req,
    m143_id,
    m143_type,
    m143_adj_mode,
    m143_amount,
    m143_per_stock,
    m143_impact_balance,
    m143_narration,
    m142_id,
    m142_narration,
    m142_from_ratio,
    m142_to_ratio,
    m142_old_par_value,
    m142_new_par_value,
    charge_id,
    charge_amount,
    charge_narration,
    charge_tax_percentage,
    nostro_account,
    nostro_currency
)
AS
    SELECT m141.m141_id,
           m141.m141_description,
           -- template details
           m140.m140_cash_adjustment_req,
           m140.m140_cash_adj_type,
           CASE m140.m140_cash_adj_type
               WHEN 1 THEN 'Pay'
               WHEN 2 THEN 'Deduct'
           END
               AS cash_adj_type,
           m140.m140_amount_type,
           --
           m140.m140_hold_adjustment_req,
           m140.m140_hold_adj_type,
           CASE m140.m140_hold_adj_type
               WHEN 1 THEN 'Pay'
               WHEN 2 THEN 'Deduct'
           END
               AS hold_adj_type,
           m140.m140_hold_adj_ratio_req,
           m140.m140_hold_adj_par_val_req,
           --
           m140.m140_charge_req,
           m140.m140_nostro_account_req,
           m140.m140_hold_payment_req,
           -- cash_adjustments details
           cash_adj.m143_id,
           cash_adj.m143_type,
           cash_adj.m143_adj_mode,
           cash_adj.m143_amount,
           cash_adj.m143_per_stock,
           cash_adj.m143_impact_balance,
           cash_adj.m143_narration,
           -- hold_adjustments details
           m142.m142_id,
           m142.m142_narration,
           m142.m142_from_ratio,
           m142.m142_to_ratio,
           m142.m142_old_par_value,
           m142.m142_new_par_value,
           -- charges details
           charge.m143_id AS charge_id,
           charge.m143_amount AS charge_amount,
           charge.m143_narration AS charge_narration,
           charge.m143_tax_percentage AS charge_tax_percentage,
           -- nostro account detail
           m72.m72_accountno AS nostro_account,
           m72.m72_currency_code_m03 AS nostro_currency
      FROM m141_cust_corporate_action m141
           JOIN m140_corp_action_templates m140
               ON m141.m141_template_id_m140 = m140.m140_id
           LEFT JOIN m143_corp_act_cash_adjustments cash_adj
               ON     m141.m141_id = cash_adj.m143_cust_corp_act_id_m141
                  AND cash_adj.m143_type = 2
           LEFT JOIN m143_corp_act_cash_adjustments charge
               ON     m141.m141_id = charge.m143_cust_corp_act_id_m141
                  AND charge.m143_type = 1
           LEFT JOIN m142_corp_act_hold_adjustments m142
               ON     m141.m141_id = m142.m142_cust_corp_act_id_m141
                  AND m142.m142_type = 1 -- Base Symbol Holdings Adjustment
           LEFT JOIN m72_exec_broker_cash_account m72
               ON m141.m141_custodian_acc_id_m72 = m72.m72_id
/