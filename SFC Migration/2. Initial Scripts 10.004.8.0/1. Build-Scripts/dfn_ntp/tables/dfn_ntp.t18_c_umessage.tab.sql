CREATE TABLE dfn_ntp.t18_c_umessage
(
    t18_id                         VARCHAR2 (20 BYTE) NOT NULL,
    t18_member_code_9700           VARCHAR2 (10 BYTE),
    t18_reference_no_9701          VARCHAR2 (20 BYTE),
    t18_account_type_9702          NUMBER (1, 0),
    t18_client_type_9703           NUMBER (1, 0),
    t18_from_nin_9704              VARCHAR2 (20 BYTE),
    t18_bank_acc_type_9705         NUMBER (2, 0),
    t18_bank_acc_no_9706           VARCHAR2 (50 BYTE),
    t18_acc_owner_name_9707        VARCHAR2 (1000 BYTE),
    t18_acc_number_9708            VARCHAR2 (15 BYTE),
    t18_acc_create_rspn_9709       NUMBER (2, 0),
    t18_address_9711               VARCHAR2 (2000 BYTE),
    t18_city_9712                  VARCHAR2 (255 BYTE),
    t18_postal_code_9713           VARCHAR2 (100 BYTE),
    t18_country_9714               VARCHAR2 (50 BYTE),
    t18_gender_9715                VARCHAR2 (1 BYTE),
    t18_name_9716                  VARCHAR2 (255 BYTE),
    t18_acc_delete_rspn_9717       NUMBER (2, 0),
    t18_acc_change_rspn_9718       NUMBER (2, 0),
    t18_pledge_type_9722           VARCHAR2 (1 BYTE),
    t18_pledgor_member_code_9723   VARCHAR2 (10 BYTE),
    t18_pledgor_acct_no_9724       VARCHAR2 (15 BYTE),
    t18_pledge_total_value_9725    NUMBER (18, 5),
    t18_pledge_member_code_9726    VARCHAR2 (10 BYTE),
    t18_pledgecall_mem_code_9727   VARCHAR2 (10 BYTE),
    t18_pledgecall_acc_no_9728     VARCHAR2 (15 BYTE),
    t18_pledge_src_trans_no_9729   VARCHAR2 (20 BYTE),
    t18_trans_rspn_9730            NUMBER (2, 0),
    t18_movement_type_9731         VARCHAR2 (1 BYTE),
    t18_seller_member_code_9732    VARCHAR2 (10 BYTE),
    t18_seller_acct_no_9733        VARCHAR2 (15 BYTE),
    t18_seller_nin_9734            VARCHAR2 (20 BYTE),
    t18_buyer_member_code_9735     VARCHAR2 (10 BYTE),
    t18_buyer_acct_no_9736         VARCHAR2 (15 BYTE),
    t18_buyer_nin_9737             VARCHAR2 (20 BYTE),
    t18_customer_id_u01            NUMBER (18, 0),
    t18_trading_account_id_u07     NUMBER (10, 0),
    t18_effective_date_9744        DATE,
    t18_return_date_9745           DATE,
    t18_transact_time_60           DATE,
    t18_created_date               DATE,
    t18_rspn_date                  DATE,
    t18_u_message_type             VARCHAR2 (5 BYTE),
    t18_u_message_status           NUMBER (1, 0),
    t18_u_message_reject_reason    VARCHAR2 (500 BYTE),
    t18_symbol                     VARCHAR2 (25 BYTE),
    t18_clordid_t01                NUMBER (18, 0),
    t18_price                      NUMBER (21, 8),
    t18_order_exec_id_t02          VARCHAR2 (100 BYTE),
    t18_shares                     NUMBER (10, 0),
    t18_trade_date_75              DATE,
    t18_settlement_date_9746       DATE,
    t18_trade_value_900            NUMBER (18, 5),
    t18_currency                   VARCHAR2 (10 BYTE),
    t18_cash_comp_date             DATE,
    t18_exchange_account_no_u07    VARCHAR2 (30 BYTE),
    t18_search_key                 VARCHAR2 (100 BYTE),
    t18_employee_id_u17            NUMBER (10, 0),
    t18_foreign_acc_no_9770        VARCHAR2 (34 BYTE),
    t18_foreign_acc_name_9771      VARCHAR2 (40 BYTE),
    t18_foreign_acc_iban_9772      VARCHAR2 (34 BYTE),
    t18_foreign_bank_name_9773     VARCHAR2 (40 BYTE),
    t18_foreign_bank_add_9774      VARCHAR2 (40 BYTE),
    t18_foreign_bank_swift_9775    VARCHAR2 (11 BYTE),
    t18_foreign_bank_aba_9776      VARCHAR2 (15 BYTE),
    t18_institute_id_m02           NUMBER (3, 0) DEFAULT 1,
    t18_symbol_id_m20              NUMBER (10, 0)
)
/


COMMENT ON COLUMN dfn_ntp.t18_c_umessage.t18_account_type_9702 IS
    'Same Values as U07_ACCOUNT_CATEGORY'
/
COMMENT ON COLUMN dfn_ntp.t18_c_umessage.t18_client_type_9703 IS
    'Same Values as U01_ACCOUNT_CATEGORY_ID_V01'
/
COMMENT ON COLUMN dfn_ntp.t18_c_umessage.t18_gender_9715 IS 'M/F'
/
COMMENT ON COLUMN dfn_ntp.t18_c_umessage.t18_movement_type_9731 IS
    'U=OMT (Off Market Trade),M=Murabaha movement,A=Others'
/
COMMENT ON COLUMN dfn_ntp.t18_c_umessage.t18_pledge_type_9722 IS
    'I=Into pledge,O=Out of pledge,C=Pledge call'
/
COMMENT ON COLUMN dfn_ntp.t18_c_umessage.t18_u_message_status IS
    '0=New, 1=Sent, 2=Response Sucess, 3=Response Reject, 4=Account Approve,  5=Oms Not Synched'
/
COMMENT ON COLUMN dfn_ntp.t18_c_umessage.t18_u_message_type IS
    'Same IDs as Old System'
/
ALTER TABLE dfn_ntp.T18_C_UMESSAGE 
 MODIFY (
  T18_BUYER_ACCT_NO_9736 VARCHAR2 (50 BYTE)

 )
/
ALTER TABLE dfn_ntp.t18_c_umessage
 MODIFY (
  t18_foreign_acc_iban_9772 VARCHAR2 (50 BYTE),
  t18_trans_rspn_9730 NUMBER (4, 0)

 )
/

ALTER TABLE dfn_ntp.T18_C_UMESSAGE 
 ADD (
  T18_REQ_REFERENCE NUMBER (5, 0)
 )
/