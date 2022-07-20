DECLARE
    l_count   NUMBER := 0;
BEGIN
    SELECT COUNT (*) INTO l_count FROM map07_city_m06;

    IF l_count = 0
    THEN
        INSERT INTO map07_city_m06
             VALUES (1, 1, 'Riyadh');

        INSERT INTO map07_city_m06
             VALUES (2, 1, 'Riyadh');

        INSERT INTO map07_city_m06
             VALUES (3, 3, 'Qasseem');

        INSERT INTO map07_city_m06
             VALUES (4, 18, 'Aflaj');

        INSERT INTO map07_city_m06
             VALUES (5, 12, 'Jeddah');

        INSERT INTO map07_city_m06
             VALUES (6, 2, 'Dammam');

        INSERT INTO map07_city_m06
             VALUES (7, 7, 'Abu Dhabia');

        INSERT INTO map07_city_m06
             VALUES (8, 4, 'Dubai');

        INSERT INTO map07_city_m06
             VALUES (9, 22, 'Abha');

        INSERT INTO map07_city_m06
             VALUES (10, 25, 'New York');

        INSERT INTO map07_city_m06
             VALUES (11, 11, 'Beirut');

        INSERT INTO map07_city_m06
             VALUES (12, 13, 'Al Khobar');

        INSERT INTO map07_city_m06
             VALUES (13, 13, 'Al Khobar');

        INSERT INTO map07_city_m06
             VALUES (14, 14, 'Istanbul');

        INSERT INTO map07_city_m06
             VALUES (15, 15, 'Geneva');

        INSERT INTO map07_city_m06
             VALUES (16, 1, 'Riyadh');

        INSERT INTO map07_city_m06
             VALUES (21, 21, 'Ahad Almasarha');

        INSERT INTO map07_city_m06
             VALUES (28, 1, 'Riyadh');

        INSERT INTO map07_city_m06
             VALUES (30, 17, 'Abu Arish');

        INSERT INTO map07_city_m06
             VALUES (31, 20, 'Rabigh');

        INSERT INTO map07_city_m06
             VALUES (32, 19, 'Al Qatif');

        INSERT INTO map07_city_m06
             VALUES (34, 18, 'Aflaj');

        INSERT INTO map07_city_m06
             VALUES (35, 21, 'Ahad Almasarha');

        INSERT INTO map07_city_m06
             VALUES (36, 24, 'Hyderabad');

        INSERT INTO map07_city_m06
             VALUES (37, 23, 'Afif');

        -- For SFC UAT

        INSERT INTO map07_city_m06
             VALUES (45, 22, 'Abha');

        INSERT INTO map07_city_m06
             VALUES (75, 22, 'Abha');

        INSERT INTO map07_city_m06
             VALUES (90, 7, 'Abu Dhabia');

        INSERT INTO map07_city_m06
             VALUES (71, 26, 'Adleyah');

        INSERT INTO map07_city_m06
             VALUES (65, 23, 'Afif');

        INSERT INTO map07_city_m06
             VALUES (52, 21, 'Ahad Almasarha');

        INSERT INTO map07_city_m06
             VALUES (77, 27, 'Ahad Rafidah');

        INSERT INTO map07_city_m06
             VALUES (123, 28, 'Ain Dar');

        INSERT INTO map07_city_m06
             VALUES (116, 29, 'Al Bahah');

        INSERT INTO map07_city_m06
             VALUES (101, 30, 'Al Dawadmi');

        INSERT INTO map07_city_m06
             VALUES (114, 31, 'Al Fawarah');

        INSERT INTO map07_city_m06
             VALUES (109, 32, 'Al Kharj');

        INSERT INTO map07_city_m06
             VALUES (131, 33, 'Al Jadida');

        INSERT INTO map07_city_m06
             VALUES (50, 34, 'Al Ahsa');

        INSERT INTO map07_city_m06
             VALUES (57, 35, 'Al Awamiyah');

        INSERT INTO map07_city_m06
             VALUES (87, 36, 'Al Qudaih');

        INSERT INTO map07_city_m06
             VALUES (54, 13, 'Al Khobar');

        INSERT INTO map07_city_m06
             VALUES (93, 37, 'Al Asyah');

        INSERT INTO map07_city_m06
             VALUES (43, 38, 'Badr');

        INSERT INTO map07_city_m06
             VALUES (60, 39, 'Buraydah');

        INSERT INTO map07_city_m06
             VALUES (68, 40, 'Dhahran');

        INSERT INTO map07_city_m06
             VALUES (147, 41, 'Faifa');

        INSERT INTO map07_city_m06
             VALUES (42, 42, 'Hafar Al Batin');

        INSERT INTO map07_city_m06
             VALUES (120, 43, 'Hail');

        INSERT INTO map07_city_m06
             VALUES (107, 44, 'Al Hofuf');

        INSERT INTO map07_city_m06
             VALUES (56, 12, 'Jeddah');

        INSERT INTO map07_city_m06
             VALUES (74, 45, 'Jizan');

        INSERT INTO map07_city_m06
             VALUES (146, 46, 'Al Jubail');

        INSERT INTO map07_city_m06
             VALUES (142, 46, 'Al Jubail');

        INSERT INTO map07_city_m06
             VALUES (59, 47, 'Khamis Mushait');

        INSERT INTO map07_city_m06
             VALUES (143, 48, 'London');

        INSERT INTO map07_city_m06
             VALUES (44, 49, 'Madina');

        INSERT INTO map07_city_m06
             VALUES (61, 50, 'Mecca');

        INSERT INTO map07_city_m06
             VALUES (79, 5, 'Manama');

        INSERT INTO map07_city_m06
             VALUES (132, 51, 'Al Mubarraz');

        INSERT INTO map07_city_m06
             VALUES (119, 52, 'Yoshkar Ola');

        INSERT INTO map07_city_m06
             VALUES (108, 53, 'Onaiza');

        INSERT INTO map07_city_m06
             VALUES (51, 19, 'Al Qatif');

        INSERT INTO map07_city_m06
             VALUES (92, 54, 'Ras Tanura');

        INSERT INTO map07_city_m06
             VALUES (144, 1, 'Riyadh');

        INSERT INTO map07_city_m06
             VALUES (103, 55, 'Sabya');

        INSERT INTO map07_city_m06
             VALUES (89, 56, 'Safwa');

        INSERT INTO map07_city_m06
             VALUES (136, 58, 'Sanabis');

        INSERT INTO map07_city_m06
             VALUES (95, 59, 'Saihat');

        INSERT INTO map07_city_m06
             VALUES (138, 60, 'Tabuk');

        INSERT INTO map07_city_m06
             VALUES (141, 61, 'Taif');

        INSERT INTO map07_city_m06
             VALUES (110, 7, 'Abu Dhabia');
		
		INSERT INTO map07_city_m06
             VALUES (38, 16, 'Colombo');
			 
		INSERT INTO map07_city_m06
             VALUES (55, 2, 'Dammam');
			 
		INSERT INTO map07_city_m06
             VALUES (72, 57, 'Sakaka');
			
		INSERT INTO map07_city_m06
             VALUES (73, 62, 'Al Jawf');
			 
		INSERT INTO map07_city_m06
             VALUES (96, 63, 'Noida');
			 
		INSERT INTO map07_city_m06
             VALUES (126, 4, 'Dubai');
			 
		INSERT INTO map07_city_m06
             VALUES (127, 4, 'Dubai');
			 
		INSERT INTO map07_city_m06
             VALUES (130, 64, 'Al Rahwa');
    END IF;
END;
/
