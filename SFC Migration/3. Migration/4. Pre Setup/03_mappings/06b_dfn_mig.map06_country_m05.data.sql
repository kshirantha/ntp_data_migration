DECLARE
    l_count   NUMBER := 0;
BEGIN
    SELECT COUNT (*) INTO l_count FROM map06_country_m05;

    IF l_count = 0
    THEN
        INSERT INTO map06_country_m05
             VALUES (230, 186, 'SAMOA');

        INSERT INTO map06_country_m05
             VALUES (31, 31, 'BYELORUSSIAN SSR');

        INSERT INTO map06_country_m05
             VALUES (46, 52, 'DEMOCRATIC REPUBLIC OF CONGO');

        INSERT INTO map06_country_m05
             VALUES (112, 39, 'CAMBODIA');

        INSERT INTO map06_country_m05
             VALUES (369, 83, 'GERMANY');

        INSERT INTO map06_country_m05
             VALUES (286, 111, 'KAZAKHSTAN');

        INSERT INTO map06_country_m05
             VALUES (284, 24, 'BELGIUM');

        INSERT INTO map06_country_m05
             VALUES (124, 83, 'GERMANY');

        INSERT INTO map06_country_m05
             VALUES (371, 226, 'UNITED STATES OF AMERICA');

        INSERT INTO map06_country_m05
             VALUES (305, 111, 'KAZAKHSTAN');

        INSERT INTO map06_country_m05
             VALUES (278, 205, 'SWEDEN');

        INSERT INTO map06_country_m05
             VALUES (379, 107, 'ITALY');

        INSERT INTO map06_country_m05
             VALUES (188, 181, 'SAINT HELENA');

        INSERT INTO map06_country_m05
             VALUES (310, 152, 'NETHERLANDS');

        INSERT INTO map06_country_m05
             VALUES (367, 110, 'JORDAN');

        INSERT INTO map06_country_m05
             VALUES (235, 152, 'NETHERLANDS');

        INSERT INTO map06_country_m05
             VALUES (220, 60, 'CZECHIA (CZECH REPUBLIC FORMER YUGOSLAVIA)');

        INSERT INTO map06_country_m05
             VALUES (222, 52, 'DEMOCRATIC REPUBLIC OF CONGO');

        INSERT INTO map06_country_m05
             VALUES (227, 56, 'COTE D''IVOIRE');

        INSERT INTO map06_country_m05
             VALUES (233, 114, 'NORTH KOREA');

        INSERT INTO map06_country_m05
             VALUES (234, 115, 'SOUTH KOREA');

        INSERT INTO map06_country_m05
             VALUES (236, 154, 'SCOTLAND');

        INSERT INTO map06_country_m05
             VALUES (355, 107, 'ITALY');

        INSERT INTO map06_country_m05
             VALUES (276, 220, 'SPAIN');

        INSERT INTO map06_country_m05
             VALUES (244, 78, 'FRENCH POLYNESIA');

        INSERT INTO map06_country_m05
             VALUES (249, 153, 'NETHERLANDS ANTILLES');

        INSERT INTO map06_country_m05
             VALUES (241, 220, 'SPAIN');

        INSERT INTO map06_country_m05
             VALUES (254, 182, 'SAINT KITTS AND NEVIS');

        INSERT INTO map06_country_m05
             VALUES (259, 77, 'FRENCH GUIANA');

        INSERT INTO map06_country_m05
             VALUES (260, 153, 'NETHERLANDS ANTILLES');

        INSERT INTO map06_country_m05
             VALUES (385, 228, 'URUGUAY');

        INSERT INTO map06_country_m05
             VALUES (267, 123, 'LIBYA');

        INSERT INTO map06_country_m05
             VALUES (271, 207, 'SYRIA');

        INSERT INTO map06_country_m05
             VALUES (297, 128, 'MACEDONIA');

        INSERT INTO map06_country_m05
             VALUES (301, 190, 'MONTENEGRO');

        INSERT INTO map06_country_m05
             VALUES (303, 142, 'MOLDOVA');

        INSERT INTO map06_country_m05
             VALUES (328, 226, 'UNITED STATES OF AMERICA');

        INSERT INTO map06_country_m05
             VALUES (285, 114, 'NORTH KOREA');

        INSERT INTO map06_country_m05
             VALUES (398, 166, 'PALESTINIAN TERRITORY');

        INSERT INTO map06_country_m05
             VALUES (399, 69, 'ERITREA');

        INSERT INTO map06_country_m05
             VALUES (382, 226, 'UNITED STATES OF AMERICA');

        INSERT INTO map06_country_m05
             VALUES (376, 226, 'UNITED STATES OF AMERICA');

        INSERT INTO map06_country_m05
             VALUES (242, 226, 'UNITED STATES OF AMERICA');

        INSERT INTO map06_country_m05
             VALUES (326, 106, 'ISRAEL');

        INSERT INTO map06_country_m05
             VALUES (1, 1, 'SRI LANKA');

        INSERT INTO map06_country_m05
             VALUES (179, 2, 'SAUDI ARABIA');

        INSERT INTO map06_country_m05
             VALUES (352, 16, 'AUSTRALIA');

        INSERT INTO map06_country_m05
             VALUES (282, 4, 'AFGHANISTAN');

        INSERT INTO map06_country_m05
             VALUES (2, 5, 'ALBANIA');

        INSERT INTO map06_country_m05
             VALUES (3, 6, 'ALGERIA');

        INSERT INTO map06_country_m05
             VALUES (4, 7, 'AMERICAN SAMOA');

        INSERT INTO map06_country_m05
             VALUES (291, 8, 'ANDORRA');

        INSERT INTO map06_country_m05
             VALUES (5, 9, 'ANGOLA');

        INSERT INTO map06_country_m05
             VALUES (6, 10, 'ANGUILLA');

        INSERT INTO map06_country_m05
             VALUES (250, 118, 'LAOS');

        INSERT INTO map06_country_m05
             VALUES (7, 12, 'ANTIGUA AND BARBUDA');

        INSERT INTO map06_country_m05
             VALUES (8, 13, 'ARGENTINA');

        INSERT INTO map06_country_m05
             VALUES (306, 14, 'ARMENIA');

        INSERT INTO map06_country_m05
             VALUES (9, 15, 'ARUBA');

        INSERT INTO map06_country_m05
             VALUES (10, 16, 'AUSTRALIA');

        INSERT INTO map06_country_m05
             VALUES (11, 17, 'AUSTRIA');

        INSERT INTO map06_country_m05
             VALUES (280, 18, 'AZERBAIJAN');

        INSERT INTO map06_country_m05
             VALUES (14, 19, 'BAHAMAS');

        INSERT INTO map06_country_m05
             VALUES (256, 20, 'BAHRAIN');

        INSERT INTO map06_country_m05
             VALUES (16, 21, 'BANGLADESH');

        INSERT INTO map06_country_m05
             VALUES (17, 22, 'BARBADOS');

        INSERT INTO map06_country_m05
             VALUES (287, 23, 'BELARUS');

        INSERT INTO map06_country_m05
             VALUES (18, 24, 'BELGIUM');

        INSERT INTO map06_country_m05
             VALUES (19, 25, 'BELIZE');

        INSERT INTO map06_country_m05
             VALUES (20, 26, 'BENIN');

        INSERT INTO map06_country_m05
             VALUES (21, 27, 'BERMUDA');

        INSERT INTO map06_country_m05
             VALUES (30, 28, 'BHUTAN');

        INSERT INTO map06_country_m05
             VALUES (22, 29, 'BOLIVIA');

        INSERT INTO map06_country_m05
             VALUES (118, 182, 'SAINT KITTS AND NEVIS');

        INSERT INTO map06_country_m05
             VALUES (23, 31, 'BOTSWANA');

        INSERT INTO map06_country_m05
             VALUES (24, 32, 'BOUVET ISLAND');

        INSERT INTO map06_country_m05
             VALUES (25, 33, 'BRAZIL');

        INSERT INTO map06_country_m05
             VALUES (283, 211, 'THAILAND');

        INSERT INTO map06_country_m05
             VALUES (26, 35, 'BRUNEI');

        INSERT INTO map06_country_m05
             VALUES (27, 36, 'BULGARIA');

        INSERT INTO map06_country_m05
             VALUES (28, 37, 'BURKINA FASO');

        INSERT INTO map06_country_m05
             VALUES (29, 38, 'BURUNDI');

        INSERT INTO map06_country_m05
             VALUES (245, 39, 'CAMBODIA');

        INSERT INTO map06_country_m05
             VALUES (33, 40, 'CAMEROON');

        INSERT INTO map06_country_m05
             VALUES (406, 41, 'CANADA');

        INSERT INTO map06_country_m05
             VALUES (35, 42, 'CAPE VERDE');

        INSERT INTO map06_country_m05
             VALUES (36, 43, 'CAYMAN ISLANDS');

        INSERT INTO map06_country_m05
             VALUES (408, 224, 'UNITED ARAB EMIRATES');

        INSERT INTO map06_country_m05
             VALUES (40, 45, 'CHAD');

        INSERT INTO map06_country_m05
             VALUES (41, 46, 'CHILE');

        INSERT INTO map06_country_m05
             VALUES (42, 47, 'CHINA');

        INSERT INTO map06_country_m05
             VALUES (43, 48, 'CHRISTMAS ISLAND');

        INSERT INTO map06_country_m05
             VALUES (37, 49, 'COCOS (KEELING) ISLANDS');

        INSERT INTO map06_country_m05
             VALUES (44, 50, 'COLOMBIA');

        INSERT INTO map06_country_m05
             VALUES (45, 51, 'COMOROS');

        INSERT INTO map06_country_m05
             VALUES (268, 31, 'BOTSWANA');

        INSERT INTO map06_country_m05
             VALUES (253, 53, 'CURACAO');

        INSERT INTO map06_country_m05
             VALUES (47, 54, 'COOK ISLANDS');

        INSERT INTO map06_country_m05
             VALUES (48, 55, 'COSTA RICA');

        INSERT INTO map06_country_m05
             VALUES (49, 56, 'COTE D''IVOIRE');

        INSERT INTO map06_country_m05
             VALUES (263, 57, 'CROATIA');

        INSERT INTO map06_country_m05
             VALUES (50, 58, 'CUBA');

        INSERT INTO map06_country_m05
             VALUES (51, 59, 'CYPRUS');

        INSERT INTO map06_country_m05
             VALUES (255, 60, 'CZECHIA (CZECH REPUBLIC FORMER YUGOSLAVIA)');

        INSERT INTO map06_country_m05
             VALUES (61, 61, 'DENMARK');

        INSERT INTO map06_country_m05
             VALUES (56, 62, 'DJIBOUTI');

        INSERT INTO map06_country_m05
             VALUES (57, 63, 'DOMINICA');

        INSERT INTO map06_country_m05
             VALUES (58, 64, 'DOMINICAN REPUBLIC');

        INSERT INTO map06_country_m05
             VALUES (63, 65, 'ECUADOR');

        INSERT INTO map06_country_m05
             VALUES (64, 66, 'EGYPT');

        INSERT INTO map06_country_m05
             VALUES (65, 67, 'EL SALVADOR');

        INSERT INTO map06_country_m05
             VALUES (67, 68, 'EQUATORIAL GUINEA');

        INSERT INTO map06_country_m05
             VALUES (383, 206, 'SWITZERLAND');

        INSERT INTO map06_country_m05
             VALUES (274, 70, 'ESTONIA');

        INSERT INTO map06_country_m05
             VALUES (68, 71, 'ETHIOPIA');

        INSERT INTO map06_country_m05
             VALUES (71, 72, 'FALKLAND ISLANDS (MALVINAS)');

        INSERT INTO map06_country_m05
             VALUES (72, 73, 'FAROE ISLANDS');

        INSERT INTO map06_country_m05
             VALUES (73, 74, 'FIJI');

        INSERT INTO map06_country_m05
             VALUES (74, 75, 'FINLAND');

        INSERT INTO map06_country_m05
             VALUES (75, 76, 'FRANCE');

        INSERT INTO map06_country_m05
             VALUES (76, 77, 'FRENCH GUIANA');

        INSERT INTO map06_country_m05
             VALUES (77, 78, 'FRENCH POLYNESIA');

        INSERT INTO map06_country_m05
             VALUES (126, 123, 'LIBYA');

        INSERT INTO map06_country_m05
             VALUES (79, 80, 'GABON');

        INSERT INTO map06_country_m05
             VALUES (270, 81, 'GAMBIA');

        INSERT INTO map06_country_m05
             VALUES (295, 82, 'GEORGIA');

        INSERT INTO map06_country_m05
             VALUES (299, 83, 'GERMANY');

        INSERT INTO map06_country_m05
             VALUES (80, 84, 'GHANA');

        INSERT INTO map06_country_m05
             VALUES (84, 85, 'GIBRALTAR');

        INSERT INTO map06_country_m05
             VALUES (83, 86, 'GREECE');

        INSERT INTO map06_country_m05
             VALUES (85, 87, 'GREENLAND');

        INSERT INTO map06_country_m05
             VALUES (86, 88, 'GRENADA');

        INSERT INTO map06_country_m05
             VALUES (87, 89, 'GUADELOUPE');

        INSERT INTO map06_country_m05
             VALUES (88, 90, 'GUAM');

        INSERT INTO map06_country_m05
             VALUES (89, 91, 'GUATEMALA');

        INSERT INTO map06_country_m05
             VALUES (91, 92, 'GUINEA');

        INSERT INTO map06_country_m05
             VALUES (123, 183, 'SAINT LUCIA');

        INSERT INTO map06_country_m05
             VALUES (92, 94, 'GUYANA');

        INSERT INTO map06_country_m05
             VALUES (94, 95, 'HAITI');

        INSERT INTO map06_country_m05
             VALUES (95, 96, 'HEARD AND MC DONALD ISLANDS');

        INSERT INTO map06_country_m05
             VALUES (96, 97, 'HONDURAS');

        INSERT INTO map06_country_m05
             VALUES (97, 98, 'HONG KONG');

        INSERT INTO map06_country_m05
             VALUES (98, 99, 'HUNGARY');

        INSERT INTO map06_country_m05
             VALUES (108, 100, 'ICELAND');

        INSERT INTO map06_country_m05
             VALUES (100, 101, 'INDIA');

        INSERT INTO map06_country_m05
             VALUES (101, 102, 'INDONESIA');

        INSERT INTO map06_country_m05
             VALUES (102, 103, 'IRAN');

        INSERT INTO map06_country_m05
             VALUES (103, 104, 'IRAQ');

        INSERT INTO map06_country_m05
             VALUES (104, 105, 'IRELAND');

        INSERT INTO map06_country_m05
             VALUES (106, 106, 'ISRAEL');

        INSERT INTO map06_country_m05
             VALUES (107, 107, 'ITALY');

        INSERT INTO map06_country_m05
             VALUES (109, 108, 'JAMAICA');

        INSERT INTO map06_country_m05
             VALUES (110, 109, 'JAPAN');

        INSERT INTO map06_country_m05
             VALUES (111, 110, 'JORDAN');

        INSERT INTO map06_country_m05
             VALUES (289, 111, 'KAZAKHSTAN');

        INSERT INTO map06_country_m05
             VALUES (113, 112, 'KENYA');

        INSERT INTO map06_country_m05
             VALUES (114, 113, 'KIRIBATI');

        INSERT INTO map06_country_m05
             VALUES (171, 184, 'SAINT PIERRE AND MIQUELON');

        INSERT INTO map06_country_m05
             VALUES (187, 185, 'SAINT VINCENT AND THE GRENADINES');

        INSERT INTO map06_country_m05
             VALUES (117, 116, 'KUWAIT');

        INSERT INTO map06_country_m05
             VALUES (290, 117, 'KYRGYZSTAN');

        INSERT INTO map06_country_m05
             VALUES (119, 118, 'LAOS');

        INSERT INTO map06_country_m05
             VALUES (247, 119, 'LATVIA');

        INSERT INTO map06_country_m05
             VALUES (120, 120, 'LEBANON');

        INSERT INTO map06_country_m05
             VALUES (121, 121, 'LESOTHO');

        INSERT INTO map06_country_m05
             VALUES (122, 122, 'LIBERIA');

        INSERT INTO map06_country_m05
             VALUES (194, 207, 'SYRIA');

        INSERT INTO map06_country_m05
             VALUES (372, 208, 'TAIWAN');

        INSERT INTO map06_country_m05
             VALUES (239, 125, 'LITHUANIA');

        INSERT INTO map06_country_m05
             VALUES (125, 126, 'LUXEMBOURG');

        INSERT INTO map06_country_m05
             VALUES (128, 127, 'MACAU');

        INSERT INTO map06_country_m05
             VALUES (323, 41, 'CANADA');

        INSERT INTO map06_country_m05
             VALUES (129, 129, 'MADAGASCAR');

        INSERT INTO map06_country_m05
             VALUES (130, 130, 'MALAWI');

        INSERT INTO map06_country_m05
             VALUES (131, 131, 'MALAYSIA');

        INSERT INTO map06_country_m05
             VALUES (132, 132, 'MALDIVES');

        INSERT INTO map06_country_m05
             VALUES (133, 133, 'MALI');

        INSERT INTO map06_country_m05
             VALUES (252, 134, 'MALTA');

        INSERT INTO map06_country_m05
             VALUES (134, 135, 'MARSHALL ISLANDS');

        INSERT INTO map06_country_m05
             VALUES (135, 136, 'MARTINIQUE');

        INSERT INTO map06_country_m05
             VALUES (136, 137, 'MAURITANIA');

        INSERT INTO map06_country_m05
             VALUES (137, 138, 'MAURITIUS');

        INSERT INTO map06_country_m05
             VALUES (329, 225, 'UNITED KINGDOM');

        INSERT INTO map06_country_m05
             VALUES (138, 140, 'MEXICO');

        INSERT INTO map06_country_m05
             VALUES (78, 141, 'FEDERATED STATES OF MICRONESIA');

        INSERT INTO map06_country_m05
             VALUES (318, 132, 'MALDIVES');

        INSERT INTO map06_country_m05
             VALUES (140, 143, 'MONACO');

        INSERT INTO map06_country_m05
             VALUES (141, 144, 'MONGOLIA');

        INSERT INTO map06_country_m05
             VALUES (142, 145, 'MONTSERRAT');

        INSERT INTO map06_country_m05
             VALUES (143, 146, 'MOROCCO');

        INSERT INTO map06_country_m05
             VALUES (144, 147, 'MOZAMBIQUE');

        INSERT INTO map06_country_m05
             VALUES (32, 148, 'MYANMAR');

        INSERT INTO map06_country_m05
             VALUES (146, 149, 'NAMIBIA');

        INSERT INTO map06_country_m05
             VALUES (147, 150, 'NAURU');

        INSERT INTO map06_country_m05
             VALUES (148, 151, 'NEPAL');

        INSERT INTO map06_country_m05
             VALUES (149, 152, 'NETHERLANDS');

        INSERT INTO map06_country_m05
             VALUES (13, 153, 'NETHERLANDS ANTILLES');

        INSERT INTO map06_country_m05
             VALUES (152, 154, 'NEW CALEDONIA');

        INSERT INTO map06_country_m05
             VALUES (151, 155, 'NEW ZEALAND');

        INSERT INTO map06_country_m05
             VALUES (153, 156, 'NICARAGUA');

        INSERT INTO map06_country_m05
             VALUES (154, 157, 'NIGER');

        INSERT INTO map06_country_m05
             VALUES (156, 158, 'NIGERIA');

        INSERT INTO map06_country_m05
             VALUES (158, 159, 'NIUE');

        INSERT INTO map06_country_m05
             VALUES (155, 160, 'NORFOLK ISLAND');

        INSERT INTO map06_country_m05
             VALUES (145, 161, 'NORTHERN MARIANA ISLANDS');

        INSERT INTO map06_country_m05
             VALUES (157, 162, 'NORWAY');

        INSERT INTO map06_country_m05
             VALUES (159, 163, 'OMAN');

        INSERT INTO map06_country_m05
             VALUES (160, 164, 'PAKISTAN');

        INSERT INTO map06_country_m05
             VALUES (161, 165, 'PALAU');

        INSERT INTO map06_country_m05
             VALUES (353, 226, 'UNITED STATES OF AMERICA');

        INSERT INTO map06_country_m05
             VALUES (162, 167, 'PANAMA');

        INSERT INTO map06_country_m05
             VALUES (163, 168, 'PAPUA NEW GUINEA');

        INSERT INTO map06_country_m05
             VALUES (164, 169, 'PARAGUAY');

        INSERT INTO map06_country_m05
             VALUES (165, 170, 'PERU');

        INSERT INTO map06_country_m05
             VALUES (166, 171, 'PHILIPPINES');

        INSERT INTO map06_country_m05
             VALUES (167, 172, 'PITCAIRN');

        INSERT INTO map06_country_m05
             VALUES (168, 173, 'POLAND');

        INSERT INTO map06_country_m05
             VALUES (170, 174, 'PORTUGAL');

        INSERT INTO map06_country_m05
             VALUES (226, 175, 'PUERTO RICO');

        INSERT INTO map06_country_m05
             VALUES (172, 176, 'QATAR');

        INSERT INTO map06_country_m05
             VALUES (173, 177, 'REUNION');

        INSERT INTO map06_country_m05
             VALUES (174, 178, 'ROMANIA');

        INSERT INTO map06_country_m05
             VALUES (264, 179, 'RUSSIAN FEDERATION');

        INSERT INTO map06_country_m05
             VALUES (175, 180, 'RWANDA');

        INSERT INTO map06_country_m05
             VALUES (374, 111, 'KAZAKHSTAN');

        INSERT INTO map06_country_m05
             VALUES (294, 20, 'BAHRAIN');

        INSERT INTO map06_country_m05
             VALUES (411, 20, 'BAHRAIN');

        INSERT INTO map06_country_m05
             VALUES (293, 226, 'UNITED STATES OF AMERICA');

        INSERT INTO map06_country_m05
             VALUES (327, 226, 'UNITED STATES OF AMERICA');

        INSERT INTO map06_country_m05
             VALUES (176, 186, 'SAMOA');

        INSERT INTO map06_country_m05
             VALUES (177, 187, 'SAN MARINO');

        INSERT INTO map06_country_m05
             VALUES (178, 188, 'SAO TOME AND PRINCIPE');

        INSERT INTO map06_country_m05
             VALUES (180, 189, 'SENEGAL');

        INSERT INTO map06_country_m05
             VALUES (265, 190, 'SERBIA AND MONTENEGRO');

        INSERT INTO map06_country_m05
             VALUES (181, 191, 'SEYCHELLES');

        INSERT INTO map06_country_m05
             VALUES (182, 192, 'SIERRA LEONE');

        INSERT INTO map06_country_m05
             VALUES (183, 193, 'SINGAPORE');

        INSERT INTO map06_country_m05
             VALUES (266, 194, 'SLOVAKIA');

        INSERT INTO map06_country_m05
             VALUES (240, 195, 'SLOVENIA');

        INSERT INTO map06_country_m05
             VALUES (184, 196, 'SOLOMON ISLANDS');

        INSERT INTO map06_country_m05
             VALUES (185, 197, 'SOMALIA');

        INSERT INTO map06_country_m05
             VALUES (225, 198, 'SOUTH AFRICA');

        INSERT INTO map06_country_m05
             VALUES (354, 107, 'ITALY');

        INSERT INTO map06_country_m05
             VALUES (70, 200, 'SPAIN');

        INSERT INTO map06_country_m05
             VALUES (189, 201, 'SUDAN');

        INSERT INTO map06_country_m05
             VALUES (257, 202, 'SURINAME');

        INSERT INTO map06_country_m05
             VALUES (191, 203, 'SVALBARD AND JAN MAYEN ISLANDS');

        INSERT INTO map06_country_m05
             VALUES (192, 204, 'SWAZILAND');

        INSERT INTO map06_country_m05
             VALUES (193, 205, 'SWEDEN');

        INSERT INTO map06_country_m05
             VALUES (82, 206, 'SWITZERLAND');

        INSERT INTO map06_country_m05
             VALUES (375, 41, 'CANADA');

        INSERT INTO map06_country_m05
             VALUES (196, 208, 'TAIWAN');

        INSERT INTO map06_country_m05
             VALUES (368, 209, 'TAJIKISTAN');

        INSERT INTO map06_country_m05
             VALUES (197, 210, 'TANZANIA');

        INSERT INTO map06_country_m05
             VALUES (198, 211, 'THAILAND');

        INSERT INTO map06_country_m05
             VALUES (62, 212, 'TIMOR LESTE');

        INSERT INTO map06_country_m05
             VALUES (199, 213, 'TOGO');

        INSERT INTO map06_country_m05
             VALUES (200, 214, 'TOKELAU');

        INSERT INTO map06_country_m05
             VALUES (201, 215, 'TONGA');

        INSERT INTO map06_country_m05
             VALUES (202, 216, 'TRINIDAD AND TOBAGO');

        INSERT INTO map06_country_m05
             VALUES (203, 217, 'TUNISIA');

        INSERT INTO map06_country_m05
             VALUES (204, 218, 'TURKEY');

        INSERT INTO map06_country_m05
             VALUES (402, 219, 'TURKMENISTAN');

        INSERT INTO map06_country_m05
             VALUES (205, 220, 'TURKS AND CAICOS ISLANDS');

        INSERT INTO map06_country_m05
             VALUES (206, 221, 'TUVALU');

        INSERT INTO map06_country_m05
             VALUES (208, 222, 'UGANDA');

        INSERT INTO map06_country_m05
             VALUES (209, 223, 'UKRAINE');

        INSERT INTO map06_country_m05
             VALUES (12, 224, 'UNITED ARAB EMIRATES');

        INSERT INTO map06_country_m05
             VALUES (93, 225, 'UNITED KINGDOM');

        INSERT INTO map06_country_m05
             VALUES (210, 226, 'UNITED STATES OF AMERICA');

        INSERT INTO map06_country_m05
             VALUES (292, 40, 'CAMEROON');

        INSERT INTO map06_country_m05
             VALUES (211, 228, 'URUGUAY');

        INSERT INTO map06_country_m05
             VALUES (400, 229, 'UZBEKISTAN');

        INSERT INTO map06_country_m05
             VALUES (212, 230, 'VANUATU');

        INSERT INTO map06_country_m05
             VALUES (325, 106, 'ISRAEL');

        INSERT INTO map06_country_m05
             VALUES (214, 232, 'VENEZUELA');

        INSERT INTO map06_country_m05
             VALUES (215, 233, 'VIETNAM');

        INSERT INTO map06_country_m05
             VALUES (217, 234, 'BRITISH VIRGIN ISLANDS');

        INSERT INTO map06_country_m05
             VALUES (216, 235, 'U.S. VIRGIN ISLANDS');

        INSERT INTO map06_country_m05
             VALUES (218, 236, 'WALLIS AND FUTUNA ISLANDS');

        INSERT INTO map06_country_m05
             VALUES (69, 237, 'WESTERN SAHARA');

        INSERT INTO map06_country_m05
             VALUES (219, 238, 'YEMEN');

        INSERT INTO map06_country_m05
             VALUES (223, 239, 'ZAMBIA');

        INSERT INTO map06_country_m05
             VALUES (224, 240, 'ZIMBABWE');

        INSERT INTO map06_country_m05
             VALUES (34, 41, 'CANADA');

        INSERT INTO map06_country_m05
             VALUES (221, 238, 'YEMEN');

        INSERT INTO map06_country_m05
             VALUES (59, 83, 'GERMANY');

        INSERT INTO map06_country_m05
             VALUES (350, 83, 'GERMANY');

        INSERT INTO map06_country_m05
             VALUES (231, 194, 'SLOVAKIA');

        INSERT INTO map06_country_m05
             VALUES (296, 225, 'UNITED KINGDOM');

        INSERT INTO map06_country_m05
             VALUES (262, 148, 'MYANMAR');

        INSERT INTO map06_country_m05
             VALUES (258, 220, 'TURKS AND CAICOS ISLANDS');
    END IF;
END;
/
