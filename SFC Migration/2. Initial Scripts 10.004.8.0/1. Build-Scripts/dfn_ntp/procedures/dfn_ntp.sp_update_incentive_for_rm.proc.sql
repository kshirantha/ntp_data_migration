CREATE OR REPLACE PROCEDURE dfn_ntp.sp_update_incentive_for_rm
IS
    iso_week_start_date        DATE;
    iso_week_end_date          DATE;
    start_of_the_month         DATE;
    end_of_the_month           DATE;
    start_of_the_fortnight     DATE;
    end_of_the_fortnight       DATE;
    l_sysdate                  DATE;
    l_existing_records_count   NUMBER (18) := 0;

    CURSOR dealer_commission_structures
    IS
          SELECT m162.m162_id,
                 m163.m163_from,
                 m163.m163_to,
                 m163.m163_percentage,
                 m163.m163_currency_code_m03,
                 m163.m163_exchange_id_m01,
                 m162.m162_commission_type_id_v01,
                 m162.m162_group_type_id_v01,
                 m162.m162_frequency_id_v01,
                 m162.m162_institute_id_m02
            FROM m162_incentive_group m162, m163_incentive_slabs m163
           WHERE     m162.m162_id = m163.m163_incentive_group_id_m162
                 AND m163.m163_status_id_v01 = 2
                 AND m162.m162_group_type_id_v01 = 1                 --RM Type
        ORDER BY m162_id;
