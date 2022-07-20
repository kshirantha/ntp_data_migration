SPOOL log.run.dfn_ntp.package REPLACE

WHENEVER SQLERROR EXIT
SET ECHO OFF
SET DEFINE OFF
SET SQLBLANKLINES ON

SELECT 'pkg_dc_common2' AS package_name FROM DUAL;

@@dfn_ntp.pkg_dc_common2.pkg.sql

SELECT 'pkg_bsf' AS package_name FROM DUAL;

@@dfn_ntp.pkg_bsf.pkg.sql

SELECT 'pkg_sfc_ams_inquiries' AS package_name FROM DUAL;

@@dfn_ntp.pkg_sfc_ams_inquiries.pkg.sql

SELECT 'pkg_sfc_b2b_inquiries' AS package_name FROM DUAL;

@@dfn_ntp.pkg_sfc_b2b_inquiries.pkg.sql

SELECT 'pkg_dc_synchronize' AS package_name FROM DUAL;

@@dfn_ntp.pkg_dc_synchronize.pkg.sql

SELECT 'pkg_csm' AS package_name FROM DUAL;

@@dfn_ntp.pkg_csm.pkg.sql


SPOOL OFF
