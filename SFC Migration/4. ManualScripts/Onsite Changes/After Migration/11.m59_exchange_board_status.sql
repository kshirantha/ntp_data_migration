/* Formatted on 1/12/2021 12:05:14 AM (QP5 v5.206) */
DECLARE
BEGIN
    DELETE dfn_ntp.m59_exchange_board_status;


    UPDATE dfn_ntp.app_seq_store
       SET app_seq_value = 0
     WHERE app_seq_name = 'M59_EXCHANGE_BOARD_STATUS';

    COMMIT;


    FOR i IN (SELECT m01_id, m01_exchange_code FROM dfn_ntp.m01_exchanges)
    LOOP
        FOR j IN (SELECT * FROM dfn_ntp.v19_board_status)
        LOOP
            INSERT
              INTO dfn_ntp.m59_exchange_board_status (
                       m59_id,
                       m59_exchange_id_m01,
                       m59_exchange_code_m01,
                       m59_board_status_id_v19,
                       m59_custom_type)
            VALUES (
                       dfn_ntp.fn_get_next_sequnce (
                           'M59_EXCHANGE_BOARD_STATUS'),
                       i.m01_id,
                       i.m01_exchange_code,
                       j.v19_id,
                       '1');
        END LOOP;
    END LOOP;
END;
/

commit;

