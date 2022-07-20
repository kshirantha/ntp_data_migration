DECLARE
    l_count   NUMBER := 0;
BEGIN
    SELECT COUNT (*) INTO l_count FROM map08_identity_type_m15;

    IF l_count = 0
    THEN
        INSERT INTO map08_identity_type_m15
             VALUES (1, 1, 'NIN');

        INSERT INTO map08_identity_type_m15
             VALUES (6, 2, 'IQAMA');

        INSERT INTO map08_identity_type_m15
             VALUES (7, 7, 'DIPLOMAT CARD');

        INSERT INTO map08_identity_type_m15
             VALUES (8, 8, 'DIPLOMAT PASSPORT');

        INSERT INTO map08_identity_type_m15
             VALUES (9, 9, 'EMBASSIES');

        INSERT INTO map08_identity_type_m15
             VALUES (10, 10, 'EXPATRIATES - HOME COUNTRY ID');

        INSERT INTO map08_identity_type_m15
             VALUES (11, 11, 'GCC NATIONALS - NATIONAL ID');

        INSERT INTO map08_identity_type_m15
             VALUES (12, 12, 'GCC NATIONALS - PASSPORT');

        INSERT INTO map08_identity_type_m15
             VALUES (13, 13, 'MULTINATIONAL ORGANIZATION');

        INSERT INTO map08_identity_type_m15
             VALUES (14, 14, 'HAFITHAT NOUFOUS [SAUDI]');

        INSERT INTO map08_identity_type_m15
             VALUES (15, 15, 'PILGRIM MISSION');

        INSERT INTO map08_identity_type_m15
             VALUES (16, 16, 'DRIVING LICENSE');

        INSERT INTO map08_identity_type_m15
             VALUES (26, 17, 'COMMERCIAL REGISTRATION');

        INSERT INTO map08_identity_type_m15
             VALUES (17, 17, 'COMMERCIAL REGISTRATION');

        INSERT INTO map08_identity_type_m15
             VALUES (18, 18, 'PUBLIC CORPORATION');

        INSERT INTO map08_identity_type_m15
             VALUES (19, 19, 'PRINCES');

        INSERT INTO map08_identity_type_m15
             VALUES (20, 20, 'OTHERS');

        INSERT INTO map08_identity_type_m15
             VALUES (21, 21, 'INSURANCE COMPANIES');

        INSERT INTO map08_identity_type_m15
             VALUES (22, 22, 'GOVERNMENT ENTITIES');

        INSERT INTO map08_identity_type_m15
             VALUES (38, 23, 'PASSPORT');

        INSERT INTO map08_identity_type_m15
             VALUES (2, 24, 'COMPANY');

        INSERT INTO map08_identity_type_m15
             VALUES (3, 25, 'GOVERNMENT');

        INSERT INTO map08_identity_type_m15
             VALUES (4, 26, 'INSTITUTION');

        INSERT INTO map08_identity_type_m15
             VALUES (5, 27, 'SWAP');

        INSERT INTO map08_identity_type_m15
             VALUES (23, 28, 'BEDOUN');

        INSERT INTO map08_identity_type_m15
             VALUES (24, 29, 'BANK MEMO');

        INSERT INTO map08_identity_type_m15
             VALUES (
                        25,
                        30,
                        'COPY OF DECISION TO FORM THE BOARD OF DIRECTORS');

        INSERT INTO map08_identity_type_m15
             VALUES (
                        46,
                        31,
                        'LICENSE FROM GEN. PRES. FOR YOUTH WELFARE (GPYW)');

        INSERT INTO map08_identity_type_m15
             VALUES (
                        27,
                        32,
                        'APPROVAL OF HIGH COMMITTEE TO COLLECT DONATION');

        INSERT INTO map08_identity_type_m15
             VALUES (
                        28,
                        33,
                        'LIC FROM MIN OF ISLAMIC AFFAIRS FOR CALL AND GUID');

        INSERT INTO map08_identity_type_m15
             VALUES (29, 34, 'SAUDI ID CARD');

        INSERT INTO map08_identity_type_m15
             VALUES (30, 35, 'PRIVATE PROFESSIONAL LICENSE');

        INSERT INTO map08_identity_type_m15
             VALUES (
                        31,
                        36,
                        'LETTER OF INTRO/REFER CERT BY GOVT/OTHER AGENCY');

        INSERT INTO map08_identity_type_m15
             VALUES (
                        32,
                        37,
                        'LICENSE / PERMISSION FROM MINISTRY OF COMMERCE');

        INSERT INTO map08_identity_type_m15
             VALUES (33, 38, 'LICENSE FROM MIN. OF HEALTH');

        INSERT INTO map08_identity_type_m15
             VALUES (34, 39, 'MIN OF LABOR AND SOCIAL AFFAIRS LETTER');

        INSERT INTO map08_identity_type_m15
             VALUES (35, 40, 'MAGNETIC IQAMA');

        INSERT INTO map08_identity_type_m15
             VALUES (37, 41, 'PERMANENT LICENSE');

        INSERT INTO map08_identity_type_m15
             VALUES (39, 42, 'ROYAL DECREE');

        INSERT INTO map08_identity_type_m15
             VALUES (40, 43, 'SAUDI PASSPORT');

        INSERT INTO map08_identity_type_m15
             VALUES (41, 44, 'SUCCESSION DEED');

        INSERT INTO map08_identity_type_m15
             VALUES (42, 45, 'SAUDIA ID CARD');

        INSERT INTO map08_identity_type_m15
             VALUES (43, 46, 'SAMA LICENSE / SAMA APPROVAL');

        INSERT INTO map08_identity_type_m15
             VALUES (44, 47, 'SPECIAL PASSPORT');

        INSERT INTO map08_identity_type_m15
             VALUES (45, 48, 'TEMPORARY LICENSE');
    END IF;
END;
/