CREATE TABLE dfn_ntp.z02_forms_cols
(
    z02_z01_id                     NUMBER (5, 0) NOT NULL,
    z02_mapping_name               VARCHAR2 (100 BYTE) NOT NULL,
    z02_column_name                NVARCHAR2 (100) NOT NULL,
    z02_width                      NUMBER (5, 0) NOT NULL,
    z02_alignment                  NUMBER (1, 0) NOT NULL,
    z02_format                     VARCHAR2 (100 BYTE),
    z02_seq_no                     NUMBER (5, 0) NOT NULL,
    z02_visible                    NUMBER (1, 0) DEFAULT 1 NOT NULL,
    z02_translatable               NUMBER (1, 0) DEFAULT 0 NOT NULL,
    z02_show_by_default            NUMBER (1, 0) DEFAULT 1 NOT NULL,
    z02_force_default_formatting   NUMBER (1, 0) DEFAULT 0 NOT NULL,
    z02_adjust_gmt                 NUMBER (1, 0) DEFAULT 0 NOT NULL,
    z02_format_based_on_currency   NUMBER (1, 0) DEFAULT 0 NOT NULL,
    z02_currency_field_name        VARCHAR2 (100 BYTE),
    z02_show_total                 NUMBER (1, 0) DEFAULT 0 NOT NULL,
    z02_fixed_filter_value         NUMBER (1, 0) DEFAULT 0,
    z02_min_filter_length          NUMBER (2, 0) DEFAULT 0,
    z02_show_in_filter             NUMBER (1, 0) DEFAULT 1,
    z02_column_type                NUMBER (2, 0) DEFAULT 1
)
/


COMMENT ON COLUMN dfn_ntp.z02_forms_cols.z02_alignment IS
    '1= Left | 2 = Right | 3 = Center'
/
COMMENT ON COLUMN dfn_ntp.z02_forms_cols.z02_column_type IS
    '1- Normal | 2 - Number | 3 - Date | 4 - Currency | 5 - Check Box | 6 - Drop Down | 7 - Button | 8 - Hidden Column (Store ID at Row Level) | 9 - Input Text Field'
/
COMMENT ON COLUMN dfn_ntp.z02_forms_cols.z02_translatable IS
    '0=No | 1 = Yes (Using app resources) | 2 = Yes (Using _lang field)'
/

ALTER TABLE DFN_NTP.Z02_FORMS_COLS
 ADD (
  Z02_FEATURE_ID_V14 NUMBER (3,0)
 )
/