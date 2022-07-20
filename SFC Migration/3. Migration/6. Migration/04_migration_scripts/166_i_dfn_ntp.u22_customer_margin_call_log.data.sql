DECLARE
    l_cust_margin_call_log_id   NUMBER;
    l_sqlerrm                   VARCHAR2 (4000);
BEGIN
    SELECT NVL (MAX (u22_id), 0)
      INTO l_cust_margin_call_log_id
      FROM dfn_ntp.u22_customer_margin_call_log;

    DELETE FROM error_log
          WHERE mig_table = 'U22_CUSTOMER_MARGIN_CALL_LOG';

    FOR i
        IN (SELECT u23_map.new_cust_margin_prod_id,
                   u24.u24_id,
                   u24.u24_date,
                   u24.u24_type, -- [SAME IDs]
                   u24.u24_utilized_amount,
                   u24.u24_utilized_percentage,
                   u24.u24_top_up_amount,
                   u22_map.new_cust_mrg_call_log_id
              FROM mubasher_oms.u24_cust_margin_notifications@mubasher_db_link u24,
                   u23_cust_margin_prod_mappings u23_map,
                   u22_cust_mrg_call_log_mappings u22_map
             WHERE     u24.u24_cust_margin_product =
                           u23_map.old_cust_margin_prod_id
                   AND u24.u24_id = u22_map.old_cust_mrg_call_log_id(+))
    LOOP
        BEGIN
            IF i.new_cust_mrg_call_log_id IS NULL
            THEN
                l_cust_margin_call_log_id := l_cust_margin_call_log_id + 1;

                INSERT
                  INTO dfn_ntp.u22_customer_margin_call_log (
                           u22_id,
                           u22_margin_prdouct_id_u23,
                           u22_date,
                           u22_type,
                           u22_utilized_amount,
                           u22_utilized_percentage,
                           u22_top_up_amount,
                           u22_cash_balance,
                           u22_block_amount,
                           u22_margin_blocked,
                           u22_rapv)
                VALUES (l_cust_margin_call_log_id, -- u22_id
                        i.new_cust_margin_prod_id, -- u22_margin_prdouct_id_u23
                        i.u24_date, -- u22_date
                        i.u24_type, -- u22_type
                        i.u24_utilized_amount, -- u22_utilized_amount
                        i.u24_utilized_percentage, -- u22_utilized_percentage
                        i.u24_top_up_amount, -- u22_top_up_amount
                        0, -- u22_cash_balance | Old Log Records Not Required to be Updated in Post Migration
                        0, -- u22_block_amount | Old Log Records Not Required to be Updated in Post Migration
                        0, -- u22_margin_blocked | Old Log Records Not Required to be Updated in Post Migration
                        0 -- u22_rapv | Old Log Records Not Required to be Updated in Post Migration
                         );

                INSERT INTO u22_cust_mrg_call_log_mappings
                     VALUES (i.u24_id, l_cust_margin_call_log_id);
            ELSE
                UPDATE dfn_ntp.u22_customer_margin_call_log
                   SET u22_margin_prdouct_id_u23 =
                           i.new_cust_margin_prod_id, -- u22_margin_prdouct_id_u23
                       u22_date = i.u24_date, -- u22_date
                       u22_type = i.u24_type, -- u22_type
                       u22_utilized_amount = i.u24_utilized_amount, -- u22_utilized_amount
                       u22_utilized_percentage = i.u24_utilized_percentage, -- u22_utilized_percentage
                       u22_top_up_amount = i.u24_top_up_amount -- u22_top_up_amount
                 WHERE u22_id = i.new_cust_mrg_call_log_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'U22_CUSTOMER_MARGIN_CALL_LOG',
                                i.u24_id,
                                CASE
                                    WHEN i.new_cust_mrg_call_log_id
                                             IS NULL
                                    THEN
                                        l_cust_margin_call_log_id
                                    ELSE
                                        i.new_cust_mrg_call_log_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_cust_mrg_call_log_id
                                             IS NULL
                                    THEN
                                        'INSERT'
                                    ELSE
                                        'UPDATE'
                                END,
                                SYSDATE);
        END;
    END LOOP;
END;
/
