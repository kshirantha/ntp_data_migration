CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_dc_rpt_margin_sum_master
(
    u01_id,
    u23_max_margin_limit,
    limit_utilization,
    marginable_pv,
    m07_name,
    m74_saibor_basis_group_id_m65
)
AS
    SELECT u01_id,
           ROUND (u23_max_margin_limit, 0) AS u23_max_margin_limit,
           ROUND (limit_utilization, 0) AS limit_utilization,
           ROUND (marginable_pv, 0) AS marginable_pv,
           m07_name,
           m74_saibor_basis_group_id_m65
      FROM (  SELECT u01_id,
                     MAX (u23_max_margin_limit) AS u23_max_margin_limit,
                     CASE
                         WHEN SUM (limit_utilization) < 0 THEN 0
                         ELSE SUM (limit_utilization)
                     END
                         AS limit_utilization,
                     SUM (marginable_pv) AS marginable_pv,
                     m07_name,
                     m74_saibor_basis_group_id_m65
                FROM (SELECT u01.u01_id,
                               u23.u23_max_margin_limit
                             * CASE
                                   WHEN u23_max_limit_currency_m03 = 'SAR'
                                   THEN
                                       1
                                   ELSE
                                       get_exchange_rate (
                                           u23_institute_id_m02,
                                           u23_max_limit_currency_m03,
                                           'SAR')
                               END
                                 AS u23_max_margin_limit,
                               CASE
                                   WHEN (  u06.u06_balance
                                         - 0
                                         + u06.u06_payable_blocked
                                         - u06.u06_receivable_amount -- 0 should be u06.u06_loan_amount
                                                                    ) < 0
                                   THEN
                                         (  u06.u06_balance
                                          - 0
                                          + u06.u06_payable_blocked
                                          - u06.u06_receivable_amount -- 0 should be u06.u06_loan_amount
                                                                     )
                                       * -1
                                   ELSE
                                       0
                               END
                             * CASE
                                   WHEN u06.u06_currency_code_m03 = 'SAR'
                                   THEN
                                       1
                                   ELSE
                                       get_exchange_rate (
                                           u23_institute_id_m02,
                                           u06.u06_currency_code_m03,
                                           'SAR')
                               END
                                 AS limit_utilization,
                               NVL (
                                   get_pfolio_val_by_cash_ac (
                                       u06_id,
                                       u06_institute_id_m02,
                                       1,
                                       1,
                                       1,
                                       1),
                                   0)
                             * CASE
                                   WHEN u06.u06_currency_code_m03 = 'SAR'
                                   THEN
                                       1
                                   ELSE
                                       get_exchange_rate (
                                           u23_institute_id_m02,
                                           u06.u06_currency_code_m03,
                                           'SAR')
                               END
                                 AS marginable_pv,
                             m07.m07_name,
                             m74_saibor_basis_group_id_m65
                        FROM u01_customer u01
                             INNER JOIN u06_cash_account u06
                                 ON u01.u01_id = u06.u06_customer_id_u01
                             INNER JOIN u07_trading_account u07
                                 ON u06.u06_id = u07.u07_cash_account_id_u06
                             INNER JOIN u23_customer_margin_product u23
                                 ON u07.u07_customer_id_u01 =
                                        u23.u23_customer_id_u01
                             INNER JOIN m73_margin_products m73
                                 ON u23.u23_margin_product_m73 = m73.m73_id
                             INNER JOIN m07_location m07
                                 ON u01.u01_signup_location_id_m07 = m07.m07_id
                             INNER JOIN m74_margin_interest_group m74
                                 ON u23.u23_interest_group_id_m74 = m74.m74_id
                       WHERE m73.m73_status_id_v01 != 5)
            GROUP BY u01_id, m07_name, m74_saibor_basis_group_id_m65)
/
