CREATE TABLE dfn_ntp.u25_om_mar_req_questionnaire
(
    u25_margin_request_id_t73   NUMBER (5, 0) NOT NULL,
    u25_question_id_m183        NUMBER (3, 0) NOT NULL,
    u25_answer                  VARCHAR2 (100 BYTE) NOT NULL,
    u25_cash_account_id_u06     NUMBER (10, 0),
    u25_customer_id_u01         NUMBER (10, 0),
    u25_margin_product_id_m73   NUMBER (3, 0),
    u25_custom_type             VARCHAR2 (50 BYTE) DEFAULT 1,
    u25_inst_id_m02             NUMBER (3, 0)
)
/



ALTER TABLE dfn_ntp.u25_om_mar_req_questionnaire
ADD CONSTRAINT pk_u25 PRIMARY KEY (u25_margin_request_id_t73,
  u25_question_id_m183)
USING INDEX
/

COMMENT ON COLUMN dfn_ntp.u25_om_mar_req_questionnaire.u25_cash_account_id_u06 IS
    'fk u06'
/
COMMENT ON COLUMN dfn_ntp.u25_om_mar_req_questionnaire.u25_customer_id_u01 IS
    'fk u01'
/
COMMENT ON COLUMN dfn_ntp.u25_om_mar_req_questionnaire.u25_inst_id_m02 IS
    'fk m02'
/
COMMENT ON COLUMN dfn_ntp.u25_om_mar_req_questionnaire.u25_margin_product_id_m73 IS
    'fk m73'
/
COMMENT ON COLUMN dfn_ntp.u25_om_mar_req_questionnaire.u25_margin_request_id_t73 IS
    'fk t73'
/
COMMENT ON COLUMN dfn_ntp.u25_om_mar_req_questionnaire.u25_question_id_m183 IS
    'fk 183'
/
