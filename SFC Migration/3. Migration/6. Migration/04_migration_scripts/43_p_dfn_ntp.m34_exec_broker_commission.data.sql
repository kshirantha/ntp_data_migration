DECLARE
    l_broker_id              NUMBER;
    l_primary_institute_id   NUMBER;
    l_exec_brk_comm_id       NUMBER;
    l_sqlerrm                VARCHAR2 (4000);
BEGIN
    SELECT VALUE
      INTO l_broker_id
      FROM migration_params
     WHERE code = 'BROKERAGE_ID';

    SELECT m150.m150_primary_institute_id_m02
      INTO l_primary_institute_id
      FROM dfn_ntp.m150_broker m150
     WHERE m150.m150_id = l_broker_id;

    SELECT NVL (MAX (m34_id), 0)
      INTO l_exec_brk_comm_id
      FROM dfn_ntp.m34_exec_broker_commission;

    DELETE FROM error_log
          WHERE mig_table LIKE 'M34_EXEC_BROKER_COMMISSION';

    FOR i
        IN (SELECT m10.m10_ov_start,
                   m10.m10_ov_end,
                   m10.m10_exchange_pct_comm,
                   m10.m10_exchange_flat_comm,
                   m10.m10_min_comm,
                   m26_map.new_executing_broker_id,
                   m10.m10_instrument_type,
                   m10.m10_commission_type,
                   m10.m10_currency,
                   m10.m10_id,
                   m03.m03_id,
                   m01.m01_id,
                   v09.v09_id,
                   m10.m10_vat,
                   m10.m10_vat_charge_type,
                   m124.m124_id,
                   NVL (map16.map16_ntp_code, m10.m10_exchange)
                       AS exchange_code,
                   m34_map.new_exec_broker_comm_id
              FROM mubasher_oms.m10_exchange_commission_exec@mubasher_db_link m10,
                   dfn_ntp.m03_currency m03,
                   dfn_ntp.m124_commission_types m124,
                   (SELECT m01_id, m01_exchange_code
                      FROM dfn_ntp.m01_exchanges
                     WHERE m01_institute_id_m02 = l_primary_institute_id) m01,
                   map16_optional_exchanges_m01 map16,
                   m26_executing_broker_mappings m26_map,
                   dfn_ntp.v09_instrument_types v09,
                   m34_exec_broker_comm_mappings m34_map
             WHERE     m10.m10_currency = m03.m03_code(+)
                   AND m10.m10_exchange = map16.map16_oms_code(+)
                   AND NVL (map16.map16_ntp_code, m10.m10_exchange) =
                           m01.m01_exchange_code(+)
                   AND m10.m10_broker_id = m26_map.old_executing_broker_id(+)
                   AND m10.m10_vat_charge_type = m124.m124_value(+)
                   AND m10.m10_instrument_type = v09_code(+)
                   AND m10.m10_id = m34_map.old_exec_broker_comm_id(+))
    LOOP
        BEGIN
            IF i.m01_id IS NULL
            THEN
                raise_application_error (-20001,
                                         'Exchange Not Available',
                                         TRUE);
            END IF;

            IF i.m03_id IS NULL
            THEN
                raise_application_error (-20001,
                                         'Currency Not Available',
                                         TRUE);
            END IF;

            IF i.new_exec_broker_comm_id IS NULL
            THEN
                l_exec_brk_comm_id := l_exec_brk_comm_id + 1;

                INSERT
                  INTO dfn_ntp.m34_exec_broker_commission (
                           m34_start,
                           m34_end,
                           m34_percent,
                           m34_flat_comm,
                           m34_min_comm,
                           m34_exec_broker_id_m26,
                           m34_exchange_code_m01,
                           m34_instrument_type,
                           m34_type,
                           m34_currency_code_m03,
                           m34_id,
                           m34_currency_id_m03,
                           m34_exchange_id_m01,
                           m34_created_by_id_u17,
                           m34_created_date,
                           m34_modified_by_id_u17,
                           m34_modified_date,
                           m34_instrument_type_id_v09,
                           m34_vat_percentage,
                           m34_vat_charge_type_m124,
                           m34_custom_type,
                           m34_category)
                VALUES (i.m10_ov_start, -- m34_start
                        i.m10_ov_end, -- m34_end
                        i.m10_exchange_pct_comm, -- m34_percent
                        i.m10_exchange_flat_comm, -- m34_flat_comm
                        i.m10_min_comm, -- m34_min_comm
                        i.new_executing_broker_id, -- m34_exec_broker_id_m26
                        i.exchange_code, -- m34_exchange_code_m01
                        i.m10_instrument_type, -- m34_instrument_type
                        i.m10_commission_type, -- m34_type
                        i.m10_currency, -- m34_currency_code_m03
                        l_exec_brk_comm_id, -- m34_id
                        i.m03_id, -- m34_currency_id_m03
                        i.m01_id, -- m34_exchange_id_m01
                        0, -- m34_created_by_id_u17
                        SYSDATE, -- m34_created_date
                        NULL, -- m34_modified_by_id_u17
                        NULL, -- m34_modified_date
                        i.v09_id, -- m34_instrument_type_id_v09
                        i.m10_vat, -- m34_vat_percentage
                        i.m124_id, -- m34_vat_charge_type_m124
                        '1', -- m34_custom_type
                        0 --  m34_category | Not Available
                         );

                INSERT INTO m34_exec_broker_comm_mappings
                     VALUES (i.m10_id, l_exec_brk_comm_id);
            ELSE
                UPDATE dfn_ntp.m34_exec_broker_commission
                   SET m34_start = i.m10_ov_start, -- m34_start
                       m34_end = i.m10_ov_end, -- m34_end
                       m34_percent = i.m10_exchange_pct_comm, -- m34_percent
                       m34_flat_comm = i.m10_exchange_flat_comm, -- m34_flat_comm
                       m34_min_comm = i.m10_min_comm, -- m34_min_comm
                       m34_exec_broker_id_m26 = i.new_executing_broker_id, -- m34_exec_broker_id_m26
                       m34_exchange_code_m01 = i.exchange_code, -- m34_exchange_code_m01
                       m34_instrument_type = i.m10_instrument_type, -- m34_instrument_type
                       m34_type = i.m10_commission_type, -- m34_type
                       m34_currency_code_m03 = i.m10_currency, -- m34_currency_code_m03
                       m34_currency_id_m03 = i.m03_id, -- m34_currency_id_m03
                       m34_exchange_id_m01 = i.m01_id, -- m34_exchange_id_m01
                       m34_instrument_type_id_v09 = i.v09_id, -- m34_instrument_type_id_v09
                       m34_vat_percentage = i.m10_vat, -- m34_vat_percentage
                       m34_vat_charge_type_m124 = i.m124_id, -- m34_vat_charge_type_m124
                       m34_modified_by_id_u17 = 0, -- m34_modified_by_id_u17
                       m34_modified_date = SYSDATE -- m34_modified_date
                 WHERE m34_id = i.new_exec_broker_comm_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'M34_EXEC_BROKER_COMMISSION',
                                i.m10_id,
                                CASE
                                    WHEN i.new_exec_broker_comm_id IS NULL
                                    THEN
                                        l_exec_brk_comm_id
                                    ELSE
                                        i.new_exec_broker_comm_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_exec_broker_comm_id IS NULL
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