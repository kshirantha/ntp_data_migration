/* Formatted on 8/15/2019 12:51:12 PM (QP5 v5.276) */
CREATE OR REPLACE PROCEDURE dfn_ntp.sp_get_institute_config (
    pinstituteid   IN     NUMBER,
    p_view            OUT SYS_REFCURSOR,
    prows             OUT NUMBER)
IS
BEGIN
    OPEN p_view FOR
        SELECT m02.m02_id, m02.m02_overdraw
          FROM m02_institute m02
         WHERE m02.m02_id = pinstituteid;
END;
/