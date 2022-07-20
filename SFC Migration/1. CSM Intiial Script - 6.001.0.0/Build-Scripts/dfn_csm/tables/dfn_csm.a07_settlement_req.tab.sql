DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'DROP TABLE dfn_csm.a07_settlement_req';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tables
     WHERE     owner = UPPER ('dfn_csm')
           AND table_name = UPPER ('a07_settlement_req');

    IF l_count = 1
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

CREATE TABLE dfn_csm.a07_settlement_req
(
    a07_id          NUMBER (18, 0),
    a07_oms_ref     NUMBER (18, 0),
    a07_fix_msg     VARCHAR2 (2000 BYTE),
    a07_csd_no      VARCHAR2 (100 BYTE),
    a07_nin         VARCHAR2 (100 BYTE),
    a07_timestamp   DATE,
    a07_status      NUMBER (2, 0) DEFAULT 0
)
/


