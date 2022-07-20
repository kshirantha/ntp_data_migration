-- Table DFN_NTP.R04_LEVEL2_RECON

CREATE TABLE dfn_ntp.r04_level2_recon
(
    uniquekey                VARCHAR2 (50),
    execid                   VARCHAR2 (50),
    clordid                  VARCHAR2 (50),
    ordid                    VARCHAR2 (50),
    side                     NUMBER (18, 0),
    symbol                   VARCHAR2 (50),
    fixlastprice             NUMBER (18, 5),
    fixlastshares            NUMBER (18, 0),
    fixleavesqty             NUMBER (18, 0),
    fixtransacttime          VARCHAR2 (50),
    fixstatus                NUMBER (18, 0),
    auditlastprice           NUMBER (18, 5),
    auditlastshares          NUMBER (18, 0),
    auditleavesqty           NUMBER (18, 5),
    auditcumqty              NUMBER (18, 0),
    auditcumcommission       NUMBER (18, 5),
    auditcumordervalue       NUMBER (18, 5),
    auditcumordernetvalue    NUMBER (18, 5),
    auditcumordernetsettle   NUMBER (18, 5),
    auditstatus              NUMBER (18, 0),
    auditfxrate              NUMBER (18, 5)
)
/

-- Constraints for  DFN_NTP.R04_LEVEL2_RECON


  ALTER TABLE dfn_ntp.r04_level2_recon MODIFY (uniquekey NOT NULL ENABLE)
/



-- End of DDL Script for Table DFN_NTP.R04_LEVEL2_RECON
