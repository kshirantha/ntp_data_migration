CREATE TABLE dfn_ntp.e100_process_deposit_txn_c
    (e100_data                       VARCHAR2(3 BYTE),
    e100_client_id                  VARCHAR2(10 BYTE),
    e100_cash_account               VARCHAR2(11 BYTE),
    e100_transac_date               VARCHAR2(8 BYTE),
    e100_value_date                 VARCHAR2(8 BYTE),
    e100_txn_timestamp              VARCHAR2(14 BYTE),
    e100_trans_type                 VARCHAR2(5 BYTE),
    e100_branch_code                VARCHAR2(5 BYTE),
    e100_transac_ref                VARCHAR2(10 BYTE),
    e100_txn_type                   VARCHAR2(4 BYTE),
    e100_withdrawal_type            VARCHAR2(3 BYTE),
    e100_currency                   VARCHAR2(3 BYTE),
    e100_amount                     VARCHAR2(16 BYTE),
    e100_debit_account              VARCHAR2(11 BYTE),
    e100_debit_acc_name             NVARCHAR2(40),
    e100_seq_no                     VARCHAR2(2 BYTE))
  SEGMENT CREATION IMMEDIATE
  ORGANIZATION EXTERNAL (
   DEFAULT DIRECTORY  ext_dir
    ACCESS PARAMETERS(RECORDS DELIMITED BY '\n'
    LOAD WHEN e100_data != 'UTL'
    SKIP 1
   CHARACTERSET ar8mswin1256
    FIELDS LRTRIM
    MISSING FIELD VALUES ARE NULL
    (e100_data (1:3) CHAR (3),
    e100_client_id (5:14) CHAR (10),
    e100_cash_account (16:26) CHAR (11),
    e100_transac_date (28:35) CHAR (8),
    e100_value_date (37:44) CHAR (8),
    e100_txn_timestamp (46:59) CHAR (14),
    e100_trans_type (61:65) CHAR (5),
    e100_branch_code (72:76) CHAR (5),
    e100_transac_ref (78:87) CHAR (10),
    e100_txn_type (89:92) CHAR (4),
    e100_withdrawal_type (94:96) CHAR (3),
    e100_currency (98:100) CHAR (3),
    e100_amount (102:117) CHAR (16),
    e100_debit_account (119:129)  CHAR (11),
    e100_debit_acc_name (131:170)  CHAR (40),
    e100_seq_no (172:173) CHAR (2)  )
   )
   LOCATION (
    ext_dir:'falcom_deposit_transactions.csv'
   )
  )
   REJECT LIMIT UNLIMITED
  NOPARALLEL
/