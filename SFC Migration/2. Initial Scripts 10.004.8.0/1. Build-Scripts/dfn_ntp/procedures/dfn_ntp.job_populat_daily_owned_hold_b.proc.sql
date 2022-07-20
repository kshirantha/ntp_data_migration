CREATE OR REPLACE PROCEDURE dfn_ntp.job_populat_daily_owned_hold_b
IS
    l_dependant_job_status   NUMBER;
    l_dependant_job          VARCHAR (100);
    l_current_job_id         NUMBER;
    l_current_job_log_id     NUMBER;
    l_h101_id                NUMBER := 0;
    l_h102_id                NUMBER := 0;
    l_t58_id                 NUMBER := 0;
BEGIN
    SELECT v07_id
      INTO l_current_job_id
      FROM v07_db_jobs
     WHERE v07_job_name = 'DAILY_OWNED_HOLDING_B';

    job_sch_verify_job_dependancy (l_dependant_job_status,
                                   l_dependant_job,
                                   l_current_job_id);

    IF (l_dependant_job_status > 0)
    THEN
        job_sch_insert_job_history (l_current_job_log_id, l_current_job_id);

        DELETE FROM h102_daily_other_owned_hld_b;

        DELETE FROM h101_daily_owned_holding_b;

        COMMIT;

        FOR i
            IN (  SELECT u24_symbol_code_m20,
                         u24_exchange_code_m01,
                         m20.m20_id,
                         m20.m20_exchange_id_m01,
                         SUM (u24_net_holding) u24_net_holding
                    FROM u24_holdings u24, m20_symbol m20
                   WHERE     m20.m20_symbol_code = u24.u24_symbol_code_m20
                         AND m20.m20_exchange_code_m01 =
                                 u24.u24_exchange_code_m01
                         AND u24_net_holding > 0
                GROUP BY u24_symbol_code_m20,
                         u24_exchange_code_m01,
                         m20.m20_exchange_id_m01,
                         m20.m20_id)
        LOOP
            l_h101_id := l_h101_id + 1;

            INSERT INTO h101_daily_owned_holding_b (h101_id,
                                                    h101_exchange_id_m01,
                                                    h101_exchange_code_m01,
                                                    h101_symbol_id_m20,
                                                    h101_symbol_code_m20,
                                                    h101_holding)
                 VALUES (l_h101_id,
                         i.m20_exchange_id_m01,
                         i.u24_exchange_code_m01,
                         i.m20_id,
                         i.u24_symbol_code_m20,
                         i.u24_net_holding);
        END LOOP;

        COMMIT;


        FOR i IN (SELECT h101_id,
                         h101_exchange_id_m01,
                         h101_exchange_code_m01,
                         h101_symbol_id_m20,
                         h101_symbol_code_m20
                    FROM h101_daily_owned_holding_b)
        LOOP
            FOR j
                IN (  SELECT u24_symbol_code_m20,
                             u24_symbol_id_m20,
                             SUM (u24_net_holding) u24_net_holding
                        FROM u24_holdings a
                       WHERE     a.u24_trading_acnt_id_u07 IN
                                     (SELECT u24.u24_trading_acnt_id_u07
                                        FROM u24_holdings u24
                                       WHERE     u24_symbol_id_m20 =
                                                     i.h101_symbol_id_m20
                                             AND u24_exchange_code_m01 =
                                                     i.h101_exchange_code_m01)
                             AND u24_symbol_id_m20 <> i.h101_symbol_id_m20
                             AND u24_net_holding > 0
                             AND ROWNUM < 25
                    GROUP BY u24_symbol_code_m20, u24_symbol_id_m20
                    ORDER BY u24_net_holding DESC)
            LOOP
                l_h102_id := l_h102_id + 1;

                INSERT
                  INTO h102_daily_other_owned_hld_b (h102_id,
                                                     h102_daily_owned_id_h101,
                                                     h102_exchange_id_m01,
                                                     h102_exchange_code_m01,
                                                     h102_symbol_id_m20,
                                                     h102_symbol_code_m20,
                                                     h102_holding)
                VALUES (l_h102_id,
                        i.h101_id,
                        i.h101_exchange_id_m01,
                        i.h101_exchange_code_m01,
                        j.u24_symbol_id_m20,
                        j.u24_symbol_code_m20,
                        j.u24_net_holding);
            END LOOP;
        END LOOP;

        SELECT MAX (t58_id) + 1 INTO l_t58_id FROM t58_cache_clear_request;

        INSERT INTO t58_cache_clear_request (t58_id,
                                             t58_table_id,
                                             t58_store_keys_json,
                                             t58_clear_all,
                                             t58_custom_type,
                                             t58_status,
                                             t58_created_date,
                                             t58_priority,
                                             t58_server_id)
             VALUES (l_t58_id,
                     'H101_DAILY_OWNED_HOLDING_B',
                     NULL,
                     1,
                     1,
                     0,
                     SYSDATE,
                     0,
                     NULL);

        UPDATE app_seq_store
           SET app_seq_value = l_t58_id
         WHERE app_seq_name = 'T58_CACHE_CLEAR_REQUEST';

        COMMIT;

        job_sch_update_job_history (
            l_current_job_id,
            l_current_job_log_id,
            1,
            'DAILY_OWNED_HOLDING_B Executed Successfully');
    ELSE
        job_sch_update_job_history (
            l_current_job_id,
            l_current_job_log_id,
            3,
               'ERROR!!! Dependancy Job '
            || l_dependant_job
            || ' Not Executed! Current Job DAILY_OWNED_HOLDING_B Will Not Execute');

        job_sch_send_notification (
               'ERROR!!! Dependancy Job '
            || l_dependant_job
            || ' Not Executed! Current Job DAILY_OWNED_HOLDING_B Will Not Execute');
    END IF;
EXCEPTION
    WHEN OTHERS
    THEN
        COMMIT;

        job_sch_update_job_history (l_current_job_id,
                                    l_current_job_log_id,
                                    3,
                                    SUBSTR (SQLERRM, 1, 512));

        job_sch_send_notification (
               'ERROR!!! DAILY_OWNED_HOLDING_B Execution Failed -> '
            || SUBSTR (SQLERRM, 1, 512));
END;
/
