-- This is Production Data

/*
DECLARE
    l_count   NUMBER := 0;
BEGIN
    SELECT COUNT (*) INTO l_count FROM map17_customer_category_v01_86;

    IF l_count = 0
    THEN
        INSERT
          INTO map17_customer_category_v01_86 (map17_oms_id,
                                               map17_ntp_id,
                                               map17_name)
        VALUES (1, 0, 'STANDARD');

        INSERT
          INTO map17_customer_category_v01_86 (map17_oms_id,
                                               map17_ntp_id,
                                               map17_name)
        VALUES (2, 1, 'STAFF');

        INSERT
          INTO map17_customer_category_v01_86 (map17_oms_id,
                                               map17_ntp_id,
                                               map17_name)
        VALUES (3, 2001, 'TYPE A');

        INSERT
          INTO map17_customer_category_v01_86 (map17_oms_id,
                                               map17_ntp_id,
                                               map17_name)
        VALUES (4, 2002, 'TYPE B');

        INSERT
          INTO map17_customer_category_v01_86 (map17_oms_id,
                                               map17_ntp_id,
                                               map17_name)
        VALUES (5, 2003, 'TYPE C');

        INSERT
          INTO map17_customer_category_v01_86 (map17_oms_id,
                                               map17_ntp_id,
                                               map17_name)
        VALUES (126, 2004, 'TYPE D');

        INSERT
          INTO map17_customer_category_v01_86 (map17_oms_id,
                                               map17_ntp_id,
                                               map17_name)
        VALUES (206, 2005, 'TYPE E');

        INSERT
          INTO map17_customer_category_v01_86 (map17_oms_id,
                                               map17_ntp_id,
                                               map17_name)
        VALUES (346, 2006, 'TYPE E');

        INSERT
          INTO map17_customer_category_v01_86 (map17_oms_id,
                                               map17_ntp_id,
                                               map17_name)
        VALUES (26, 2007, 'SWAP');

        INSERT
          INTO map17_customer_category_v01_86 (map17_oms_id,
                                               map17_ntp_id,
                                               map17_name)
        VALUES (46, 2008, 'SWAP A');

        INSERT
          INTO map17_customer_category_v01_86 (map17_oms_id,
                                               map17_ntp_id,
                                               map17_name)
        VALUES (146, 2009, 'SWAP 15');

        INSERT
          INTO map17_customer_category_v01_86 (map17_oms_id,
                                               map17_ntp_id,
                                               map17_name)
        VALUES (286, 2010, 'SWAP 15.5');

        INSERT
          INTO map17_customer_category_v01_86 (map17_oms_id,
                                               map17_ntp_id,
                                               map17_name)
        VALUES (166, 2011, 'SWAP 16.5');

        INSERT
          INTO map17_customer_category_v01_86 (map17_oms_id,
                                               map17_ntp_id,
                                               map17_name)
        VALUES (186, 2012, 'SWAP 17');

        INSERT
          INTO map17_customer_category_v01_86 (map17_oms_id,
                                               map17_ntp_id,
                                               map17_name)
        VALUES (326, 2013, 'SWAP 17.5');

        INSERT
          INTO map17_customer_category_v01_86 (map17_oms_id,
                                               map17_ntp_id,
                                               map17_name)
        VALUES (306, 2014, 'SWAP 18');

        INSERT
          INTO map17_customer_category_v01_86 (map17_oms_id,
                                               map17_ntp_id,
                                               map17_name)
        VALUES (226, 2016, 'SWAP 20');

        INSERT
          INTO map17_customer_category_v01_86 (map17_oms_id,
                                               map17_ntp_id,
                                               map17_name)
        VALUES (86, 2017, 'SWAP 22');

        INSERT
          INTO map17_customer_category_v01_86 (map17_oms_id,
                                               map17_ntp_id,
                                               map17_name)
        VALUES (167, 2018, 'SWAP 22.5');

        INSERT
          INTO map17_customer_category_v01_86 (map17_oms_id,
                                               map17_ntp_id,
                                               map17_name)
        VALUES (266, 2019, 'SWAP 24');

        INSERT
          INTO map17_customer_category_v01_86 (map17_oms_id,
                                               map17_ntp_id,
                                               map17_name)
        VALUES (106, 2020, 'SWAP 30');

        INSERT
          INTO map17_customer_category_v01_86 (map17_oms_id,
                                               map17_ntp_id,
                                               map17_name)
        VALUES (246, 2021, 'SWAP 80');

        INSERT
          INTO map17_customer_category_v01_86 (map17_oms_id,
                                               map17_ntp_id,
                                               map17_name)
        VALUES (66, 2022, 'PASSPORT - SWAP');

        INSERT
          INTO map17_customer_category_v01_86 (map17_oms_id,
                                               map17_ntp_id,
                                               map17_name)
        VALUES (67, 2023, 'BLOMINVEST - SWAP');

        INSERT
          INTO map17_customer_category_v01_86 (map17_oms_id,
                                               map17_ntp_id,
                                               map17_name)
        VALUES (366, 2024, '35 BPS');

        INSERT
          INTO map17_customer_category_v01_86 (map17_oms_id,
                                               map17_ntp_id,
                                               map17_name)
        VALUES (406, 2025, '55 BPS');

        INSERT
          INTO map17_customer_category_v01_86 (map17_oms_id,
                                               map17_ntp_id,
                                               map17_name)
        VALUES (386, 2026, '70 BPS');

        INSERT
          INTO map17_customer_category_v01_86 (map17_oms_id,
                                               map17_ntp_id,
                                               map17_name)
        VALUES (426, 2027, '120 BPS');

        INSERT
          INTO map17_customer_category_v01_86 (map17_oms_id,
                                               map17_ntp_id,
                                               map17_name)
        VALUES (427, 2028, 'ALGO');
    END IF;
END;
/
*/
-- This is UAT Data

