CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_custodian_trade_rejection
(
    t01_cl_ord_id,
    t01_orig_cl_ord_id,
    t01_ord_no,
    t01_exchange_ord_id,
    t01_price_inst_type,
    t01_date,
    t01_last_updated_date_time,
    t01_symbol_code_m20,
    t01_exchange_code_m01,
    t01_price,
    t01_avg_price,
    t01_cum_netstl,
    t01_institution_id_m02,
    t01_trading_acc_id_u07,
    t01_cum_quantity,
    status,
    status_lang,
    order_type,
    order_type_lang,
    order_side,
    u07_display_name,
    u01_customer_no,
    customer_name,
    order_channel,
    dealer_name,
    u06_external_ref_no,
    u01_external_ref_no,
    gtd,
    reject_reason,
    exec_broker,
    order_mode,
    t18_trade_date_75,
    t18_settlement_date_9746,
    t18_trade_value_900,
    t18_currency,
    t18_cash_comp_date,
    t18_u_message_type,
    t18_order_exec_id_t02,
    t18_price,
    t18_shares
)
AS
    SELECT t01.t01_cl_ord_id,                                  -- t01_clordid,
           CASE
               WHEN t01.t01_orig_cl_ord_id > 0 THEN t01.t01_orig_cl_ord_id
           END                                              -- t01_origclordid
               AS t01_orig_cl_ord_id,
           t01.t01_ord_no,                                     -- t01_orderno,
           t01.t01_exchange_ord_id,                             -- t01_orderid
           t01.t01_price_inst_type,                       -- t01_security_type
           t01.t01_date,                                    -- t01_createddate
           t01.t01_last_updated_date_time,                 -- t01_last_updated
           t01.t01_symbol_code_m20,                       -- t01_symbol,    ??
           t01.t01_exchange_code_m01,           -- t01_exchange,            ??
           t01.t01_price,                                    -- t01_lastpx, ??
           t01.t01_avg_price,                                    -- t01_avgpx,
           -- a.t01_netsettle AS t01_cumnetsettle,
           t01.t01_cum_netstl,                   --   /   t01_ord_net_settle ?
           t01.t01_institution_id_m02,
           t01.t01_trading_acc_id_u07,
           CASE
               WHEN t01.t01_cum_quantity > 0 THEN t01.t01_cum_quantity
               ELSE 0
           END
               AS t01_cum_quantity,                              -- t01_cumqty
           v30.v30_description AS status,                 -- m16_descriotion_1
           v30.v30_description_lang AS status_lang,
           v06.v06_description_1 AS order_type,          -- m14_description_1,
           v06.v06_description_2 AS order_type_lang,
           CASE t01.t01_side WHEN 1 THEN 'Buy' WHEN 2 THEN 'Sell' END
               AS order_side,                   -- ok        m13_description_1
           u07.u07_display_name,                      --u05_accountno, ???????
           u01.u01_customer_no,                     -- m01_c1_customer_id, ???
           --NVL (f.m01_c1_other_names, '') || ' ' || NVL (f.m01_c1_last_name, '')
           --  AS custname,
           u01.u01_display_name AS customer_name,
           -- u01.u01_display_name_lang AS customer_name_lang,

           -- t01.t01_leavesqty,         -- Samurdhi W

           CASE t01.t01_ord_channel_id_v29                      -- t01_channel
               WHEN 0 THEN 'External'
               WHEN 1 THEN 'Web'
               WHEN 2 THEN 'TWS'
               WHEN 3 THEN 'AT'
               WHEN 4 THEN 'Manual'
               WHEN 5 THEN 'FIX'
               WHEN 6 THEN 'TWS'
               WHEN 7 THEN 'AT'
               WHEN 8 THEN 'Cond'
               WHEN 9 THEN 'Mobile'
               WHEN 10 THEN 'IVR'
               WHEN 11 THEN 'Applet'
               WHEN 12 THEN 'DT'
               WHEN 14 THEN 'TWS'
               WHEN 15 THEN 'BB'
               WHEN 16 THEN 'iPhone'
               WHEN 17 THEN 'iPad'
               WHEN 18 THEN 'Android'
               WHEN 19 THEN 'ATM'
               WHEN 20 THEN 'LOS'
               WHEN 21 THEN 'Bank IVR'
               WHEN 22 THEN 'Internet'
               WHEN 23 THEN 'PB'
               WHEN 24 THEN 'SELF TRADE'
               WHEN 25 THEN 'Surface'
           END
               AS order_channel,                           -- m44_description,
           /*UPPER (
               TRIM (
                      NVL (m06_createdby.m06_other_names, '')
                   || ' '
                   || NVL (m06_createdby.m06_last_name, '')))
               AS dealername,*/
           u17_created_by.u17_full_name AS dealer_name,
           u06.u06_external_ref_no,                 -- t03_external_reference,
           u01.u01_external_ref_no,                    -- m01_external_ref_no,
           v10.v10_description AS gtd,                     -- m117_description
           CASE
               WHEN (    t01.t01_status_id_v30 = '8'
                     AND INSTR (t01.t01_reject_reason, '|') <> 0) -- t01_ordstatus   t01_text
               THEN
                   SUBSTR (t01.t01_reject_reason,
                           0,
                           INSTR (t01.t01_reject_reason, '|') - 1)
               WHEN t01.t01_status_id_v30 = '8'
               THEN
                   t01.t01_reject_reason
           END
               AS reject_reason,                                         -- ok
           m26.m26_name AS exec_broker,                    -- ex01_b.ex01_name
           CASE
               WHEN t01.t01_order_mode = 1 THEN 'Offline'
               WHEN t01.t01_order_mode = 0 THEN 'Online'
           END
               AS order_mode,                                            -- ok
           /*CASE
               WHEN t01.t01_independent_custody_id = 0 THEN 'None' -- t01_custodian_id_m26  ??
               WHEN t01.t01_independent_custody_id <> 0 THEN 'ICM'
           END
               AS custody,*/
           -- Samurdhi W

           t18.t18_trade_date_75,                        -- t83_trade_date_75,
           t18.t18_settlement_date_9746,          -- t83_settlement_date_9746,
           t18.t18_trade_value_900,                     -- t83_trade_value_900
           t18.t18_currency,                                   -- t83_currency
           t18.t18_cash_comp_date,                       -- t83_cash_comp_date
           t18.t18_u_message_type,                       -- t83_u_message_type
           t18.t18_order_exec_id_t02,                       -- t83_t11_exec_id
           t18.t18_price,                                         -- t83_price
           t18.t18_shares                                        -- t83_shares
      /*FROM t01_order t01,                     -- t01_order_summary_intraday_all a,
           -- v30_order_status v30,                            -- m16_order_status b,
           -- v06_order_type v06,                                -- m14_order_type c,
           -- u07_trading_account u07,                    -- u05_security_accounts e,
           -- u01_customer u01,                                    -- m01_customer f,
           -- u06_cash_account u06,                            -- t03_cash_account g,
           -- v10_tif v10,                                           -- m117_tif tif,
           -- u17_employee u17_created_by,            -- m06_employees m06_createdby,
           -- m26_executing_broker m26,         -- ex01_executing_institution ex01_b,
           -- t18_c_umessage t18                                 -- t83_u_message t83
     WHERE     -- t01.t01_status_id_v30 = v30.v30_status_id -- a.t01_ordstatus = b.m16_status_id
           -- AND t01.t01_ord_type_id_v06 = v06.v06_type_id -- a.t01_ordertype = c.m14_type_id
           -- AND t01.t01_trading_acc_id_u07 = u07.u07_id -- a.t01_security_ac_id = e.u05_id
           -- AND u07.u07_customer_id_u01 = u01.u01_id -- e.u05_customer_id = f.m01_customer_id
           -- AND u07.u07_cash_account_id_u06 = u06.u06_id -- e.u05_cash_account_id = g.t03_account_id
           -- AND t01.t01_tif_id_v10 = v10.v10_id(+) -- a.t01_timeinforce = tif.m117_id(+)
           -- AND t01.t01_dealer_id_u17 = u17_created_by.u17_id(+) -- a.t01_userid = m06_createdby.m06_login_id(+)
           -- AND t01.t01_exec_broker_id_m26 = m26.m26_id(+) -- a.t01_exec_broker_inst = ex01_b.ex01_id(+)
           -- AND t01.t01_cl_ord_id = t18.t18_clordid_t01 -- a.t01_orderid = t83.t83_t01_clordid*/

      FROM t01_order t01
           JOIN v30_order_status v30
               ON t01.t01_status_id_v30 = v30.v30_status_id
           JOIN v06_order_type v06
               ON t01.t01_ord_type_id_v06 = v06.v06_type_id
           JOIN u07_trading_account u07
               ON t01.t01_trading_acc_id_u07 = u07.u07_id
           JOIN u01_customer u01
               ON u07.u07_customer_id_u01 = u01.u01_id
           JOIN u06_cash_account u06
               ON u07.u07_cash_account_id_u06 = u06.u06_id
           LEFT JOIN v10_tif v10
               ON t01.t01_tif_id_v10 = v10.v10_id
           LEFT JOIN u17_employee u17_created_by
               ON t01.t01_dealer_id_u17 = u17_created_by.u17_id
           LEFT JOIN m26_executing_broker m26
               ON t01.t01_exec_broker_id_m26 = m26.m26_id
           LEFT JOIN t18_c_umessage t18
               ON t01.t01_cl_ord_id = t18.t18_clordid_t01;
/
