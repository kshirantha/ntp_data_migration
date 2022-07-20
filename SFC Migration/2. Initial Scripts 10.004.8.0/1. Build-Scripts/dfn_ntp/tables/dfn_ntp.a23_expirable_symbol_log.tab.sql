DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'CREATE TABLE dfn_ntp.a23_expirable_symbol_log(    a23_id                  NUMBER (18, 0) NOT NULL,    a23_reference_id        NUMBER (18, 0) NOT NULL,    a23_request_date        DATE,    a23_expire_date         DATE,    a23_symbol_id_m20       NUMBER (10, 0) NOT NULL,    a23_exchange_code_m01   VARCHAR2 (10 BYTE) NOT NULL,    a23_institute_id_m02    NUMBER (5, 0) NOT NULL,    a23_trading_ac_id_u07   NUMBER (10, 0) NOT NULL,    a23_failed_reason       VARCHAR2 (2000 BYTE),    a23_status              NUMBER (2, 0))';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tables
     WHERE     owner = UPPER ('dfn_ntp')
           AND table_name = UPPER ('a23_expirable_symbol_log');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

COMMENT ON COLUMN dfn_ntp.a23_expirable_symbol_log.a23_reference_id IS
    'Reference id to identify same request entries'
/
