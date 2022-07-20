CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_sharia_symbol_list
(
    m119_id,
    m119_institute_id_m02,
    m119_exchange_id_m01,
    m119_exchange_code_m01,
    m119_symbol_id_m20,
    m119_symbol_code_m20,
    m119_created_by_id_u17,
    created_by_name,
    m119_created_date,
    m119_sharia_group_id_m120
)
AS
    (SELECT m119.m119_id,
            m119.m119_institute_id_m02,
            m119.m119_exchange_id_m01,
            m119.m119_exchange_code_m01,
            m119.m119_symbol_id_m20,
            m119.m119_symbol_code_m20,
            m119.m119_created_by_id_u17,
            u17_created_by.u17_full_name AS created_by_name,
            m119.m119_created_date,
            m119.m119_sharia_group_id_m120
       FROM     m119_sharia_symbol m119
            LEFT JOIN
                u17_employee u17_created_by
            ON m119.m119_created_by_id_u17 = u17_created_by.u17_id);
/
