CREATE TABLE dfn_csm.a05_trade_rec_notif
(
    a05_id           NUMBER (10, 0) NOT NULL,
    a05_notif_id     VARCHAR2 (50 BYTE),
    a05_notif_date   DATE,
    a05_notif_time   DATE,
    a05_symbol       VARCHAR2 (50 BYTE),
    a05_trd_id       VARCHAR2 (50 BYTE),
    a05_status_id    NUMBER (20, 0) DEFAULT 1,
    a05_csd_acc      VARCHAR2 (30 BYTE),
    a05_ccp_acc      VARCHAR2 (30 BYTE)
)
SEGMENT CREATION IMMEDIATE
NOPARALLEL
LOGGING
MONITORING
/



ALTER TABLE dfn_csm.a05_trade_rec_notif
ADD CONSTRAINT pk_a05_id PRIMARY KEY (a05_id)
USING INDEX
/

COMMENT ON COLUMN dfn_csm.a05_trade_rec_notif.a05_id IS 'pk'
/
COMMENT ON COLUMN dfn_csm.a05_trade_rec_notif.a05_status_id IS
    '1-pending, 2-send to rectify, 3-success'
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'DROP TABLE dfn_csm.a05_trade_rec_notif';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tables
     WHERE     owner = UPPER ('dfn_csm')
           AND table_name = UPPER ('a05_trade_rec_notif');

    IF l_count = 1
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

CREATE TABLE dfn_csm.a05_trade_rec_notif
(
    a05_id           NUMBER (10, 0) NOT NULL,
    a05_notif_id     VARCHAR2 (50 BYTE),
    a05_notif_date   DATE,
    a05_notif_time   DATE,
    a05_symbol       VARCHAR2 (50 BYTE),
    a05_trd_id       VARCHAR2 (50 BYTE),
    a05_status_id    NUMBER (20, 0) DEFAULT 1,
    a05_csd_acc      VARCHAR2 (30 BYTE),
    a05_ccp_acc      VARCHAR2 (30 BYTE)
)
/



ALTER TABLE dfn_csm.a05_trade_rec_notif
ADD CONSTRAINT pk_a05_id PRIMARY KEY (a05_id)
USING INDEX
/

COMMENT ON COLUMN dfn_csm.a05_trade_rec_notif.a05_id IS 'pk'
/
COMMENT ON COLUMN dfn_csm.a05_trade_rec_notif.a05_status_id IS
    '1-pending, 2-send to rectify, 3-success'
/

ALTER TABLE dfn_csm.a05_trade_rec_notif 
 ADD (
  A05_CREATED_BY NUMBER (18, 0) DEFAULT 0
 )
/

ALTER TABLE dfn_csm.a05_trade_rec_notif 
 ADD (
  A05_CREATED_DATE DATE
 )
/

ALTER TABLE dfn_csm.a05_trade_rec_notif 
 ADD (
  A05_MODIFIED_BY NUMBER (18, 0)
 )
/

ALTER TABLE dfn_csm.a05_trade_rec_notif 
 ADD (
  A05_MODIFIED_DATE DATE
 )
/

ALTER TABLE dfn_csm.a05_trade_rec_notif 
 ADD (
  A05_STATUS_CHANGED_BY NUMBER (18, 0)
 )
/

ALTER TABLE dfn_csm.a05_trade_rec_notif 
 ADD (
  A05_STATUS_CHANGED_DATE DATE
 )
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'DROP TABLE dfn_csm.a05_trade_rec_notif';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tables
     WHERE     owner = UPPER ('dfn_csm')
           AND table_name = UPPER ('a05_trade_rec_notif');

    IF l_count = 1
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

CREATE TABLE dfn_csm.a05_trade_rec_notif
(
    a05_id                    NUMBER (10, 0) NOT NULL,
    a05_notif_id              VARCHAR2 (50 BYTE),
    a05_notif_date            DATE,
    a05_notif_time            DATE,
    a05_symbol                VARCHAR2 (50 BYTE),
    a05_trd_id                VARCHAR2 (50 BYTE),
    a05_status_id             NUMBER (20, 0) DEFAULT 1,
    a05_csd_acc               VARCHAR2 (30 BYTE),
    a05_ccp_acc               VARCHAR2 (30 BYTE),
    a05_created_by            NUMBER (18, 0) DEFAULT 0,
    a05_created_date          DATE,
    a05_modified_by           NUMBER (18, 0),
    a05_modified_date         DATE,
    a05_status_changed_by     NUMBER (18, 0),
    a05_status_changed_date   DATE,
    a05_rectified_csd_acc     VARCHAR2 (30 BYTE),
    a05_rectified_ccp_acc     VARCHAR2 (30 BYTE)
)
/




ALTER TABLE dfn_csm.a05_trade_rec_notif
ADD CONSTRAINT pk_a05_id PRIMARY KEY (a05_id)
USING INDEX
/

COMMENT ON COLUMN dfn_csm.a05_trade_rec_notif.a05_id IS 'pk'
/
COMMENT ON COLUMN dfn_csm.a05_trade_rec_notif.a05_status_id IS
    '1-pending, 2-send to rectify, 3 - rectifiy , 0 - Available ,11 -  L1 Approved , 4 - Fail'
/