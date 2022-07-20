DECLARE
    l_murabaha_amortize_id   NUMBER;
    l_sqlerrm                VARCHAR2 (4000);
BEGIN
    SELECT NVL (MAX (t90_id), 0)
      INTO l_murabaha_amortize_id
      FROM dfn_ntp.t90_murabaha_amortize;

    DELETE FROM error_log
          WHERE mig_table = 'T90_MURABAHA_AMORTIZE';

    FOR i
        IN (SELECT t87.t87_id,
                   t75_map.new_murabaha_contract_id,
                   t87.t87_date,
                   t87.t87_amortize_amount,
                   t87.t87_status, -- [SAME IDs]
                   t90_map.new_murabaha_amortize_id
              FROM mubasher_oms.t87_murabaha_amortize@mubasher_db_link t87,
                   t75_murabaha_contract_mappings t75_map,
                   t90_murabaha_amortize_mappings t90_map
             WHERE     t87.t87_t85_contract_id =
                           t75_map.old_murabaha_contract_id(+)
                   AND t87.t87_id = t90_map.old_murabaha_amortize_id(+))
    LOOP
        BEGIN
            IF i.new_murabaha_contract_id IS NULL
            THEN
                raise_application_error (-20001,
                                         'Contract Not Available',
                                         TRUE);
            END IF;

            IF i.new_murabaha_amortize_id IS NULL
            THEN
                l_murabaha_amortize_id := l_murabaha_amortize_id + 1;

                INSERT
                  INTO dfn_ntp.t90_murabaha_amortize (t90_id,
                                                      t90_contract_id_t75,
                                                      t90_date,
                                                      t90_amortize_amount,
                                                      t90_status)
                VALUES (l_murabaha_amortize_id,
                        i.new_murabaha_contract_id,
                        i.t87_date,
                        i.t87_amortize_amount,
                        i.t87_status);

                INSERT
                  INTO t90_murabaha_amortize_mappings (
                           old_murabaha_amortize_id,
                           new_murabaha_amortize_id)
                VALUES (i.t87_id, l_murabaha_amortize_id);
            ELSE
                UPDATE dfn_ntp.t90_murabaha_amortize
                   SET t90_contract_id_t75 = i.new_murabaha_contract_id, -- t90_contract_id_t75
                       t90_date = i.t87_date, -- t90_date
                       t90_amortize_amount = i.t87_amortize_amount, -- t90_amortize_amount
                       t90_status = i.t87_status -- t90_status
                 WHERE t90_id = i.new_murabaha_amortize_id;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'T90_MURABAHA_AMORTIZE',
                                i.t87_id,
                                CASE
                                    WHEN i.new_murabaha_amortize_id IS NULL
                                    THEN
                                        l_murabaha_amortize_id
                                    ELSE
                                        i.new_murabaha_amortize_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_murabaha_amortize_id IS NULL
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
