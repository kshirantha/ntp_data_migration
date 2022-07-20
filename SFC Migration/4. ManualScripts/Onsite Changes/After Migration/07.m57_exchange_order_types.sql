/* Formatted on 24-Dec-2020 12:01:52 (QP5 v5.206) */
DECLARE
BEGIN
    UPDATE dfn_ntp.app_seq_store
       SET app_seq_value = 0
     WHERE app_seq_name = 'M57_EXCHANGE_ORDER_TYPES';

    DELETE dfn_ntp.m57_exchange_order_types;

    COMMIT;

    DELETE dfn_ntp.v06_order_type
     WHERE v06_type_id NOT IN ('1', '2');

    COMMIT;

    FOR i IN (SELECT m01_id, m01_exchange_code FROM dfn_ntp.m01_exchanges)
    LOOP
        FOR j IN (SELECT v06_type_id FROM dfn_ntp.v06_order_type)
        LOOP
            INSERT INTO dfn_ntp.m57_exchange_order_types (m57_id,
                                                  m57_exchange_id_m01,
                                                  m57_order_type_id_v06,
                                                  m57_exchange_code_m01,
                                                  m57_custom_type)
                 VALUES (dfn_ntp.fn_get_next_sequnce ('M57_EXCHANGE_ORDER_TYPES'),
                         i.m01_id,
                         j.v06_type_id,
                         i.m01_exchange_code,
                         '1');
        END LOOP;
    END LOOP;
END;
/
commit;
