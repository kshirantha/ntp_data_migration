CREATE OR REPLACE TRIGGER dfn_ntp.trg_z04_before_update
    BEFORE INSERT OR DELETE OR UPDATE
    ON dfn_ntp.z04_forms_color
    REFERENCING NEW AS new OLD AS old
    FOR EACH ROW
BEGIN
    UPDATE z08_version z08
       SET z08.z08_version = z08.z08_version + 1,
           z08.z08_last_updated_datetime = SYSDATE
     WHERE z08.z08_sql = 'Z04_FORMS_COLOR';

    UPDATE z01_forms_m z01
       SET z01.z01_colors_updated_datetime = SYSDATE
     WHERE z01.z01_id = :new.z04_z01_id;

    UPDATE z01_forms_m_c z01
       SET z01.z01_colors_updated_datetime = SYSDATE
     WHERE z01.z01_id = :new.z04_z01_id;
END;
/
