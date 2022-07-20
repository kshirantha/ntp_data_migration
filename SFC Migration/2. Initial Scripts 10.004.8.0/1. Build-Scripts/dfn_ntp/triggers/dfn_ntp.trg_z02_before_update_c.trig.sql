CREATE OR REPLACE TRIGGER dfn_ntp.trg_z02_before_update_c
    BEFORE INSERT OR DELETE OR UPDATE
    ON dfn_ntp.z02_forms_cols_c
    REFERENCING NEW AS new OLD AS old
    FOR EACH ROW
BEGIN
    UPDATE z08_version z08
       SET z08.z08_version = z08.z08_version + 1,
           z08.z08_last_updated_datetime = SYSDATE
     WHERE z08.z08_sql = 'Z02_FORMS_COLS';

    UPDATE z01_forms_m z01
       SET z01.z01_columns_updated_datetime = SYSDATE
     WHERE z01.z01_id = :new.z02_z01_id;

    MERGE INTO z01_forms_m_c c
         USING (SELECT a.z01_tag
                  FROM z01_forms_m a
                 WHERE a.z01_id = :new.z02_z01_id) d
            ON (c.z01_tag = d.z01_tag)
    WHEN MATCHED
    THEN
        UPDATE SET c.z01_columns_updated_datetime = SYSDATE;
END;
/
