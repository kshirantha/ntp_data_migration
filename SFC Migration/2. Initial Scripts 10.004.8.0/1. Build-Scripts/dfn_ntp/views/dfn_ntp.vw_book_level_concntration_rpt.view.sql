CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_book_level_concntration_rpt
(
    m77_symbol,
    stock_name,
    sector,
    tot_marketvalue_of_collateral,
    prop_loan_util_bas_on_mkt_val1,
    collat_cover_based_on_mkt_val,
    tot_marginable_val_of_collat,
    prop_loan_util_bdon_marg_val2,
    collat_cover_bdon_margin_val,
    marg_exposure_util_perc_stock,
    marg_exposure_util_perc_sector,
    no
)
AS
    SELECT m20_symbol_code AS m77_symbol,
           stock_name,
           sector,
           tot_marketvalue_of_collateral,
           prop_loan_util_bas_on_mkt_val1,
           collat_cover_based_on_mkt_val,
           tot_marginable_val_of_collat,
           prop_loan_util_bdon_marg_val2,
           collat_cover_bdon_margin_val,
           marg_exposure_util_perc_stock,
           marg_exposure_util_perc_sector,
           no
      FROM (SELECT t1.*,
                   ROW_NUMBER ()
                       OVER (PARTITION BY sector ORDER BY m20_symbol_code)
                       no
              FROM (SELECT b.m20_symbol_code,
                           b.stock_name,
                           b.sector,
                           b.tot_marketvalue_of_collateral,
                           b.prop_loan_util_bas_on_mkt_val1,
                           b.collat_cover_based_on_mkt_val,
                           b.tot_marginable_val_of_collat,
                           b.prop_loan_util_bdon_marg_val2,
                           b.collat_cover_bdon_margin_val,
                           b.marg_exposure_util_perc_stock,
                           ROUND (
                               SUM (marg_exposure_util_perc_stock)
                                   OVER (PARTITION BY sector),
                               2)
                               AS marg_exposure_util_perc_sector
                      FROM (SELECT a.*,
                                   CASE
                                       WHEN prop_loan_util_bas_on_mkt_val1 <>
                                                0
                                       THEN
                                           ROUND (
                                                 100
                                               * prop_loan_util_bas_on_mkt_val1
                                               / (SUM (
                                                      prop_loan_util_bas_on_mkt_val1)
                                                  OVER (PARTITION BY NULL)),
                                               2)
                                       ELSE
                                           0
                                   END
                                       AS marg_exposure_util_perc_stock
                              FROM (SELECT   '' AS no,
                                             m20_symbol_code,
                                             m20_short_description
                                                 AS stock_name,
                                             sector,
                                             SUM (symbol_market_value)
                                                 AS tot_marketvalue_of_collateral,
                                             SUM (pu_based_on_market_value)
                                                 AS prop_loan_util_bas_on_mkt_val1,
                                             CASE
                                                 WHEN SUM (
                                                          pu_based_on_market_value) <>
                                                          0
                                                 THEN
                                                     ROUND (
                                                           -100
                                                         * (  SUM (
                                                                  symbol_market_value)
                                                            / SUM (
                                                                  pu_based_on_market_value)),
                                                         2)
                                             END
                                                 AS collat_cover_based_on_mkt_val,
                                             SUM (symbol_marginable_value)
                                                 AS tot_marginable_val_of_collat,
                                             SUM (pu_based_on_marg_value)
                                                 AS prop_loan_util_bdon_marg_val2,
                                             CASE
                                                 WHEN SUM (
                                                          pu_based_on_marg_value) <>
                                                          0
                                                 THEN
                                                     ROUND (
                                                           -100
                                                         * (  SUM (
                                                                  symbol_marginable_value)
                                                            / SUM (
                                                                  pu_based_on_marg_value)),
                                                         2)
                                             END
                                                 AS collat_cover_bdon_margin_val
                                        FROM vw_book_level_conc_master
                                    GROUP BY sector,
                                             m20_symbol_code,
                                             m20_short_description) a) b) t1)
/