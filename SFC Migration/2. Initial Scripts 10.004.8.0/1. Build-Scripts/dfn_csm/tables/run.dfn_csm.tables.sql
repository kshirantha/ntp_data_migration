SPOOL log.run.dfn_csm.tables REPLACE

WHENEVER SQLERROR EXIT
SET ECHO OFF
SET DEFINE OFF
SET SQLBLANKLINES ON

SELECT 'a01_trade_request_list' AS table_name FROM DUAL;

@@dfn_csm.a01_trade_request_list.tab.sql

SELECT 'a15_aggregate_list' AS table_name FROM DUAL;

@@dfn_csm.a15_aggregate_list.tab.sql

SELECT 'a05_trade_rec_notif' AS table_name FROM DUAL;

@@dfn_csm.a05_trade_rec_notif.tab.sql

SELECT 'a13_settlement_position_req' AS table_name FROM DUAL;

@@dfn_csm.a13_settlement_position_req.tab.sql

SPOOL OFF
