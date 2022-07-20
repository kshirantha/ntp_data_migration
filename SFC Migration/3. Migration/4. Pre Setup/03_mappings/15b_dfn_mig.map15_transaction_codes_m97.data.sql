DECLARE
    l_count   NUMBER := 0;
BEGIN
    SELECT COUNT (*) INTO l_count FROM map15_transaction_codes_m97;

    IF l_count = 0
    THEN
        INSERT INTO map15_transaction_codes_m97
             VALUES ('SELSET', 'SELSET', 'Sell Settlement');

        INSERT INTO map15_transaction_codes_m97
             VALUES ('CONOPN', 'CONOPN', 'Contact Open');

        INSERT INTO map15_transaction_codes_m97
             VALUES ('WODINT', 'WODINT', 'Withdrawal Over Draw Interest');

        INSERT INTO map15_transaction_codes_m97
             VALUES ('IODINT', 'IODINT', 'Incedential Over Draw Interest');

        INSERT INTO map15_transaction_codes_m97
             VALUES ('DIC', 'DIC', 'Debit Interest Capitalization');

        INSERT INTO map15_transaction_codes_m97
             VALUES ('SUBFE', 'SUBFE', 'Annual Fees');

        INSERT INTO map15_transaction_codes_m97
             VALUES ('CTRFEE', 'CTRFEE', 'Cash Transfer Processing Fee');

        INSERT INTO map15_transaction_codes_m97
             VALUES ('ETIFEE', 'ETIFEE', 'ETI Processing Fee');

        INSERT INTO map15_transaction_codes_m97
             VALUES ('PLGFEE', 'PLGFEE', 'Pledge Processing Fee');

        INSERT INTO map15_transaction_codes_m97
             VALUES ('CFRE', 'CFRE', 'Capitalization Reverse');

        INSERT INTO map15_transaction_codes_m97
             VALUES ('STKSUB', 'STKSUB', 'Stock Subscription Fee');

        INSERT INTO map15_transaction_codes_m97
             VALUES ('AWAN', 'AWAN', 'AWAN Subscription');

        INSERT INTO map15_transaction_codes_m97
             VALUES ('MFSRFD', 'MFSRFD', 'MFS Client Cash Refund');

        INSERT INTO map15_transaction_codes_m97
             VALUES ('MFSCHG', 'MFSCHG', 'MFS Client Cash Transfer');

        INSERT INTO map15_transaction_codes_m97
             VALUES ('MMOT', 'MMOT', 'Maintenance Margin Requirement');

        INSERT INTO map15_transaction_codes_m97
             VALUES ('REFCOM', 'REFCOM', 'Referral Commission');

        INSERT INTO map15_transaction_codes_m97
             VALUES ('FRD', 'FRD', 'Fund Redemption');

        INSERT INTO map15_transaction_codes_m97
             VALUES ('SFIN', 'SFIN', 'Short Initial Margin');

        INSERT INTO map15_transaction_codes_m97
             VALUES ('LFOT', 'LFOT', 'Long Initial Margin');

        INSERT INTO map15_transaction_codes_m97
             VALUES ('LFIN', 'LFIN', 'Long Initial Margin');

        INSERT INTO map15_transaction_codes_m97
             VALUES ('SFOT', 'SFOT', 'Short Initial Margin');

        INSERT INTO map15_transaction_codes_m97
             VALUES ('BTOP', 'BTOP', 'Buy Initial Margin Requirment');

        INSERT INTO map15_transaction_codes_m97
             VALUES ('STCL', 'STCL', 'Sell Initial Margin Settlement');

        INSERT INTO map15_transaction_codes_m97
             VALUES ('MMIN', 'MMIN', 'Maintenance Margin In');

        INSERT INTO map15_transaction_codes_m97
             VALUES (
                        'MMDP',
                        'MMDP',
                        'Recording of maintainence margin as collected for deposits placement with BSF');

        INSERT INTO map15_transaction_codes_m97
             VALUES (
                        'MMWD',
                        'MMWD',
                        'Recording withdraw of maintainence margin from company account');

        INSERT INTO map15_transaction_codes_m97
             VALUES (
                        'ODINT',
                        'ODINT',
                        'Unauthorized Overdraft Clients Interest');

        INSERT INTO map15_transaction_codes_m97
             VALUES ('REVBUY', 'REVBUY', 'Reverse Buy');

        INSERT INTO map15_transaction_codes_m97
             VALUES ('SUBFEE', 'SUBFEE', 'Subscription Fee');

        INSERT INTO map15_transaction_codes_m97
             VALUES ('DEPOST', 'DEPOST', 'Deposit');

        INSERT INTO map15_transaction_codes_m97
             VALUES ('WITHDR', 'WITHDR', 'Withdraw');

        INSERT INTO map15_transaction_codes_m97
             VALUES ('STPFEE', 'STPFEE', 'Stocks Transfer Processing Fee');

        INSERT INTO map15_transaction_codes_m97
             VALUES ('STLBUY', 'STLBUY', 'Buy');

        INSERT INTO map15_transaction_codes_m97
             VALUES ('STLSEL', 'STLSEL', 'Sell');

        INSERT INTO map15_transaction_codes_m97
             VALUES ('REVSEL', 'REVSEL', 'Reverse Sell');

        INSERT INTO map15_transaction_codes_m97
             VALUES ('BRKCOM', 'BRKCOM', 'Broker Commission');

        INSERT INTO map15_transaction_codes_m97
             VALUES ('EXGCOM', 'EXGCOM', 'Exchange Commission');

        INSERT INTO map15_transaction_codes_m97
             VALUES ('MGNFEE', 'MGNFEE', 'Margin Fee');

        INSERT INTO map15_transaction_codes_m97
             VALUES ('MISFEE', 'MISFEE', 'Miscellaneous');

        INSERT INTO map15_transaction_codes_m97
             VALUES ('REFUND', 'REFUND', 'Refund');

        INSERT INTO map15_transaction_codes_m97
             VALUES ('BUYSET', 'BUYSET', 'Buy Settlement');

        INSERT INTO map15_transaction_codes_m97
             VALUES ('MLFO', 'MRGFND', 'Margin Funding');

        INSERT INTO map15_transaction_codes_m97
             VALUES ('MLSO', 'MRGCOV', 'Margin Covering');

        INSERT INTO map15_transaction_codes_m97
             VALUES ('MIBO', 'MRGFND', 'Margin Funding');

        INSERT INTO map15_transaction_codes_m97
             VALUES ('MISO', 'MRGCOV', 'Margin Covering');

        INSERT INTO map15_transaction_codes_m97
             VALUES ('FLF', 'MRGFND', 'Margin Funding');

        INSERT INTO map15_transaction_codes_m97
             VALUES ('FLS', 'MRGCOV', 'Margin Covering');

        INSERT INTO map15_transaction_codes_m97
             VALUES ('FTOC', 'MRGCOV', 'Margin Covering');

        INSERT INTO map15_transaction_codes_m97
             VALUES ('FTOL', 'MRGFND', 'Margin Funding');

        INSERT INTO map15_transaction_codes_m97
             VALUES ('MALF', 'MRGFND', 'Margin Funding');

        INSERT INTO map15_transaction_codes_m97
             VALUES ('MALS', 'MRGCOV', 'Margin Covering');

        INSERT INTO map15_transaction_codes_m97
             VALUES ('IBD', 'MGNFEE', 'Margin Fee');

        INSERT INTO map15_transaction_codes_m97
             VALUES ('MLRO', 'MGNFEE', 'Margin Fee');

        INSERT INTO map15_transaction_codes_m97
             VALUES ('REVEXS', 'REVSEL', 'Reverse Sell');

        INSERT INTO map15_transaction_codes_m97
             VALUES ('REVEXB', 'REVBUY', 'Reverse Buy');

        INSERT INTO map15_transaction_codes_m97
             VALUES (
                        'ICMR',
                        'CUDYORDFEE',
                        'Custody Transactional Charge(Order)');

        INSERT INTO map15_transaction_codes_m97
             VALUES ('ICMR', 'CUDYHLDFEE', 'Custody Holding Charge');

        /* No Usage in SFC

        INSERT INTO map15_transaction_codes_m97
            VALUES ('ICMR', 'CUDYTRNFEE', 'Custody Transactions Charge'); */

        /* Manually Handle Depending on the Type of T12 Linked Beneficiary Account for 'TRNFEE'

        INSERT INTO map15_transaction_codes_m97
             VALUES (
                        'TRNFEE',
                        'CTRFEE_BNK',
                        'Cash Transfer Fee - Between Brokerage Accounts');

        INSERT INTO map15_transaction_codes_m97
             VALUES (
                        'TRNFEE',
                        'CTRFEE_OTR',
                        'Cash Transfer Fee - Between Other Accounts');

        INSERT INTO map15_transaction_codes_m97
             VALUES (
                        'TRNFEE',
                        'CTRFEE_INT',
                        'Cash Transfer Fee - Between Cash Accounts'); */

        INSERT INTO map15_transaction_codes_m97
             VALUES ('MIIO', 'MGNFEE', 'Margin Fee');

        INSERT INTO map15_transaction_codes_m97
             VALUES ('CADPST', 'REFUND', 'Refund');

        INSERT INTO map15_transaction_codes_m97
             VALUES ('CAWHDR', 'CHARGE', 'Charge');

        INSERT INTO map15_transaction_codes_m97
             VALUES ('CDI', 'REFUND', 'Refund');

        INSERT INTO map15_transaction_codes_m97
             VALUES ('MBC', 'REFUND', 'Refund');

        INSERT INTO map15_transaction_codes_m97
             VALUES ('TRNSFR', 'CSHTRN', 'Cash Transfer');

        INSERT INTO map15_transaction_codes_m97
             VALUES ('DEPDIV', 'REFUND', 'Refund');

        INSERT INTO map15_transaction_codes_m97
             VALUES ('MACO', 'MACO', 'Murabaha Profit Commission');

        INSERT INTO map15_transaction_codes_m97
             VALUES ('PSTLTR', 'PSTLTR', 'Pending Settle Transfer Fee');

        INSERT INTO map15_transaction_codes_m97
             VALUES (
                        'SF05',
                        'SF05',
                        'Payable From Pending Settlement Accrual Interest');

        INSERT INTO map15_transaction_codes_m97
             VALUES ('FSB', 'FSB', 'Fund Subscription');

        INSERT INTO map15_transaction_codes_m97
             VALUES ('FTI', 'FTI', 'Local Fund Transfer IN for Local GL');

        INSERT INTO map15_transaction_codes_m97
             VALUES ('FTO', 'FTO', 'Fund Transfer OUT');

        INSERT INTO map15_transaction_codes_m97
             VALUES ('EXTWDR', 'EXTWDR', 'Cash Transfer');

        INSERT INTO map15_transaction_codes_m97
             VALUES (
                        'INDCH',
                        'INDCH',
                        'Credit and Debit Independent Custodian');

        INSERT INTO map15_transaction_codes_m97
             VALUES ('VML1', 'MTML', 'Recording Losses on Futures Contracts');

        INSERT INTO map15_transaction_codes_m97
             VALUES ('VMG1', 'MTMP', 'Recording Gains on Futures Contracts');

        INSERT INTO map15_transaction_codes_m97
             VALUES ('FTB', 'FTB', 'Fund Transfer Fee - Bank');

        INSERT INTO map15_transaction_codes_m97
             VALUES ('FIS', 'FIS', 'FIS');

        INSERT INTO map15_transaction_codes_m97
             VALUES ('MIAO', 'MGNFEE', 'Margin Fee');

        INSERT INTO map15_transaction_codes_m97
             VALUES ('MLAO', 'MGNFEE', 'Margin Fee');

        INSERT INTO map15_transaction_codes_m97
             VALUES (
                        'STKFEE',
                        'STPFEE_INT',
                        'Stocks Transfer Fee - Within customer');

        INSERT INTO map15_transaction_codes_m97
             VALUES (
                        'PLEDGE',
                        'PLGFEE_IN',
                        'Pledge Processing Fee - Pledge In');

        INSERT INTO map15_transaction_codes_m97
             VALUES (
                        'DEPLED',
                        'PLGFEE_OUT',
                        'Pledge Processing Fee - Pledge Out');

        INSERT INTO map15_transaction_codes_m97
             VALUES (
                        'BSFCTR',
                        'CTRFEE_BNK',
                        'Cash Transfer Fee - Between Brokerage Accounts');

        INSERT INTO map15_transaction_codes_m97
             VALUES (
                        'OTRCTR',
                        'CTRFEE_OTR',
                        'Cash Transfer Fee - Between Other Accounts');

        INSERT INTO map15_transaction_codes_m97
             VALUES (
                        'SFCCTR',
                        'CTRFEE_INT',
                        'Cash Transfer Fee - Between Cash Accounts');

        INSERT INTO map15_transaction_codes_m97
             VALUES (
                        'FAMIST',
                        'STPFEE_CUS',
                        'Stocks Transfer Fee - Between OMS Customers');

        INSERT INTO map15_transaction_codes_m97
             VALUES (
                        'FAMIST',
                        'STPFEE_BRD',
                        'Stocks Transfer Fee - Between Brokers - Different Customers');

        INSERT INTO map15_transaction_codes_m97
             VALUES (
                        'INTEST',
                        'STPFEE_BRS',
                        'Stocks Transfer Fee - Between Brokers - Same Customer');

        INSERT INTO map15_transaction_codes_m97
             VALUES (
                        'INTRST',
                        'STPFEE_INT',
                        'Stocks Transfer Fee - Within customer');

        INSERT INTO map15_transaction_codes_m97
             VALUES (
                        'MURBST',
                        'STPFEE_MUR',
                        'Stocks Transfer Fee - Murabaha');

        INSERT INTO map15_transaction_codes_m97
             VALUES (
                        'BIACST',
                        'STPFEE_CTI',
                        'Stocks Transfer Fee - Between OMS Cust Corporate to Individual');

        INSERT INTO map15_transaction_codes_m97
             VALUES ('14', 'ETIFEE_PRO', 'ETI - Mubasher Pro (Premium)'); -- Sub Charge ID USed as Sub Charge Code is NULL

        INSERT INTO map15_transaction_codes_m97
             VALUES ('16', 'ETIFEE_AWN', 'ETI - Awan (Premium)'); -- Sub Charge ID USed as Sub Charge Code is NULL
    END IF;
END;
/
