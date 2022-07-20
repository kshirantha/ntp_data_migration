CREATE OR REPLACE TRIGGER dfn_ntp.trg_z01_before_update
    BEFORE INSERT OR DELETE OR UPDATE
    ON dfn_ntp.z01_forms_m
    REFERENCING NEW AS new OLD AS old
    FOR EACH ROW
BEGIN
    IF (   (:new.z01_id IS NULL AND :old.z01_id IS NOT NULL)
        OR (:new.z01_id IS NOT NULL AND :old.z01_id IS NULL)
        OR (:new.z01_id <> :old.z01_id)
        OR (:new.z01_tag IS NULL AND :old.z01_tag IS NOT NULL)
        OR (:new.z01_tag IS NOT NULL AND :old.z01_tag IS NULL)
        OR (:new.z01_tag <> :old.z01_tag)
        OR (:new.z01_version_no IS NULL AND :old.z01_version_no IS NOT NULL)
        OR (:new.z01_version_no IS NOT NULL AND :old.z01_version_no IS NULL)
        OR (:new.z01_version_no <> :old.z01_version_no)
        OR (:new.z01_view_name IS NULL AND :old.z01_view_name IS NOT NULL)
        OR (:new.z01_view_name IS NOT NULL AND :old.z01_view_name IS NULL)
        OR (:new.z01_view_name <> :old.z01_view_name)
        OR (:new.z01_title IS NULL AND :old.z01_title IS NOT NULL)
        OR (:new.z01_title IS NOT NULL AND :old.z01_title IS NULL)
        OR (:new.z01_title <> :old.z01_title)
        OR (:new.z01_form_type IS NULL AND :old.z01_form_type IS NOT NULL)
        OR (:new.z01_form_type IS NOT NULL AND :old.z01_form_type IS NULL)
        OR (:new.z01_form_type <> :old.z01_form_type)
        OR (:new.z01_sort_column IS NULL AND :old.z01_sort_column IS NOT NULL)
        OR (:new.z01_sort_column IS NOT NULL AND :old.z01_sort_column IS NULL)
        OR (:new.z01_sort_column <> :old.z01_sort_column)
        OR (:new.z01_date_field IS NULL AND :old.z01_date_field IS NOT NULL)
        OR (:new.z01_date_field IS NOT NULL AND :old.z01_date_field IS NULL)
        OR (:new.z01_date_field <> :old.z01_date_field)
        OR (    :new.z01_truncate_date IS NULL
            AND :old.z01_truncate_date IS NOT NULL)
        OR (    :new.z01_truncate_date IS NOT NULL
            AND :old.z01_truncate_date IS NULL)
        OR (:new.z01_truncate_date <> :old.z01_truncate_date)
        OR (    :new.z01_load_all_data IS NULL
            AND :old.z01_load_all_data IS NOT NULL)
        OR (    :new.z01_load_all_data IS NOT NULL
            AND :old.z01_load_all_data IS NULL)
        OR (:new.z01_load_all_data <> :old.z01_load_all_data)
        OR (:new.z01_time_stamp IS NULL AND :old.z01_time_stamp IS NOT NULL)
        OR (:new.z01_time_stamp IS NOT NULL AND :old.z01_time_stamp IS NULL)
        OR (:new.z01_time_stamp <> :old.z01_time_stamp)
        OR (    :new.z01_has_sensitive_data IS NULL
            AND :old.z01_has_sensitive_data IS NOT NULL)
        OR (    :new.z01_has_sensitive_data IS NOT NULL
            AND :old.z01_has_sensitive_data IS NULL)
        OR (:new.z01_has_sensitive_data <> :old.z01_has_sensitive_data)
        OR (    :new.z01_excel_export_sec_id IS NULL
            AND :old.z01_excel_export_sec_id IS NOT NULL)
        OR (    :new.z01_excel_export_sec_id IS NOT NULL
            AND :old.z01_excel_export_sec_id IS NULL)
        OR (:new.z01_excel_export_sec_id <> :old.z01_excel_export_sec_id)
        OR (    :new.z01_textfile_export_sec_id IS NULL
            AND :old.z01_textfile_export_sec_id IS NOT NULL)
        OR (    :new.z01_textfile_export_sec_id IS NOT NULL
            AND :old.z01_textfile_export_sec_id IS NULL)
        OR (:new.z01_textfile_export_sec_id <>
                :old.z01_textfile_export_sec_id)
        OR (    :new.z01_auto_refresh IS NULL
            AND :old.z01_auto_refresh IS NOT NULL)
        OR (    :new.z01_auto_refresh IS NOT NULL
            AND :old.z01_auto_refresh IS NULL)
        OR (:new.z01_auto_refresh <> :old.z01_auto_refresh)
        OR (:new.z01_source_type IS NULL AND :old.z01_source_type IS NOT NULL)
        OR (:new.z01_source_type IS NOT NULL AND :old.z01_source_type IS NULL)
        OR (:new.z01_source_type <> :old.z01_source_type)
        OR (:new.z01_ignore_sort IS NULL AND :old.z01_ignore_sort IS NOT NULL)
        OR (:new.z01_ignore_sort IS NOT NULL AND :old.z01_ignore_sort IS NULL)
        OR (:new.z01_ignore_sort <> :old.z01_ignore_sort)
        OR (    :new.z01_load_data_on_opening IS NULL
            AND :old.z01_load_data_on_opening IS NOT NULL)
        OR (    :new.z01_load_data_on_opening IS NOT NULL
            AND :old.z01_load_data_on_opening IS NULL)
        OR (:new.z01_load_data_on_opening <> :old.z01_load_data_on_opening)
        OR (    :new.z01_fully_loaded IS NULL
            AND :old.z01_fully_loaded IS NOT NULL)
        OR (    :new.z01_fully_loaded IS NOT NULL
            AND :old.z01_fully_loaded IS NULL)
        OR (:new.z01_fully_loaded <> :old.z01_fully_loaded)
        OR (    :new.z01_is_customized IS NULL
            AND :old.z01_is_customized IS NOT NULL)
        OR (    :new.z01_is_customized IS NOT NULL
            AND :old.z01_is_customized IS NULL)
        OR (:new.z01_is_customized <> :old.z01_is_customized)
        OR (:new.z01_broker_code IS NULL AND :old.z01_broker_code IS NOT NULL)
        OR (:new.z01_broker_code IS NOT NULL AND :old.z01_broker_code IS NULL)
        OR (:new.z01_broker_code <> :old.z01_broker_code))
    THEN
        UPDATE z08_version z08
           SET z08.z08_version = z08.z08_version + 1,
               z08.z08_last_updated_datetime = SYSDATE
         WHERE z08.z08_sql = 'Z01_FORMS_M';

        IF :new.z01_id IS NOT NULL
        THEN
            :new.z01_updated_datetime := SYSDATE;

            UPDATE z01_forms_m_c z01
               SET z01.z01_menus_updated_datetime = SYSDATE
             WHERE z01.z01_tag = :new.z01_tag;
        END IF;
    END IF;
END;
/
