CREATE TABLE dfn_ntp.m169_otc_trading_commission
(
    m169_id                         NUMBER (5, 0) NOT NULL,
    m169_name                       VARCHAR2 (255 BYTE) NOT NULL,
    m169_additional_details         VARCHAR2 (400 BYTE),
    m169_sub_assest_type_id_v08     NUMBER (3, 0) NOT NULL,
    m169_currency_id_m03            NUMBER (5, 0) NOT NULL,
    m169_currency_code_m03          CHAR (3 BYTE) NOT NULL,
    m169_commission_percentage      NUMBER (18, 5) DEFAULT 0 NOT NULL,
    m169_flat_commission            NUMBER (18, 5) DEFAULT 0,
    m169_minimum_commission         NUMBER (18, 5) DEFAULT 0,
    m169_vat                        NUMBER (18, 5) DEFAULT 0,
    m169_status_id_v01              NUMBER (5, 0),
    m169_created_by_id_u17          NUMBER (10, 0) NOT NULL,
    m169_created_date               DATE NOT NULL,
    m169_modified_by_id_u17         NUMBER (10, 0),
    m169_modified_date              DATE,
    m169_status_changed_by_id_u17   NUMBER (10, 0),
    m169_status_changed_date        DATE,
    m169_custom_type                VARCHAR2 (50 BYTE) DEFAULT 1,
    m169_institute_id_m02           NUMBER (3, 0)
)
/


ALTER TABLE dfn_ntp.m169_otc_trading_commission
    ADD CONSTRAINT pk_m169 PRIMARY KEY (m169_id) USING INDEX
/