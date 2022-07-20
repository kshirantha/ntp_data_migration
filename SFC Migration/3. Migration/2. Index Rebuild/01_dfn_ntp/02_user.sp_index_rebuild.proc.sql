CREATE OR REPLACE PROCEDURE sp_index_rebuild (is_rebuild NUMBER DEFAULT 1)
IS
    l_count    NUMBER;
    l_script   VARCHAR2 (4000);
    PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
    ---------------------------------------------ANALYSE INDEXES------------------------------------------------------

    BEGIN
        EXECUTE IMMEDIATE ('TRUNCATE TABLE USER_INDEX_STATS');


        FOR x IN (SELECT index_name, user AS owner
                    FROM user_indexes
                   WHERE index_type = 'NORMAL')
        LOOP
            EXECUTE IMMEDIATE
                (   'ANALYZE INDEX "'
                 || x.owner
                 || '"."'
                 || x.index_name
                 || '" VALIDATE STRUCTURE');

            EXECUTE IMMEDIATE
                   'INSERT INTO USER_INDEX_STATS SELECT S.*,'''
                || x.owner
                || ''' FROM INDEX_STATS S';
        END LOOP;

        COMMIT;
    END;

    ----------------------------------------------REBUILD INDEXES-----------------------------------------------------

    IF (is_rebuild = 1)
    THEN
        BEGIN
            FOR x
                IN (SELECT s.owner, s.name
                      FROM user_index_stats s
                     WHERE     (lf_rows > 100 AND del_lf_rows > 0)
                           AND (   height > 3
                                OR ( (del_lf_rows / lf_rows) * 100) > 20))
            LOOP
                EXECUTE IMMEDIATE
                       'ALTER INDEX "'
                    || x.owner
                    || '"."'
                    || x.name
                    || '" REBUILD PARALLEL 4';
            END LOOP;
        END;
    END IF;
END;
/