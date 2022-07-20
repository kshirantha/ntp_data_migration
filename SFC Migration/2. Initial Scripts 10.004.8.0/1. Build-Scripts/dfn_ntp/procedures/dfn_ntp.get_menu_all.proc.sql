CREATE OR REPLACE PROCEDURE dfn_ntp.get_menu_all (
    p_broker_code    IN     VARCHAR2 DEFAULT NULL,
    p_country_code   IN     VARCHAR2 DEFAULT NULL,
    p_view              OUT SYS_REFCURSOR,
    prows               OUT NUMBER)
IS
    l_qry   VARCHAR2 (15000);
BEGIN
    l_qry :=
           'SELECT z07.* FROM(SELECT a.z07_id,
                   a.z07_name,
                   a.z07_tag,
                   a.z07_sec_id,
                   a.z07_fkey,
                   a.z07_hide,
                   a.z07_icon,
                   a.z07_route,
                   a.z07_query_params,
                   a.z07_pkey,
                   a.z07_broker_code,
                   a.z07_custom_type,
                   a.z07_is_customized,
                   a.z07_deleted_from_core,
                   a.z07_feature_id_v14,
                   a.z07_form_title
              FROM Z07_MENU a
            WHERE a.z07_id || ''--'' || z07_name NOT IN
                  (SELECT z07_id || ''--'' || z07_name
                   FROM Z07_MENU_C
                   WHERE z07_broker_code in ('''
        || p_country_code
        || ''', '''
        || p_broker_code
        || '''))

            UNION ALL
            SELECT a.z07_id,
                   a.z07_name,
                   a.z07_tag,
                   a.z07_sec_id,
                   a.z07_fkey,
                   a.z07_hide,
                   a.z07_icon,
                   a.z07_route,
                   a.z07_query_params,
                   a.z07_pkey,
                   a.z07_broker_code,
                   a.z07_custom_type,
                   a.z07_is_customized,
                   a.z07_deleted_from_core,
                   a.z07_feature_id_v14,
                   a.z07_form_title
              FROM Z07_MENU_C a
            WHERE a.z07_change_status <> 3
              AND z07_broker_code = '''
        || p_country_code
        || '''
              AND z07_id || ''--'' || z07_name NOT IN
                  (SELECT z07_id || ''--'' || z07_name
                   FROM Z07_MENU_C
                   WHERE z07_broker_code = '''
        || p_broker_code
        || ''')

            UNION ALL
            SELECT a.z07_id,
                   a.z07_name,
                   a.z07_tag,
                   a.z07_sec_id,
                   a.z07_fkey,
                   a.z07_hide,
                   a.z07_icon,
                   a.z07_route,
                   a.z07_query_params,
                   a.z07_pkey,
                   a.z07_broker_code,
                   a.z07_custom_type,
                   a.z07_is_customized,
                   a.z07_deleted_from_core,
                   a.z07_feature_id_v14,
                   a.z07_form_title
              FROM Z07_MENU_C a
            WHERE a.z07_change_status <> 3
              AND z07_broker_code = '''
        || p_broker_code
        || ''') z07
                LEFT JOIN
                    v14_controllable_features v14
                ON z07.z07_feature_id_v14 = v14.id
            WHERE NVL(v14.enabled, 1) = 1
            ORDER BY Z07_ID';

    OPEN p_view FOR l_qry;
END;
/
