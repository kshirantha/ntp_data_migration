CREATE OR REPLACE PROCEDURE dfn_ntp.get_form (
    updated_datetime   IN     VARCHAR2,
    p_view                OUT SYS_REFCURSOR,
    prows                 OUT NUMBER)
IS
BEGIN
    OPEN p_view FOR
        SELECT *
          FROM z01_forms_m a
         WHERE z01_updated_datetime >
                   TO_DATE (updated_datetime, 'dd/MM/yyyy hh24:mi:ss');
END;
/
/