BEGIN
    l_sysdate := func_get_eod_date;

    SELECT TRUNC (l_sysdate, 'iw'),
           TRUNC (l_sysdate, 'iw') + 7 - 1 / 86400,
           TRUNC (l_sysdate, 'mm'),
           LAST_DAY (TRUNC (l_sysdate, 'mm')) + 1 - 1 / 86400,
           CASE
               WHEN TO_CHAR (l_sysdate, 'DD') < 15
               THEN
                   TRUNC (l_sysdate, 'mm')
               ELSE
                   TRUNC (TRUNC (l_sysdate, 'mm') + 16, 'W')
           END,
           CASE
               WHEN TO_CHAR (l_sysdate, 'DD') < 15
               THEN
                   TRUNC (TRUNC (l_sysdate, 'mm') + 16, 'W') - 1 + .99999
               ELSE
                   LAST_DAY (TRUNC (l_sysdate, 'mm')) + 1 - 1 / 86400
           END
      INTO iso_week_start_date,
           iso_week_end_date,
           start_of_the_month,
           end_of_the_month,
           start_of_the_fortnight,
           end_of_the_fortnight
      FROM DUAL;

    FOR structure IN dealer_commission_structures
    LOOP
        FOR commission
            IN (  SELECT m10.m10_id,
                         orders.t02_txn_currency,
                         m01.m01_id,
                         m01_exchange_code,
                         MAX (orders.t02_cash_settle_date)
                             AS t02_cash_settle_date,
                         SUM (ABS (orders.t02_broker_commission))
                             AS t02_broker_commission,
                         SUM (ABS (orders.t02_commission_adjst))
                             AS total_commission
                    FROM t02_transaction_log_order orders
                         JOIN u06_cash_account u06
                             ON orders.t02_cash_acnt_id_u06 = u06.u06_id
                         JOIN u01_customer u01
                             ON u06.u06_customer_id_u01 = u01.u01_id
                         JOIN m10_relationship_manager m10
                             ON     u01.u01_relationship_mngr_id_m10 =
                                        m10.m10_id
                                AND m10.m10_incentive_group_id_m162 =
                                        structure.m162_id
                                AND m10.m10_institute_id_m02 =
                                        structure.m162_institute_id_m02
                         JOIN m01_exchanges m01
                             ON     orders.t02_exchange_id_m01 = m01.m01_id
                                AND m01.m01_id = structure.m163_exchange_id_m01
                                AND orders.t02_txn_currency =
                                        structure.m163_currency_code_m03
                   WHERE (   (    structure.m162_frequency_id_v01 = 2
                              AND orders.t02_create_date >= l_sysdate - 30
                              AND orders.t02_cash_settle_date BETWEEN l_sysdate
                                                                  AND   l_sysdate
                                                                      + 0.99999)
                          OR (    structure.m162_frequency_id_v01 = 3
                              AND orders.t02_create_date >=
                                      iso_week_start_date - 30
                              AND l_sysdate = TRUNC (iso_week_end_date)
                              AND orders.t02_cash_settle_date BETWEEN iso_week_start_date
                                                                  AND iso_week_end_date)
                          OR (    structure.m162_frequency_id_v01 = 4
                              AND orders.t02_create_date >=
                                      start_of_the_fortnight - 30
                              AND l_sysdate = TRUNC (end_of_the_fortnight)
                              AND orders.t02_cash_settle_date BETWEEN start_of_the_fortnight
                                                                  AND end_of_the_fortnight)
                          OR (    structure.m162_frequency_id_v01 = 5
                              AND orders.t02_create_date >=
                                      start_of_the_month - 30
                              AND l_sysdate = TRUNC (end_of_the_month)
                              AND orders.t02_cash_settle_date BETWEEN start_of_the_month
                                                                  AND end_of_the_month))
                GROUP BY m10.m10_id,
                         m01.m01_id,
                         m01_exchange_code,
                         orders.t02_txn_currency)
        LOOP
            IF (CASE structure.m162_commission_type_id_v01
                    WHEN 1
                    THEN
                            commission.total_commission >=
                                structure.m163_from
                        AND commission.total_commission < structure.m163_to
                    ELSE
                            commission.t02_broker_commission >=
                                structure.m163_from
                        AND commission.t02_broker_commission <
                                structure.m163_to
                END)
            THEN
                SELECT COUNT (*)
                  INTO l_existing_records_count
                  FROM t47_incentive_for_staff_n_cust
                 WHERE     t47_staff_or_customer_id = commission.m10_id
                       AND t47_exchange_id_m01 = commission.m01_id
                       AND t47_txn_currency_code_m03 =
                               commission.t02_txn_currency
                       AND t47_group_type_id_v01 =
                               structure.m162_group_type_id_v01
                       AND t47_settle_date BETWEEN CASE structure.m162_frequency_id_v01
                                                       WHEN 2
                                                       THEN
                                                           l_sysdate
                                                       WHEN 3
                                                       THEN
                                                           iso_week_start_date
                                                       WHEN 4
                                                       THEN
                                                           start_of_the_fortnight
                                                       WHEN 5
                                                       THEN
                                                           start_of_the_month
                                                   END
                                               AND CASE structure.m162_frequency_id_v01
                                                       WHEN 2
                                                       THEN
                                                           l_sysdate + .99999
                                                       WHEN 3
                                                       THEN
                                                           iso_week_end_date
                                                       WHEN 4
                                                       THEN
                                                           end_of_the_fortnight
                                                       WHEN 5
                                                       THEN
                                                           end_of_the_month
                                                   END;

                IF l_existing_records_count > 0
                THEN
                    DELETE t47_incentive_for_staff_n_cust
                     WHERE     t47_staff_or_customer_id = commission.m10_id
                           AND t47_exchange_id_m01 = commission.m01_id
                           AND t47_txn_currency_code_m03 =
                                   commission.t02_txn_currency
                           AND t47_group_type_id_v01 =
                                   structure.m162_group_type_id_v01
                           AND t47_settle_date BETWEEN CASE structure.m162_frequency_id_v01
                                                           WHEN 2
                                                           THEN
                                                               l_sysdate
                                                           WHEN 3
                                                           THEN
                                                               iso_week_start_date
                                                           WHEN 4
                                                           THEN
                                                               start_of_the_fortnight
                                                           WHEN 5
                                                           THEN
                                                               start_of_the_month
                                                       END
                                                   AND CASE structure.m162_frequency_id_v01
                                                           WHEN 2
                                                           THEN
                                                                 l_sysdate
                                                               + .99999
                                                           WHEN 3
                                                           THEN
                                                               iso_week_end_date
                                                           WHEN 4
                                                           THEN
                                                               end_of_the_fortnight
                                                           WHEN 5
                                                           THEN
                                                               end_of_the_month
                                                       END;
                END IF;

                INSERT
                  INTO t47_incentive_for_staff_n_cust (
                           t47_staff_or_customer_id,
                           t47_exchange_id_m01,
                           t47_exchange_code_m01,
                           t47_txn_currency_code_m03,
                           t47_settle_date,
                           t47_broker_commission,
                           t47_total_commission,
                           t47_commission_type_id_v01,
                           t47_incentive,
                           t47_group_type_id_v01,
                           t47_frequency_id_v01,
                           t47_from_date,
                           t47_to_date,
                           t47_incentive_group_id_m162)
                VALUES (
                           commission.m10_id,
                           commission.m01_id,
                           commission.m01_exchange_code,
                           commission.t02_txn_currency,
                           commission.t02_cash_settle_date,
                           commission.t02_broker_commission,
                           commission.total_commission,
                           structure.m162_commission_type_id_v01,
                           CASE structure.m162_commission_type_id_v01
                               WHEN 1
                               THEN
                                   ROUND (
                                       (  commission.total_commission
                                        * structure.m163_percentage
                                        / 100),
                                       2)
                               ELSE
                                   ROUND (
                                       (  commission.t02_broker_commission
                                        * structure.m163_percentage
                                        / 100),
                                       2)
                           END,
                           structure.m162_group_type_id_v01,
                           structure.m162_frequency_id_v01,
                           CASE structure.m162_frequency_id_v01
                               WHEN 2 THEN l_sysdate
                               WHEN 3 THEN iso_week_start_date
                               WHEN 4 THEN start_of_the_fortnight
                               WHEN 5 THEN start_of_the_month
                           END,
                           CASE structure.m162_frequency_id_v01
                               WHEN 2 THEN l_sysdate + .99999
                               WHEN 3 THEN iso_week_end_date
                               WHEN 4 THEN end_of_the_fortnight
                               WHEN 5 THEN end_of_the_month
                           END,
                           structure.m162_id);
            END IF;
        END LOOP;
    END LOOP;
END;
/
