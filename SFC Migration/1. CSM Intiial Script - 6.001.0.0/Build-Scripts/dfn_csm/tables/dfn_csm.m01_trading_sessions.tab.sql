DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'DROP TABLE dfn_csm.m01_trading_sessions';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tables
     WHERE     owner = UPPER ('dfn_csm')
           AND table_name = UPPER ('m01_trading_sessions');

    IF l_count = 1
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

CREATE TABLE dfn_csm.m01_trading_sessions
(
    m01_id                  NUMBER (10, 0) NOT NULL,
    m01_session_code        VARCHAR2 (50 BYTE),
    m01_session_status      NUMBER (1, 0) NOT NULL,
    m01_last_eod_date       DATE,
    m01_active_session_id   VARCHAR2 (50 BYTE),
    m01_last_open_date      DATE
)
/



ALTER TABLE dfn_csm.m01_trading_sessions
ADD CONSTRAINT m01_id PRIMARY KEY (m01_id)
USING INDEX
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_csm.m01_trading_sessions
RENAME COLUMN m01_session_status TO m01_session_connect_status
';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_csm')
           AND table_name = UPPER ('m01_trading_sessions')
           AND column_name = UPPER ('m01_session_status');

    IF l_count = 1
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;

/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
                  := 'ALTER TABLE dfn_csm.m01_trading_sessions
ADD (
m01_session_login_status NUMBER (1, 0) NOT NULL
)';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_csm')
           AND table_name = UPPER ('m01_trading_sessions')
           AND column_name = UPPER ('m01_session_login_status');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/
