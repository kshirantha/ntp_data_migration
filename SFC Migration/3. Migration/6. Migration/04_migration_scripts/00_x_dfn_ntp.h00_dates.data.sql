DECLARE
    l_count          NUMBER;
    l_min_s01_date   DATE;
    l_min_s02_date   DATE;
    l_start_date     DATE;
BEGIN
    SELECT NVL (MIN (s01.s01_trimdate), TRUNC (SYSDATE - 1))
      INTO l_min_s01_date
      FROM mubasher_oms.s01_holdings_summary@mubasher_db_link s01;

    SELECT NVL (MIN (s02.s02_trimdate), TRUNC (SYSDATE - 1))
      INTO l_min_s02_date
      FROM mubasher_oms.s02_cash_account_summary@mubasher_db_link s02;

    IF l_min_s01_date <= l_min_s02_date
    THEN
        l_start_date := l_min_s01_date;
    ELSE
        l_start_date := l_min_s02_date;
    END IF;

    DELETE FROM dfn_ntp.h00_dates;

    WHILE l_start_date < TRUNC (SYSDATE)
    LOOP
        INSERT INTO dfn_ntp.h00_dates (h00_date)
             VALUES (l_start_date);

        l_start_date := l_start_date + 1;
    END LOOP;

    COMMIT;
END;
/

BEGIN
    dfn_ntp.sp_stat_gather ('H00_DATES');
END;
/
