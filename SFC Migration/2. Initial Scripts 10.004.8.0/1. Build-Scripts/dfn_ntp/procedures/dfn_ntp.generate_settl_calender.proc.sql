CREATE OR REPLACE PROCEDURE dfn_ntp.generate_settl_calender (
    pexchange                  VARCHAR2,
    psartdate                  DATE,
    pweekend_holidays          VARCHAR2,
    pdefault_buy_tplus         INT,
    pdefault_sell_tplus        INT,
    pbuy_tplus_sun_cash        INT DEFAULT 0,
    pbuy_tplus_mon_cash        INT DEFAULT 0,
    pbuy_tplus_tue_cash        INT DEFAULT 0,
    pbuy_tplus_wed_cash        INT DEFAULT 0,
    pbuy_tplus_thu_cash        INT DEFAULT 0,
    pbuy_tplus_fri_cash        INT DEFAULT 0,
    pbuy_tplus_sat_cash        INT DEFAULT 0,
    psell_tplus_sun_cash       INT DEFAULT 2,
    psell_tplus_mon_cash       INT DEFAULT 2,
    psell_tplus_tue_cash       INT DEFAULT 2,
    psell_tplus_wed_cash       INT DEFAULT 2,
    psell_tplus_thu_cash       INT DEFAULT 2,
    psell_tplus_fri_cash       INT DEFAULT 2,
    psell_tplus_sat_cash       INT DEFAULT 2,
    pboard_code                VARCHAR,
    pinstitution               NUMBER DEFAULT 1,
    ploss_category             INT DEFAULT 0,
    pbuy_tplus_sun_holding     INT DEFAULT 0,
    pbuy_tplus_mon_holding     INT DEFAULT 0,
    pbuy_tplus_tue_holding     INT DEFAULT 0,
    pbuy_tplus_wed_holding     INT DEFAULT 0,
    pbuy_tplus_thu_holding     INT DEFAULT 0,
    pbuy_tplus_fri_holding     INT DEFAULT 0,
    pbuy_tplus_sat_holding     INT DEFAULT 0,
    psell_tplus_sun_holding    INT DEFAULT 2,
    psell_tplus_mon_holding    INT DEFAULT 2,
    psell_tplus_tue_holding    INT DEFAULT 2,
    psell_tplus_wed_holding    INT DEFAULT 2,
    psell_tplus_thu_holding    INT DEFAULT 2,
    psell_tplus_fri_holding    INT DEFAULT 2,
    psell_tplus_sat_holding    INT DEFAULT 2,
    psettlement_group          INT DEFAULT 0,
    pgenerated_by              NUMBER DEFAULT NULL,
    psettlementcalenderid      NUMBER DEFAULT NULL)
IS
    n                          INT;
    start_calender_year        INT;
    end_calender_year          INT;
    temporary_record_count     INT;
    calender_date              DATE;
    holiday_type               NUMBER (1) DEFAULT 0;
    date_description           VARCHAR (100);
    zm36_date                  DATE;
    curr_date_of_week          NUMBER (2);

    sell_tplus_count           NUMBER (2);
    buy_tplus_count            NUMBER (2);
    sell_tplus_count_holding   NUMBER (2);
    buy_tplus_count_holding    NUMBER (2);

    sell_tplus_date            DATE;
    buy_tplus_date             DATE;
    sell_tplus_holding_date    DATE;
    buy_tplus_holding_date     DATE;
    month_end_date             DATE DEFAULT NULL;
    week_end_date              DATE DEFAULT NULL;

    CURSOR c2 (
        pcurrent_year INT)
    IS
          SELECT m36_date, m36_holiday
            FROM m36_settlement_calendar
           WHERE     m36_exchange_code_m01 = pexchange
                 AND m36_year = start_calender_year
                 AND m36_board_code_m54 = pboard_code
                 AND m36_institution_id_m02 = pinstitution
                 AND m36_symbol_settle_category_v11 = ploss_category
                 AND m36_cust_settle_group_id_m35 = psettlement_group
        --     AND m36_holiday = 0
        ORDER BY m36_date;

    CURSOR set_settle_dates
    IS
          SELECT *
            FROM m36_settlement_calendar
           WHERE     m36_exchange_code_m01 = pexchange
                 AND m36_working_day > 0
                 AND m36_year = start_calender_year
                 AND m36_board_code_m54 = pboard_code
                 AND m36_institution_id_m02 = pinstitution
                 AND m36_symbol_settle_category_v11 = ploss_category
                 AND m36_cust_settle_group_id_m35 = psettlement_group
                 AND is_temp_record = 0
        ORDER BY m36_date;
