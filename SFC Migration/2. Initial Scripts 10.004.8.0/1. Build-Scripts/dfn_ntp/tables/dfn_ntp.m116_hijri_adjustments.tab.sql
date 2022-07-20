CREATE TABLE dfn_ntp.m116_hijri_adjustments
(
    m116_id                         NUMBER (5, 0),
    m116_from_date                  DATE,
    m116_to_date                    DATE,
    m116_created_by_id_u17          NUMBER (10, 0),
    m116_created_date               DATE,
    m116_modified_by_id_u17         NUMBER (10, 0),
    m116_modified_date              DATE,
    m116_adjustment                 NUMBER (5, 0),
    m116_status_id_v01              NUMBER (20, 0),
    m116_status_changed_by_id_u17   NUMBER (20, 0),
    m116_status_changed_date        DATE,
    m116_custom_type                VARCHAR2 (50 BYTE) DEFAULT 1,
    m116_institute_id_m02           NUMBER (3, 0) DEFAULT 1
)
/

ALTER TABLE dfn_ntp.m116_hijri_adjustments
ADD CONSTRAINT m116_id PRIMARY KEY (m116_id)
USING INDEX
/