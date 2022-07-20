DECLARE
    l_count   NUMBER := 0;
BEGIN
    SELECT COUNT (*) INTO l_count FROM map16_optional_exchanges_m01;

    IF l_count = 0
    THEN
        INSERT
          INTO map16_optional_exchanges_m01 (map16_oms_code,
                                             map16_ntp_code,
                                             map16_name)
        VALUES ('SFCMF', 'MDEX', 'SFC MUTUAL FUNDS');
    END IF;
END;
/