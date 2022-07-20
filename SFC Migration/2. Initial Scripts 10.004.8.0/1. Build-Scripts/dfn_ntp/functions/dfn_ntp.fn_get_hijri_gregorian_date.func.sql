CREATE OR REPLACE FUNCTION dfn_ntp.fn_get_hijri_gregorian_date (
    pdate    VARCHAR, -- Format:  DD/MM/YYYY
    ptype    NUMBER) -- Type: 0 - Gregorian to Hijri | 1 - Hijri to Gregorian
    RETURN VARCHAR2
IS
    l_converted_date    VARCHAR2 (20);
    l_count             NUMBER;
    l_m116_adjustment   NUMBER;
    l_date              DATE;
BEGIN
    l_date := TO_DATE (pdate, 'dd/mm/yyyy');

    SELECT COUNT (m116_adjustment)
      INTO l_count
      FROM m116_hijri_adjustments
     WHERE m116_from_date <= l_date AND m116_to_date >= l_date;

    IF l_count > 0
    THEN
        SELECT m116_adjustment
          INTO l_m116_adjustment
          FROM m116_hijri_adjustments
         WHERE m116_from_date <= l_date AND m116_to_date >= l_date;
    ELSE
        l_m116_adjustment := 0;
    END IF;

    IF ptype = 0
    THEN
        l_date := l_date + 1; -- To Correct Any Diff If Could Exist
        l_date := l_date + l_m116_adjustment;

        SELECT TO_CHAR (l_date,
                        'dd/mm/yyyy',
                        'nls_calendar=''arabic hijrah''')
          INTO l_converted_date
          FROM DUAL;
    END IF;

    IF ptype = 1
    THEN
        SELECT TO_DATE (pdate,
                        'dd/mm/yyyy',
                        'nls_calendar=''Arabic Hijrah''')
                   to_gregorian
          INTO l_date
          FROM DUAL;

        l_date := l_date - 1; -- To Correct Any Diff If Could Exist

        IF l_m116_adjustment <> 0
        THEN
            l_converted_date :=
                TO_CHAR (l_date - l_m116_adjustment, 'dd/mm/yyyy');
        ELSE
            l_converted_date := TO_CHAR (l_date, 'dd/mm/yyyy');
        END IF;
    END IF;

    RETURN l_converted_date;
END;
/