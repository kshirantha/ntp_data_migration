CREATE OR REPLACE PROCEDURE dfn_ntp.get_form_columns (
    updated_datetime   IN     VARCHAR2,
    p_view                OUT SYS_REFCURSOR,
    prows                 OUT NUMBER)
IS
BEGIN
    OPEN p_view FOR
          SELECT *
            FROM vw_z02_forms_cols
           WHERE UPPER (z02_z01_id) IN
                     (SELECT z01_id
                        FROM z01_forms_m
                       WHERE z01_columns_updated_datetime >
                                 TO_DATE (updated_datetime,
                                          'dd/MM/yyyy hh24:mi:ss'))
        ORDER BY z02_z01_id;
END;
/
/
