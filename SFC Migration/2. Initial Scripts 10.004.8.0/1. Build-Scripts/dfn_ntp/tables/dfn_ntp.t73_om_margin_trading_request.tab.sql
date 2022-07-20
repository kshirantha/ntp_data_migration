CREATE TABLE dfn_ntp.t73_om_margin_trading_request
(
    t73_id                           NUMBER (5, 0) NOT NULL,
    t73_cash_account_id_u06          NUMBER (10, 0) NOT NULL,
    t73_customer_id_u01              NUMBER (10, 0) NOT NULL,
    t73_margin_product_id_m73        NUMBER (3, 0) NOT NULL,
    t73_max_margin_limit             NUMBER (18, 5) DEFAULT 0,
    t73_currency_id_m03              NUMBER (5, 0),
    t73_currency_code_m03            CHAR (3 BYTE),
    t73_margin_expiry_date           DATE,
    t73_margin_call_level_1          NUMBER (10, 5) DEFAULT 0,
    t73_margin_call_level_2          NUMBER (10, 5) DEFAULT 0,
    t73_liquidation_level            NUMBER (10, 5) DEFAULT 0,
    t73_margin_percentage            NUMBER (10, 5),
    t73_margin_notify_mobile         VARCHAR2 (35 BYTE),
    t73_margin_notify_email          VARCHAR2 (100 BYTE),
    t73_customer_age                 NUMBER (3, 0),
    t73_profession_id_m114           NUMBER (4, 0),
    t73_residence_region             VARCHAR2 (100 BYTE),
    t73_annual_income                NUMBER (18, 5),
    t73_other_banks_margin           NUMBER (18, 5),
    t73_other_income                 NUMBER (18, 5),
    t73_trading_experience           NUMBER (3, 0),
    t73_leverage_experience          NUMBER (3, 0),
    t73_portfolio_with_ap            NUMBER (3, 0),
    t73_required_margin              NUMBER (18, 5),
    t73_tenor                        NUMBER (3, 0),
    t73_margin_profit                NUMBER (18, 5),
    t73_agent_fee                    NUMBER (18, 5),
    t73_no_of_approval               NUMBER (2, 0),
    t73_is_approval_completed        NUMBER (1, 0),
    t73_current_approval_level       NUMBER (2, 0),
    t73_next_status                  NUMBER (3, 0),
    t73_created_date                 DATE DEFAULT SYSDATE,
    t73_status_changed_date          DATE,
    t73_status_id_v01                NUMBER (5, 0),
    t73_comment                      VARCHAR2 (400 BYTE),
    t73_created_by_id_u17            NUMBER (10, 0),
    t73_status_changed_by_id_u17     NUMBER (10, 0),
    t73_custom_type                  VARCHAR2 (50 BYTE) DEFAULT 1,
    t73_institute_id_m02             NUMBER (3, 0) DEFAULT 1,
    t73_murahaba_basket_id_m181      NUMBER (10, 0),
    t73_portfolio_age                NUMBER (3, 0),
    t73_simah_document               BLOB,
    t73_bsf_remedial_document        BLOB,
    t73_credit_commi_approval_doc    BLOB,
    t73_simah_document_name          VARCHAR2 (100 BYTE),
    t73_bsf_remedial_document_name   VARCHAR2 (100 BYTE),
    t73_credit_commi_appr_doc_name   VARCHAR2 (100 BYTE),
    t73_min_margin_limit             NUMBER (18, 5)
)
/



ALTER TABLE dfn_ntp.t73_om_margin_trading_request
ADD PRIMARY KEY (t73_id)
USING INDEX
/

COMMENT ON COLUMN dfn_ntp.t73_om_margin_trading_request.t73_bsf_remedial_document IS
    'Required to upload in L1'
/
COMMENT ON COLUMN dfn_ntp.t73_om_margin_trading_request.t73_bsf_remedial_document_name IS
    'BSF Redimal File Name'
/
COMMENT ON COLUMN dfn_ntp.t73_om_margin_trading_request.t73_cash_account_id_u06 IS
    'fk - U06'
/
COMMENT ON COLUMN dfn_ntp.t73_om_margin_trading_request.t73_credit_commi_appr_doc_name IS
    'Credit Card Approval File Name'
/
COMMENT ON COLUMN dfn_ntp.t73_om_margin_trading_request.t73_credit_commi_approval_doc IS
    'Required to upload in L4'
