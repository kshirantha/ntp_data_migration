CREATE OR REPLACE PROCEDURE dfn_ntp.get_form_colors (
    updated_datetime   IN     VARCHAR2,
    p_view                OUT SYS_REFCURSOR,
    prows                 OUT NUMBER)
IS
BEGIN
    OPEN p_view FOR
          SELECT *
            FROM vw_z04_forms_color
           WHERE UPPER (z04_z01_id) IN
                     (SELECT z01_id
                        FROM z01_forms_m
                       WHERE z01_colors_updated_datetime >
                                 TO_DATE (updated_datetime,
                                          'dd/MM/yyyy hh24:mi:ss'))
        ORDER BY z04_z01_id;
END;
/
/
