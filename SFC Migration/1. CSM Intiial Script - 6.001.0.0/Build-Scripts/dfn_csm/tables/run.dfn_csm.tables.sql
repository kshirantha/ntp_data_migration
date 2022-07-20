spool log.run.dfn_csm.tables replace

whenever sqlerror exit
set echo off
set define off
set sqlblanklines on

@@dfn_csm.a00_trade_capture_report.tab.sql
@@dfn_csm.a01_trade_request_list.tab.sql
@@dfn_csm.a02_trade_request_list_details.tab.sql
@@dfn_csm.a03_message_audit.tab.sql
@@dfn_csm.a04_mt_messages.tab.sql
@@dfn_csm.a04_settlement_instruction.tab.sql
@@dfn_csm.a05_trade_rec_notif.tab.sql
@@dfn_csm.a07_settlement_req.tab.sql
@@dfn_csm.a08_margin_requirement_request.tab.sql
@@dfn_csm.a09_margin_requirement_report.tab.sql
@@dfn_csm.a10_collateral_inquiry.tab.sql
@@dfn_csm.a11_collateral_report.tab.sql
@@dfn_csm.a12_collateral_assignment.tab.sql
@@dfn_csm.a13_settlement_position_req.tab.sql
@@dfn_csm.a14_settlement_position_rep.tab.sql
@@dfn_csm.a15_aggregate_list.tab.sql
@@dfn_csm.m01_trading_sessions.tab.sql
@@dfn_csm.m02_margin_types.tab.sql
@@dfn_csm.m03_users.tab.sql
@@dfn_csm.m04_aud_activity.tab.sql
@@dfn_csm.m05_clearing_firm.tab.sql
@@dfn_csm.m06_collateral_amount_type.tab.sql
@@dfn_csm.m07_clearing_member_details.tab.sql
@@dfn_csm.s01_db_jobs.tab.sql
@@dfn_csm.s02_db_jobs_execution_log.tab.sql
@@dfn_csm.t01_execution_details.tab.sql
@@dfn_csm.t02_trade_capture_request.tab.sql
@@dfn_csm.t03_audit.tab.sql
@@dfn_csm.t04_share_transfer.tab.sql
@@dfn_csm.t05_pledge_transfer.tab.sql

spool off
