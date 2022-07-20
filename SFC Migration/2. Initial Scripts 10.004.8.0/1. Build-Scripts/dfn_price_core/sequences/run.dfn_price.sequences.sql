spool log.run.dfn_price.sequences replace

whenever sqlerror exit
set echo off
set define off
set sqlblanklines on

select 'seq_announcements_id' as sequence_name from dual;
@@dfn_price.seq_announcements_id.seq.sql
select 'seq_esp_news_id' as sequence_name from dual;
@@dfn_price.seq_esp_news_id.seq.sql


spool off
