DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
                  := 'CREATE TABLE dfn_csm.m07_clearing_member_details
    (
    m07_id            NUMBER (10, 0),
    m07_ex01_id       NUMBER (10, 0),
    m07_member_code   VARCHAR2 (100 BYTE),
    m07_description   VARCHAR2 (500 BYTE)
    )
SEGMENT CREATION IMMEDIATE
NOPARALLEL
LOGGING
MONITORING';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tables
     WHERE     owner = UPPER ('dfn_csm')
           AND table_name = UPPER ('m07_clearing_member_details');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/





COMMENT ON COLUMN dfn_csm.m07_clearing_member_details.m07_ex01_id IS
    'fk from mubasher_oms ex01'
/

ALTER TABLE dfn_csm.m07_clearing_member_details
 ADD (
  m07_broker_code VARCHAR2 (50)
 )
/

