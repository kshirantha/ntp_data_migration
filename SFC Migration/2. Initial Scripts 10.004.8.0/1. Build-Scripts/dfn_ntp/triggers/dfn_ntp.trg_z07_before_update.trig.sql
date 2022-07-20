CREATE OR REPLACE TRIGGER dfn_ntp.trg_z07_before_update
    BEFORE INSERT OR DELETE OR UPDATE
    ON dfn_ntp.z07_menu
    REFERENCING NEW AS new OLD AS old
    FOR EACH ROW
BEGIN
    UPDATE z08_version z08
       SET z08.z08_version = z08.z08_version + 1,
           z08.z08_last_updated_datetime = SYSDATE
     WHERE z08.z08_sql = 'Z07_MENU';
END;
/
