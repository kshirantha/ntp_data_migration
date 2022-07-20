spool log.run.dfn_price.tables replace

whenever sqlerror exit
set echo off
set define off
set sqlblanklines on

select 'esp_exchangemaster' as table_name from dual;
@@dfn_price.esp_exchangemaster.tab.sql
select 'esp_symbolmap' as table_name from dual;
@@dfn_price.esp_symbolmap.tab.sql
select 'esp_indicies' as table_name from dual;
@@dfn_price.esp_indicies.tab.sql
select 'esp_intraday_combine_trades' as table_name from dual;
@@dfn_price.esp_intraday_combine_trades.tab.sql
select 'esp_intraday_ohlc' as table_name from dual;
@@dfn_price.esp_intraday_ohlc.tab.sql
select 'esp_intraday_trades' as table_name from dual;
@@dfn_price.esp_intraday_trades.tab.sql
select 'esp_marketdepth' as table_name from dual;
@@dfn_price.esp_marketdepth.tab.sql
select 'esp_todays_snapshots' as table_name from dual;
@@dfn_price.esp_todays_snapshots.tab.sql
select 'esp_transactions_complete' as table_name from dual;
@@dfn_price.esp_transactions_complete.tab.sql
select 'esp_language_master' as table_name from dual;
@@dfn_price.esp_language_master.tab.sql
select 'sys_version' as table_name from dual;
@@dfn_price.sys_version.tab.sql
select 'announcements' as table_name from dual;
@@dfn_price.announcements.tab.sql
select 'esp_symbolmap_descriptions' as table_name from dual;
@@dfn_price.esp_symbolmap_descriptions.tab.sql
select 'esp_news' as table_name from dual;
@@dfn_price.esp_news.tab.sql
select 'esp_investors' as table_name from dual;
@@dfn_price.esp_investors.tab.sql
select 'esp_periodic_indicators' as table_name from dual;
@@dfn_price.esp_periodic_indicators.tab.sql
select 'eod_snapshot' as table_name from dual;
@@dfn_price.eod_snapshot.tab.sql
select 'esp_instrument_types' as table_name from dual;
@@dfn_price.esp_instrument_types.tab.sql
select 'esp_sectors_descriptions' as table_name from dual;
@@dfn_price.esp_sectors_descriptions.tab.sql
select 'esp_markets_descriptions' as table_name from dual;
@@dfn_price.esp_markets_descriptions.tab.sql
select 'esp_exchange_descriptions' as table_name from dual;
@@dfn_price.esp_exchange_descriptions.tab.sql
select 'esp_symbolmap_desc_cust' as table_name from dual;
@@dfn_price.esp_symbolmap_desc_cust.tab.sql
select 'esp_symbolmap_cust' as table_name from dual;
@@dfn_price.esp_symbolmap_cust.tab.sql
select 'esp_sectors' as table_name from dual;
@@dfn_price.esp_sectors.tab.sql
select 'esp_markets' as table_name from dual;
@@dfn_price.esp_markets.tab.sql


spool off