DECLARE
    l_count   NUMBER := 0;
BEGIN
    SELECT COUNT (*) INTO l_count FROM map17_customer_category_v01_86;

    IF l_count = 0
    THEN
        INSERT
          INTO map17_customer_category_v01_86 (map17_oms_id,
                                               map17_ntp_id,
                                               map17_name)
        VALUES (1, 0, 'STANDARD');

        INSERT
          INTO map17_customer_category_v01_86 (map17_oms_id,
                                               map17_ntp_id,
                                               map17_name)
        VALUES (2, 1, 'STAFF');

        INSERT
          INTO map17_customer_category_v01_86 (map17_oms_id,
                                               map17_ntp_id,
                                               map17_name)
        VALUES (3, 2001, 'TYPE A');

        INSERT
          INTO map17_customer_category_v01_86 (map17_oms_id,
                                               map17_ntp_id,
                                               map17_name)
        VALUES (4, 2002, 'TYPE B');

        INSERT
          INTO map17_customer_category_v01_86 (map17_oms_id,
                                               map17_ntp_id,
                                               map17_name)
        VALUES (5, 2003, 'TYPE C');

        INSERT
          INTO map17_customer_category_v01_86 (map17_oms_id,
                                               map17_ntp_id,
                                               map17_name)
        VALUES (186, 2004, 'TYPE D');

        INSERT
          INTO map17_customer_category_v01_86 (map17_oms_id,
                                               map17_ntp_id,
                                               map17_name)
        VALUES (226, 2016, 'SWAP 20');

        INSERT
          INTO map17_customer_category_v01_86 (map17_oms_id,
                                               map17_ntp_id,
                                               map17_name)
        VALUES (246, 2024, '35 BPS');

        INSERT
          INTO map17_customer_category_v01_86 (map17_oms_id,
                                               map17_ntp_id,
                                               map17_name)
        VALUES (247, 2028, 'ALGO');

        INSERT
          INTO map17_customer_category_v01_86 (map17_oms_id,
                                               map17_ntp_id,
                                               map17_name)
        VALUES (106, 2015, 'SWAP 19');

        INSERT
          INTO map17_customer_category_v01_86 (map17_oms_id,
                                               map17_ntp_id,
                                               map17_name)
        VALUES (6, 2029, 'VIP');

        INSERT
          INTO map17_customer_category_v01_86 (map17_oms_id,
                                               map17_ntp_id,
                                               map17_name)
        VALUES (87, 2030, 'INB');

        INSERT
          INTO map17_customer_category_v01_86 (map17_oms_id,
                                               map17_ntp_id,
                                               map17_name)
        VALUES (66, 2031, 'PWC');

        INSERT
          INTO map17_customer_category_v01_86 (map17_oms_id,
                                               map17_ntp_id,
                                               map17_name)
        VALUES (86, 2032, 'IBO');

        INSERT
          INTO map17_customer_category_v01_86 (map17_oms_id,
                                               map17_ntp_id,
                                               map17_name)
        VALUES (126, 2033, 'STAFF SFC');

        INSERT
          INTO map17_customer_category_v01_86 (map17_oms_id,
                                               map17_ntp_id,
                                               map17_name)
        VALUES (146, 2034, 'REFERRAL');
    END IF;
END;
/