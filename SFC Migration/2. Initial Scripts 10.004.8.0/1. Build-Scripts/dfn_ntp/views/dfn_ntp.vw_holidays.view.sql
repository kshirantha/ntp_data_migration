CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_holidays
(
    m96_id,
    m96_exchange_id_m01,
    m96_exchange_code_m01,
    m96_d1,
    holiday_year,
    m96_description,
    m96_instrument_type_code_v09,
    m96_instrument_type_id_v09,
    m96_institution_m02,
    v09_description
)
AS
    (SELECT a.m96_id,
            a.m96_exchange_id_m01,
            a.m96_exchange_code_m01,
            a.m96_d1,
            EXTRACT (YEAR FROM m96_d1) AS holiday_year,
            a.m96_description,
            a.m96_instrument_type_code_v09,
            a.m96_instrument_type_id_v09,
            a.m96_institution_m02,
            v09.v09_description
       FROM     m96_holidays a
            LEFT JOIN
                v09_instrument_types v09
            ON m96_instrument_type_id_v09 = v09.v09_id)
/
