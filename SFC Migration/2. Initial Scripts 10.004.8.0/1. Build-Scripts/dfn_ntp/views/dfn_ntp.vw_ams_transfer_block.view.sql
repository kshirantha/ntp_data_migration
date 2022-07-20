CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_ams_transfer_block
(
    id,
    blockedamount,
    fromdate,
    todate,
    narration,
    status,
    createddate,
    userid,
    externalref,
    created_by,
    custname
)
AS
      SELECT t10_id AS id,
             t10_amount_blocked AS blockedamount,
             t10_from_date AS fromdate,
             t10_to_date AS todate,
             t10_reason_for_block AS narration,
             t10_status AS status,
             t10_created_date AS createddate,
             t10_created_by AS userid,
             u06.u06_investment_account_no AS externalref,
             u17.u17_full_name AS created_by,
             u01_display_name AS custname
        FROM t10_cash_block_request t10
             INNER JOIN u06_cash_account u06
                 ON u06.u06_id = t10.t10_cash_account_id_u06
             INNER JOIN u17_employee u17
                 ON u17.u17_id = t10_created_by
             INNER JOIN u01_customer u01
                 ON u01.u01_id = u06.u06_customer_id_u01 AND t10_type = 2
    ORDER BY t10.t10_id DESC
/
