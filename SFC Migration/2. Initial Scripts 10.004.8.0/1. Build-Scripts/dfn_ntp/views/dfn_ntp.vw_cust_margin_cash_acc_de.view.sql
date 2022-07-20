CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_cust_margin_cash_acc_de
(
    u06_id,
    u06_display_name,
    u06_customer_id_u01,
    u06_margin_product_id_u23,
    u06_status_id_v01,
    t24_id,
    t24_default_cash_acc_id_u06,
    t24_cust_margin_product_id_u23,
    t24_status_id_v01,
    row_id,
    other_cash_account_id,
    availability
)
AS
    SELECT u06.u06_id,
           u06.u06_display_name,
           u06.u06_customer_id_u01,
           CASE
               WHEN u06.u06_margin_product_id_u23 IS NOT NULL
               THEN
                   u06.u06_margin_product_id_u23
               WHEN u06.u06_margin_product_id_u23 IS NULL
               THEN
                   CASE
                       WHEN default_acc.t24_cust_margin_product_id_u23
                                IS NOT NULL
                       THEN
                           default_acc.t24_cust_margin_product_id_u23
                       WHEN other_acc.u23_id IS NOT NULL
                       THEN
                           other_acc.u23_id
                       ELSE
                           -1
                   END
           END
               AS u06_margin_product_id_u23,
           u06.u06_status_id_v01,
           default_acc.t24_id,
           default_acc.t24_default_cash_acc_id_u06,
           default_acc.t24_cust_margin_product_id_u23,
           default_acc.t24_status_id_v01,
           default_acc.row_id,
           other_acc.other_cash_account AS other_cash_account_id,
           CASE
               WHEN u06.u06_margin_product_id_u23 > 0
               THEN
                   2 -- Once has been assigned and approved
               WHEN    (    u06.u06_margin_product_id_u23 IS NULL
                        AND default_acc.t24_status_id_v01 = 1)
                    OR (    u06.u06_margin_product_id_u23 IS NULL
                        AND default_acc.t24_id IS NULL
                        AND other_acc.other_cash_account IS NOT NULL)
               THEN
                   1 -- First time is being assigned
               ELSE
                   0 -- Completely available
           END
               AS availability
      FROM u06_cash_account u06
           LEFT JOIN (SELECT *
                        FROM (SELECT t24_id,
                                     t24_default_cash_acc_id_u06,
                                     t24_cust_margin_product_id_u23,
                                     t24_status_id_v01,
                                     ROW_NUMBER ()
                                     OVER (
                                         PARTITION BY t24_cust_margin_product_id_u23
                                         ORDER BY t24_id DESC)
                                         AS row_id
                                FROM t24_customer_margin_request)
                       WHERE row_id = 1) default_acc
               ON u06.u06_id = default_acc.t24_default_cash_acc_id_u06
           LEFT JOIN (SELECT *
                        FROM (WITH u23
                                   AS (SELECT u23_id,
                                              u23_other_cash_acc_ids_u06
                                         FROM u23_customer_margin_product
                                        WHERE     u23_other_cash_acc_ids_u06
                                                      IS NOT NULL
                                              AND u23_status_id_v01 NOT IN
                                                      (3, 5))
                                  SELECT DISTINCT
                                         u23_id,
                                         TRIM (REGEXP_SUBSTR (other_cash_account,
                                                              '[^,]+',
                                                              1,
                                                              LEVEL))
                                             other_cash_account
                                    FROM (SELECT u23_id,
                                                 u23_other_cash_acc_ids_u06
                                                     other_cash_account
                                            FROM u23)
                              CONNECT BY INSTR (other_cash_account,
                                                ',',
                                                1,
                                                LEVEL - 1) > 0)
                       WHERE other_cash_account IS NOT NULL) other_acc
               ON u06.u06_id = other_acc.other_cash_account
/