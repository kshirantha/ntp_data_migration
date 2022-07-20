SPOOL log.run.dfn_ntp.triggers REPLACE

WHENEVER SQLERROR EXIT
SET ECHO OFF
SET DEFINE OFF
SET SQLBLANKLINES ON

SELECT 'customer_after_update_trg' AS trigger_name FROM DUAL;

@@dfn_ntp.customer_after_update_trg.trig.sql

SELECT 'trg_z07_before_update' AS trigger_name FROM DUAL;

@@dfn_ntp.trg_z07_before_update.trig.sql

SELECT 'cash_account_after_trg' AS trigger_name FROM DUAL;

@@dfn_ntp.cash_account_after_trg.trig.sql

SELECT 'trg_z01_before_update' AS trigger_name FROM DUAL;

@@dfn_ntp.trg_z01_before_update.trig.sql

SELECT 'trg_z02_before_update' AS trigger_name FROM DUAL;

@@dfn_ntp.trg_z02_before_update.trig.sql

SELECT 'trg_z03_before_update' AS trigger_name FROM DUAL;

@@dfn_ntp.trg_z03_before_update.trig.sql

SELECT 'trg_z04_before_update' AS trigger_name FROM DUAL;

@@dfn_ntp.trg_z04_before_update.trig.sql

SELECT 'h02_trg_insert_update' AS trigger_name FROM DUAL;

@@dfn_ntp.h02_trg_insert_update.trig.sql

SELECT 'h01_trg_insert_update' AS trigger_name FROM DUAL;

@@dfn_ntp.h01_trg_insert_update.trig.sql

SELECT 'trg_z02_before_update_c' AS trigger_name FROM DUAL;

@@dfn_ntp.trg_z02_before_update_c.trig.sql

SELECT 'trg_z03_before_update_c' AS trigger_name FROM DUAL;

@@dfn_ntp.trg_z03_before_update_c.trig.sql

SELECT 'trg_z04_before_update_c' AS trigger_name FROM DUAL;

@@dfn_ntp.trg_z04_before_update_c.trig.sql

SELECT 'trg_z07_before_update_c' AS trigger_name FROM DUAL;

@@dfn_ntp.trg_z07_before_update_c.trig.sql

SELECT 'trg_z01_before_update_c' AS trigger_name FROM DUAL;

@@dfn_ntp.trg_z01_before_update_c.trig.sql

SELECT 'trg_contact_detai_after_update' AS trigger_name FROM DUAL;

@@dfn_ntp.trg_contact_detai_after_update.trig.sql


SPOOL OFF