/
COMMENT ON COLUMN dfn_ntp.t73_om_margin_trading_request.t73_customer_age IS
    'Age in Years'
/
COMMENT ON COLUMN dfn_ntp.t73_om_margin_trading_request.t73_customer_id_u01 IS
    'fk - U01'
/
COMMENT ON COLUMN dfn_ntp.t73_om_margin_trading_request.t73_institute_id_m02 IS
    'fk - M02'
/
COMMENT ON COLUMN dfn_ntp.t73_om_margin_trading_request.t73_leverage_experience IS
    'Leverage Experience in Years'
/
COMMENT ON COLUMN dfn_ntp.t73_om_margin_trading_request.t73_margin_notify_email IS
    'Online Margin Notifications are sent to this Email'
/
COMMENT ON COLUMN dfn_ntp.t73_om_margin_trading_request.t73_margin_notify_mobile IS
    'Online Margin Notifications are sent to this Mobile'
/
COMMENT ON COLUMN dfn_ntp.t73_om_margin_trading_request.t73_margin_percentage IS
    'Intial Margin or Coverage'
/
COMMENT ON COLUMN dfn_ntp.t73_om_margin_trading_request.t73_margin_product_id_m73 IS
    'fk - M73'
/
COMMENT ON COLUMN dfn_ntp.t73_om_margin_trading_request.t73_murahaba_basket_id_m181 IS
    'fk -M181'
/
COMMENT ON COLUMN dfn_ntp.t73_om_margin_trading_request.t73_portfolio_age IS
    'Portfolio Age in Years'
/
COMMENT ON COLUMN dfn_ntp.t73_om_margin_trading_request.t73_portfolio_with_ap IS
    'Portfolio with AP in Years'
/
COMMENT ON COLUMN dfn_ntp.t73_om_margin_trading_request.t73_profession_id_m114 IS
    'fk - M114'
/
COMMENT ON COLUMN dfn_ntp.t73_om_margin_trading_request.t73_required_margin IS
    'Max Margin Limit in U23'
/
COMMENT ON COLUMN dfn_ntp.t73_om_margin_trading_request.t73_residence_region IS
    'Sent from UA as a text'
/
COMMENT ON COLUMN dfn_ntp.t73_om_margin_trading_request.t73_simah_document IS
    'Required to upload in L1'
/
COMMENT ON COLUMN dfn_ntp.t73_om_margin_trading_request.t73_simah_document_name IS
    'SIMAH File Name'
/
COMMENT ON COLUMN dfn_ntp.t73_om_margin_trading_request.t73_tenor IS
    'Tenor in Months'
/
COMMENT ON COLUMN dfn_ntp.t73_om_margin_trading_request.t73_trading_experience IS
    'Trading Experience in Years'
/

ALTER TABLE dfn_ntp.t73_om_margin_trading_request
 ADD (
  t73_margin_final_approval_doc BLOB,
  t73_margin_final_appr_doc_name VARCHAR2 (100),
  t73_margin_email_notifi_id_t13 NUMBER (10, 0),
  t73_margin_sms_notifica_id_t13 NUMBER (10, 0),
  t73_approval_margin NUMBER (18, 5)
 )
 MODIFY (
  t73_simah_document_name VARCHAR2 (200 BYTE),
  t73_bsf_remedial_document_name VARCHAR2 (200 BYTE),
  t73_credit_commi_appr_doc_name VARCHAR2 (200 BYTE)

 )
/
COMMENT ON COLUMN dfn_ntp.t73_om_margin_trading_request.t73_margin_final_approval_doc IS
    'Margin Final Approval'
/
COMMENT ON COLUMN dfn_ntp.t73_om_margin_trading_request.t73_approval_margin IS
    'Required in Murahaba'
/
COMMENT ON COLUMN dfn_ntp.t73_om_margin_trading_request.t73_margin_sms_notifica_id_t13 IS
    'T13 Id of the SMS'
/
COMMENT ON COLUMN dfn_ntp.t73_om_margin_trading_request.t73_margin_email_notifi_id_t13 IS
    'T13 Id of the Email'
/

ALTER TABLE dfn_ntp.T73_OM_MARGIN_TRADING_REQUEST 
 MODIFY (
  T73_ANNUAL_INCOME VARCHAR2 (100 BYTE)
 )
/