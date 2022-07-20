CREATE TABLE dfn_ntp.m189_limit_adjust_requests
(
	m189_id                        NUMBER(10,0),
    m189_customer_id_u01           NUMBER(10,0),
    m189_login_id_u09              NUMBER(10,0),
    m189_cash_account_id_u06       NUMBER(10,0),
    m189_cash_transfer_limit       NUMBER(10,0),
    m189_buy_order_limit           NUMBER(10,0),
    m189_sell_order_limit          NUMBER(10,0),
    m189_created_date              DATE,
    m189_status_id_v01             NUMBER(10,0),
    m189_status_changed_by_id_u17  NUMBER(10,0),
    m189_status_changed_date       DATE,
    m189_institution_id_m02        NUMBER(10,0),
    m189_custom_type               VARCHAR2(50 BYTE),
	m189_created_by_id_u17         NUMBER(10,0)
)
/
DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
                  := 'ALTER TABLE dfn_ntp.M189_LIMIT_ADJUST_REQUESTS 
 ADD (
  M189_LIMIT_TYPE NUMBER (2)
 )';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_ntp')
           AND table_name = UPPER ('M189_LIMIT_ADJUST_REQUESTS')
           AND column_name = UPPER ('M189_LIMIT_TYPE');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

COMMENT ON COLUMN dfn_ntp.m189_limit_adjust_requests.m189_limit_type IS
    '1=Order, 2=Transfer'
/

CREATE INDEX dfn_ntp.m189_id_u06
    ON dfn_ntp.m189_limit_adjust_requests (m189_cash_account_id_u06 ASC)
/

ALTER TABLE dfn_ntp.m189_limit_adjust_requests
ADD CONSTRAINT m189_pk PRIMARY KEY (m189_id)
USING INDEX
/
