CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_confirm_rollback_approvals
(
    t64_id,
    u01_customer_no,
    u01_display_name,
    u06_display_name,
    u07_display_name,
    t64_trade_confirm_no,
    t64_status_id_v01,
    t63_institute_id_m02,
    t63_exchange_id_m01,
    t63_created_by_id_u17,
    t63_created_date,
    t64_status_changed_by_id_u17,
    t64_status_changed_date,
    status_description,
    created_by_full_name,
    status_changed_by_full_name
)
AS
      SELECT MAX (t64.t64_id) AS t64_id,
             MAX (u01.u01_customer_no) AS u01_customer_no,
             MAX (u01.u01_display_name) AS u01_display_name,
             MAX (u06.u06_display_name) AS u06_display_name,
             MAX (u07.u07_display_name) AS u07_display_name,
             t64.t64_trade_confirm_no,
             t64.t64_status_id_v01,
             MAX (t63.t63_institute_id_m02) AS t63_institute_id_m02,
             MAX (t63.t63_exchange_id_m01) AS t63_exchange_id_m01,
             MAX (t63.t63_created_by_id_u17) AS t63_created_by_id_u17,
             MAX (t63.t63_created_date) AS t63_created_date,
             MAX (t64.t64_status_changed_by_id_u17)
                 AS t64_status_changed_by_id_u17,
             MAX (t64.t64_status_changed_date) AS t64_status_changed_date,
             MAX (status_list.v01_description) AS status_description,
             MAX (u17_created_by.u17_full_name) AS created_by_full_name,
             MAX (u17_status_changed_by.u17_full_name)
                 AS status_changed_by_full_name
        FROM t63_tc_request_list t63
             INNER JOIN t64_trade_confirmation_list t64
                 ON t63.t63_id = t64.t64_tc_request_id_t63
             INNER JOIN t02_transaction_log t02
                 ON t02.t02_trade_confirm_no = t64.t64_trade_confirm_no
             INNER JOIN u01_customer u01
                 ON u01.u01_id = t02.t02_customer_id_u01
             INNER JOIN u06_cash_account u06
                 ON u06.u06_id = t02.t02_cash_acnt_id_u06
             INNER JOIN u07_trading_account u07
                 ON u07.u07_id = t02.t02_trd_acnt_id_u07
             INNER JOIN u17_employee u17_created_by
                 ON t63.t63_created_by_id_u17 = u17_created_by.u17_id
             LEFT JOIN u17_employee u17_status_changed_by
                 ON t64.t64_status_changed_by_id_u17 =
                        u17_status_changed_by.u17_id
             LEFT JOIN vw_status_list status_list
                 ON t64.t64_status_id_v01 = status_list.v01_id
       WHERE t63.t63_type = 2
    GROUP BY t64.t64_trade_confirm_no, t64.t64_status_id_v01
    ORDER BY t64.t64_trade_confirm_no
/