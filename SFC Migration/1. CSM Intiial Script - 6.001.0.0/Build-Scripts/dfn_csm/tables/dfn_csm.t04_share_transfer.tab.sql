DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'DROP TABLE dfn_csm.t04_share_transfer';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tables
     WHERE     owner = UPPER ('dfn_csm')
           AND table_name = UPPER ('t04_share_transfer');

    IF l_count = 1
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

CREATE TABLE dfn_csm.t04_share_transfer
(
    t04_id                   NUMBER (18, 0),
    t04_oms_ref              NUMBER (18, 0),
    t04_movement_type        VARCHAR2 (30 BYTE),
    t04_settlement_date      DATE,
    t04_transaction_date     DATE,
    t04_isincode             VARCHAR2 (30 BYTE),
    t04_quantity             NUMBER (18, 0),
    t04_buyer_acc_no         VARCHAR2 (30 BYTE),
    t04_buyer_member_code    VARCHAR2 (30 BYTE),
    t04_seller_acc_no        VARCHAR2 (30 BYTE),
    t04_seller_member_code   VARCHAR2 (30 BYTE),
    t04_sender_status        NUMBER (2, 0) DEFAULT -1,
    t04_receiver_status      NUMBER (2, 0) DEFAULT -1,
    t04_type                 NUMBER (1, 0),
    t04_match_ref            NUMBER (18, 0) DEFAULT -1,
    t04_receiver_ref         NUMBER (18, 0) DEFAULT -1,
    t04_receiver_new_ref     NUMBER (18, 0) DEFAULT -1
)
/



COMMENT ON COLUMN dfn_csm.t04_share_transfer.t04_match_ref IS 'MT548 req Id'
/
COMMENT ON COLUMN dfn_csm.t04_share_transfer.t04_receiver_new_ref IS
    'MT578 new message req id'
/
COMMENT ON COLUMN dfn_csm.t04_share_transfer.t04_receiver_ref IS
    'MT578 req Id'
/
COMMENT ON COLUMN dfn_csm.t04_share_transfer.t04_receiver_status IS
    '1 = Send to Exchange, 2 = Pending Confirmation , 3 = L2 Approved, 4 = Alleged, 5 = L1 Approved, 6 = Failed'
/
COMMENT ON COLUMN dfn_csm.t04_share_transfer.t04_sender_status IS
    '1 = Send to Exchange, 2 = Pending Confirmation , 3 = L2 Approved'
/
COMMENT ON COLUMN dfn_csm.t04_share_transfer.t04_type IS
    '1 = Receiver, 2 = Sender'
/

ALTER TABLE dfn_csm.T04_SHARE_TRANSFER 
 ADD (
  t04_l1_approved_by NUMBER (5),
  t04_l1_approved_date DATE,
  t04_l2_approved_by NUMBER (5),
  t04_l2_approved_date DATE
 )
/
