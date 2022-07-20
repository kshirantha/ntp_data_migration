CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_m181_murabaha_baskets
(
    m181_id,
    m181_basket_name,
    m181_basket_code,
    m181_basket_size,
    m181_upper_limit,
    m181_lower_limit,
    m181_created_date,
    m181_modified_by_id_u17,
    m181_modified_date,
    m181_created_by_id_u17,
    m181_status_id_v01,
    status_description,
    m181_status_changed_by_id_u17,
    m181_status_changed_date,
    is_in_use,
    basket_type,
    created_by_name,
    modified_by_name,
    status_changed_by_name,
    m181_type,
    m181_institute_id_m02
)
AS
    (SELECT m181.m181_id,
            m181.m181_basket_name,
            m181.m181_basket_code,
            m181.m181_basket_size,
            m181.m181_upper_limit,
            m181.m181_lower_limit,
            m181.m181_created_date,
            m181.m181_modified_by_id_u17,
            m181.m181_modified_date,
            m181.m181_created_by_id_u17,
            m181.m181_status_id_v01,
            status_list.v01_description AS status_description,
            m181.m181_status_changed_by_id_u17,
            m181.m181_status_changed_date,
            CASE
                WHEN m181.m181_in_use = 0 THEN 'Not In Use'
                WHEN m181.m181_in_use = 1 THEN 'In Use'
            END
                AS is_in_use,
            CASE
                WHEN m181.m181_type = 0 THEN 'FIXED'
                WHEN m181.m181_type = 1 THEN 'CUSTOMIZABLE'
            END
                AS basket_type,
            u17_created_by.u17_full_name AS created_by_name,
            u17_modified_by.u17_full_name AS modified_by_name,
            u17_status_changed_by.u17_full_name AS status_changed_by_name,
            m181.m181_type,
            m181.m181_institute_id_m02
       FROM m181_murabaha_baskets m181
            LEFT JOIN u17_employee u17_created_by
                ON m181.m181_created_by_id_u17 = u17_created_by.u17_id
            LEFT JOIN u17_employee u17_modified_by
                ON m181.m181_modified_by_id_u17 = u17_modified_by.u17_id
            LEFT JOIN u17_employee u17_status_changed_by
                ON m181.m181_status_changed_by_id_u17 =
                       u17_status_changed_by.u17_id
            LEFT JOIN vw_status_list status_list
                ON m181.m181_status_id_v01 = status_list.v01_id)
/