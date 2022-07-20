CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_customer_restrictions
(
    u01_customer_no,
    u01_display_name,
    login_name,
    description,
    id,
    narration,
    narration_lang,
    restriction_source,
    u01_institute_id_m02,
    u07_id
)
AS
    SELECT u01.u01_customer_no,
           u01.u01_display_name,
           NULL AS login_name,
           v31.v31_name AS description,
           u11.u11_cash_account_id_u06 AS id,
           u11.u11_narration AS narration,
           u11.u11_narration_lang AS narration_lang,
           CASE u11.u11_restriction_source
               WHEN 0 THEN 'Manual'
               WHEN 1 THEN 'Customer_ID_Expired'
               WHEN 2 THEN 'CMA_Details_Expired'
               WHEN 3 THEN 'Inactive'
               WHEN 4 THEN 'Dormant'
               WHEN 5 THEN ' Account Closure'
               WHEN 7 THEN 'Underage_to_Minor'
               WHEN 8 THEN 'Minor_to_Major'
           END
               AS restriction_source,
           u01_institute_id_m02,
           NULL AS u07_id
      FROM u11_cash_restriction u11
           INNER JOIN v31_restriction v31
               ON v31.v31_id = u11.u11_restriction_type_id_v31
           INNER JOIN u06_cash_account u06
               ON u06.u06_id = u11.u11_cash_account_id_u06
           INNER JOIN u01_customer u01
               ON u01.u01_id = u06.u06_customer_id_u01
    UNION ALL
    SELECT u01.u01_customer_no,
           u01.u01_display_name,
           NULL AS login_name,
           v31.v31_name AS description,
           u12.u12_trading_account_id_u07 AS id,
           u12.u12_narration AS narration,
           u12.u12_narration_lang AS narration_lang,
           CASE u12.u12_restriction_source
               WHEN 0 THEN 'Manual'
               WHEN 1 THEN 'Customer_ID_Expired'
               WHEN 2 THEN 'CMA_Details_Expired'
               WHEN 3 THEN 'Inactive'
               WHEN 4 THEN 'Dormant'
               WHEN 5 THEN ' Account Closure'
               WHEN 7 THEN 'Underage_to_Minor'
               WHEN 8 THEN 'Minor_to_Major'
           END
               AS restriction_source,
           u01_institute_id_m02,
           u12.u12_trading_account_id_u07 AS u07_id
      FROM u12_trading_restriction u12
           INNER JOIN v31_restriction v31
               ON v31.v31_id = u12.u12_restriction_type_id_v31
           INNER JOIN u07_trading_account u07
               ON u07.u07_id = u12.u12_trading_account_id_u07
           INNER JOIN u01_customer u01
               ON u01.u01_id = u07.u07_customer_id_u01
    UNION ALL
    SELECT u01.u01_customer_no,
           u01.u01_display_name,
           u09_login_name AS login_name,
           v31.v31_name AS description,
           u20.u20_login_id_u30 AS id,
           u20.u20_narration AS narration,
           u20.u20_narration_lang AS narration_lang,
           NULL AS restriction_source,
           u01_institute_id_m02,
           NULL AS u07_id
      FROM u20_login_cash_restriction u20
           INNER JOIN v31_restriction v31
               ON v31.v31_id = u20.u20_restriction_type_id_v31
           INNER JOIN u30_login_cash_acc u30
               ON u30.u30_id = u20.u20_login_id_u30
           INNER JOIN u06_cash_account u06
               ON u06.u06_id = u30.u30_cash_acc_id_u06
           INNER JOIN u01_customer u01
               ON u01.u01_id = u06.u06_customer_id_u01
           INNER JOIN u09_customer_login u09
               ON u30.u30_login_id_u09 = u09.u09_id
    UNION ALL
    SELECT u01.u01_customer_no,
           u01.u01_display_name,
           u09_login_name AS login_name,
           v31.v31_name AS description,
           u21.u21_login_id_u10 AS id,
           u21.u21_narration AS narration,
           u21.u21_narration_lang AS narration_lan,
           NULL AS restriction_source,
           u01_institute_id_m02,
           NULL AS u07_id
      FROM u21_login_trading_restriction u21
           INNER JOIN v31_restriction v31
               ON v31.v31_id = u21.u21_restriction_type_id_v31
           INNER JOIN u10_login_trading_acc u10
               ON u10.u10_id = u21.u21_login_id_u10
           INNER JOIN u07_trading_account u07
               ON u07.u07_id = u10.u10_trading_acc_id_u07
           INNER JOIN u01_customer u01
               ON u01.u01_id = u07.u07_customer_id_u01
           INNER JOIN u09_customer_login u09
               ON u10.u10_login_id_u09 = u09.u09_id
/