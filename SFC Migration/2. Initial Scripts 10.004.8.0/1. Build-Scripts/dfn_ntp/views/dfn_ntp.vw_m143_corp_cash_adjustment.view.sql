CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_m143_corp_cash_adjustment
(
   m143_id,
   m143_cust_corp_act_id_m141,
   m143_type,
   m143_adj_mode,
   m143_amount,
   m143_per_stock,
   m143_tax_percentage,
   m143_impact_balance,
   m143_narration,
   adj_type,
   adj_mode
)
AS
   (SELECT m143.m143_id,
           m143.m143_cust_corp_act_id_m141,
           m143.m143_type,
           m143.m143_adj_mode,
           m143.m143_amount,
           m143.m143_per_stock,
           m143.m143_tax_percentage,
           m143.m143_impact_balance,
           m143.m143_narration,
           CASE
              WHEN m143_type = 1 THEN 'Charge'
              WHEN m143_type = 2 THEN 'Cash Adjustment'
           END
              AS adj_type,
           CASE
              WHEN m143_adj_mode = 1 THEN 'Pay'
              WHEN m143_adj_mode = 2 THEN 'Deduct'
           END
              AS adj_mode
      FROM m143_corp_act_cash_adjustments m143)
/