CREATE TABLE dfn_ntp.m177_cash_transfer_limit_group
(
    m177_id                         NUMBER (10, 0) NOT NULL,
    m177_group_name                 VARCHAR2 (255 BYTE) NOT NULL,
    m177_cash_transfer_limit        NUMBER (18, 5) NOT NULL,
    m177_frequency_id_v01           NUMBER (1, 0) NOT NULL,
    m177_is_default                 NUMBER (1, 0),
    m177_status_id_v01              NUMBER (5, 0),
    m177_created_by_id_u17          NUMBER (10, 0),
    m177_created_date               DATE,
    m177_status_changed_by_id_u17   NUMBER (10, 0),
    m177_status_changed_date        DATE,
    m177_modified_by_id_u17         NUMBER (10, 0),
    m177_modified_date              DATE,
    m177_custom_type                VARCHAR2 (50 BYTE),
    m177_institute_id_m02           NUMBER (3, 0)
)
/

ALTER TABLE dfn_ntp.m177_cash_transfer_limit_group
ADD CONSTRAINT pk_m177 PRIMARY KEY (m177_id)
USING INDEX
/


COMMENT ON COLUMN dfn_ntp.M177_CASH_TRANSFER_LIMIT_GROUP.M177_FREQUENCY_ID_V01 IS '1 - Cumulative | 2 -  Per Transaction'
/