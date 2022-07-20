CREATE TABLE dfn_ntp.m36_settlement_calendar
(
    m36_buy_cash_settle_date         DATE,
    m36_buy_holdings_settle_date     DATE,
    m36_sell_cash_settle_date        DATE,
    m36_sell_holdings_settle_date    DATE,
    m36_month_end                    DATE,
    m36_week_end                     DATE,
    m36_date                         DATE,
    m36_exchange_code_m01            VARCHAR2 (10 BYTE),
    m36_instrument_type_code_v09     VARCHAR2 (20 BYTE),
    m36_symbol_settle_category_v11   NUMBER (10, 2),
    m36_cust_settle_group_id_m35     NUMBER (10, 2),
    m36_description                  VARCHAR2 (200 BYTE),
    m36_holiday                      NUMBER (1, 0),
    m36_working_day                  NUMBER (5, 0),
    m36_institution_id_m02           NUMBER (5, 0),
    m36_instrument_type_id_v09       NUMBER (10, 0),
    m36_year                         NUMBER (5, 0),
    is_temp_record                   NUMBER (1, 0) DEFAULT 0
)
/

ALTER TABLE dfn_ntp.m36_settlement_calendar
    ADD CONSTRAINT pk_m36_settlement_calendar PRIMARY KEY
            (m36_date,
             m36_exchange_code_m01,
             m36_instrument_type_code_v09,
             m36_symbol_settle_category_v11,
             m36_cust_settle_group_id_m35,
             m36_year)
            USING INDEX
/

COMMENT ON COLUMN dfn_ntp.m36_settlement_calendar.m36_holiday IS
    '0 - working day, 1 - weekend, 2 - special holiday'
/

ALTER TABLE dfn_ntp.M36_SETTLEMENT_CALENDAR 
 ADD (
  M36_SETTLE_CAL_CONF_ID_M95 NUMBER (10)
 )
/

ALTER TABLE dfn_ntp.m36_settlement_calendar
 ADD (
  m36_board_code_m54 VARCHAR2 (6)
 )
/

ALTER TABLE dfn_ntp.m36_settlement_calendar 
DROP CONSTRAINT pk_m36_settlement_calendar
DROP     INDEX
/

ALTER TABLE dfn_ntp.m36_settlement_calendar
 MODIFY (
  m36_board_code_m54 VARCHAR2 (10 BYTE)

 )
/



DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
                  := 'ALTER TABLE dfn_ntp.M36_SETTLEMENT_CALENDAR 
 ADD (
  M36_LAST_WORK_DAY_FOR_HOLIDAY NUMBER (5, 0)
 )';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_ntp')
           AND table_name = UPPER ('M36_SETTLEMENT_CALENDAR ')
           AND column_name = UPPER ('M36_LAST_WORK_DAY_FOR_HOLIDAY');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/
