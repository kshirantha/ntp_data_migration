CREATE TABLE dfn_ntp.m82_audit_activity
(
    m82_id                NUMBER (10, 0) NOT NULL,
    m82_activity_name     VARCHAR2 (100 BYTE),
    m82_category_id_m81   NUMBER (5, 0) NOT NULL,
    m82_action_id         NUMBER (5, 0)
)
/


ALTER TABLE dfn_ntp.m82_audit_activity
ADD CONSTRAINT m82_audit_activity_pk PRIMARY KEY (m82_id)
USING INDEX
/

COMMENT ON TABLE dfn_ntp.m82_audit_activity IS
    'Audit Activity MasterTable ID (M01=X), (U01=1000+X), (V01=2000+X), (T01=3000+X), (Z01=4000+X),  (OTHER=9000+Y) Where X is the Table ID, Y is a Sequence 

Activity Type Action ID: 1=Add, 2=Edit, 3=Delete, 4=Status Change, 5=Set Default, 6=Bulk Assign, 7=Assigned, 8=Unassigned, 9=Downloaded 10=Uploaded, 11- Suspended, 12 - Processed, 13=Deposit, 14=Withdraw, 15=Transfer, 16=Charge, 17=Refund, 18 = View, 19 = Changed

Activity Id = Table ID + 0 + Activity Type'
/
COMMENT ON COLUMN dfn_ntp.m82_audit_activity.m82_action_id IS
    'Action ID: 1=Add, 2=Edit, 3=Delete, 
4=Status Change, 5=Set Default, 6=Bulk Assign, 7=Assigned, 8=Unassigned, 9=Downloaded 10=Uploaded, 11- Suspended, 12 - Processed, 13=Deposit, 14=Withdraw, 15=Transfer, 16=Charge, 
17=Refund, 18 = View, 19 = Changed, 20 = Validated'
/
COMMENT ON COLUMN dfn_ntp.m82_audit_activity.m82_activity_name IS
    'Activity Name'
/
COMMENT ON COLUMN dfn_ntp.m82_audit_activity.m82_category_id_m81 IS
    'FK from M81 : Category ID'
/
COMMENT ON COLUMN dfn_ntp.m82_audit_activity.m82_id IS
    'Refer Table Comment for Description'
/

COMMENT ON TABLE dfn_ntp.m82_audit_activity IS
    'Use IDs greater than 10000  for customizations'
/

COMMENT ON COLUMN dfn_ntp.M82_AUDIT_ACTIVITY.M82_ACTION_ID IS 'Action ID: 1=Add, 2=Edit, 3=Delete,
4=Status Change, 5=Set Default, 6=Bulk Assign, 7=Assigned, 8=Unassigned, 9=Downloaded 10=Uploaded, 11- Suspended, 12 - Processed, 13=Deposit, 14=Withdraw, 15=Transfer, 16=Charge,
17=Refund, 18 = View, 19 = Changed, 20 = Validated, 21 = Failed'
/