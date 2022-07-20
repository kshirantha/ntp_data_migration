CREATE OR REPLACE PROCEDURE dfn_ntp.sp_get_minimum_commission (
    p_view                 OUT SYS_REFCURSOR,
    prows                  OUT NUMBER,
    p_to_currency       IN     VARCHAR2,
    p_institute_id      IN     NUMBER,
    psearchcriteria            VARCHAR2 DEFAULT NULL,
    p_exchanges_codes   IN     VARCHAR2 DEFAULT NULL)
IS
    l_query   VARCHAR2 (5000);
BEGIN
    prows := 1;

    IF (psearchcriteria IS NOT NULL)
    THEN
        l_query := ' WHERE ' || psearchcriteria;
    ELSE
        l_query := '';
    END IF;

    IF p_exchanges_codes IS NULL
    THEN
        l_query :=
               'select * from (SELECT m22.m22_id,
                     MIN (m22.m22_description) AS commission_group,
                     MIN (m22.m22_exchange_code_m01) AS exchange,
                     m23.m23_currency_code_m03 AS currency,
                     m23.m23_min_commission AS current_minimum_commisssion,
                     get_exchange_rate ('
            || p_institute_id
            || ',
                                        '''
            || p_to_currency
            || ''',
                                        m23.m23_currency_code_m03)
                         AS fx_rate,
                     0 AS propsed_commission
                FROM     m23_commission_slabs m23
                     INNER JOIN
                         m22_commission_group m22
                     ON m23.m23_commission_group_id_m22 = m22.m22_id
               WHERE m22.m22_institute_id_m02 = '
            || p_institute_id
            || ' GROUP BY m22.m22_id,
                     m23.m23_currency_code_m03,
                     m23.m23_min_commission) '
            || l_query;
    ELSE
        l_query :=
               'select * from (SELECT m22.m22_id,
               MIN (m22.m22_description) AS commission_group,
                         MIN (m22.m22_exchange_code_m01) AS exchange,
                         m23.m23_currency_code_m03 AS currency,
                         m23.m23_min_commission AS current_minimum_commisssion,
                         get_exchange_rate ('
            || p_institute_id
            || ', '''
            || p_to_currency
            || ''', m23.m23_currency_code_m03) AS fx_rate,
                         0 AS propsed_commission
                    FROM     m23_commission_slabs m23
                         INNER JOIN
                             m22_commission_group m22
                         ON m23.m23_commission_group_id_m22 = m22.m22_id
                   WHERE     m22.m22_institute_id_m02 = '
            || p_institute_id
            || ' AND m22.m22_exchange_code_m01 IN ('
            || p_exchanges_codes
            || ') GROUP BY m22.m22_id, m23.m23_currency_code_m03, m23.m23_min_commission) '
            || l_query;
    END IF;

    OPEN p_view FOR l_query;
END;
/
