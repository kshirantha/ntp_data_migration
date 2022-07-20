CREATE TABLE dfn_ntp.m185_custody_excb_cash_account
(
    m185_id                          NUMBER (10, 0) NOT NULL,
    m185_institute_id_m02            NUMBER (3, 0),
    m185_accountno                   VARCHAR2 (50 BYTE) NOT NULL,
    m185_custody_execbroker_id_m26   NUMBER (10, 0) NOT NULL,
    m185_balance                     NUMBER (18, 5) DEFAULT 0 NOT NULL,
    m185_currency_code_m03           CHAR (3 BYTE) NOT NULL,
    m185_currency_id_m03             NUMBER (15, 0),
    m185_created_by_id_u17           NUMBER (10, 0) NOT NULL,
    m185_created_date                DATE DEFAULT SYSDATE NOT NULL,
    m185_lastupdated_by_id_u17       NUMBER (10, 0),
    m185_lastupdated_date            DATE,
    m185_status_id_v01               NUMBER (20, 0) NOT NULL,
    m185_status_changed_by_id_u17    NUMBER (10, 0) NOT NULL,
    m185_status_changed_date         DATE NOT NULL,
    m185_custom_type                 VARCHAR2 (50 BYTE) DEFAULT 1
)
/



CREATE UNIQUE INDEX dfn_ntp.m185_accountn_uk
    ON dfn_ntp.m185_custody_excb_cash_account (m185_accountno ASC)
/


ALTER TABLE dfn_ntp.m185_custody_excb_cash_account
    ADD CONSTRAINT m185_pk PRIMARY KEY (m185_id) USING INDEX
/

COMMENT ON TABLE dfn_ntp.m185_custody_excb_cash_account IS
    'this table keeps the cash accounts of custody and exec broker'
/
COMMENT ON COLUMN dfn_ntp.m185_custody_excb_cash_account.m185_custody_execbroker_id_m26 IS
    'fk from m26'
/