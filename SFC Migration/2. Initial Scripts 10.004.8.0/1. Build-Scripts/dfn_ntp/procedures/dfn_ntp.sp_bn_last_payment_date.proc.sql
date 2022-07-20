CREATE OR REPLACE PROCEDURE dfn_ntp.sp_bn_last_payment_date
IS
    last_payment_date        DATE;
    next_last_payment_date   DATE;
BEGIN
    FOR i
        IN (SELECT m20.m20_id,
                   m20e.m20_int_payment_date,
                   m20e.m20_accrual_start_date,
                   v25.v25_duration AS m20_no_of_payment_v25
              FROM m20_symbol m20
                   LEFT JOIN m20_symbol_extended m20e
                       ON m20.m20_id = m20e.m20_id
                   LEFT JOIN v25_payment_types v25
                       ON m20e.m20_no_of_payment_v25 = v25_id
             WHERE     m20.m20_instrument_type_id_v09 = 6
                   AND m20e.m20_accrual_start_date IS NOT NULL
                   AND m20e.m20_no_of_payment_v25 IS NOT NULL)
    LOOP
        last_payment_date :=
            ADD_MONTHS (i.m20_accrual_start_date, i.m20_no_of_payment_v25);

        next_last_payment_date := i.m20_accrual_start_date;

        IF (TRUNC (last_payment_date) = func_get_eod_date + 1)
        THEN
            UPDATE m20_symbol_extended
               SET m20_int_payment_date = TRUNC (last_payment_date)
             WHERE m20_id = i.m20_id;

            COMMIT;
        END IF;

        IF (TRUNC (last_payment_date) < func_get_eod_date + 1)
        THEN
            LOOP
                next_last_payment_date :=
                    ADD_MONTHS (next_last_payment_date,
                                i.m20_no_of_payment_v25);



                IF TRUNC (next_last_payment_date) >= func_get_eod_date + 1
                THEN
                    EXIT;
                END IF;

                UPDATE m20_symbol_extended
                   SET m20_int_payment_date = TRUNC (next_last_payment_date)
                 WHERE m20_id = i.m20_id;
            END LOOP;
        END IF;
    END LOOP;

    COMMIT;
END;
/