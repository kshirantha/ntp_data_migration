BEGIN
    DBMS_STATS.gather_schema_stats (
        ownname            => 'DFN_PRICE',
        estimate_percent   => DBMS_STATS.auto_sample_size,
        cascade            => TRUE,
        degree             => 3);
END;
/