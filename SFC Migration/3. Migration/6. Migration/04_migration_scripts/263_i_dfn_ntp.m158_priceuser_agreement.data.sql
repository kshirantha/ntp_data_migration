DECLARE
    l_sqlerrm   VARCHAR2 (4000);
BEGIN
    DELETE FROM error_log
          WHERE mig_table = 'M158_PRICEUSER_AGREEMENT';

    FOR i
        IN (SELECT m201.m201_opt_1,
                   m201.m201_opt_2,
                   m201.m201_opt_3,
                   m201.m201_opt_4,
                   m201.m201_opt_5,
                   CASE WHEN m201.m201_agreed = 1 THEN 0 -- Private
                                                        ELSE 1 -- Business
                                                              END
                       AS agreement_type,
                   m201.m201_date_signed,
                   m201.m201_priceuser,
                   u09_map.old_customer_login_id,
                   u09_map.new_customer_login_id,
                   u09.u09_customer_id_u01,
                   m201.m201_customer_id,
                   m158.m158_user_id_u09,
                   m158.m158_customer_id_u01
              FROM mubasher_oms.m201_priceuser_agreement@mubasher_db_link m201,
                   u09_customer_login_mappings u09_map, -- [Corrective Actions Discussed]
                   dfn_ntp.u09_customer_login u09,
                   dfn_ntp.m158_priceuser_agreement m158
             WHERE     m201.m201_user_id = u09_map.old_customer_login_id(+) -- [Corrective Actions Discussed]
                   AND u09_map.new_customer_login_id = u09.u09_id(+)
                   AND u09_map.new_customer_login_id =
                           m158.m158_user_id_u09(+)
                   AND u09.u09_customer_id_u01 = m158.m158_customer_id_u01(+))
    LOOP
        BEGIN
            IF i.new_customer_login_id IS NULL
            THEN
                raise_application_error (-20001,
                                         'Customer Login Not Available',
                                         TRUE);
            END IF;

            IF i.u09_customer_id_u01 IS NULL
            THEN
                raise_application_error (-20001,
                                         'Customer Not Available',
                                         TRUE);
            END IF;

            IF     i.m158_user_id_u09 IS NOT NULL
               AND i.m158_customer_id_u01 IS NOT NULL
            THEN
                UPDATE dfn_ntp.m158_priceuser_agreement
                   SET m158_opt_1 = i.m201_opt_1, -- m158_opt_1
                       m158_opt_2 = i.m201_opt_2, -- m158_opt_2
                       m158_opt_3 = i.m201_opt_3, -- m158_opt_3
                       m158_opt_4 = i.m201_opt_4, -- m158_opt_4
                       m158_opt_5 = i.m201_opt_5, -- m158_opt_5
                       m158_customer_type_v01 = i.agreement_type, -- m158_customer_type_v01
                       m158_date_signed = i.m201_date_signed, -- m158_date_signed
                       m158_priceuser = i.m201_priceuser -- m158_priceuser
                 WHERE     m158_user_id_u09 = i.m158_user_id_u09
                       AND m158_customer_id_u01 = i.m158_customer_id_u01;
            ELSE
                INSERT
                  INTO dfn_ntp.m158_priceuser_agreement (
                           m158_user_id_u09,
                           m158_customer_id_u01,
                           m158_opt_1,
                           m158_opt_2,
                           m158_opt_3,
                           m158_opt_4,
                           m158_opt_5,
                           m158_customer_type_v01,
                           m158_date_signed,
                           m158_priceuser)
                VALUES (i.new_customer_login_id, -- m158_user_id_u09
                        i.u09_customer_id_u01, -- m158_customer_id_u01
                        i.m201_opt_1, -- m158_opt_1
                        i.m201_opt_2, -- m158_opt_2
                        i.m201_opt_3, -- m158_opt_3
                        i.m201_opt_4, -- m158_opt_4
                        i.m201_opt_5, -- m158_opt_5
                        i.agreement_type, -- m158_customer_type_v01
                        i.m201_date_signed, -- m158_date_signed
                        i.m201_priceuser -- m158_priceuser
                                        );
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'M158_PRICEUSER_AGREEMENT',
                                   'Customer - '
                                || i.m201_customer_id
                                || ' | Login - '
                                || i.old_customer_login_id,
                                CASE
                                    WHEN     i.m158_user_id_u09 IS NOT NULL
                                         AND i.m158_customer_id_u01
                                                 IS NOT NULL
                                    THEN
                                           'Customer - '
                                        || i.m158_customer_id_u01
                                        || ' | Login - '
                                        || i.m158_user_id_u09
                                    ELSE
                                           'Customer - '
                                        || i.u09_customer_id_u01
                                        || ' | Login - '
                                        || i.new_customer_login_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN     i.m158_user_id_u09 IS NOT NULL
                                         AND i.m158_customer_id_u01
                                                 IS NOT NULL
                                    THEN
                                        'UPDATE'
                                    ELSE
                                        'INSERT'
                                END,
                                SYSDATE);
        END;
    END LOOP;
END;
/

COMMIT;