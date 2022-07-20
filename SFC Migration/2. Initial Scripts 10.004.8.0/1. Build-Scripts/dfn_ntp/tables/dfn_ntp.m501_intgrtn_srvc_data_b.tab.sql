CREATE TABLE dfn_ntp.m501_intgrtn_srvc_data_b
(
    m501_id                        NUMBER(5,0) NOT NULL UNIQUE,
    m501_key                       VARCHAR2(50 BYTE) NOT NULL,
    m501_value                     VARCHAR2(1000 BYTE),
    m501_type                      NUMBER(2,0),
    m501_type_description          VARCHAR2(255 BYTE)
)
/

 

ALTER TABLE dfn_ntp.m501_intgrtn_srvc_data_b
ADD CONSTRAINT m501_pk PRIMARY KEY (m501_key)
USING INDEX
/

COMMENT ON COLUMN dfn_ntp.M501_INTGRTN_SRVC_DATA_B.M501_TYPE IS '1=SQLs | 2=Config | 3=URLs'
/