CREATE TABLE dfn_ntp.t74_om_margin_req_murabh_bskt
(
    t74_margin_request_id_m73     NUMBER (5, 0) NOT NULL,
    t74_murahaba_basket_id_m181   NUMBER (10, 0),
    t74_exchange_id_m01           CHAR (10 BYTE),
    t74_exchange_code_m01         CHAR (10 BYTE) NOT NULL,
    t74_symbol_code_m20           VARCHAR2 (40 BYTE) NOT NULL,
    t74_symbol_id_m20             NUMBER (10, 0),
    t74_amount                    NUMBER (18, 5),
    t74_custom_type               VARCHAR2 (50 BYTE) DEFAULT 1,
    t74_institution_id_m02        NUMBER (3, 0) NOT NULL
)
/



ALTER TABLE dfn_ntp.t74_om_margin_req_murabh_bskt
ADD CONSTRAINT pk_t74_om_nur_bskt PRIMARY KEY (t74_margin_request_id_m73,
  t74_symbol_id_m20)
USING INDEX
/

COMMENT ON COLUMN dfn_ntp.t74_om_margin_req_murabh_bskt.t74_exchange_code_m01 IS
    'fk m01'
/
COMMENT ON COLUMN dfn_ntp.t74_om_margin_req_murabh_bskt.t74_exchange_id_m01 IS
    'fk m01'
/
COMMENT ON COLUMN dfn_ntp.t74_om_margin_req_murabh_bskt.t74_institution_id_m02 IS
    'fk m02'
/
COMMENT ON COLUMN dfn_ntp.t74_om_margin_req_murabh_bskt.t74_margin_request_id_m73 IS
    'fk m73'
/
COMMENT ON COLUMN dfn_ntp.t74_om_margin_req_murabh_bskt.t74_murahaba_basket_id_m181 IS
    'fkm181'
/
COMMENT ON COLUMN dfn_ntp.t74_om_margin_req_murabh_bskt.t74_symbol_code_m20 IS
    'fk m20'
/
COMMENT ON COLUMN dfn_ntp.t74_om_margin_req_murabh_bskt.t74_symbol_id_m20 IS
    'fk m20'
/
