CREATE TABLE dfn_ntp.m123_master_data_versions
(
    m123_id        NUMBER (3, 0) NOT NULL,
    m123_name      VARCHAR2 (50 BYTE),
    m123_version   NUMBER (5, 0)
)
/

ALTER TABLE dfn_ntp.m123_master_data_versions
ADD CONSTRAINT m123_master_data_versions_pk PRIMARY KEY (m123_id)
USING INDEX
/