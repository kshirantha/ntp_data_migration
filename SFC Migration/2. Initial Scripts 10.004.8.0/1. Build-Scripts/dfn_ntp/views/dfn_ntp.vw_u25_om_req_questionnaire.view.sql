CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_u25_om_req_questionnaire
(
    u25_question_id_m183,
    u25_margin_request_id_t73,
    u25_answer,
    u25_cash_account_id_u06,
    u25_customer_id_u01,
    u25_margin_product_id_m73,
    u25_custom_type,
    u25_inst_id_m02,
    m183_description,
    m183_description_lang
)
AS
    SELECT u25.u25_question_id_m183,
           u25.u25_margin_request_id_t73,
           u25.u25_answer,
           u25.u25_cash_account_id_u06,
           u25.u25_customer_id_u01,
           u25.u25_margin_product_id_m73,
           u25.u25_custom_type,
           u25.u25_inst_id_m02,
           m183.m183_description,
           m183.m183_description_lang
      FROM     u25_om_mar_req_questionnaire u25
           JOIN
               m183_om_questionnaire m183
           ON u25.u25_question_id_m183 = m183.m183_id
/
