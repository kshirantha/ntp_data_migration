------------------------ Public DB Links from SYS User -------------------------

/*
DECLARE
    l_link_cnt   NUMBER := 0;
BEGIN
    SELECT COUNT (*)
      INTO l_link_cnt
      FROM user_objects
     WHERE object_type = 'DATABASE LINK' AND object_name = 'MUBASHER_DB_LINK';

    IF l_link_cnt = 1
    THEN
        EXECUTE IMMEDIATE 'DROP DATABASE LINK MUBASHER_DB_LINK';
		EXECUTE IMMEDIATE
               'CREATE PUBLIC DATABASE LINK MUBASHER_DB_LINK CONNECT TO MUBASHER_OMS_MIG IDENTIFIED BY password  USING '
            || '''127.0.0.1/SOURCEDB'''
            || ' ';
    ELSE
        EXECUTE IMMEDIATE
               'CREATE PUBLIC DATABASE LINK MUBASHER_DB_LINK CONNECT TO MUBASHER_OMS_MIG IDENTIFIED BY password  USING '
            || '''127.0.01/SOURCEDB'''
            || ' ';
    END IF;
END;
/

DECLARE
    l_link_cnt   NUMBER := 0;
BEGIN
    SELECT COUNT (*)
      INTO l_link_cnt
      FROM user_objects
     WHERE object_type = 'DATABASE LINK' AND object_name = 'MUBASHER_PRICE_LINK';

    IF l_link_cnt = 1
    THEN
        EXECUTE IMMEDIATE 'DROP DATABASE LINK MUBASHER_PRICE_LINK';
		EXECUTE IMMEDIATE
               'CREATE PUBLIC DATABASE LINK MUBASHER_PRICE_LINK CONNECT TO MUBASHER_PRICE_MIG IDENTIFIED BY password  USING '
            || '''127.0.0.1/SOURCEDB'''
            || ' ';
    ELSE
        EXECUTE IMMEDIATE
               'CREATE PUBLIC DATABASE LINK MUBASHER_PRICE_LINK CONNECT TO MUBASHER_PRICE_MIG IDENTIFIED BY password  USING '
            || '''127.0.01/SOURCEDB'''
            || ' ';
    END IF;
END;
/
*/

------------------------ Private DB Links from Other User -------------------------

DECLARE
    l_link_cnt   NUMBER := 0;
BEGIN
    SELECT COUNT (*)
      INTO l_link_cnt
      FROM user_objects
     WHERE object_type = 'DATABASE LINK' AND object_name = 'MUBASHER_DB_LINK';

    IF l_link_cnt = 1
    THEN
        EXECUTE IMMEDIATE 'DROP DATABASE LINK MUBASHER_DB_LINK';
		EXECUTE IMMEDIATE
               'CREATE DATABASE LINK MUBASHER_DB_LINK CONNECT TO MUBASHER_OMS_MIG IDENTIFIED BY password  USING '
            || '''192.168.14.240:1523/SFCMIG'''
            || ' ';
    ELSE
        EXECUTE IMMEDIATE
               'CREATE DATABASE LINK MUBASHER_DB_LINK CONNECT TO MUBASHER_OMS_MIG IDENTIFIED BY password  USING '
            || '''192.168.14.240:1523/SFCMIG'''
            || ' ';
    END IF;
END;
/

DECLARE
    l_link_cnt   NUMBER := 0;
BEGIN
    SELECT COUNT (*)
      INTO l_link_cnt
      FROM user_objects
     WHERE object_type = 'DATABASE LINK' AND object_name = 'MUBASHER_PRICE_LINK';

    IF l_link_cnt = 1
    THEN
        EXECUTE IMMEDIATE 'DROP DATABASE LINK MUBASHER_PRICE_LINK';
		EXECUTE IMMEDIATE
               'CREATE DATABASE LINK MUBASHER_PRICE_LINK CONNECT TO MUBASHER_PRICE_MIG IDENTIFIED BY password  USING '
            || '''192.168.14.240:1523/SFCMIG'''
            || ' ';
    ELSE
        EXECUTE IMMEDIATE
               'CREATE DATABASE LINK MUBASHER_PRICE_LINK CONNECT TO MUBASHER_PRICE_MIG IDENTIFIED BY password  USING '
            || '''192.168.14.240:1523/SFCMIG'''
            || ' ';
    END IF;
END;
/