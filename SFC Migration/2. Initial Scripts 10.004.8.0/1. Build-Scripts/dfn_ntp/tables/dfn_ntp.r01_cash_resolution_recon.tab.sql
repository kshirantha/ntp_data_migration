-- Table DFN_NTP.R01_CASH_RESOLUTION_RECON

CREATE TABLE dfn_ntp.r01_cash_resolution_recon
(
    cashacntid          VARCHAR2 (50),
    balance             NUMBER (18, 5),
    reconbalance        NUMBER (18, 5),
    block               NUMBER (18, 5),
    reconblock          NUMBER (18, 5),
    openbuyblock        NUMBER (18, 5),
    reconopenbuyblock   NUMBER (18, 5),
    payable             NUMBER (18, 5),
    reconpayable        NUMBER (18, 5),
    receivable          NUMBER (18, 5),
    reconreceivable     NUMBER (18, 5)
)
/



-- End of DDL Script for Table DFN_NTP.R01_CASH_RESOLUTION_RECON
