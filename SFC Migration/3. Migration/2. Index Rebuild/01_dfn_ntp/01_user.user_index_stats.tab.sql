DECLARE
    l_count    NUMBER := 0;
    l_table    VARCHAR2 (50) := 'user_index_stats';
    l_map_id   VARCHAR2 (50) := '01';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || ' (
    height                 NUMBER,
    blocks                 NUMBER,
    name                   VARCHAR2 (30 BYTE),
    partition_name         VARCHAR2 (30 BYTE),
    lf_rows                NUMBER,
    lf_blks                NUMBER,
    lf_rows_len            NUMBER,
    lf_blk_len             NUMBER,
    br_rows                NUMBER,
    br_blks                NUMBER,
    br_rows_len            NUMBER,
    br_blk_len             NUMBER,
    del_lf_rows            NUMBER,
    del_lf_rows_len        NUMBER,
    distinct_keys          NUMBER,
    most_repeated_key      NUMBER,
    btree_space            NUMBER,
    used_space             NUMBER,
    pct_used               NUMBER,
    rows_per_key           NUMBER,
    blks_gets_per_access   NUMBER,
    pre_rows               NUMBER,
    pre_rows_len           NUMBER,
    opt_cmpr_count         NUMBER,
    opt_cmpr_pctsave       NUMBER,
    owner                  VARCHAR2 (30)
    )';
    END IF;
END;
/
