CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_trading_limit_utilized
(
    u06_id,
    u06_customer_id_u01,
    utilization,
    u06_primary_od_limit,
    u06_secondary_od_limit
)
AS
    SELECT a.u06_id,
           a.u06_customer_id_u01,
           CASE
               WHEN (a.u06_balance + a.u06_payable_blocked - a.u06_receivable_amount) <
                        0
               THEN
                   ROUND (
                       (    (  - (  a.u06_balance
                                  + a.u06_payable_blocked
                                  - a.u06_receivable_amount)
                             + (-a.u06_blocked))
                          / (CASE
                                 WHEN (    a.u06_primary_od_limit > 0
                                       AND (   TRUNC (a.u06_primary_expiry) >
                                                   SYSDATE
                                            OR a.u06_primary_expiry IS NULL))
                                 THEN
                                     u06_primary_od_limit
                                 ELSE
                                     0
                             END)
                        + (CASE
                               WHEN (    a.u06_secondary_od_limit > 0
                                     AND (   TRUNC (a.u06_secondary_expiry) >
                                                 SYSDATE
                                          OR a.u06_secondary_expiry IS NULL))
                               THEN
                                   u06_secondary_od_limit
                               ELSE
                                   0
                           END)),
                       8)
               ELSE
                   0
           END
               AS utilization,
           CASE
               WHEN (    a.u06_primary_od_limit > 0
                     AND (   TRUNC (a.u06_primary_expiry) > SYSDATE
                          OR a.u06_primary_expiry IS NULL))
               THEN
                   u06_primary_od_limit
               ELSE
                   0
           END
               AS u06_primary_od_limit,
           CASE
               WHEN (    a.u06_secondary_od_limit > 0
                     AND (   TRUNC (a.u06_secondary_expiry) > SYSDATE
                          OR a.u06_secondary_expiry IS NULL))
               THEN
                   u06_secondary_od_limit
               ELSE
                   0
           END
               AS u06_secondary_od_limit
      FROM u06_cash_account a
     WHERE    (    a.u06_primary_od_limit > 0
               AND (   TRUNC (a.u06_primary_expiry) > SYSDATE
                    OR a.u06_primary_expiry IS NULL))
           OR (    a.u06_secondary_od_limit > 0
               AND (   TRUNC (a.u06_secondary_expiry) > SYSDATE
                    OR a.u06_secondary_expiry IS NULL))
/