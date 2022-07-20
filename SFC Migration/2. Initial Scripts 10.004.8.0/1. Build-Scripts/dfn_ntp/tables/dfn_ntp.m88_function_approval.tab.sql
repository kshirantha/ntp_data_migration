CREATE TABLE dfn_ntp.m88_function_approval
(
    m88_id                     NUMBER (5, 0) NOT NULL,
    m88_function               VARCHAR2 (50 BYTE),
    m88_function_description   VARCHAR2 (50 BYTE),
    m88_approval_levels        NUMBER (1, 0),
    m88_maker_checker_type     NUMBER (1, 0),
    m88_channel_id_v29         NUMBER (5, 0),
    m88_custom_type            VARCHAR2 (50 BYTE) DEFAULT 1
)
/

ALTER TABLE dfn_ntp.m88_function_approval
ADD PRIMARY KEY (m88_id)
USING INDEX
/

COMMENT ON COLUMN dfn_ntp.m88_function_approval.m88_approval_levels IS
    '0 - Imidiate | 1- 1 Level | 2 - 2 Levels'
/
COMMENT ON COLUMN dfn_ntp.m88_function_approval.m88_maker_checker_type IS
    '0 - No Restriction | 1- Maker Can''t Ddo Approvals | 2 - Can''t Do Consecutive Approvals | 3 - Only One Approval By One Person'
/

ALTER TABLE dfn_ntp.m88_function_approval
 ADD (
  m88_txn_code VARCHAR2 (10)
 )
/

COMMENT ON COLUMN dfn_ntp.m88_function_approval.m88_channel_id_v29 IS
    '-1 : All'
/

COMMENT ON COLUMN dfn_ntp.m88_function_approval.m88_txn_code IS
    'M97 Charge Code & OMS Txn Codes'
/

ALTER TABLE dfn_ntp.m88_function_approval ADD CONSTRAINT m88_fn_chnl_uk
  UNIQUE (
  m88_function
  ,m88_channel_id_v29
)
 ENABLE
 VALIDATE
/