BEGIN
    start_calender_year := get_year_by_date (psartdate);
    end_calender_year := get_year_by_date (psartdate);
    calender_date := TRUNC (psartdate);
    date_description := '';
    holiday_type := 0;
    temporary_record_count := 20;

    UPDATE m01_exchanges
       SET m01_weekend_holidays = pweekend_holidays,
           m01_buy_tplus = pdefault_buy_tplus,
           m01_sell_tplus = pdefault_sell_tplus
     WHERE m01_exchange_code = pexchange;

    DELETE m36_settlement_calendar
     WHERE     m36_exchange_code_m01 = pexchange
           AND m36_year = start_calender_year
           AND m36_board_code_m54 = pboard_code
           AND m36_institution_id_m02 = pinstitution
           AND m36_symbol_settle_category_v11 = ploss_category
           AND m36_cust_settle_group_id_m35 = psettlement_group;

    WHILE (end_calender_year = start_calender_year)
    LOOP
        IF (INSTR (pweekend_holidays, TO_CHAR (calender_date, 'd')) > 0)
        THEN
            date_description := TO_CHAR (calender_date, 'DAY');
            holiday_type := 1;
        ELSE
            date_description := 'WORKING DAY';
            holiday_type := 0;
        END IF;

        INSERT INTO m36_settlement_calendar (m36_exchange_code_m01,
                                             m36_date,
                                             m36_description,
                                             m36_institution_id_m02,
                                             m36_symbol_settle_category_v11,
                                             m36_cust_settle_group_id_m35,
                                             m36_holiday,
                                             m36_year,
                                             m36_settle_cal_conf_id_m95,
                                             m36_board_code_m54)
             VALUES (pexchange,
                     calender_date,
                     date_description,
                     pinstitution,
                     ploss_category,
                     psettlement_group,
                     holiday_type,
                     start_calender_year,
                     psettlementcalenderid,
                     pboard_code);

        calender_date := calender_date + 1;
        end_calender_year := get_year_by_date (calender_date);
    END LOOP;

    /*
    these temporary records are generated to get the settlement date for last days of december . eg for dec 31st

    */
    WHILE (temporary_record_count > 0)
    LOOP
        IF (INSTR (pweekend_holidays, TO_CHAR (calender_date, 'd')) > 0)
        THEN
            date_description := TO_CHAR (calender_date, 'DAY');
            holiday_type := 1;
        ELSE
            date_description := 'WORKING DAY';
            holiday_type := 0;
        END IF;

        INSERT INTO m36_settlement_calendar (m36_exchange_code_m01,
                                             m36_date,
                                             m36_description,
                                             m36_institution_id_m02,
                                             m36_symbol_settle_category_v11,
                                             m36_cust_settle_group_id_m35,
                                             m36_holiday,
                                             m36_year,
                                             is_temp_record,
                                             m36_settle_cal_conf_id_m95,
                                             m36_board_code_m54)
             VALUES (pexchange,
                     calender_date,
                     date_description,
                     pinstitution,
                     ploss_category,
                     psettlement_group,
                     holiday_type,
                     start_calender_year,
                     1,
                     psettlementcalenderid,
                     pboard_code);

        calender_date := calender_date + 1;
        temporary_record_count := temporary_record_count - 1;
    END LOOP;

    /* end */
    FOR h
        IN (SELECT *
              FROM m96_holidays m96
             WHERE     m96_exchange_code_m01 = pexchange
                   AND TO_CHAR (m96_d1, 'YYYY') = start_calender_year
                   AND m96_institution_m02 = pinstitution)
    LOOP
        UPDATE m36_settlement_calendar m36
           SET m36.m36_holiday = 2,
               m36.m36_description =
                   CASE
                       WHEN m36_description <> 'WORKING DAY'
                       THEN
                              TRIM (m36_description)
                           || ' \ '
                           || h.m96_description
                       ELSE
                           h.m96_description
                   END
         WHERE     TRUNC (m36.m36_date) = TRUNC (h.m96_d1)
               AND m36_exchange_code_m01 = pexchange
               AND m36_board_code_m54 = pboard_code
               AND m36_institution_id_m02 = pinstitution
               AND m36_symbol_settle_category_v11 = ploss_category
               AND m36_cust_settle_group_id_m35 = psettlement_group;
    END LOOP;

    n := 0;

    FOR rec IN c2 (start_calender_year)
    LOOP
        IF rec.m36_holiday = 0
        THEN
            n := n + 1;

            UPDATE m36_settlement_calendar
               SET m36_working_day = n
             WHERE     m36_exchange_code_m01 = pexchange
                   AND m36_date = rec.m36_date
                   AND m36_board_code_m54 = pboard_code
                   AND m36_institution_id_m02 = pinstitution
                   AND m36_symbol_settle_category_v11 = ploss_category
                   AND m36_cust_settle_group_id_m35 = psettlement_group;
        ELSE
            UPDATE m36_settlement_calendar
               SET m36_last_work_day_for_holiday = n + 1
             WHERE     m36_exchange_code_m01 = pexchange
                   AND m36_date = rec.m36_date
                   AND m36_board_code_m54 = pboard_code
                   AND m36_institution_id_m02 = pinstitution
                   AND m36_symbol_settle_category_v11 = ploss_category
                   AND m36_cust_settle_group_id_m35 = psettlement_group;
        END IF;
    END LOOP;


    FOR rec IN set_settle_dates
    LOOP
        curr_date_of_week := TO_NUMBER (TO_CHAR (rec.m36_date, 'D'));
        sell_tplus_count :=
            get_tplus_count (curr_date_of_week,
                             psell_tplus_sun_cash,
                             psell_tplus_mon_cash,
                             psell_tplus_tue_cash,
                             psell_tplus_wed_cash,
                             psell_tplus_thu_cash,
                             psell_tplus_fri_cash,
                             psell_tplus_sat_cash);
        buy_tplus_count :=
            get_tplus_count (curr_date_of_week,
                             pbuy_tplus_sun_cash,
                             pbuy_tplus_mon_cash,
                             pbuy_tplus_tue_cash,
                             pbuy_tplus_wed_cash,
                             pbuy_tplus_thu_cash,
                             pbuy_tplus_fri_cash,
                             pbuy_tplus_sat_cash);

        sell_tplus_count_holding :=
            get_tplus_count (curr_date_of_week,
                             psell_tplus_sun_holding,
                             psell_tplus_mon_holding,
                             psell_tplus_tue_holding,
                             psell_tplus_wed_holding,
                             psell_tplus_thu_holding,
                             psell_tplus_fri_holding,
                             psell_tplus_sat_holding);
        buy_tplus_count_holding :=
            get_tplus_count (curr_date_of_week,
                             pbuy_tplus_sun_holding,
                             pbuy_tplus_mon_holding,
                             pbuy_tplus_tue_holding,
                             pbuy_tplus_wed_holding,
                             pbuy_tplus_thu_holding,
                             pbuy_tplus_fri_holding,
                             pbuy_tplus_sat_holding);

        IF     sell_tplus_count = buy_tplus_count
           AND sell_tplus_count = sell_tplus_count_holding
           AND sell_tplus_count = buy_tplus_count_holding
        THEN
            SELECT a.m36_date,
                   a.m36_date,
                   a.m36_date,
                   a.m36_date
              INTO sell_tplus_date,
                   buy_tplus_date,
                   sell_tplus_holding_date,
                   buy_tplus_holding_date
              FROM m36_settlement_calendar a
             WHERE     a.m36_exchange_code_m01 = rec.m36_exchange_code_m01
                   AND a.m36_working_day =
                           rec.m36_working_day + NVL (sell_tplus_count, 0)
                   AND a.m36_board_code_m54 = rec.m36_board_code_m54
                   AND a.m36_institution_id_m02 = pinstitution
                   AND a.m36_year = start_calender_year
                   AND a.m36_symbol_settle_category_v11 =
                           rec.m36_symbol_settle_category_v11
                   AND a.m36_cust_settle_group_id_m35 =
                           rec.m36_cust_settle_group_id_m35;
        ELSE
            SELECT a.m36_date
              INTO sell_tplus_date
              FROM m36_settlement_calendar a
             WHERE     a.m36_exchange_code_m01 = rec.m36_exchange_code_m01
                   AND a.m36_working_day =
                           rec.m36_working_day + NVL (sell_tplus_count, 0)
                   AND a.m36_board_code_m54 = rec.m36_board_code_m54
                   AND a.m36_institution_id_m02 = pinstitution
                   AND a.m36_year = start_calender_year
                   AND a.m36_symbol_settle_category_v11 =
                           rec.m36_symbol_settle_category_v11
                   AND a.m36_cust_settle_group_id_m35 =
                           rec.m36_cust_settle_group_id_m35;


            SELECT a.m36_date
              INTO buy_tplus_date
              FROM m36_settlement_calendar a
             WHERE     a.m36_exchange_code_m01 = rec.m36_exchange_code_m01
                   AND a.m36_working_day =
                           rec.m36_working_day + NVL (buy_tplus_count, 0)
                   AND a.m36_board_code_m54 = rec.m36_board_code_m54
                   AND a.m36_institution_id_m02 = pinstitution
                   AND a.m36_year = start_calender_year
                   AND a.m36_symbol_settle_category_v11 =
                           rec.m36_symbol_settle_category_v11
                   AND a.m36_cust_settle_group_id_m35 =
                           rec.m36_cust_settle_group_id_m35;

            SELECT a.m36_date
              INTO sell_tplus_holding_date
              FROM m36_settlement_calendar a
             WHERE     a.m36_exchange_code_m01 = rec.m36_exchange_code_m01
                   AND a.m36_working_day =
                             rec.m36_working_day
                           + NVL (sell_tplus_count_holding, 0)
                   AND a.m36_board_code_m54 = rec.m36_board_code_m54
                   AND a.m36_institution_id_m02 = pinstitution
                   AND a.m36_year = start_calender_year
                   AND a.m36_symbol_settle_category_v11 =
                           rec.m36_symbol_settle_category_v11
                   AND a.m36_cust_settle_group_id_m35 =
                           rec.m36_cust_settle_group_id_m35;

            SELECT a.m36_date
              INTO buy_tplus_holding_date
              FROM m36_settlement_calendar a
             WHERE     a.m36_exchange_code_m01 = rec.m36_exchange_code_m01
                   AND a.m36_working_day =
                             rec.m36_working_day
                           + NVL (buy_tplus_count_holding, 0)
                   AND a.m36_board_code_m54 = rec.m36_board_code_m54
                   AND a.m36_institution_id_m02 = pinstitution
                   AND a.m36_year = start_calender_year
                   AND a.m36_symbol_settle_category_v11 =
                           rec.m36_symbol_settle_category_v11
                   AND a.m36_cust_settle_group_id_m35 =
                           rec.m36_cust_settle_group_id_m35;
        END IF;


        IF (month_end_date IS NULL OR rec.m36_date > month_end_date)
        THEN
            SELECT MAX (m36_date)
              INTO month_end_date
              FROM m36_settlement_calendar a
             WHERE     a.m36_date <=
                           (SELECT get_last_day_of_month (rec.m36_date)
                              FROM DUAL)
                   AND a.m36_working_day > 0
                   AND a.m36_exchange_code_m01 = rec.m36_exchange_code_m01
                   AND a.m36_board_code_m54 = rec.m36_board_code_m54
                   AND a.m36_year = start_calender_year
                   AND a.m36_institution_id_m02 = pinstitution
                   AND a.m36_symbol_settle_category_v11 =
                           rec.m36_symbol_settle_category_v11
                   AND a.m36_cust_settle_group_id_m35 =
                           rec.m36_cust_settle_group_id_m35;
        END IF;

        IF (week_end_date IS NULL OR rec.m36_date > week_end_date)
        THEN
            SELECT MAX (a.m36_date)
              INTO week_end_date
              FROM m36_settlement_calendar a
             WHERE     a.m36_date <
                           (SELECT MIN (m36_date)
                              FROM m36_settlement_calendar b
                             WHERE     b.m36_date >= rec.m36_date
                                   AND b.m36_holiday = 1
                                   AND b.m36_exchange_code_m01 =
                                           rec.m36_exchange_code_m01
                                   AND b.m36_board_code_m54 =
                                           rec.m36_board_code_m54
                                   AND b.m36_year = start_calender_year
                                   AND b.m36_institution_id_m02 =
                                           pinstitution
                                   AND b.m36_symbol_settle_category_v11 =
                                           rec.m36_symbol_settle_category_v11
                                   AND b.m36_cust_settle_group_id_m35 =
                                           rec.m36_cust_settle_group_id_m35)
                   AND a.m36_working_day > 0
                   AND a.m36_exchange_code_m01 = rec.m36_exchange_code_m01
                   AND a.m36_board_code_m54 = rec.m36_board_code_m54
                   AND a.m36_year = start_calender_year
                   AND a.m36_institution_id_m02 = pinstitution
                   AND a.m36_cust_settle_group_id_m35 =
                           rec.m36_cust_settle_group_id_m35
                   AND a.m36_symbol_settle_category_v11 =
                           rec.m36_symbol_settle_category_v11;
        END IF;

        UPDATE m36_settlement_calendar m36
           SET m36.m36_sell_cash_settle_date = sell_tplus_date,
               m36.m36_buy_cash_settle_date = buy_tplus_date,
               m36.m36_sell_holdings_settle_date = sell_tplus_holding_date,
               m36.m36_buy_holdings_settle_date = buy_tplus_holding_date,
               m36_month_end = month_end_date,
               m36_week_end = week_end_date
         WHERE     m36_exchange_code_m01 = rec.m36_exchange_code_m01
               AND m36_date = rec.m36_date
               AND m36_board_code_m54 = rec.m36_board_code_m54
               AND m36_institution_id_m02 = pinstitution
               AND m36_symbol_settle_category_v11 =
                       rec.m36_symbol_settle_category_v11
               AND m36_cust_settle_group_id_m35 =
                       rec.m36_cust_settle_group_id_m35;
    END LOOP;

    MERGE INTO m36_settlement_calendar m36
         USING m36_settlement_calendar m36_o
            ON (    m36.m36_exchange_code_m01 = m36_o.m36_exchange_code_m01
                AND m36.m36_last_work_day_for_holiday = m36_o.m36_working_day
                AND m36.m36_year = m36_o.m36_year
                AND m36.m36_board_code_m54 = m36_o.m36_board_code_m54
                AND m36.m36_institution_id_m02 = m36_o.m36_institution_id_m02
                AND m36.m36_symbol_settle_category_v11 =
                        m36_o.m36_symbol_settle_category_v11
                AND m36.m36_cust_settle_group_id_m35 =
                        m36_o.m36_cust_settle_group_id_m35)
    WHEN MATCHED
    THEN
        UPDATE SET
            m36.m36_sell_cash_settle_date = m36_o.m36_sell_cash_settle_date,
            m36.m36_buy_cash_settle_date = m36_o.m36_buy_cash_settle_date,
            m36.m36_sell_holdings_settle_date =
                m36_o.m36_sell_holdings_settle_date,
            m36.m36_buy_holdings_settle_date =
                m36_o.m36_buy_holdings_settle_date,
            m36.m36_month_end = m36_o.m36_month_end,
            m36.m36_week_end = m36_o.m36_week_end;

    DELETE FROM m36_settlement_calendar
          WHERE is_temp_record = 1;
END;
/
