DECLARE
    l_inst_order_channel_id   NUMBER;
    l_sqlerrm                 VARCHAR2 (4000);
BEGIN
    SELECT NVL (MAX (m68_id), 0)
      INTO l_inst_order_channel_id
      FROM dfn_ntp.m68_institute_order_channels;

    DELETE FROM error_log
          WHERE mig_table = 'M68_INSTITUTE_ORDER_CHANNELS';

    FOR i
        IN (SELECT v29.v29_id, m02_map.new_institute_id, m68.m68_id
              FROM dfn_ntp.v29_order_channel v29, -- [Existing Order Channels are Added as No Source is Avaliable]
                   m02_institute_mappings m02_map, -- [Cross Join - Repeating for each Institution]
                   dfn_ntp.m68_institute_order_channels m68
             WHERE     m02_map.new_institute_id =
                           m68.m68_institution_id_m02(+)
                   AND v29.v29_id = m68.m68_channel_id_v29(+))
    LOOP
        BEGIN
            IF i.m68_id IS NULL
            THEN
                l_inst_order_channel_id := l_inst_order_channel_id + 1;

                INSERT
                  INTO dfn_ntp.m68_institute_order_channels (
                           m68_id,
                           m68_channel_id_v29,
                           m68_institution_id_m02,
                           m68_ignore_commision_discount,
                           m68_custom_type)
                VALUES (l_inst_order_channel_id, -- m68_id
                        i.v29_id, -- m68_channel_id_v29
                        i.new_institute_id, -- m68_institution_id_m02
                        0, -- m68_ignore_commision_discount | Not Available
                        '1'); -- m68_custom_type
            ELSE
                UPDATE dfn_ntp.m68_institute_order_channels
                   SET m68_ignore_commision_discount = 0 -- m68_ignore_commision_discount
                 WHERE m68_id = i.m68_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'M68_INSTITUTE_ORDER_CHANNELS',
                                i.v29_id,
                                CASE
                                    WHEN i.m68_id IS NULL
                                    THEN
                                        l_inst_order_channel_id
                                    ELSE
                                        i.m68_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.m68_id IS NULL THEN 'INSERT'
                                    ELSE 'UPDATE'
                                END,
                                SYSDATE);
        END;
    END LOOP;
END;
/
