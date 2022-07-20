CREATE OR REPLACE PROCEDURE dfn_ntp.sp_idsr_report (
    p_view                OUT SYS_REFCURSOR,
    prows                 OUT NUMBER,
    p_current_date     IN     DATE,
    p_institution_id   IN     NUMBER)
IS
BEGIN
    BEGIN
        OPEN p_view FOR
              SELECT exchange,
                     product_category,
                     product_name,
                     SUM (private_user) AS private_user,
                     MAX (private_user_exg_fee) AS private_user_exg_fee,
                     SUM (business_user) AS business_user,
                     MAX (business_user_exg_fee) AS business_user_exg_fee,
                     SUM (in_house_user) AS in_house_user,
                     MAX (in_house_user_exg_fee) AS in_house_user_exg_fee
                FROM (SELECT subs.m153_exchange_code_m01 AS exchange,
                             subs.product_category,
                             subs.v35_product_name AS product_name,
                             subs.private_user AS private_user,
                             subs.private_user_exg_fee AS private_user_exg_fee,
                             subs.business_user AS business_user,
                             subs.business_user_exg_fee
                                 AS business_user_exg_fee,
                             subs.in_house_user,
                             subs.in_house_user_exg_fee
                        FROM (SELECT u01.u01_id,
                                     u01.u01_customer_no,
                                     u01.u01_full_name,
                                     m152.m152_id,
                                     v35.v35_product_code,
                                     v35.v35_product_name,
                                     CASE
                                         WHEN m152.m152_premium_product = 1
                                         THEN
                                             'Premium'
                                         ELSE
                                             'Market Depth'
                                     END
                                         AS product_category,
                                     v35.v35_rank,
                                     RANK ()
                                     OVER (PARTITION BY t57.t57_customer_id_u01
                                           ORDER BY m152.m152_rank DESC)
                                         highest_rank,
                                     t57.t57_from_date,
                                     t57.t57_to_date,
                                     m153.m153_exchange_code_m01,
                                     u09.u09_id,
                                     u09.u09_price_user_name,
                                     CASE
                                         WHEN m158.m158_customer_type_v01 = 1 THEN 1
                                         ELSE 0
                                     END
                                         AS private_user,
                                     CASE
                                         WHEN m158.m158_customer_type_v01 = 1
                                         THEN
                                             t57.t57_exchange_fee -- Is VAT Required?
                                         ELSE
                                             0
                                     END
                                         AS private_user_exg_fee,
                                     CASE
                                         WHEN m158.m158_customer_type_v01 = 0 THEN 1
                                         ELSE 0
                                     END
                                         AS business_user,
                                     CASE
                                         WHEN m158.m158_customer_type_v01 = 0
                                         THEN
                                             t57.t57_exchange_fee -- Is VAT Required?
                                         ELSE
                                             0
                                     END
                                         AS business_user_exg_fee,
                                     0 AS in_house_user,
                                     0 AS in_house_user_exg_fee
                                FROM t56_product_subscription_data t56,
                                     m152_products m152,
                                     u01_customer u01,
                                     u09_customer_login u09,
                                     t57_exchange_subscription_data t57,
                                     m153_exchange_subscription_prd m153,
                                     m158_priceuser_agreement m158,
                                     v35_products v35
                               WHERE     t56.t56_product_id_m152 = m152.m152_id
                                     AND m152.m152_product_id_v35 = v35.v35_id
                                     AND t56.t56_customer_id_u01 = u01.u01_id
                                     AND t56.t56_customer_login_u09 =
                                             u09.u09_id
                                     AND u01.u01_id = t57.t57_customer_id_u01
                                     AND t57.t57_exchange_product_id_m153 =
                                             m153.m153_id
                                     AND t57.t57_customer_login_u09 =
                                             u09.u09_id
                                     AND u01.u01_institute_id_m02 =
                                             p_institution_id
                                     AND t57.t57_status = 1 -- Only Approved Subscriptions
                                     AND t57.t57_from_date <=
                                             TRUNC (LAST_DAY (SYSDATE))
                                     AND t57.t57_to_date >=
                                             TRUNC (LAST_DAY (SYSDATE))
                                     AND u01.u01_id = m158.m158_customer_id_u01) subs
                       WHERE highest_rank = 1
                      UNION ALL
                      SELECT u28.u28_exchange_code_m01 AS exchange,
                             'Market Depth' AS product_category,
                             'DT' AS product,
                             0 AS private_user,
                             0 AS private_user_exg_fee,
                             0 AS business_user,
                             0 AS business_user_exg_fee,
                             1 AS in_house_user,
                             0 AS in_house_user_exg_fee
                        FROM u17_employee u17,
                             m11_employee_type m11,
                             u28_employee_exchanges u28
                       WHERE     u17.u17_type_id_m11 = m11.m11_id
                             AND u17.u17_id = u28.u28_employee_id_u17
                             AND u17.u17_institution_id_m02 = p_institution_id
                             AND m11.m11_category <> 1
                             AND u28.u28_price_subscribed = 1
                             AND u17.u17_price_login_name IS NOT NULL)
            GROUP BY exchange, product_category, product_name
            ORDER BY exchange;
    END;
END;
/