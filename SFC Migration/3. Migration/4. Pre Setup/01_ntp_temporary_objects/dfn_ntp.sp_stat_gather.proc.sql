CREATE OR REPLACE PROCEDURE dfn_ntp.sp_stat_gather (p_table IN VARCHAR2)
IS
BEGIN
    DBMS_STATS.gather_table_stats (
        ownname            => 'DFN_NTP',
        tabname            => p_table,
        cascade            => TRUE,
        estimate_percent   => DBMS_STATS.auto_sample_size);
END;
/

GRANT EXECUTE ON dfn_ntp.sp_stat_gather TO dfn_mig
/