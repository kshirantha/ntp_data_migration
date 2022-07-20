CREATE OR REPLACE 
PROCEDURE dfn_ntp.sp_verify_customer(        
                                     p_status              OUT   NUMBER ,
                                     p_login_id            IN    NUMBER ,
                                     p_customer_id         IN    NUMBER ,
                                     p_default_id          IN    VARCHAR2  )
IS
    l_customer_id           NUMBER ;
    l_default_id            VARCHAR2 (60) ;

BEGIN

    SELECT u09.u09_customer_id_u01
      INTO l_customer_id
      FROM u09_customer_login u09
     WHERE u09.u09_id = p_login_id;

     SELECT u01.u01_default_id_no
      INTO l_default_id
      FROM u01_customer u01
     WHERE u01.u01_id = p_customer_id ;

   IF l_customer_id = p_customer_id
    THEN
        IF l_default_id = p_default_id
          THEN
            p_status := 1;
          ELSE
            p_status := 0;
          END IF;
    ELSE
        p_status := 0;
    END IF;

EXCEPTION
    WHEN OTHERS
    THEN
        p_status := -1;
END;
/