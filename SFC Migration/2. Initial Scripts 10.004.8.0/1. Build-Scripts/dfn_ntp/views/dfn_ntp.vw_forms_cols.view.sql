CREATE OR REPLACE VIEW dfn_ntp.vw_forms_cols
(
    z02_z01_id,
    z02_mapping_name,
    z02_column_name,
    z02_width,
    z02_alignment,
    z02_format,
    z02_seq_no,
    z02_visible,
    z02_translatable,
    z02_show_by_default,
    z02_force_default_formatting,
    z02_adjust_gmt,
    z02_format_based_on_currency,
    z02_currency_field_name,
    z02_show_total,
    z02_fixed_filter_value,
    z02_min_filter_length,
    z02_show_in_filter,
    z02_column_type,
    status
)
AS
    SELECT a.z02_z01_id,
           a.z02_mapping_name,
           a.z02_column_name,
           a.z02_width,
           a.z02_alignment,
           a.z02_format,
           a.z02_seq_no,
           a.z02_visible,
           a.z02_translatable,
           a.z02_show_by_default,
           a.z02_force_default_formatting,
           a.z02_adjust_gmt,
           a.z02_format_based_on_currency,
           a.z02_currency_field_name,
           a.z02_show_total,
           a.z02_fixed_filter_value,
           a.z02_min_filter_length,
           a.z02_show_in_filter,
           a.z02_column_type,
           2 AS status
      FROM z02_forms_cols a
/
