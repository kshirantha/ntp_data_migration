CREATE TABLE dfn_ntp.m184_channel_wise_symbol_restr
(
    m184_id                         NUMBER (5, 0) NOT NULL,
    m184_exchange_id_m01            NUMBER (5, 0) NOT NULL,
    m184_exchange_code_m01          VARCHAR2 (10 BYTE) NOT NULL,
    m184_symbol_id_m20              NUMBER (5, 0),
    m184_symbol_code_m20            VARCHAR2 (50 BYTE),
    m184_restriction_id_v31         NUMBER (5, 0) NOT NULL,
    m184_reason                     VARCHAR2 (200 BYTE),
    m184_from_date                  DATE,
    m184_to_date                    DATE,
    m184_status_id_v01              NUMBER (5, 0),
    m184_created_by_id_u17          NUMBER (10, 0),
    m184_created_date               DATE,
    m184_status_changed_by_id_u17   NUMBER (10, 0),
    m184_status_changed_date        DATE,
    m184_modified_by_id_u17         NUMBER (10, 0),
    m184_modified_date              DATE,
    m184_institute_id_m02           NUMBER (3, 0) NOT NULL,
    m184_custom_type                VARCHAR2 (50 BYTE),
    m184_apply_to_all_symbol        NUMBER (1, 0),
    m184_channel_id_v29             NUMBER (5, 0) NOT NULL
)
/



ALTER TABLE dfn_ntp.m184_channel_wise_symbol_restr
ADD CONSTRAINT pk_m184_id PRIMARY KEY (m184_id)
USING INDEX
/

COMMENT ON COLUMN dfn_ntp.m184_channel_wise_symbol_restr.m184_apply_to_all_symbol IS
    '0 - False, 1 - True'
/
COMMENT ON COLUMN dfn_ntp.m184_channel_wise_symbol_restr.m184_restriction_id_v31 IS
    'V31_TYPE = 3'
/

ALTER TABLE dfn_ntp.M184_CHANNEL_WISE_SYMBOL_RESTR 
 MODIFY (
  M184_EXCHANGE_ID_M01 NULL,
  M184_EXCHANGE_CODE_M01 NULL

 )
/

ALTER TABLE dfn_ntp.m184_channel_wise_symbol_restr MODIFY (m184_symbol_id_m20 NUMBER (10))
/
