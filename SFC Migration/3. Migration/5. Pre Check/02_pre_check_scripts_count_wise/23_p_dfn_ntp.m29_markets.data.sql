DECLARE
    l_source_count   NUMBER;
    l_error_count    NUMBER := 0;
    l_rec_count      NUMBER;
BEGIN
    SELECT num_rows
      INTO l_source_count
      FROM all_tables@mubasher_db_link
     WHERE owner = 'MUBASHER_OMS' AND table_name = 'M115_SUB_MARKETS';

    ----------- No Default Market For Exchange -----------

    FOR i IN (SELECT DISTINCT m115_exchange
                FROM mubasher_oms.m115_sub_markets@mubasher_db_link m115)
    LOOP
        SELECT COUNT (*)
          INTO l_rec_count
          FROM mubasher_oms.m115_sub_markets@mubasher_db_link m115
         WHERE m115_exchange = i.m115_exchange AND m115_is_default = 1;

        IF (l_rec_count = 0)
        THEN
            SELECT COUNT (*)
              INTO l_rec_count
              FROM mubasher_oms.m115_sub_markets@mubasher_db_link m115
             WHERE m115_exchange = i.m115_exchange;

            IF l_rec_count > 1
            THEN
                l_error_count := l_error_count + 1;
            ELSE
                NULL; -- The Only One will be Marked as Default during Migration
            END IF;
        END IF;
    END LOOP;

    INSERT INTO pre_check_table_count_wise (target_table,
                                            source_table,
                                            source_count,
                                            error_count,
                                            error_reason)
         VALUES ('M29_MARKETS',
                 'M115_SUB_MARKETS',
                 l_source_count,
                 l_error_count,
                 '(M115_IS_DEFAULT) NOT DEFINED FOR EXCHANGES');
END;
/