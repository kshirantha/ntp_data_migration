CREATE OR REPLACE PROCEDURE dfn_ntp.sp_populate_murabaha_amortize
IS
    l_date   DATE := TRUNC (func_get_eod_date ());
BEGIN
    INSERT INTO t90_murabaha_amortize (t90_id,
                                       t90_contract_id_t75,
                                       t90_date,
                                       t90_amortize_amount,
                                       t90_status)
        SELECT seq_t90_id.NEXTVAL,
               t75.t75_id,
               l_date,
               CASE
                   WHEN t75.t75_close_status = 1
                   THEN
                       (  t75.t75_actual_profit_amount
                        - t75.t75_amortized_profit_amount)
                   WHEN (  TRUNC (t75.t75_expiry_date)
                         - TRUNC (t75.t75_created_date)) > 1
                   THEN
                       ROUND (
                             t75.t75_actual_profit_amount
                           / (  TRUNC (t75.t75_expiry_date)
                              - TRUNC (t75.t75_created_date)),
                           2)
                   ELSE
                       (  t75.t75_actual_profit_amount
                        - t75.t75_amortized_profit_amount)
               END
                   AS current_amortize,
               1
          FROM t75_murabaha_contracts t75
         WHERE t75.t75_actual_profit_amount - t75.t75_amortized_profit_amount >
                   0;

    COMMIT;

    FOR i
        IN (SELECT t90_contract_id_t75, t90_amortize_amount
            FROM t90_murabaha_amortize
            WHERE     t90_date BETWEEN l_date AND l_date + 0.99999
                  AND t90_status = 1)
    LOOP
        UPDATE t75_murabaha_contracts
           SET t75_amortized_profit_amount =
                   t75_amortized_profit_amount + i.t90_amortize_amount,
               t75_close_status =
                   CASE
                       WHEN t75_actual_profit_amount =
                                  t75_amortized_profit_amount
                                + i.t90_amortize_amount
                       THEN
                           1
                       ELSE
                           t75_close_status
                   END
         WHERE t75_id = i.t90_contract_id_t75;
    END LOOP;
END;
/