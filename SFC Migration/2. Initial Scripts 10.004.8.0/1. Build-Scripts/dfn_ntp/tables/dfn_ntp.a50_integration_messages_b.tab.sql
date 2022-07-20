CREATE TABLE dfn_ntp.a50_integration_messages_b
(
    a50_id             NUMBER (18, 0) NOT NULL,
    a50_message_id     VARCHAR2 (100 BYTE),
    a50_message        VARCHAR2 (4000 BYTE),
    a50_status         NUMBER (2, 0),
    a50_created_date   DATE DEFAULT SYSDATE
)
/

ALTER TABLE dfn_ntp.a50_integration_messages_b
ADD CONSTRAINT a50_pk PRIMARY KEY (a50_id)
USING INDEX
/


ALTER TABLE dfn_ntp.a50_integration_messages_b
 ADD (
    a50_account_no VARCHAR2 (75 BYTE),
    a50_update_code VARCHAR2 (20),
    a50_created_by_id_u17 NUMBER (18,0)
 )
/


COMMENT ON COLUMN dfn_ntp.a50_integration_messages_b.a50_account_no IS
    'A50_UPDATE_CODE = QRYCUS, REFCUS, BLKCUS, DLKCUS  Ref  U01_CUSTOMER_NO |  A50_UPDATE_CODE = QRYACC, REFACC, BLKACC, DLKACC  Ref U06_INVESTMENT_ACCOUNT_NO'
/
COMMENT ON COLUMN dfn_ntp.a50_integration_messages_b.a50_update_code IS
    'QRYCUS - Create Customer | QRYACC - Create Account | REFCUS - Refresh Customer | REFACC - Refresh Account | BLKCUS - Block Customer | DLKCUS - Unblock Customer | BLKACC - Block Account | DLKACC - Unblock Account'
/