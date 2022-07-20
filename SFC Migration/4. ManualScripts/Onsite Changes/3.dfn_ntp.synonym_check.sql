CREATE OR REPLACE SYNONYM prc_sfc_ams_idb_interface FOR ams.prc_idb_interface@ntp2intg;
CREATE OR REPLACE SYNONYM cism_syno FOR cism@ntp2intg;
CREATE OR REPLACE SYNONYM crat_syno FOR crat@ntp2intg;
CREATE OR REPLACE SYNONYM proc_benf_acc_inq FOR idbuat.proc_benf_acc_inq@ntp2intg; -- in prod should change : remove 'uat'
CREATE OR REPLACE SYNONYM fn_get_sfc_iban FOR ams.func_get_sfc_iban@ntp2intg;