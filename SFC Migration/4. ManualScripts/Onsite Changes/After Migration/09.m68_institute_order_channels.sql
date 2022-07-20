/* Formatted on 1/12/2021 12:17:19 AM (QP5 v5.206) */
DECLARE
BEGIN
    UPDATE dfn_ntp.app_seq_store
       SET app_seq_value = 0
     WHERE app_seq_name = 'M68_INSTITUTE_ORDER_CHANNELS';

    DELETE dfn_ntp.m68_institute_order_channels;

    COMMIT;

    DELETE dfn_ntp.v29_order_channel
     WHERE v29_id NOT IN (0, 1, 4, 5, 7, 10, 12, 14, 16, 18, 19, 76, 77, 101);



    COMMIT;

    FOR j IN (SELECT v10_id FROM dfn_ntp.v10_tif)
    LOOP
        INSERT
          INTO dfn_ntp.m68_institute_order_channels (
                   m68_id,
                   m68_channel_id_v29,
                   m68_institution_id_m02,
                   m68_ignore_commision_discount,
                   m68_custom_type)
        VALUES (dfn_ntp.fn_get_next_sequnce ('M68_INSTITUTE_ORDER_CHANNELS'),
                j.v10_id,
                1,
                0,
                '1');
    END LOOP;

    COMMIT;
END;
/

COMMIT;
