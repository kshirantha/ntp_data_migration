spool log.run.dfn_price.procedures replace

whenever sqlerror exit
set echo off
set define off
set sqlblanklines on

select 'sp_upd_symbolmap_desc' as procedure_name from dual;
@@dfn_price.sp_upd_symbolmap_desc.proc.sql
select 'sp_upd_sectors_desc' as procedure_name from dual;
@@dfn_price.sp_upd_sectors_desc.proc.sql
select 'sp_upd_sectors' as procedure_name from dual;
@@dfn_price.sp_upd_sectors.proc.sql
select 'sp_upd_market_data' as procedure_name from dual;
@@dfn_price.sp_upd_market_data.proc.sql
select 'sp_upd_markets_desc' as procedure_name from dual;
@@dfn_price.sp_upd_markets_desc.proc.sql
select 'sp_upd_markets' as procedure_name from dual;
@@dfn_price.sp_upd_markets.proc.sql
select 'sp_upd_exchange_master' as procedure_name from dual;
@@dfn_price.sp_upd_exchange_master.proc.sql
select 'sp_upd_exchange_details' as procedure_name from dual;
@@dfn_price.sp_upd_exchange_details.proc.sql
select 'sp_upd_exchange_desc' as procedure_name from dual;
@@dfn_price.sp_upd_exchange_desc.proc.sql
select 'sp_ins_upd_symbolmap_desc_cust' as procedure_name from dual;
@@dfn_price.sp_ins_upd_symbolmap_desc_cust.proc.sql
select 'sp_ins_upd_symbolmap_cust' as procedure_name from dual;
@@dfn_price.sp_ins_upd_symbolmap_cust.proc.sql
select 'sp_ins_upd_snapshots' as procedure_name from dual;
@@dfn_price.sp_ins_upd_snapshots.proc.sql
select 'sp_ins_upd_realtime_symbol' as procedure_name from dual;
@@dfn_price.sp_ins_upd_realtime_symbol.proc.sql
select 'sp_ins_upd_periodic_indicators' as procedure_name from dual;
@@dfn_price.sp_ins_upd_periodic_indicators.proc.sql
select 'sp_ins_upd_mkt_depth_mbps' as procedure_name from dual;
@@dfn_price.sp_ins_upd_mkt_depth_mbps.proc.sql
select 'sp_ins_upd_mkt_depth_mbp' as procedure_name from dual;
@@dfn_price.sp_ins_upd_mkt_depth_mbp.proc.sql
select 'sp_ins_upd_mkt_depth_mbo' as procedure_name from dual;
@@dfn_price.sp_ins_upd_mkt_depth_mbo.proc.sql
select 'sp_ins_upd_indicies' as procedure_name from dual;
@@dfn_price.sp_ins_upd_indicies.proc.sql
select 'sp_ins_upd_esp_news' as procedure_name from dual;
@@dfn_price.sp_ins_upd_esp_news.proc.sql
select 'sp_ins_upd_announcements' as procedure_name from dual;
@@dfn_price.sp_ins_upd_announcements.proc.sql
select 'sp_ins_ohlc_intraday_trades' as procedure_name from dual;
@@dfn_price.sp_ins_ohlc_intraday_trades.proc.sql
select 'sp_ins_intraday_trades' as procedure_name from dual;
@@dfn_price.sp_ins_intraday_trades.proc.sql
select 'sp_ins_intraday_combine_trades' as procedure_name from dual;
@@dfn_price.sp_ins_intraday_combine_trades.proc.sql
select 'sp_insert_update_symbolmap' as procedure_name from dual;
@@dfn_price.sp_insert_update_symbolmap.proc.sql
select 'sp_insert_update_investors' as procedure_name from dual;
@@dfn_price.sp_insert_update_investors.proc.sql
select 'sp_init_tday_shots_at_mkt_init' as procedure_name from dual;
@@dfn_price.sp_init_tday_shots_at_mkt_init.proc.sql
select 'sp_init_tables_at_mkt_init' as procedure_name from dual;
@@dfn_price.sp_init_tables_at_mkt_init.proc.sql
select 'sp_init_market_main' as procedure_name from dual;
@@dfn_price.sp_init_market_main.proc.sql
select 'sp_init_indicies_at_mkt_init' as procedure_name from dual;
@@dfn_price.sp_init_indicies_at_mkt_init.proc.sql
select 'sp_eod_price_data' as procedure_name from dual;
@@dfn_price.sp_eod_price_data.proc.sql
select 'sp_eod_master_data' as procedure_name from dual;
@@dfn_price.sp_eod_master_data.proc.sql
select 'sp_change_marketstatus' as procedure_name from dual;
@@dfn_price.sp_change_marketstatus.proc.sql
select 'esp_eod' as procedure_name from dual;
@@dfn_price.esp_eod.proc.sql
select 'ann_kse_is_ann_exists' as procedure_name from dual;
@@dfn_price.ann_kse_is_ann_exists.proc.sql


spool off
