CREATE TABLE dfn_csm.t05_pledge_transfer
(
    t05_id                    NUMBER (10, 0),
    t05_isincode              VARCHAR2 (100 BYTE),
    t05_quantity              NUMBER (10, 0),
    t05_pledgor_member_code   VARCHAR2 (100 BYTE),
    t05_pledgor_acc_no        VARCHAR2 (100 BYTE),
    t05_pledgee_member_code   VARCHAR2 (100 BYTE),
    t05_pledgee_acc_no        VARCHAR2 (100 BYTE),
    t05_sender_status         NUMBER (5, 0),
    t05_receiver_status       NUMBER (5, 0),
    t05_acceptance_ref        VARCHAR2 (500 BYTE),
    t05_registration_ref      VARCHAR2 (500 BYTE),
    t05_pledge_type           VARCHAR2 (1 BYTE),
    t05_oms_ref               VARCHAR2 (500 BYTE),
    t05_csd_ref               VARCHAR2 (500 BYTE),
    t05_created_date          DATE,
    t05_type                  NUMBER (1, 0),
    t05_process_status        VARCHAR2 (10 BYTE),
    t05_pledge_status         VARCHAR2 (10 BYTE),
    t05_settlement_status     VARCHAR2 (10 BYTE)
)
/





COMMENT ON COLUMN dfn_csm.t05_pledge_transfer.t05_id IS 'pk'
/
COMMENT ON COLUMN dfn_csm.t05_pledge_transfer.t05_pledge_status IS
    'REJT=Rejected, CANC=Cancelled, PCNF=Pending, REGI=Registered, APPR=Fully Executed, RELE=Fully Released, EXPI=Expired, OTHR'
/
COMMENT ON COLUMN dfn_csm.t05_pledge_transfer.t05_pledge_type IS
    'I=Into pledge,O=Out of pledge,C=Pledge call'
/
COMMENT ON COLUMN dfn_csm.t05_pledge_transfer.t05_process_status IS
    'REJT=Rejected, CAND=Cancelled, PACK=Accepted, COMP=Completed, OTHR'
/
COMMENT ON COLUMN dfn_csm.t05_pledge_transfer.t05_settlement_status IS
    'SETT=Fully restricted on pledgor’s account, PAIN=Partially restricted, USET=Not restricted'
/
COMMENT ON COLUMN dfn_csm.t05_pledge_transfer.t05_type IS
    '1 = Receiver, 2 = Sender'
/
