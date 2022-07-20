DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'DROP TABLE dfn_csm.a04_settlement_instruction';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tables
     WHERE     owner = UPPER ('dfn_csm')
           AND table_name = UPPER ('a04_settlement_instruction');

    IF l_count = 1
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

CREATE TABLE dfn_csm.a04_settlement_instruction
(
    a04_reqid                VARCHAR2 (100 BYTE),
    a04_function             VARCHAR2 (500 BYTE),
    a04_prep_date            VARCHAR2 (20 BYTE),
    a04_parent_reqid         VARCHAR2 (50 BYTE),
    a04_process_status       VARCHAR2 (10 BYTE),
    a04_match_status         VARCHAR2 (10 BYTE),
    a04_settlement_status    VARCHAR2 (10 BYTE),
    a04_reason_nmat          VARCHAR2 (500 BYTE),
    a04_isin_code            VARCHAR2 (50 BYTE),
    a04_quantity             NUMBER,
    a04_amount               NUMBER,
    a04_csd_no               VARCHAR2 (50 BYTE),
    a04_trade_date           VARCHAR2 (50 BYTE),
    a04_settlement_date      VARCHAR2 (50 BYTE),
    a04_effect_settle_date   VARCHAR2 (50 BYTE)
)
/


