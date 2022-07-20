
CREATE OR REPLACE 
PROCEDURE dfn_ntp.add_tila_agreement (user_id         IN     NUMERIC,
                              opt1            IN     NUMERIC,
                              opt2            IN     NUMERIC,
                              opt3            IN     NUMERIC,
                              opt4            IN     NUMERIC,
                              opt5            IN     NUMERIC,
                              customer_type   IN     NUMERIC,
                              status             OUT NUMERIC)
IS
    name_count1       NUMBER;
    customer_id       NUMBER;
    price_user_name   VARCHAR2 (20);
BEGIN
    SELECT COUNT (*)
      INTO name_count1
      FROM m158_priceuser_agreement
     WHERE m158_priceuser_agreement.m158_user_id_u09 = user_id;

    SELECT u01_id, u09_price_user_name
      INTO customer_id, price_user_name
      FROM u01_customer a, u09_customer_login b
     WHERE a.u01_id = b.u09_customer_id_u01 AND b.u09_id = user_id;

    IF (name_count1 = 1)
    THEN
        UPDATE m158_priceuser_agreement
           SET m158_priceuser_agreement.m158_opt_1 = opt1,
               m158_priceuser_agreement.m158_opt_2 = opt2,
               m158_priceuser_agreement.m158_opt_3 = opt3,
               m158_priceuser_agreement.m158_opt_4 = opt4,
               m158_priceuser_agreement.m158_opt_5 = opt5,
               m158_priceuser_agreement.m158_customer_type_v01 = customer_type,
               m158_priceuser_agreement.m158_date_signed = SYSDATE
         WHERE m158_priceuser_agreement.m158_user_id_u09 = user_id;
    ELSE
        INSERT INTO m158_priceuser_agreement
             VALUES (user_id,
                     customer_id,
                     opt1,
                     opt2,
                     opt3,
                     opt4,
                     opt5,
                     customer_type,
                     SYSDATE,
                     price_user_name);
    END IF;

    UPDATE u01_customer
       SET u01_customer.u01_tila_enable = 0
     WHERE u01_customer.u01_id = customer_id;

    status := 1;
END;                                                             
/





