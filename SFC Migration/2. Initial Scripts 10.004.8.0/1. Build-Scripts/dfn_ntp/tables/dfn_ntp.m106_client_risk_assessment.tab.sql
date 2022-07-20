-- Table DFN_NTP.M106_CLIENT_RISK_ASSESSMENT

CREATE TABLE dfn_ntp.m106_client_risk_assessment
(
    m106_id            NUMBER (10, 0),
    m106_type          NUMBER (10, 0),
    m106_name          VARCHAR2 (500),
    m106_risk_factor   NUMBER (3, 0),
    m106_name_lang     VARCHAR2 (500)
)
/

-- Constraints for  DFN_NTP.M106_CLIENT_RISK_ASSESSMENT


  ALTER TABLE dfn_ntp.m106_client_risk_assessment ADD CONSTRAINT pk_m106 PRIMARY KEY (m106_id)
  USING INDEX  ENABLE
/



-- Comments for  DFN_NTP.M106_CLIENT_RISK_ASSESSMENT

COMMENT ON COLUMN dfn_ntp.m106_client_risk_assessment.m106_id IS 'm106_pk'
/
COMMENT ON COLUMN dfn_ntp.m106_client_risk_assessment.m106_type IS
    '1=Employment type,2=PEP,3=Customer Group,4=Client Status,5=Legal status'
/
COMMENT ON COLUMN dfn_ntp.m106_client_risk_assessment.m106_name IS
    'description of relevant type'
/
COMMENT ON COLUMN dfn_ntp.m106_client_risk_assessment.m106_risk_factor IS
    '1=Neutral,2=High,3=High/ Neutral'
/
COMMENT ON COLUMN dfn_ntp.m106_client_risk_assessment.m106_name_lang IS
    'description of relevant type in other lang'
/
-- End of DDL Script for Table DFN_NTP.M106_CLIENT_RISK_ASSESSMENT
