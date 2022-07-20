DECLARE
    l_count   NUMBER := 0;
BEGIN
    SELECT COUNT (*) INTO l_count FROM map04_entitlements_v04;

    IF l_count = 0
    THEN
        INSERT INTO map04_entitlements_v04 
        VALUES(17,170,'Customer');
        INSERT INTO map04_entitlements_v04 
        VALUES(1805,270,'Customer - Account Closure');
        INSERT INTO map04_entitlements_v04 
        VALUES(1806,271,'Customer - Account Closure Requests');
        INSERT INTO map04_entitlements_v04 
        VALUES(623,281,'Customer - Account Locked Customers');
        INSERT INTO map04_entitlements_v04 
        VALUES(20,171,'Customer - Cash Accounts');
        INSERT INTO map04_entitlements_v04 
        VALUES(73,176,'Customer - Cash Accounts - Adjust Trading/Transaction Limits');
        INSERT INTO map04_entitlements_v04 
        VALUES(56,179,'Customer - Cash Accounts - Approved Entries');
        INSERT INTO map04_entitlements_v04 
        VALUES(334,175,'Customer - Cash Accounts - Cash Transfer');
        INSERT INTO map04_entitlements_v04 
        VALUES(72,174,'Customer - Cash Accounts - Charges && Refunds');
        INSERT INTO map04_entitlements_v04 
        VALUES(52,172,'Customer - Cash Accounts - Deposit Money');
        INSERT INTO map04_entitlements_v04 
        VALUES(1087,178,'Customer - Cash Accounts - Pending Entries');
        INSERT INTO map04_entitlements_v04 
        VALUES(190,177,'Customer - Cash Accounts - Remove Blocked Amount');
        INSERT INTO map04_entitlements_v04 
        VALUES(27,180,'Customer - Cash Accounts - View Transactions');
        INSERT INTO map04_entitlements_v04 
        VALUES(53,173,'Customer - Cash Accounts - Withdraw Money');
        INSERT INTO map04_entitlements_v04 
        VALUES(108,291,'Customer - Customer Account');
        INSERT INTO map04_entitlements_v04 
        VALUES(180,293,'Customer - Customer Account - Corporate Accounts');
        INSERT INTO map04_entitlements_v04 
        VALUES(109,292,'Customer - Customer Account - Individual Accounts');
        INSERT INTO map04_entitlements_v04 
        VALUES(67,294,'Customer - Customer Account - Master Accounts');
        INSERT INTO map04_entitlements_v04 
        VALUES(38,184,'Customer - Customer Login Manage - Approve');
        INSERT INTO map04_entitlements_v04 
        VALUES(38,188,'Customer - Customer Login Manage - Delete');
        INSERT INTO map04_entitlements_v04 
        VALUES(38,183,'Customer - Customer Login Manage - Edit');
        INSERT INTO map04_entitlements_v04 
        VALUES(38,189,'Customer - Customer Login Manage - Grant');
        INSERT INTO map04_entitlements_v04 
        VALUES(38,187,'Customer - Customer Login Manage - Mark For Delete');
        INSERT INTO map04_entitlements_v04 
        VALUES(38,186,'Customer - Customer Login Manage - Reject');
        INSERT INTO map04_entitlements_v04 
        VALUES(38,185,'Customer - Customer Login Manage - Restore');
        INSERT INTO map04_entitlements_v04 
        VALUES(38,190,'Customer - Customer Login Manage - Save');
        INSERT INTO map04_entitlements_v04 
        VALUES(6,181,'Customer - Customer Login Manager ');
        INSERT INTO map04_entitlements_v04 
        VALUES(38,182,'Customer - Customer Login Manager - Add');
        INSERT INTO map04_entitlements_v04 
        VALUES(1625,921,'Customer - Customer Power of Attorney - Add');
        INSERT INTO map04_entitlements_v04 
        VALUES(1626,929,'Customer - Customer Power of Attorney - Approvals');
        INSERT INTO map04_entitlements_v04 
        VALUES(1626,923,'Customer - Customer Power of Attorney - Approve');
        INSERT INTO map04_entitlements_v04 
        VALUES(1626,926,'Customer - Customer Power of Attorney - Delete');
        INSERT INTO map04_entitlements_v04 
        VALUES(1625,922,'Customer - Customer Power of Attorney - Edit');
        INSERT INTO map04_entitlements_v04 
        VALUES(1625,924,'Customer - Customer Power of Attorney - Grant');
        INSERT INTO map04_entitlements_v04 
        VALUES(1625,925,'Customer - Customer Power of Attorney - Mark For Delete');
        INSERT INTO map04_entitlements_v04 
        VALUES(1626,927,'Customer - Customer Power of Attorney - Reject');
        INSERT INTO map04_entitlements_v04 
        VALUES(1626,928,'Customer - Customer Power of Attorney - Restore');
        INSERT INTO map04_entitlements_v04 
        VALUES(1628,930,'Customer - Customer Power of Attorney - Trading Restrictions');
        INSERT INTO map04_entitlements_v04 
        VALUES(1628,931,'Customer - Customer Power of Attorney - Trading Symbol Restrictions');
        INSERT INTO map04_entitlements_v04 
        VALUES(270,401,'Customer - Customers');
        INSERT INTO map04_entitlements_v04 
        VALUES(269,406,'Customer - Customers -  Delete');
        INSERT INTO map04_entitlements_v04 
        VALUES(270,407,'Customer - Customers -  Grant');
        INSERT INTO map04_entitlements_v04 
        VALUES(269,402,'Customer - Customers - Approve');
        INSERT INTO map04_entitlements_v04 
        VALUES(334,497,'Customer - Customers - Customer Summary - Cash Account  - Beneficiary Transfer');
        INSERT INTO map04_entitlements_v04 
        VALUES(52,494,'Customer - Customers - Customer Summary - Cash Account  - Cash Deposit');
        INSERT INTO map04_entitlements_v04 
        VALUES(334,496,'Customer - Customers - Customer Summary - Cash Account  - Cash Transfer');
        INSERT INTO map04_entitlements_v04 
        VALUES(72,498,'Customer - Customers - Customer Summary - Cash Account  - Charges and Refund');
        INSERT INTO map04_entitlements_v04 
        VALUES(73,493,'Customer - Customers - Customer Summary - Cash Account - Adjust Trading/ Transaction Limit');
        INSERT INTO map04_entitlements_v04 
        VALUES(1416,521,'Customer - Customers - Customer Summary - Documents');
        INSERT INTO map04_entitlements_v04 
        VALUES(60,522,'Customer - Customers - Customer Summary - Documents - Upload');
        INSERT INTO map04_entitlements_v04 
        VALUES(1804,517,'Customer - Customers - Customer Summary - Trade Account  - Close Trading Account');
        INSERT INTO map04_entitlements_v04 
        VALUES(1411,516,'Customer - Customers - Customer Summary - Trade Account  - Security Transfer');
        INSERT INTO map04_entitlements_v04 
        VALUES(51,518,'Customer - Customers - Customer Summary - Trade Account  - Stock Adjustments');
        INSERT INTO map04_entitlements_v04 
        VALUES(164,514,'Customer - Customers - Customer Summary - Trade Account  - View Holdings Summary - Front Office');
        INSERT INTO map04_entitlements_v04 
        VALUES(164,513,'Customer - Customers - Customer Summary - Trade Account - View Holdings Summary - Back Office');
        INSERT INTO map04_entitlements_v04 
        VALUES(12,492,'Customer - Customers - Customer Summary -Search');
        INSERT INTO map04_entitlements_v04 
        VALUES(53,495,'Customer - Customers - ECustomer Summary - Cash Account  - Cash Withdraw');
        INSERT INTO map04_entitlements_v04 
        VALUES(890,515,'Customer - Customers - ECustomer Summary - Trade Account  - Restrictions');
        INSERT INTO map04_entitlements_v04 
        VALUES(10,408,'Customer - Customers - Edit');
        INSERT INTO map04_entitlements_v04 
        VALUES(70,471,'Customer - Customers - Edit - Beneficiary Account ');
        INSERT INTO map04_entitlements_v04 
        VALUES(503,472,'Customer - Customers - Edit - Beneficiary Account - Add');
        INSERT INTO map04_entitlements_v04 
        VALUES(504,474,'Customer - Customers - Edit - Beneficiary Account - Approve');
        INSERT INTO map04_entitlements_v04 
        VALUES(504,478,'Customer - Customers - Edit - Beneficiary Account - Delete');
        INSERT INTO map04_entitlements_v04 
        VALUES(71,473,'Customer - Customers - Edit - Beneficiary Account - Edit');
        INSERT INTO map04_entitlements_v04 
        VALUES(558,479,'Customer - Customers - Edit - Beneficiary Account - Grant');
        INSERT INTO map04_entitlements_v04 
        VALUES(558,477,'Customer - Customers - Edit - Beneficiary Account - Mark For Delete');
        INSERT INTO map04_entitlements_v04 
        VALUES(504,476,'Customer - Customers - Edit - Beneficiary Account - Reject');
        INSERT INTO map04_entitlements_v04 
        VALUES(504,475,'Customer - Customers - Edit - Beneficiary Account - Restore');
        INSERT INTO map04_entitlements_v04 
        VALUES(253,421,'Customer - Customers - Edit - Cash Accounts ');
        INSERT INTO map04_entitlements_v04 
        VALUES(7,422,'Customer - Customers - Edit - Cash Accounts - Add');
        INSERT INTO map04_entitlements_v04 
        VALUES(254,424,'Customer - Customers - Edit - Cash Accounts - Approve');
        INSERT INTO map04_entitlements_v04 
        VALUES(254,428,'Customer - Customers - Edit - Cash Accounts - Delete');
        INSERT INTO map04_entitlements_v04 
        VALUES(30,423,'Customer - Customers - Edit - Cash Accounts - Edit');
        INSERT INTO map04_entitlements_v04 
        VALUES(253,429,'Customer - Customers - Edit - Cash Accounts - Grant');
        INSERT INTO map04_entitlements_v04 
        VALUES(253,427,'Customer - Customers - Edit - Cash Accounts - Mark For Delete');
        INSERT INTO map04_entitlements_v04 
        VALUES(254,426,'Customer - Customers - Edit - Cash Accounts - Reject');
        INSERT INTO map04_entitlements_v04 
        VALUES(254,425,'Customer - Customers - Edit - Cash Accounts - Restore');
        INSERT INTO map04_entitlements_v04 
        VALUES(890,431,'Customer - Customers - Edit - Cash Accounts - Restriction Approvals');
        INSERT INTO map04_entitlements_v04 
        VALUES(1430,430,'Customer - Customers - Edit - Cash Accounts - Restrictions');
        INSERT INTO map04_entitlements_v04 
        VALUES(172,411,'Customer - Customers - Edit - Customer Contact ');
        INSERT INTO map04_entitlements_v04 
        VALUES(172,412,'Customer - Customers - Edit - Customer Contact - Add');
        INSERT INTO map04_entitlements_v04 
        VALUES(172,414,'Customer - Customers - Edit - Customer Contact - Approve');
        INSERT INTO map04_entitlements_v04 
        VALUES(172,418,'Customer - Customers - Edit - Customer Contact - Delete');
        INSERT INTO map04_entitlements_v04 
        VALUES(172,413,'Customer - Customers - Edit - Customer Contact - Edit');
        INSERT INTO map04_entitlements_v04 
        VALUES(172,419,'Customer - Customers - Edit - Customer Contact - Grant');
        INSERT INTO map04_entitlements_v04 
        VALUES(172,417,'Customer - Customers - Edit - Customer Contact - Mark For Delete');
        INSERT INTO map04_entitlements_v04 
        VALUES(172,416,'Customer - Customers - Edit - Customer Contact - Reject');
        INSERT INTO map04_entitlements_v04 
        VALUES(172,415,'Customer - Customers - Edit - Customer Contact - Restore');
        INSERT INTO map04_entitlements_v04 
        VALUES(1586,461,'Customer - Customers - Edit - Margin Trading ');
        INSERT INTO map04_entitlements_v04 
        VALUES(1588,462,'Customer - Customers - Edit - Margin Trading - Add');
        INSERT INTO map04_entitlements_v04 
        VALUES(1587,464,'Customer - Customers - Edit - Margin Trading - Approve');
        INSERT INTO map04_entitlements_v04 
        VALUES(1587,468,'Customer - Customers - Edit - Margin Trading - Delete');
        INSERT INTO map04_entitlements_v04 
        VALUES(1587,463,'Customer - Customers - Edit - Margin Trading - Edit');
        INSERT INTO map04_entitlements_v04 
        VALUES(1587,469,'Customer - Customers - Edit - Margin Trading - Grant');
        INSERT INTO map04_entitlements_v04 
        VALUES(1587,467,'Customer - Customers - Edit - Margin Trading - Mark For Delete');
        INSERT INTO map04_entitlements_v04 
        VALUES(1587,466,'Customer - Customers - Edit - Margin Trading - Reject');
        INSERT INTO map04_entitlements_v04 
        VALUES(1587,465,'Customer - Customers - Edit - Margin Trading - Restore');
        INSERT INTO map04_entitlements_v04 
        VALUES(255,441,'Customer - Customers - Edit - Trading Accounts ');
        INSERT INTO map04_entitlements_v04 
        VALUES(9,442,'Customer - Customers - Edit - Trading Accounts - Add');
        INSERT INTO map04_entitlements_v04 
        VALUES(256,444,'Customer - Customers - Edit - Trading Accounts - Approve');
        INSERT INTO map04_entitlements_v04 
        VALUES(256,448,'Customer - Customers - Edit - Trading Accounts - Delete');
        INSERT INTO map04_entitlements_v04 
        VALUES(36,443,'Customer - Customers - Edit - Trading Accounts - Edit');
        INSERT INTO map04_entitlements_v04 
        VALUES(255,449,'Customer - Customers - Edit - Trading Accounts - Grant');
        INSERT INTO map04_entitlements_v04 
        VALUES(255,447,'Customer - Customers - Edit - Trading Accounts - Mark For Delete');
        INSERT INTO map04_entitlements_v04 
        VALUES(256,446,'Customer - Customers - Edit - Trading Accounts - Reject');
        INSERT INTO map04_entitlements_v04 
        VALUES(256,445,'Customer - Customers - Edit - Trading Accounts - Restore');
        INSERT INTO map04_entitlements_v04 
        VALUES(1645,450,'Customer - Customers - Edit - Trading Accounts - Restrictions');
        INSERT INTO map04_entitlements_v04 
        VALUES(270,405,'Customer - Customers - Mark For Delete');
        INSERT INTO map04_entitlements_v04 
        VALUES(197,523,'Customer - Customers - Power of Attorney');
        INSERT INTO map04_entitlements_v04 
        VALUES(365,1125,'Common - Allow All Institution View');
        INSERT INTO map04_entitlements_v04 
        VALUES(269,404,'Customer - Customers - Reject');
        INSERT INTO map04_entitlements_v04 
        VALUES(269,403,'Customer - Customers - Restore ');
        INSERT INTO map04_entitlements_v04 
        VALUES(329,525,'Customer - Customers - Trading Restriction - Trading Channel Restriction - Save');
        INSERT INTO map04_entitlements_v04 
        VALUES(329,527,'Customer - Customers - Trading Restriction - Trading Instrument Type Restriction - Save');
        INSERT INTO map04_entitlements_v04 
        VALUES(329,526,'Customer - Customers - Trading Restriction - Trading Symbol Restriction - Save');
        INSERT INTO map04_entitlements_v04 
        VALUES(11,483,'Customer - Customers -View');
        INSERT INTO map04_entitlements_v04 
        VALUES(1418,273,'Customer - Inactive or Dormant Cash Accounts');
        INSERT INTO map04_entitlements_v04 
        VALUES(1427,241,'Customer - SMS and Email Notification');
        INSERT INTO map04_entitlements_v04 
        VALUES(1427,242,'Customer - SMS and Email Notification - Send');
        INSERT INTO map04_entitlements_v04 
        VALUES(35,295,'Customer - Trading Accounts');
        INSERT INTO map04_entitlements_v04 
        VALUES(297,191,'Customer - Trading Groups');
        INSERT INTO map04_entitlements_v04 
        VALUES(411,192,'Customer - Trading Groups - Add');
        INSERT INTO map04_entitlements_v04 
        VALUES(412,195,'Customer - Trading Groups - Approve');
        INSERT INTO map04_entitlements_v04 
        VALUES(412,199,'Customer - Trading Groups - Delete');
        INSERT INTO map04_entitlements_v04 
        VALUES(411,193,'Customer - Trading Groups - Edit');
        INSERT INTO map04_entitlements_v04 
        VALUES(411,200,'Customer - Trading Groups - Grant');
        INSERT INTO map04_entitlements_v04 
        VALUES(411,197,'Customer - Trading Groups - Mark For Delete');
        INSERT INTO map04_entitlements_v04 
        VALUES(412,196,'Customer - Trading Groups - Reject');
        INSERT INTO map04_entitlements_v04 
        VALUES(412,198,'Customer - Trading Groups - Restore');
        INSERT INTO map04_entitlements_v04 
        VALUES(297,194,'Customer - Trading Groups - View');
        INSERT INTO map04_entitlements_v04 
        VALUES(2026,904,'Customer-KYC Details - KYC Annual Review - Add');
        INSERT INTO map04_entitlements_v04 
        VALUES(2027,912,'Customer-KYC Details - KYC Annual Review - Approvals');
        INSERT INTO map04_entitlements_v04 
        VALUES(2027,906,'Customer-KYC Details - KYC Annual Review - Approve');
        INSERT INTO map04_entitlements_v04 
        VALUES(2027,909,'Customer-KYC Details - KYC Annual Review - Delete');
        INSERT INTO map04_entitlements_v04 
        VALUES(2026,905,'Customer-KYC Details - KYC Annual Review - Edit');
        INSERT INTO map04_entitlements_v04 
        VALUES(2026,911,'Customer-KYC Details - KYC Annual Review - Grant');
        INSERT INTO map04_entitlements_v04 
        VALUES(2026,908,'Customer-KYC Details - KYC Annual Review - Mark For Delete');
        INSERT INTO map04_entitlements_v04 
        VALUES(2029,907,'Customer-KYC Details - KYC Annual Review - Reject');
        INSERT INTO map04_entitlements_v04 
        VALUES(2027,910,'Customer-KYC Details - KYC Annual Review - Restore');
        INSERT INTO map04_entitlements_v04 
        VALUES(1808,982,'Customers - Account Closure - Approve Request');
        INSERT INTO map04_entitlements_v04 
        VALUES(1807,981,'Customers - Account Closure - Close Trading Account');
        INSERT INTO map04_entitlements_v04 
        VALUES(1813,983,'Customers - Account Closure - Reject Request');
        INSERT INTO map04_entitlements_v04 
        VALUES(1521,901,'Customers - Customers - Customer Summary - Accrued Interest Adjustment - Add');
        INSERT INTO map04_entitlements_v04 
        VALUES(1457,902,'Customers - Customers - Customer Summary - Accrued Interest Adjustment - Approve');
        INSERT INTO map04_entitlements_v04 
        VALUES(1521,903,'Customers - Customers - Customer Summary - Accrued Interest Adjustment - Reject');
        INSERT INTO map04_entitlements_v04 
        VALUES(1972,1151,'DT-Allow Desk Orders Only ');
        INSERT INTO map04_entitlements_v04 
        VALUES(1289,1136,'DT-Allow Own Orders Only ');
        INSERT INTO map04_entitlements_v04 
        VALUES(3999,1154,'DT-Allow Pro Rata MBO List ');
        INSERT INTO map04_entitlements_v04 
        VALUES(2001,1152,'DT-Allow SWAP Trade ');
        INSERT INTO map04_entitlements_v04 
        VALUES(1571,1140,'DT-Approve Waiting For Approval Order ');
        INSERT INTO map04_entitlements_v04 
        VALUES(1958,1150,'DT-Broker Commission Override ');
        INSERT INTO map04_entitlements_v04 
        VALUES(1631,1142,'DT-Bulk Order Cancel ');
        INSERT INTO map04_entitlements_v04 
        VALUES(1569,1139,'DT-Exceed Buying Power ');
        INSERT INTO map04_entitlements_v04 
        VALUES(1763,1144,'DT-Margin Trading ');
        INSERT INTO map04_entitlements_v04 
        VALUES(1182,1132,'DT-Order Service ');
        INSERT INTO map04_entitlements_v04 
        VALUES(1572,1141,'DT-Reject Waiting For Approval Order ');
        INSERT INTO map04_entitlements_v04 
        VALUES(13,1117,'DT-Trading');
        INSERT INTO map04_entitlements_v04 
        VALUES(1267,1134,'DT-View All Orders ');
        INSERT INTO map04_entitlements_v04 
        VALUES(84,1302,'Finance');
        INSERT INTO map04_entitlements_v04 
        VALUES(144,670,'Finance - Brokerage Bank Accounts');
        INSERT INTO map04_entitlements_v04 
        VALUES(144,671,'Finance - Brokerage Bank Accounts - Brokerage Bank Accounts');
        INSERT INTO map04_entitlements_v04 
        VALUES(471,673,'Finance - Brokerage Bank Accounts - Brokerage Bank Accounts - Add');
        INSERT INTO map04_entitlements_v04 
        VALUES(472,676,'Finance - Brokerage Bank Accounts - Brokerage Bank Accounts - Approve');
        INSERT INTO map04_entitlements_v04 
        VALUES(1095,678,'Finance - Brokerage Bank Accounts - Brokerage Bank Accounts - Cash Statement');
        INSERT INTO map04_entitlements_v04 
        VALUES(144,682,'Finance - Brokerage Bank Accounts - Brokerage Bank Accounts - Copy Current Cell');
        INSERT INTO map04_entitlements_v04 
        VALUES(472,680,'Finance - Brokerage Bank Accounts - Brokerage Bank Accounts - Delete');
        INSERT INTO map04_entitlements_v04 
        VALUES(471,674,'Finance - Brokerage Bank Accounts - Brokerage Bank Accounts - Edit');
        INSERT INTO map04_entitlements_v04 
        VALUES(144,684,'Finance - Brokerage Bank Accounts - Brokerage Bank Accounts - Freeze Row');
        INSERT INTO map04_entitlements_v04 
        VALUES(471,683,'Finance - Brokerage Bank Accounts - Brokerage Bank Accounts - Grant');
        INSERT INTO map04_entitlements_v04 
        VALUES(471,679,'Finance - Brokerage Bank Accounts - Brokerage Bank Accounts - Mark for Delete');
        INSERT INTO map04_entitlements_v04 
        VALUES(472,677,'Finance - Brokerage Bank Accounts - Brokerage Bank Accounts - Reject');
        INSERT INTO map04_entitlements_v04 
        VALUES(472,681,'Finance - Brokerage Bank Accounts - Brokerage Bank Accounts - Restore');
        INSERT INTO map04_entitlements_v04 
        VALUES(1447,672,'Finance - Brokerage Bank Accounts - Brokerage Bank Accounts - Set To Default');
        INSERT INTO map04_entitlements_v04 
        VALUES(144,675,'Finance - Brokerage Bank Accounts - Brokerage Bank Accounts - View');
        INSERT INTO map04_entitlements_v04 
        VALUES(98,300,'Finance - Cash Management');
        INSERT INTO map04_entitlements_v04 
        VALUES(528,301,'Finance - Cash Management - Cash Requests');
        INSERT INTO map04_entitlements_v04 
        VALUES(115,301,'Finance - Cash Management - Cash Requests');
        INSERT INTO map04_entitlements_v04 
        VALUES(166,305,'Finance - Cash Management - Cash Requests - Bulk Approve');
        INSERT INTO map04_entitlements_v04 
        VALUES(167,305,'Finance - Cash Management - Cash Requests - Bulk Approve');
        INSERT INTO map04_entitlements_v04 
        VALUES(1037,306,'Finance - Cash Management - Cash Requests - Cancel');
        INSERT INTO map04_entitlements_v04 
        VALUES(528,309,'Finance - Cash Management - Cash Requests - Copy Current Cell');
        INSERT INTO map04_entitlements_v04 
        VALUES(528,310,'Finance - Cash Management - Cash Requests - Freeze Row');
        INSERT INTO map04_entitlements_v04 
        VALUES(54,302,'Finance - Cash Management - Cash Requests - Level 1 Approve');
        INSERT INTO map04_entitlements_v04 
        VALUES(1175,303,'Finance - Cash Management - Cash Requests - Level 2 Approve');
        INSERT INTO map04_entitlements_v04 
        VALUES(1188,303,'Finance - Cash Management - Cash Requests - Level 2 Approve');
        INSERT INTO map04_entitlements_v04 
        VALUES(55,303,'Finance - Cash Management - Cash Requests - Level 2 Approve');
        INSERT INTO map04_entitlements_v04 
        VALUES(528,304,'Finance - Cash Management - Cash Requests - View Transaction');
        INSERT INTO map04_entitlements_v04 
        VALUES(1503,330,'Finance - Cash Management - Scheduled Cash Blocks');
        INSERT INTO map04_entitlements_v04 
        VALUES(1503,331,'Finance - Cash Management - Scheduled Cash Blocks - Cash Blocks');
        INSERT INTO map04_entitlements_v04 
        VALUES(1502,332,'Finance - Cash Management - Scheduled Cash Blocks - Cash Blocks - Level 1 Approve');
        INSERT INTO map04_entitlements_v04 
        VALUES(1502,337,'Finance - Cash Management - Scheduled Cash Blocks - Cash Blocks - Level 1 Delete');
        INSERT INTO map04_entitlements_v04 
        VALUES(1502,333,'Finance - Cash Management - Scheduled Cash Blocks - Cash Blocks - Level 2 Approve');
        INSERT INTO map04_entitlements_v04 
        VALUES(1502,338,'Finance - Cash Management - Scheduled Cash Blocks - Cash Blocks - Level 2 Delete');
        INSERT INTO map04_entitlements_v04 
        VALUES(1502,334,'Finance - Cash Management - Scheduled Cash Blocks - Cash Blocks - Level 3 Approve');
        INSERT INTO map04_entitlements_v04 
        VALUES(1502,339,'Finance - Cash Management - Scheduled Cash Blocks - Cash Blocks - Level 3 Delete');
        INSERT INTO map04_entitlements_v04 
        VALUES(1502,335,'Finance - Cash Management - Scheduled Cash Blocks - Cash Blocks - Reject');
        INSERT INTO map04_entitlements_v04 
        VALUES(1501,336,'Finance - Cash Management - Scheduled Cash Blocks - Cash Blocks - Request for Delete');
        INSERT INTO map04_entitlements_v04 
        VALUES(1503,341,'Finance - Cash Management - Scheduled Cash Blocks - Transfer Blocks');
        INSERT INTO map04_entitlements_v04 
        VALUES(1502,342,'Finance - Cash Management - Scheduled Cash Blocks - Transfer Blocks - Level 1 Approve');
        INSERT INTO map04_entitlements_v04 
        VALUES(1502,347,'Finance - Cash Management - Scheduled Cash Blocks - Transfer Blocks - Level 1 Delete');
        INSERT INTO map04_entitlements_v04 
        VALUES(1502,343,'Finance - Cash Management - Scheduled Cash Blocks - Transfer Blocks - Level 2 Approve');
        INSERT INTO map04_entitlements_v04 
        VALUES(1502,348,'Finance - Cash Management - Scheduled Cash Blocks - Transfer Blocks - Level 2 Delete');
        INSERT INTO map04_entitlements_v04 
        VALUES(1502,344,'Finance - Cash Management - Scheduled Cash Blocks - Transfer Blocks - Level 3 Approve');
        INSERT INTO map04_entitlements_v04 
        VALUES(1502,349,'Finance - Cash Management - Scheduled Cash Blocks - Transfer Blocks - Level 3 Delete');
        INSERT INTO map04_entitlements_v04 
        VALUES(1502,345,'Finance - Cash Management - Scheduled Cash Blocks - Transfer Blocks - Reject');
        INSERT INTO map04_entitlements_v04 
        VALUES(1501,346,'Finance - Cash Management - Scheduled Cash Blocks - Transfer Blocks - Request for Delete');
        INSERT INTO map04_entitlements_v04 
        VALUES(1966,941,'Finance - Charges Group');
        INSERT INTO map04_entitlements_v04 
        VALUES(1967,942,'Finance - Charges Group - Add');
        INSERT INTO map04_entitlements_v04 
        VALUES(1968,944,'Finance - Charges Group - Approve');
        INSERT INTO map04_entitlements_v04 
        VALUES(1968,948,'Finance - Charges Group - Delete');
        INSERT INTO map04_entitlements_v04 
        VALUES(1967,943,'Finance - Charges Group - Edit');
        INSERT INTO map04_entitlements_v04 
        VALUES(1967,949,'Finance - Charges Group - Grant');
        INSERT INTO map04_entitlements_v04 
        VALUES(1967,947,'Finance - Charges Group - Mark For Delete');
        INSERT INTO map04_entitlements_v04 
        VALUES(1968,946,'Finance - Charges Group - Reject');
        INSERT INTO map04_entitlements_v04 
        VALUES(1968,945,'Finance - Charges Group - Restore');
        INSERT INTO map04_entitlements_v04 
        VALUES(41,524,'Customer - Customers - Trading Restriction');
        INSERT INTO map04_entitlements_v04 
        VALUES(1968,950,'Finance - Charges Group - Set as Default');
        INSERT INTO map04_entitlements_v04 
        VALUES(1563,720,'Finance - Commission Discount Groups');
        INSERT INTO map04_entitlements_v04 
        VALUES(1563,721,'Finance - Commission Discount Groups - Commission Discount Groups');
        INSERT INTO map04_entitlements_v04 
        VALUES(1565,722,'Finance - Commission Discount Groups - Commission Discount Groups - Add');
        INSERT INTO map04_entitlements_v04 
        VALUES(1564,727,'Finance - Commission Discount Groups - Commission Discount Groups - Approvals');
        INSERT INTO map04_entitlements_v04 
        VALUES(1564,725,'Finance - Commission Discount Groups - Commission Discount Groups - Approve');
        INSERT INTO map04_entitlements_v04 
        VALUES(1563,732,'Finance - Commission Discount Groups - Commission Discount Groups - Copy Current Cell');
        INSERT INTO map04_entitlements_v04 
        VALUES(1564,729,'Finance - Commission Discount Groups - Commission Discount Groups - Delete');
        INSERT INTO map04_entitlements_v04 
        VALUES(1565,723,'Finance - Commission Discount Groups - Commission Discount Groups - Edit');
        INSERT INTO map04_entitlements_v04 
        VALUES(1563,733,'Finance - Commission Discount Groups - Commission Discount Groups - Freeze Row');
        INSERT INTO map04_entitlements_v04 
        VALUES(1565,730,'Finance - Commission Discount Groups - Commission Discount Groups - Grant');
        INSERT INTO map04_entitlements_v04 
        VALUES(1565,728,'Finance - Commission Discount Groups - Commission Discount Groups - Mark for Delete');
        INSERT INTO map04_entitlements_v04 
        VALUES(1564,726,'Finance - Commission Discount Groups - Commission Discount Groups - Reject');
        INSERT INTO map04_entitlements_v04 
        VALUES(1564,731,'Finance - Commission Discount Groups - Commission Discount Groups - Restore');
        INSERT INTO map04_entitlements_v04 
        VALUES(1563,724,'Finance - Commission Discount Groups - Commission Discount Groups - View');
        INSERT INTO map04_entitlements_v04 
        VALUES(1566,741,'Finance - Commission Discount Groups - Commission Discount Groups Bulk Assign');
        INSERT INTO map04_entitlements_v04 
        VALUES(1659,751,'Finance - Commission Discount Groups - Discount Segments');
        INSERT INTO map04_entitlements_v04 
        VALUES(262,690,'Finance - Commission Groups');
        INSERT INTO map04_entitlements_v04 
        VALUES(262,691,'Finance - Commission Groups - Commission Groups');
        INSERT INTO map04_entitlements_v04 
        VALUES(264,692,'Finance - Commission Groups - Commission Groups - Add');
        INSERT INTO map04_entitlements_v04 
        VALUES(263,697,'Finance - Commission Groups - Commission Groups - Approvals');
        INSERT INTO map04_entitlements_v04 
        VALUES(263,695,'Finance - Commission Groups - Commission Groups - Approve');
        INSERT INTO map04_entitlements_v04 
        VALUES(263,699,'Finance - Commission Groups - Commission Groups - Delete');
        INSERT INTO map04_entitlements_v04 
        VALUES(264,693,'Finance - Commission Groups - Commission Groups - Edit');
        INSERT INTO map04_entitlements_v04 
        VALUES(264,700,'Finance - Commission Groups - Commission Groups - Grant');
        INSERT INTO map04_entitlements_v04 
        VALUES(264,698,'Finance - Commission Groups - Commission Groups - Mark for Delete');
        INSERT INTO map04_entitlements_v04 
        VALUES(263,696,'Finance - Commission Groups - Commission Groups - Reject');
        INSERT INTO map04_entitlements_v04 
        VALUES(263,701,'Finance - Commission Groups - Commission Groups - Restore');
        INSERT INTO map04_entitlements_v04 
        VALUES(263,702,'Finance - Commission Groups - Commission Groups - Set to Default');
        INSERT INTO map04_entitlements_v04 
        VALUES(262,694,'Finance - Commission Groups - Commission Groups - View');
        INSERT INTO map04_entitlements_v04 
        VALUES(1567,711,'Finance - Commission Groups - Commission Groups Bulk Assign');
        INSERT INTO map04_entitlements_v04 
        VALUES(191,1220,'Finance - Corporate Actions');
        INSERT INTO map04_entitlements_v04 
        VALUES(194,1225,'Finance - Corporate Actions - Local Files');
        INSERT INTO map04_entitlements_v04 
        VALUES(194,1222,'Finance - Corporate Actions - Local Files - Process');
        INSERT INTO map04_entitlements_v04 
        VALUES(1419,1226,'Finance - Corporate Actions - Local Files - Requests');
        INSERT INTO map04_entitlements_v04 
        VALUES(1986,1226,'Finance - Corporate Actions - Local Files - Requests');
        INSERT INTO map04_entitlements_v04 
        VALUES(1422,1223,'Finance - Corporate Actions - Local Files - Requests - Approve');
        INSERT INTO map04_entitlements_v04 
        VALUES(1420,1223,'Finance - Corporate Actions - Local Files - Requests - Approve');
        INSERT INTO map04_entitlements_v04 
        VALUES(1421,1223,'Finance - Corporate Actions - Local Files - Requests - Approve');
        INSERT INTO map04_entitlements_v04 
        VALUES(1991,1223,'Finance - Corporate Actions - Local Files - Requests - Approve');
        INSERT INTO map04_entitlements_v04 
        VALUES(1992,1223,'Finance - Corporate Actions - Local Files - Requests - Approve');
        INSERT INTO map04_entitlements_v04 
        VALUES(1993,1223,'Finance - Corporate Actions - Local Files - Requests - Reject');
        INSERT INTO map04_entitlements_v04 
        VALUES(194,1221,'Finance - Corporate Actions - Local Files - Upload File');
        INSERT INTO map04_entitlements_v04 
        VALUES(475,361,'Finance - Currency Rates');
        INSERT INTO map04_entitlements_v04 
        VALUES(476,362,'Finance - Currency Rates - Add');
        INSERT INTO map04_entitlements_v04 
        VALUES(592,366,'Finance - Currency Rates - Approve');
        INSERT INTO map04_entitlements_v04 
        VALUES(592,369,'Finance - Currency Rates - Delete');
        INSERT INTO map04_entitlements_v04 
        VALUES(476,363,'Finance - Currency Rates - Edit');
        INSERT INTO map04_entitlements_v04 
        VALUES(476,370,'Finance - Currency Rates - Grant');
        INSERT INTO map04_entitlements_v04 
        VALUES(476,368,'Finance - Currency Rates - Mark for Delete');
        INSERT INTO map04_entitlements_v04 
        VALUES(592,367,'Finance - Currency Rates - Reject');
        INSERT INTO map04_entitlements_v04 
        VALUES(592,371,'Finance - Currency Rates - Restore');
        INSERT INTO map04_entitlements_v04 
        VALUES(1479,365,'Finance - Currency Rates - Upload CSV file');
        INSERT INTO map04_entitlements_v04 
        VALUES(475,364,'Finance - Currency Rates - View');
        INSERT INTO map04_entitlements_v04 
        VALUES(310,1378,'Finance - Margin Trading');
        INSERT INTO map04_entitlements_v04 
        VALUES(1589,651,'Finance - Margin Trading - Customer Margin Requests');
        INSERT INTO map04_entitlements_v04 
        VALUES(1590,652,'Finance - Margin Trading - Customer Margin Requests - Level 1 Approve');
        INSERT INTO map04_entitlements_v04 
        VALUES(1591,653,'Finance - Margin Trading - Customer Margin Requests - Level 2 Approve');
        INSERT INTO map04_entitlements_v04 
        VALUES(1592,654,'Finance - Margin Trading - Customer Margin Requests - Reject');
        INSERT INTO map04_entitlements_v04 
        VALUES(312,571,'Finance - Margin Trading - Margin Interest Groups');
        INSERT INTO map04_entitlements_v04 
        VALUES(313,572,'Finance - Margin Trading - Margin Interest Groups - Add');
        INSERT INTO map04_entitlements_v04 
        VALUES(314,581,'Finance - Margin Trading - Margin Interest Groups - Approvals');
        INSERT INTO map04_entitlements_v04 
        VALUES(314,575,'Finance - Margin Trading - Margin Interest Groups - Approve');
        INSERT INTO map04_entitlements_v04 
        VALUES(314,578,'Finance - Margin Trading - Margin Interest Groups - Delete');
        INSERT INTO map04_entitlements_v04 
        VALUES(313,573,'Finance - Margin Trading - Margin Interest Groups - Edit');
        INSERT INTO map04_entitlements_v04 
        VALUES(313,579,'Finance - Margin Trading - Margin Interest Groups - Grant');
        INSERT INTO map04_entitlements_v04 
        VALUES(313,577,'Finance - Margin Trading - Margin Interest Groups - Mark for Delete');
        INSERT INTO map04_entitlements_v04 
        VALUES(314,576,'Finance - Margin Trading - Margin Interest Groups - Reject');
        INSERT INTO map04_entitlements_v04 
        VALUES(314,580,'Finance - Margin Trading - Margin Interest Groups - Restore');
        INSERT INTO map04_entitlements_v04 
        VALUES(312,574,'Finance - Margin Trading - Margin Interest Groups - View');
        INSERT INTO map04_entitlements_v04 
        VALUES(311,551,'Finance - Margin Trading - Margin Product');
        INSERT INTO map04_entitlements_v04 
        VALUES(1578,552,'Finance - Margin Trading - Margin Product - Add');
        INSERT INTO map04_entitlements_v04 
        VALUES(1579,561,'Finance - Margin Trading - Margin Product - Approvals');
        INSERT INTO map04_entitlements_v04 
        VALUES(1579,555,'Finance - Margin Trading - Margin Product - Approve');
        INSERT INTO map04_entitlements_v04 
        VALUES(1578,558,'Finance - Margin Trading - Margin Product - Delete');
        INSERT INTO map04_entitlements_v04 
        VALUES(1578,553,'Finance - Margin Trading - Margin Product - Edit');
        INSERT INTO map04_entitlements_v04 
        VALUES(1578,559,'Finance - Margin Trading - Margin Product - Grant');
        INSERT INTO map04_entitlements_v04 
        VALUES(1578,557,'Finance - Margin Trading - Margin Product - Mark for Delete');
        INSERT INTO map04_entitlements_v04 
        VALUES(1579,556,'Finance - Margin Trading - Margin Product - Reject');
        INSERT INTO map04_entitlements_v04 
        VALUES(1579,560,'Finance - Margin Trading - Margin Product - Restore');
        INSERT INTO map04_entitlements_v04 
        VALUES(311,554,'Finance - Margin Trading - Margin Product - View');
        INSERT INTO map04_entitlements_v04 
        VALUES(1108,610,'Finance - Margin Trading - Symbol Marginability Change Requests');
        INSERT INTO map04_entitlements_v04 
        VALUES(1111,613,'Finance - Margin Trading - Symbol Marginability Change Requests - All');
        INSERT INTO map04_entitlements_v04 
        VALUES(1112,621,'Finance - Margin Trading - Symbol Marginability Change Requests - Approve');
        INSERT INTO map04_entitlements_v04 
        VALUES(1110,612,'Finance - Margin Trading - Symbol Marginability Change Requests - Approved');
        INSERT INTO map04_entitlements_v04 
        VALUES(1109,611,'Finance - Margin Trading - Symbol Marginability Change Requests - Pending');
        INSERT INTO map04_entitlements_v04 
        VALUES(1113,622,'Finance - Margin Trading - Symbol Marginability Change Requests - Reject');
        INSERT INTO map04_entitlements_v04 
        VALUES(318,591,'Finance - Margin Trading - Symbol Marginability Groups');
        INSERT INTO map04_entitlements_v04 
        VALUES(319,592,'Finance - Margin Trading - Symbol Marginability Groups - Add');
        INSERT INTO map04_entitlements_v04 
        VALUES(320,597,'Finance - Margin Trading - Symbol Marginability Groups - Approve');
        INSERT INTO map04_entitlements_v04 
        VALUES(320,600,'Finance - Margin Trading - Symbol Marginability Groups - Delete');
        INSERT INTO map04_entitlements_v04 
        VALUES(319,593,'Finance - Margin Trading - Symbol Marginability Groups - Edit');
        INSERT INTO map04_entitlements_v04 
        VALUES(319,601,'Finance - Margin Trading - Symbol Marginability Groups - Grant');
        INSERT INTO map04_entitlements_v04 
        VALUES(319,599,'Finance - Margin Trading - Symbol Marginability Groups - Mark for Delete');
        INSERT INTO map04_entitlements_v04 
        VALUES(320,598,'Finance - Margin Trading - Symbol Marginability Groups - Reject');
        INSERT INTO map04_entitlements_v04 
        VALUES(318,596,'Finance - Margin Trading - Symbol Marginability Groups - Report');
        INSERT INTO map04_entitlements_v04 
        VALUES(320,602,'Finance - Margin Trading - Symbol Marginability Groups - Restore');
        INSERT INTO map04_entitlements_v04 
        VALUES(320,595,'Finance - Margin Trading - Symbol Marginability Groups - Set to Default');
        INSERT INTO map04_entitlements_v04 
        VALUES(318,594,'Finance - Margin Trading - Symbol Marginability Groups - View');
        INSERT INTO map04_entitlements_v04 
        VALUES(142,760,'Finance - OD Withdraw Limit Requests');
        INSERT INTO map04_entitlements_v04 
        VALUES(142,763,'Finance - OD Withdraw Limit Requests - All');
        INSERT INTO map04_entitlements_v04 
        VALUES(142,762,'Finance - OD Withdraw Limit Requests - Approved');
        INSERT INTO map04_entitlements_v04 
        VALUES(145,771,'Finance - OD Withdraw Limit Requests - Level 1 Approve');
        INSERT INTO map04_entitlements_v04 
        VALUES(146,1416,'Finance - OD Withdraw Limit Requests - Level 10 Approve');
        INSERT INTO map04_entitlements_v04 
        VALUES(146,772,'Finance - OD Withdraw Limit Requests - Level 2 Approve');
        INSERT INTO map04_entitlements_v04 
        VALUES(146,773,'Finance - OD Withdraw Limit Requests - Level 3 Approve');
        INSERT INTO map04_entitlements_v04 
        VALUES(146,1410,'Finance - OD Withdraw Limit Requests - Level 4 Approve');
        INSERT INTO map04_entitlements_v04 
        VALUES(146,1411,'Finance - OD Withdraw Limit Requests - Level 5 Approve');
        INSERT INTO map04_entitlements_v04 
        VALUES(146,1412,'Finance - OD Withdraw Limit Requests - Level 6 Approve');
        INSERT INTO map04_entitlements_v04 
        VALUES(146,1413,'Finance - OD Withdraw Limit Requests - Level 7 Approve');
        INSERT INTO map04_entitlements_v04 
        VALUES(146,1414,'Finance - OD Withdraw Limit Requests - Level 8 Approve');
        INSERT INTO map04_entitlements_v04 
        VALUES(146,1415,'Finance - OD Withdraw Limit Requests - Level 9 Approve');
        INSERT INTO map04_entitlements_v04 
        VALUES(142,761,'Finance - OD Withdraw Limit Requests - Pending');
        INSERT INTO map04_entitlements_v04 
        VALUES(147,774,'Finance - OD Withdraw Limit Requests - Reject');
        INSERT INTO map04_entitlements_v04 
        VALUES(233,1301,'Holding');
        INSERT INTO map04_entitlements_v04 
        VALUES(143,1309,'Holding - Pledge Requests');
        INSERT INTO map04_entitlements_v04 
        VALUES(524,1307,'Holding - Stock Holding Transaction');
        INSERT INTO map04_entitlements_v04 
        VALUES(235,1308,'Holding - Stock Holding Transaction - Stock Transaction');
        INSERT INTO map04_entitlements_v04 
        VALUES(525,1127,'Holdings - Portfolio');
        INSERT INTO map04_entitlements_v04 
        VALUES(132,1305,'Master Data');
        INSERT INTO map04_entitlements_v04 
        VALUES(227,91,'Master Data - Countries');
        INSERT INTO map04_entitlements_v04 
        VALUES(399,92,'Master Data - Countries - Add');
        INSERT INTO map04_entitlements_v04 
        VALUES(400,100,'Master Data - Countries - Approvals');
        INSERT INTO map04_entitlements_v04 
        VALUES(400,94,'Master Data - Countries - Approve');
        INSERT INTO map04_entitlements_v04 
        VALUES(400,98,'Master Data - Countries - Delete');
        INSERT INTO map04_entitlements_v04 
        VALUES(399,93,'Master Data - Countries - Edit');
        INSERT INTO map04_entitlements_v04 
        VALUES(227,1381,'Master Data - Countries - Edit - Cities');
        INSERT INTO map04_entitlements_v04 
        VALUES(399,1382,'Master Data - Countries - Edit - Cities - Add');
        INSERT INTO map04_entitlements_v04 
        VALUES(400,1390,'Master Data - Countries - Edit - Cities - Approvals');
        INSERT INTO map04_entitlements_v04 
        VALUES(400,1384,'Master Data - Countries - Edit - Cities - Approve');
        INSERT INTO map04_entitlements_v04 
        VALUES(400,1387,'Master Data - Countries - Edit - Cities - Delete');
        INSERT INTO map04_entitlements_v04 
        VALUES(399,1383,'Master Data - Countries - Edit - Cities - Edit');
        INSERT INTO map04_entitlements_v04 
        VALUES(399,1389,'Master Data - Countries - Edit - Cities - Grant');
        INSERT INTO map04_entitlements_v04 
        VALUES(399,1386,'Master Data - Countries - Edit - Cities - Mark for Delete');
        INSERT INTO map04_entitlements_v04 
        VALUES(400,1385,'Master Data - Countries - Edit - Cities - Reject');
        INSERT INTO map04_entitlements_v04 
        VALUES(400,1388,'Master Data - Countries - Edit - Cities - Restore');
        INSERT INTO map04_entitlements_v04 
        VALUES(399,99,'Master Data - Countries - Grant');
        INSERT INTO map04_entitlements_v04 
        VALUES(399,97,'Master Data - Countries - Mark For Delete');
        INSERT INTO map04_entitlements_v04 
        VALUES(400,96,'Master Data - Countries - Reject');
        INSERT INTO map04_entitlements_v04 
        VALUES(400,95,'Master Data - Countries - Restore');
        INSERT INTO map04_entitlements_v04 
        VALUES(509,40,'Master Data - Exchange');
        INSERT INTO map04_entitlements_v04 
        VALUES(743,1103,'Master Data - Exchange - Exchange Tick Size');
        INSERT INTO map04_entitlements_v04 
        VALUES(744,1104,'Master Data - Exchange - Exchange Tick Size - Add');
        INSERT INTO map04_entitlements_v04 
        VALUES(745,1112,'Master Data - Exchange - Exchange Tick Size - Approvals');
        INSERT INTO map04_entitlements_v04 
        VALUES(745,1106,'Master Data - Exchange - Exchange Tick Size - Approve');
        INSERT INTO map04_entitlements_v04 
        VALUES(745,1109,'Master Data - Exchange - Exchange Tick Size - Delete');
        INSERT INTO map04_entitlements_v04 
        VALUES(744,1105,'Master Data - Exchange - Exchange Tick Size - Edit');
        INSERT INTO map04_entitlements_v04 
        VALUES(744,1111,'Master Data - Exchange - Exchange Tick Size - Grant');
        INSERT INTO map04_entitlements_v04 
        VALUES(744,1108,'Master Data - Exchange - Exchange Tick Size - Mark for Delete');
        INSERT INTO map04_entitlements_v04 
        VALUES(745,1107,'Master Data - Exchange - Exchange Tick Size - Reject');
        INSERT INTO map04_entitlements_v04 
        VALUES(745,1110,'Master Data - Exchange - Exchange Tick Size - Restore');
        INSERT INTO map04_entitlements_v04 
        VALUES(222,41,'Master Data - Exchange - Exchanges');
        INSERT INTO map04_entitlements_v04 
        VALUES(419,42,'Master Data - Exchange - Exchanges - Add');
        INSERT INTO map04_entitlements_v04 
        VALUES(420,50,'Master Data - Exchange - Exchanges - Approvals');
        INSERT INTO map04_entitlements_v04 
        VALUES(420,44,'Master Data - Exchange - Exchanges - Approve');
        INSERT INTO map04_entitlements_v04 
        VALUES(420,47,'Master Data - Exchange - Exchanges - Delete');
        INSERT INTO map04_entitlements_v04 
        VALUES(419,43,'Master Data - Exchange - Exchanges - Edit');
        INSERT INTO map04_entitlements_v04 
        VALUES(419,49,'Master Data - Exchange - Exchanges - Grant');
        INSERT INTO map04_entitlements_v04 
        VALUES(419,46,'Master Data - Exchange - Exchanges - Mark for Delete');
        INSERT INTO map04_entitlements_v04 
        VALUES(420,45,'Master Data - Exchange - Exchanges - Reject');
        INSERT INTO map04_entitlements_v04 
        VALUES(420,48,'Master Data - Exchange - Exchanges - Restore');
        INSERT INTO map04_entitlements_v04 
        VALUES(385,51,'Master Data - Exchange - Other Brokerages');
        INSERT INTO map04_entitlements_v04 
        VALUES(386,52,'Master Data - Exchange - Other Brokerages - Add');
        INSERT INTO map04_entitlements_v04 
        VALUES(470,60,'Master Data - Exchange - Other Brokerages - Approvals');
        INSERT INTO map04_entitlements_v04 
        VALUES(470,54,'Master Data - Exchange - Other Brokerages - Approve');
        INSERT INTO map04_entitlements_v04 
        VALUES(470,57,'Master Data - Exchange - Other Brokerages - Delete');
        INSERT INTO map04_entitlements_v04 
        VALUES(386,53,'Master Data - Exchange - Other Brokerages - Edit');
        INSERT INTO map04_entitlements_v04 
        VALUES(386,59,'Master Data - Exchange - Other Brokerages - Grant');
        INSERT INTO map04_entitlements_v04 
        VALUES(386,56,'Master Data - Exchange - Other Brokerages - Mark for Delete');
        INSERT INTO map04_entitlements_v04 
        VALUES(470,55,'Master Data - Exchange - Other Brokerages - Reject');
        INSERT INTO map04_entitlements_v04 
        VALUES(470,58,'Master Data - Exchange - Other Brokerages - Restore');
        INSERT INTO map04_entitlements_v04 
        VALUES(683,81,'Master Data - Executing Broker Routing');
        INSERT INTO map04_entitlements_v04 
        VALUES(703,82,'Master Data - Executing Broker Routing - Add');
        INSERT INTO map04_entitlements_v04 
        VALUES(704,90,'Master Data - Executing Broker Routing - Approvals');
        INSERT INTO map04_entitlements_v04 
        VALUES(704,84,'Master Data - Executing Broker Routing - Approve');
        INSERT INTO map04_entitlements_v04 
        VALUES(704,88,'Master Data - Executing Broker Routing - Delete');
        INSERT INTO map04_entitlements_v04 
        VALUES(703,83,'Master Data - Executing Broker Routing - Edit');
        INSERT INTO map04_entitlements_v04 
        VALUES(703,89,'Master Data - Executing Broker Routing - Grant');
        INSERT INTO map04_entitlements_v04 
        VALUES(703,87,'Master Data - Executing Broker Routing - Mark For Delete');
        INSERT INTO map04_entitlements_v04 
        VALUES(704,86,'Master Data - Executing Broker Routing - Reject');
        INSERT INTO map04_entitlements_v04 
        VALUES(704,85,'Master Data - Executing Broker Routing - Restore');
        INSERT INTO map04_entitlements_v04 
        VALUES(683,61,'Master Data - Executing Broker/Custody');
        INSERT INTO map04_entitlements_v04 
        VALUES(703,62,'Master Data - Executing Broker/Custody - Add');
        INSERT INTO map04_entitlements_v04 
        VALUES(704,70,'Master Data - Executing Broker/Custody - Approvals');
        INSERT INTO map04_entitlements_v04 
        VALUES(704,64,'Master Data - Executing Broker/Custody - Approve');
        INSERT INTO map04_entitlements_v04 
        VALUES(704,67,'Master Data - Executing Broker/Custody - Delete');
        INSERT INTO map04_entitlements_v04 
        VALUES(703,63,'Master Data - Executing Broker/Custody - Edit');
        INSERT INTO map04_entitlements_v04 
        VALUES(1953,542,'Master Data - Executing Broker/Custody - Edit - Nostro Account - Add');
        INSERT INTO map04_entitlements_v04 
        VALUES(1951,550,'Master Data - Executing Broker/Custody - Edit - Nostro Account - Approvals');
        INSERT INTO map04_entitlements_v04 
        VALUES(1951,544,'Master Data - Executing Broker/Custody - Edit - Nostro Account - Approve');
        INSERT INTO map04_entitlements_v04 
        VALUES(1952,548,'Master Data - Executing Broker/Custody - Edit - Nostro Account - Delete');
        INSERT INTO map04_entitlements_v04 
        VALUES(1953,543,'Master Data - Executing Broker/Custody - Edit - Nostro Account - Edit');
        INSERT INTO map04_entitlements_v04 
        VALUES(1953,549,'Master Data - Executing Broker/Custody - Edit - Nostro Account - Grant');
        INSERT INTO map04_entitlements_v04 
        VALUES(1952,547,'Master Data - Executing Broker/Custody - Edit - Nostro Account - Mark For Delete');
        INSERT INTO map04_entitlements_v04 
        VALUES(1951,546,'Master Data - Executing Broker/Custody - Edit - Nostro Account - Reject');
        INSERT INTO map04_entitlements_v04 
        VALUES(1953,545,'Master Data - Executing Broker/Custody - Edit - Nostro Account - Restore');
        INSERT INTO map04_entitlements_v04 
        VALUES(703,69,'Master Data - Executing Broker/Custody - Grant');
        INSERT INTO map04_entitlements_v04 
        VALUES(703,66,'Master Data - Executing Broker/Custody - Mark for Delete');
        INSERT INTO map04_entitlements_v04 
        VALUES(704,65,'Master Data - Executing Broker/Custody - Reject');
        INSERT INTO map04_entitlements_v04 
        VALUES(704,68,'Master Data - Executing Broker/Custody - Restore');
        INSERT INTO map04_entitlements_v04 
        VALUES(511,1281,'Master Data - Finance');
        INSERT INTO map04_entitlements_v04 
        VALUES(229,31,'Master Data - Finance - Bank');
        INSERT INTO map04_entitlements_v04 
        VALUES(230,960,'Master Data - Finance - Charges and Refunds');
        INSERT INTO map04_entitlements_v04 
        VALUES(405,961,'Master Data - Finance - Charges and Refunds - Add');
        INSERT INTO map04_entitlements_v04 
        VALUES(406,969,'Master Data - Finance - Charges and Refunds - Approvals');
        INSERT INTO map04_entitlements_v04 
        VALUES(406,963,'Master Data - Finance - Charges and Refunds - Approve');
        INSERT INTO map04_entitlements_v04 
        VALUES(406,966,'Master Data - Finance - Charges and Refunds - Delete');
        INSERT INTO map04_entitlements_v04 
        VALUES(405,962,'Master Data - Finance - Charges and Refunds - Edit');
        INSERT INTO map04_entitlements_v04 
        VALUES(405,964,'Master Data - Finance - Charges and Refunds - Grant');
        INSERT INTO map04_entitlements_v04 
        VALUES(405,965,'Master Data - Finance - Charges and Refunds - Mark For Delete');
        INSERT INTO map04_entitlements_v04 
        VALUES(406,967,'Master Data - Finance - Charges and Refunds - Reject');
        INSERT INTO map04_entitlements_v04 
        VALUES(406,968,'Master Data - Finance - Charges and Refunds - Restore');
        INSERT INTO map04_entitlements_v04 
        VALUES(226,11,'Master Data - Finance - Currency');
        INSERT INTO map04_entitlements_v04 
        VALUES(397,12,'Master Data - Finance - Currency - Add');
        INSERT INTO map04_entitlements_v04 
        VALUES(398,20,'Master Data - Finance - Currency - Approvals');
        INSERT INTO map04_entitlements_v04 
        VALUES(398,14,'Master Data - Finance - Currency - Approve');
        INSERT INTO map04_entitlements_v04 
        VALUES(398,17,'Master Data - Finance - Currency - Delete');
        INSERT INTO map04_entitlements_v04 
        VALUES(397,13,'Master Data - Finance - Currency - Edit');
        INSERT INTO map04_entitlements_v04 
        VALUES(397,19,'Master Data - Finance - Currency - Grant');
        INSERT INTO map04_entitlements_v04 
        VALUES(397,16,'Master Data - Finance - Currency - Mark for Delete');
        INSERT INTO map04_entitlements_v04 
        VALUES(398,15,'Master Data - Finance - Currency - Reject');
        INSERT INTO map04_entitlements_v04 
        VALUES(398,18,'Master Data - Finance - Currency - Restore');
        INSERT INTO map04_entitlements_v04 
        VALUES(1433,21,'Master Data - Finance - Relationship Manager');
        INSERT INTO map04_entitlements_v04 
        VALUES(1434,22,'Master Data - Finance - Relationship Manager - Add');
        INSERT INTO map04_entitlements_v04 
        VALUES(1435,24,'Master Data - Finance - Relationship Manager - Approve');
        INSERT INTO map04_entitlements_v04 
        VALUES(1435,27,'Master Data - Finance - Relationship Manager - Delete');
        INSERT INTO map04_entitlements_v04 
        VALUES(1434,23,'Master Data - Finance - Relationship Manager - Edit');
        INSERT INTO map04_entitlements_v04 
        VALUES(1434,29,'Master Data - Finance - Relationship Manager - Grant');
        INSERT INTO map04_entitlements_v04 
        VALUES(1434,26,'Master Data - Finance - Relationship Manager - Mark for Delete');
        INSERT INTO map04_entitlements_v04 
        VALUES(1435,25,'Master Data - Finance - Relationship Manager - Reject');
        INSERT INTO map04_entitlements_v04 
        VALUES(1435,28,'Master Data - Finance - Relationship Manager - Restore');
        INSERT INTO map04_entitlements_v04 
        VALUES(1435,30,'Master Data - Finance - Relationship Manager- Approvals');
        INSERT INTO map04_entitlements_v04 
        VALUES(228,1400,'Master Data - Finance - Signup Locations');
        INSERT INTO map04_entitlements_v04 
        VALUES(401,1401,'Master Data - Finance - Signup Locations - Add');
        INSERT INTO map04_entitlements_v04 
        VALUES(402,1409,'Master Data - Finance - Signup Locations - Approvals');
        INSERT INTO map04_entitlements_v04 
        VALUES(402,1403,'Master Data - Finance - Signup Locations - Approve');
        INSERT INTO map04_entitlements_v04 
        VALUES(402,1406,'Master Data - Finance - Signup Locations - Delete');
        INSERT INTO map04_entitlements_v04 
        VALUES(401,1402,'Master Data - Finance - Signup Locations - Edit');
        INSERT INTO map04_entitlements_v04 
        VALUES(401,1404,'Master Data - Finance - Signup Locations - Grant');
        INSERT INTO map04_entitlements_v04 
        VALUES(401,1407,'Master Data - Finance - Signup Locations - Mark for Delete');
        INSERT INTO map04_entitlements_v04 
        VALUES(402,1408,'Master Data - Finance - Signup Locations - Reject');
        INSERT INTO map04_entitlements_v04 
        VALUES(402,1405,'Master Data - Finance - Signup Locations - Restore');
        INSERT INTO map04_entitlements_v04 
        VALUES(487,111,'Master Data - Id Issue Locations');
        INSERT INTO map04_entitlements_v04 
        VALUES(488,112,'Master Data - Id Issue Locations - Add');
        INSERT INTO map04_entitlements_v04 
        VALUES(489,120,'Master Data - Id Issue Locations - Approvals');
        INSERT INTO map04_entitlements_v04 
        VALUES(489,114,'Master Data - Id Issue Locations - Approve');
        INSERT INTO map04_entitlements_v04 
        VALUES(489,118,'Master Data - Id Issue Locations - Delete');
        INSERT INTO map04_entitlements_v04 
        VALUES(488,113,'Master Data - Id Issue Locations  Edit');
        INSERT INTO map04_entitlements_v04 
        VALUES(488,119,'Master Data - Id Issue Locations - Grant');
        INSERT INTO map04_entitlements_v04 
        VALUES(488,117,'Master Data - Id Issue Locations - Mark For Delete');
        INSERT INTO map04_entitlements_v04 
        VALUES(489,116,'Master Data - Id Issue Locations - Reject');
        INSERT INTO map04_entitlements_v04 
        VALUES(489,115,'Master Data - Id Issue Locations - Restore');
        INSERT INTO map04_entitlements_v04 
        VALUES(1440,101,'Master Data - Id Types');
        INSERT INTO map04_entitlements_v04 
        VALUES(1441,102,'Master Data - Id Types - Add');
        INSERT INTO map04_entitlements_v04 
        VALUES(1442,110,'Master Data - Id Types - Approvals');
        INSERT INTO map04_entitlements_v04 
        VALUES(1442,104,'Master Data - Id Types - Approve');
        INSERT INTO map04_entitlements_v04 
        VALUES(1442,108,'Master Data - Id Types - Delete');
        INSERT INTO map04_entitlements_v04 
        VALUES(1444,103,'Master Data - Id Types - Edit');
        INSERT INTO map04_entitlements_v04 
        VALUES(1441,109,'Master Data - Id Types - Grant');
        INSERT INTO map04_entitlements_v04 
        VALUES(1441,107,'Master Data - Id Types - Mark For Delete');
        INSERT INTO map04_entitlements_v04 
        VALUES(1442,106,'Master Data - Id Types - Reject');
        INSERT INTO map04_entitlements_v04 
        VALUES(1442,105,'Master Data - Id Types - Restore');
        INSERT INTO map04_entitlements_v04 
        VALUES(225,1291,'Master Data - Instrument Types');
        INSERT INTO map04_entitlements_v04 
        VALUES(414,1211,'Master Data - Instrument Types - Disable Margin');
        INSERT INTO map04_entitlements_v04 
        VALUES(1616,1240,'Master Data - Messages');
        INSERT INTO map04_entitlements_v04 
        VALUES(1616,1241,'Master Data - Messages - Reasons');
        INSERT INTO map04_entitlements_v04 
        VALUES(1617,1242,'Master Data - Messages - Reasons - Add');
        INSERT INTO map04_entitlements_v04 
        VALUES(1618,1250,'Master Data - Messages - Reasons - Approvals');
        INSERT INTO map04_entitlements_v04 
        VALUES(1618,1244,'Master Data - Messages - Reasons - Approve');
        INSERT INTO map04_entitlements_v04 
        VALUES(1618,1247,'Master Data - Messages - Reasons - Delete');
        INSERT INTO map04_entitlements_v04 
        VALUES(1617,1243,'Master Data - Messages - Reasons - Edit');
        INSERT INTO map04_entitlements_v04 
        VALUES(1617,1249,'Master Data - Messages - Reasons - Grant');
        INSERT INTO map04_entitlements_v04 
        VALUES(1617,1246,'Master Data - Messages - Reasons - Mark for Delete');
        INSERT INTO map04_entitlements_v04 
        VALUES(1618,1245,'Master Data - Messages - Reasons - Reject');
        INSERT INTO map04_entitlements_v04 
        VALUES(1618,1248,'Master Data - Messages - Reasons - Restore');
        INSERT INTO map04_entitlements_v04 
        VALUES(171,71,'Master Data - Routing Data');
        INSERT INTO map04_entitlements_v04 
        VALUES(431,72,'Master Data - Routing Data - Add');
        INSERT INTO map04_entitlements_v04 
        VALUES(432,80,'Master Data - Routing Data - Approvals');
        INSERT INTO map04_entitlements_v04 
        VALUES(432,74,'Master Data - Routing Data - Approve');
        INSERT INTO map04_entitlements_v04 
        VALUES(432,77,'Master Data - Routing Data - Delete');
        INSERT INTO map04_entitlements_v04 
        VALUES(431,73,'Master Data - Routing Data - Edit');
        INSERT INTO map04_entitlements_v04 
        VALUES(431,79,'Master Data - Routing Data - Grant');
        INSERT INTO map04_entitlements_v04 
        VALUES(431,76,'Master Data - Routing Data - Mark for Delete');
        INSERT INTO map04_entitlements_v04 
        VALUES(432,75,'Master Data - Routing Data - Reject');
        INSERT INTO map04_entitlements_v04 
        VALUES(432,78,'Master Data - Routing Data - Restore');
        INSERT INTO map04_entitlements_v04 
        VALUES(510,39,'Master Data - Symbols Management');
        INSERT INTO map04_entitlements_v04 
        VALUES(224,1181,'Master Data - Symbols Management - Sectors');
        INSERT INTO map04_entitlements_v04 
        VALUES(415,1182,'Master Data - Symbols Management - Sectors - Add');
        INSERT INTO map04_entitlements_v04 
        VALUES(416,1190,'Master Data - Symbols Management - Sectors - Approvals');
        INSERT INTO map04_entitlements_v04 
        VALUES(416,1184,'Master Data - Symbols Management - Sectors - Approve');
        INSERT INTO map04_entitlements_v04 
        VALUES(416,1188,'Master Data - Symbols Management - Sectors - Delete');
        INSERT INTO map04_entitlements_v04 
        VALUES(415,1183,'Master Data - Symbols Management - Sectors - Edit');
        INSERT INTO map04_entitlements_v04 
        VALUES(415,1189,'Master Data - Symbols Management - Sectors - Grant');
        INSERT INTO map04_entitlements_v04 
        VALUES(415,1187,'Master Data - Symbols Management - Sectors - Mark For Delete');
        INSERT INTO map04_entitlements_v04 
        VALUES(416,1186,'Master Data - Symbols Management - Sectors - Reject');
        INSERT INTO map04_entitlements_v04 
        VALUES(416,1185,'Master Data - Symbols Management - Sectors - Restore');
        INSERT INTO map04_entitlements_v04 
        VALUES(1770,1161,'Master Data - Symbols Management - Sharia Symbol Groups');
        INSERT INTO map04_entitlements_v04 
        VALUES(1754,1162,'Master Data - Symbols Management - Sharia Symbol Groups - Add');
        INSERT INTO map04_entitlements_v04 
        VALUES(1755,1170,'Master Data - Symbols Management - Sharia Symbol Groups - Approvals');
        INSERT INTO map04_entitlements_v04 
        VALUES(1755,1164,'Master Data - Symbols Management - Sharia Symbol Groups - Approve');
        INSERT INTO map04_entitlements_v04 
        VALUES(1755,1167,'Master Data - Symbols Management - Sharia Symbol Groups - Delete');
        INSERT INTO map04_entitlements_v04 
        VALUES(1754,1163,'Master Data - Symbols Management - Sharia Symbol Groups - Edit');
        INSERT INTO map04_entitlements_v04 
        VALUES(1754,1169,'Master Data - Symbols Management - Sharia Symbol Groups - Grant');
        INSERT INTO map04_entitlements_v04 
        VALUES(1754,1166,'Master Data - Symbols Management - Sharia Symbol Groups - Mark for Delete');
        INSERT INTO map04_entitlements_v04 
        VALUES(1755,1165,'Master Data - Symbols Management - Sharia Symbol Groups - Reject');
        INSERT INTO map04_entitlements_v04 
        VALUES(1755,1168,'Master Data - Symbols Management - Sharia Symbol Groups - Restore');
        INSERT INTO map04_entitlements_v04 
        VALUES(1755,1171,'Master Data - Symbols Management - Sharia Symbol Groups - Set as Default');
        INSERT INTO map04_entitlements_v04 
        VALUES(832,1172,'Master Data - Symbols Management - Sharia Symbol Groups - Sharia Symbols - Add');
        INSERT INTO map04_entitlements_v04 
        VALUES(834,1173,'Master Data - Symbols Management - Sharia Symbol Groups - Sharia Symbols - Delete');
        INSERT INTO map04_entitlements_v04 
        VALUES(223,1,'Master Data - Symbols Management - Symbols');
        INSERT INTO map04_entitlements_v04 
        VALUES(429,2,'Master Data - Symbols Management - Symbols - Add');
        INSERT INTO map04_entitlements_v04 
        VALUES(430,10,'Master Data - Symbols Management - Symbols - Approvals');
        INSERT INTO map04_entitlements_v04 
        VALUES(430,4,'Master Data - Symbols Management - Symbols - Approve');
        INSERT INTO map04_entitlements_v04 
        VALUES(430,7,'Master Data - Symbols Management - Symbols - Delete');
        INSERT INTO map04_entitlements_v04 
        VALUES(429,3,'Master Data - Symbols Management - Symbols - Edit');
        INSERT INTO map04_entitlements_v04 
        VALUES(429,9,'Master Data - Symbols Management - Symbols - Grant');
        INSERT INTO map04_entitlements_v04 
        VALUES(429,6,'Master Data - Symbols Management - Symbols - Mark for Delete');
        INSERT INTO map04_entitlements_v04 
        VALUES(430,5,'Master Data - Symbols Management - Symbols - Reject');
        INSERT INTO map04_entitlements_v04 
        VALUES(430,8,'Master Data - Symbols Management - Symbols - Restore');
        INSERT INTO map04_entitlements_v04 
        VALUES(18,1303,'Report');
        INSERT INTO map04_entitlements_v04 
        VALUES(565,1333,'Reports - Audit Reports');
        INSERT INTO map04_entitlements_v04 
        VALUES(621,1334,'Reports - Audit Reports - Recently Not Logged in Users');
        INSERT INTO map04_entitlements_v04 
        VALUES(624,1335,'Reports - Audit Reports - User Logins');
        INSERT INTO map04_entitlements_v04 
        VALUES(1693,1337,'Reports - Audit Reports - User Logins - Failed User Logins');
        INSERT INTO map04_entitlements_v04 
        VALUES(567,1336,'Reports - Audit Reports - User Logins - Successfull User Logins');
        INSERT INTO map04_entitlements_v04 
        VALUES(101,1316,'Reports - Customer');
        INSERT INTO map04_entitlements_v04 
        VALUES(1097,1318,'Reports - Customer - Cash Balance History');
        INSERT INTO map04_entitlements_v04 
        VALUES(1690,1319,'Reports - Customer - Discount Expiration');
        INSERT INTO map04_entitlements_v04 
        VALUES(1404,1317,'Reports - Customer - ID Expired Customers');
        INSERT INTO map04_entitlements_v04 
        VALUES(482,1338,'Reports - Dealers');
        INSERT INTO map04_entitlements_v04 
        VALUES(1700,1339,'Reports - Dealers - Dealer Activity Statistics');
        INSERT INTO map04_entitlements_v04 
        VALUES(540,1326,'Reports - Finance Inquiries');
        INSERT INTO map04_entitlements_v04 
        VALUES(1014,1327,'Reports - Finance Inquiries - Commission');
        INSERT INTO map04_entitlements_v04 
        VALUES(508,1328,'Reports - Finance Inquiries - Commission - Customer Wise Commission');
        INSERT INTO map04_entitlements_v04 
        VALUES(1474,1329,'Reports - Finance Inquiries - Tax Report');
        INSERT INTO map04_entitlements_v04 
        VALUES(1970,1341,'Reports - Finance Inquiries - Tax Report - Daily VAT Collection');
        INSERT INTO map04_entitlements_v04 
        VALUES(1969,1340,'Reports - Finance Inquiries - Tax Report - VAT Collection by Customer');
        INSERT INTO map04_entitlements_v04 
        VALUES(100,1314,'Reports - Holding');
        INSERT INTO map04_entitlements_v04 
        VALUES(125,1315,'Reports - Holding - Holding Master');
        INSERT INTO map04_entitlements_v04 
        VALUES(1717,1330,'Reports - Market Data');
        INSERT INTO map04_entitlements_v04 
        VALUES(1717,1332,'Reports - Market Data - Announcement');
        INSERT INTO map04_entitlements_v04 
        VALUES(1562,1331,'Reports - Market Data - Market Data Report');
        INSERT INTO map04_entitlements_v04 
        VALUES(99,1310,'Reports - Orders');
        INSERT INTO map04_entitlements_v04 
        VALUES(1038,1312,'Reports - Orders - Execution Log');
        INSERT INTO map04_entitlements_v04 
        VALUES(122,1311,'Reports - Orders - Order List');
        INSERT INTO map04_entitlements_v04 
        VALUES(113,1321,'Reports - Settlement');
        INSERT INTO map04_entitlements_v04 
        VALUES(668,1322,'Reports - Settlement - Exchange Settlement');
        INSERT INTO map04_entitlements_v04 
        VALUES(668,1323,'Reports - Settlement - Exchange Settlement - Exchange Settlement Report By Settle Date');
        INSERT INTO map04_entitlements_v04 
        VALUES(668,1324,'Reports - Settlement - Exchange Settlement - Exchange Settlement Report By Trade Date');
        INSERT INTO map04_entitlements_v04 
        VALUES(1960,1325,'Reports - Settlement - Unsettled Trades Report');
        INSERT INTO map04_entitlements_v04 
        VALUES(530,970,'Settlement');
        INSERT INTO map04_entitlements_v04 
        VALUES(136,1091,'Settlements - Settlement Calendar');
        INSERT INTO map04_entitlements_v04 
        VALUES(136,1092,'Settlements - Settlement Calendar - Add');
        INSERT INTO map04_entitlements_v04 
        VALUES(136,971,'Settlements - Settlement Calender - Holiday - Add');
        INSERT INTO map04_entitlements_v04 
        VALUES(136,972,'Settlements - Settlement Calender - Holiday - Delete');
        INSERT INTO map04_entitlements_v04 
        VALUES(1774,211,'Settlements - Settlement Groups');
        INSERT INTO map04_entitlements_v04 
        VALUES(1775,212,'Settlements - Settlement Groups - Add ');
        INSERT INTO map04_entitlements_v04 
        VALUES(1776,220,'Settlements - Settlement Groups - Approvals');
        INSERT INTO map04_entitlements_v04 
        VALUES(1776,214,'Settlements - Settlement Groups - Approve');
        INSERT INTO map04_entitlements_v04 
        VALUES(1776,218,'Settlements - Settlement Groups - Delete');
        INSERT INTO map04_entitlements_v04 
        VALUES(1775,213,'Settlements - Settlement Groups - Edit');
        INSERT INTO map04_entitlements_v04 
        VALUES(1775,219,'Settlements - Settlement Groups - Grant');
        INSERT INTO map04_entitlements_v04 
        VALUES(1775,217,'Settlements - Settlement Groups - Mark For Delete');
        INSERT INTO map04_entitlements_v04 
        VALUES(1776,216,'Settlements - Settlement Groups - Reject');
        INSERT INTO map04_entitlements_v04 
        VALUES(1776,215,'Settlements - Settlement Groups - Restore');
        INSERT INTO map04_entitlements_v04 
        VALUES(589,1306,'System');
        INSERT INTO map04_entitlements_v04 
        VALUES(275,1373,'System - Audits');
        INSERT INTO map04_entitlements_v04 
        VALUES(275,1374,'System - Audits - Audit Trail');
        INSERT INTO map04_entitlements_v04 
        VALUES(1644,1377,'System - Audits - U Messages Audit Trail');
        INSERT INTO map04_entitlements_v04 
        VALUES(1278,1294,'System - Entitlement View');
        INSERT INTO map04_entitlements_v04 
        VALUES(1279,1295,'System - Entitlement View - Institution Entitlement');
        INSERT INTO map04_entitlements_v04 
        VALUES(1277,151,'System - Institute');
        INSERT INTO map04_entitlements_v04 
        VALUES(1284,152,'System - Institute - Add');
        INSERT INTO map04_entitlements_v04 
        VALUES(1627,160,'System - Institute - Approvals');
        INSERT INTO map04_entitlements_v04 
        VALUES(1627,154,'System - Institute - Approve');
        INSERT INTO map04_entitlements_v04 
        VALUES(1627,158,'System - Institute - Delete');
        INSERT INTO map04_entitlements_v04 
        VALUES(1284,153,'System - Institute - Edit');
        INSERT INTO map04_entitlements_v04 
        VALUES(1277,1041,'System - Institute - Edit - Banks');
        INSERT INTO map04_entitlements_v04 
        VALUES(1284,1042,'System - Institute - Edit - Banks - Add');
        INSERT INTO map04_entitlements_v04 
        VALUES(1627,1043,'System - Institute - Edit - Banks - Delete');
        INSERT INTO map04_entitlements_v04 
        VALUES(1277,1101,'System - Institute - Edit - Documents');
        INSERT INTO map04_entitlements_v04 
        VALUES(1284,1102,'System - Institute - Edit - Documents - Save');
        INSERT INTO map04_entitlements_v04 
        VALUES(1277,791,'System - Institute - Edit - Executing Institutions');
        INSERT INTO map04_entitlements_v04 
        VALUES(1284,792,'System - Institute - Edit - Executing Institutions - Add');
        INSERT INTO map04_entitlements_v04 
        VALUES(1627,800,'System - Institute - Edit - Executing Institutions - Approvals');
        INSERT INTO map04_entitlements_v04 
        VALUES(1627,794,'System - Institute - Edit - Executing Institutions - Approve');
        INSERT INTO map04_entitlements_v04 
        VALUES(1627,798,'System - Institute - Edit - Executing Institutions - Delete');
        INSERT INTO map04_entitlements_v04 
        VALUES(1284,793,'System - Institute - Edit - Executing Institutions - Edit');
        INSERT INTO map04_entitlements_v04 
        VALUES(1627,799,'System - Institute - Edit - Executing Institutions - Grant');
        INSERT INTO map04_entitlements_v04 
        VALUES(1627,797,'System - Institute - Edit - Executing Institutions - Mark For Delete');
        INSERT INTO map04_entitlements_v04 
        VALUES(1627,796,'System - Institute - Edit - Executing Institutions - Reject');
        INSERT INTO map04_entitlements_v04 
        VALUES(1627,795,'System - Institute - Edit - Executing Institutions - Restore');
        INSERT INTO map04_entitlements_v04 
        VALUES(1277,781,'System - Institute - Edit - Notification');
        INSERT INTO map04_entitlements_v04 
        VALUES(1284,782,'System - Institute - Edit - Notification - Add');
        INSERT INTO map04_entitlements_v04 
        VALUES(1627,790,'System - Institute - Edit - Notification - Approvals');
        INSERT INTO map04_entitlements_v04 
        VALUES(1627,784,'System - Institute - Edit - Notification - Approve');
        INSERT INTO map04_entitlements_v04 
        VALUES(1627,788,'System - Institute - Edit - Notification - Delete');
        INSERT INTO map04_entitlements_v04 
        VALUES(1284,783,'System - Institute - Edit - Notification - Edit');
        INSERT INTO map04_entitlements_v04 
        VALUES(1627,789,'System - Institute - Edit - Notification - Grant');
        INSERT INTO map04_entitlements_v04 
        VALUES(1627,787,'System - Institute - Edit - Notification - Mark For Delete');
        INSERT INTO map04_entitlements_v04 
        VALUES(1627,786,'System - Institute - Edit - Notification - Reject');
        INSERT INTO map04_entitlements_v04 
        VALUES(1627,785,'System - Institute - Edit - Notification - Restore');
        INSERT INTO map04_entitlements_v04 
        VALUES(1627,159,'System - Institute - Grant');
        INSERT INTO map04_entitlements_v04 
        VALUES(1627,157,'System - Institute - Mark For Delete');
        INSERT INTO map04_entitlements_v04 
        VALUES(1627,156,'System - Institute - Reject');
        INSERT INTO map04_entitlements_v04 
        VALUES(1284,162,'System - Institute - Remove Root Institution');
        INSERT INTO map04_entitlements_v04 
        VALUES(1627,155,'System - Institute - Restore');
        INSERT INTO map04_entitlements_v04 
        VALUES(1284,161,'System - Institute - Set As Root Institution');
        INSERT INTO map04_entitlements_v04 
        VALUES(1280,1270,'System - System Configurations');
        INSERT INTO map04_entitlements_v04 
        VALUES(873,1271,'System - System Configurations - Uploadable Documents');
        INSERT INTO map04_entitlements_v04 
        VALUES(874,1272,'System - System Configurations - Uploadable Documents - Add');
        INSERT INTO map04_entitlements_v04 
        VALUES(874,1274,'System - System Configurations - Uploadable Documents - Approve');
        INSERT INTO map04_entitlements_v04 
        VALUES(876,1277,'System - System Configurations - Uploadable Documents - Delete');
        INSERT INTO map04_entitlements_v04 
        VALUES(875,1273,'System - System Configurations - Uploadable Documents - Edit');
        INSERT INTO map04_entitlements_v04 
        VALUES(874,1279,'System - System Configurations - Uploadable Documents - Grant');
        INSERT INTO map04_entitlements_v04 
        VALUES(876,1276,'System - System Configurations - Uploadable Documents - Mark for Delete');
        INSERT INTO map04_entitlements_v04 
        VALUES(876,1275,'System - System Configurations - Uploadable Documents - Reject');
        INSERT INTO map04_entitlements_v04 
        VALUES(874,1278,'System - System Configurations - Uploadable Documents - Restore');
        INSERT INTO map04_entitlements_v04 
        VALUES(135,1230,'Tools - Reconciliation');
        INSERT INTO map04_entitlements_v04 
        VALUES(135,1231,'Tools - Reconciliation - Eod Reconciliation -Process');
        INSERT INTO map04_entitlements_v04 
        VALUES(50,801,'Trading');
        INSERT INTO map04_entitlements_v04 
        VALUES(50,802,'Trading - Order List');
        INSERT INTO map04_entitlements_v04 
        VALUES(1907,1149,'Trading - Order List - Advanced Algo Orders');
        INSERT INTO map04_entitlements_v04 
        VALUES(1858,1126,'Trading - Order List - Algo Orders');
        INSERT INTO map04_entitlements_v04 
        VALUES(502,1126,'Trading - Order List - Algo Orders');
        INSERT INTO map04_entitlements_v04 
        VALUES(87,1119,'Trading - Order List - Approve/Reject Order');
        INSERT INTO map04_entitlements_v04 
        VALUES(375,131,'Trading - Order List - Back Office Order List');
        INSERT INTO map04_entitlements_v04 
        VALUES(1666,140,'Trading - Order List - Back Office Order List - Get Status From Exchange');
        INSERT INTO map04_entitlements_v04 
        VALUES(58,136,'Trading - Order List - Back Office Order List - Reverse Order');
        INSERT INTO map04_entitlements_v04 
        VALUES(11,134,'Trading - Order List - Back Office Order List - Search Customer');
        INSERT INTO map04_entitlements_v04 
        VALUES(611,139,'Trading - Order List - Back Office Order List - Set Status');
        INSERT INTO map04_entitlements_v04 
        VALUES(355,139,'Trading - Order List - Back Office Order List - Set Status');
        INSERT INTO map04_entitlements_v04 
        VALUES(372,139,'Trading - Order List - Back Office Order List - Set Status');
        INSERT INTO map04_entitlements_v04 
        VALUES(354,139,'Trading - Order List - Back Office Order List - Set Status');
        INSERT INTO map04_entitlements_v04 
        VALUES(371,139,'Trading - Order List - Back Office Order List - Set Status');
        INSERT INTO map04_entitlements_v04 
        VALUES(612,141,'Trading - Order List - Back Office Order List - Trading Report');
        INSERT INTO map04_entitlements_v04 
        VALUES(164,135,'Trading - Order List - Back Office Order List - View Holding');
        INSERT INTO map04_entitlements_v04 
        VALUES(4008,132,'Trading - Order List - Back Office Order List - View Order');
        INSERT INTO map04_entitlements_v04 
        VALUES(356,1124,'Trading - Order List - Conditional Orders');
        INSERT INTO map04_entitlements_v04 
        VALUES(945,1129,'AT/DT - Trading - Order List - Desk Orders');
        INSERT INTO map04_entitlements_v04 
        VALUES(951,1129,'AT/DT - Trading - Order List - Desk Orders');
        INSERT INTO map04_entitlements_v04 
        VALUES(946,1822,'Trading - Order List - Desk Orders');
        INSERT INTO map04_entitlements_v04 
        VALUES(947,1822,'Trading - Order List - Desk Orders');
        INSERT INTO map04_entitlements_v04 
        VALUES(949,1822,'Trading - Order List - Desk Orders');
        INSERT INTO map04_entitlements_v04 
        VALUES(952,1822,'Trading - Order List - Desk Orders');
        INSERT INTO map04_entitlements_v04 
        VALUES(950,1822,'Trading - Order List - Desk Orders');
        INSERT INTO map04_entitlements_v04 
        VALUES(948,1822,'Trading - Order List - Desk Orders');
        INSERT INTO map04_entitlements_v04 
        VALUES(86,1122,'Trading - Order List - Expire Order');
        INSERT INTO map04_entitlements_v04 
        VALUES(104,121,'Trading - Order List - Front Office Order List ');
        INSERT INTO map04_entitlements_v04 
        VALUES(277,1123,'Trading - Order List - Manual Order Execution');
        INSERT INTO map04_entitlements_v04 
        VALUES(1980,1123,'Trading - Order List - Manual Order Execution');
        INSERT INTO map04_entitlements_v04 
        VALUES(104,803,'Trading - Order List - Orders');
        INSERT INTO map04_entitlements_v04 
        VALUES(140,1121,'Trading - Order List - Waiting for Approval');
        INSERT INTO map04_entitlements_v04 
        VALUES(1069,1130,'Trading - Trading Connections');
        INSERT INTO map04_entitlements_v04 
        VALUES(1070,1130,'Trading - Trading Connections');
        INSERT INTO map04_entitlements_v04 
        VALUES(643,1304,'Users');
        INSERT INTO map04_entitlements_v04 
        VALUES(545,1292,'Users - Account Locaked Users');
        INSERT INTO map04_entitlements_v04 
        VALUES(220,221,'Users - AT Users');
        INSERT INTO map04_entitlements_v04 
        VALUES(75,222,'Users - AT Users - Add');
        INSERT INTO map04_entitlements_v04 
        VALUES(258,230,'Users - AT Users - Approvals');
        INSERT INTO map04_entitlements_v04 
        VALUES(258,224,'Users - AT Users - Approve');
        INSERT INTO map04_entitlements_v04 
        VALUES(213,233,'Users - AT Users - Assign Cash Accounts');
        INSERT INTO map04_entitlements_v04 
        VALUES(213,234,'Users - AT Users - Assign Cash Accounts - Add');
        INSERT INTO map04_entitlements_v04 
        VALUES(258,228,'Users - AT Users - Delete');
        INSERT INTO map04_entitlements_v04 
        VALUES(76,223,'Users - AT Users - Edit');
        INSERT INTO map04_entitlements_v04 
        VALUES(1429,1071,'Users - AT Users - Edit - Authorization Limits');
        INSERT INTO map04_entitlements_v04 
        VALUES(1429,1072,'Users - AT Users - Edit - Authorization Limits - Save');
        INSERT INTO map04_entitlements_v04 
        VALUES(568,1061,'Users - AT Users - Edit - Notification Groups');
        INSERT INTO map04_entitlements_v04 
        VALUES(570,1063,'Users - AT Users - Edit - Notification Groups - Approve');
        INSERT INTO map04_entitlements_v04 
        VALUES(570,1066,'Users - AT Users - Edit - Notification Groups - Delete');
        INSERT INTO map04_entitlements_v04 
        VALUES(569,1068,'Users - AT Users - Edit - Notification Groups - Grant');
        INSERT INTO map04_entitlements_v04 
        VALUES(569,1065,'Users - AT Users - Edit - Notification Groups - Mark For Delete');
        INSERT INTO map04_entitlements_v04 
        VALUES(570,1064,'Users - AT Users - Edit - Notification Groups - Reject');
        INSERT INTO map04_entitlements_v04 
        VALUES(570,1067,'Users - AT Users - Edit - Notification Groups - Restore');
        INSERT INTO map04_entitlements_v04 
        VALUES(570,1062,'Users - AT Users - Edit - Notification Groups - Save');
        INSERT INTO map04_entitlements_v04 
        VALUES(257,229,'Users - AT Users - Grant');
        INSERT INTO map04_entitlements_v04 
        VALUES(257,227,'Users - AT Users - Mark For Delete');
        INSERT INTO map04_entitlements_v04 
        VALUES(258,226,'Users - AT Users - Reject');
        INSERT INTO map04_entitlements_v04 
        VALUES(78,232,'Users - AT Users - Reset Password');
        INSERT INTO map04_entitlements_v04 
        VALUES(258,225,'Users - AT Users - Restore');
        INSERT INTO map04_entitlements_v04 
        VALUES(1787,4312,'Trading - OTC Trading - Bonds');
        INSERT INTO map04_entitlements_v04 
        VALUES(1782,4175,'Finance - Cash Management - L2 Approval for Overdrawn Transactions');
        INSERT INTO map04_entitlements_v04 
        VALUES(1455,4383,'Master Data - Symbols Management - Symbols - Price And Quantity Factors - Edit ');
        INSERT INTO map04_entitlements_v04 
        VALUES(388,231,'Users - AT Users - Unlock Account');
        INSERT INTO map04_entitlements_v04 
        VALUES(218,1379,'Users - AT Users - User Groups');
        INSERT INTO map04_entitlements_v04 
        VALUES(1247,251,'Users - Dealers');
        INSERT INTO map04_entitlements_v04 
        VALUES(257,252,'Users - Dealers - Add');
        INSERT INTO map04_entitlements_v04 
        VALUES(258,260,'Users - Dealers - Approvals');
        INSERT INTO map04_entitlements_v04 
        VALUES(258,254,'Users - Dealers - Approve');
        INSERT INTO map04_entitlements_v04 
        VALUES(213,263,'Users - Dealers - Assign Cash Accounts');
        INSERT INTO map04_entitlements_v04 
        VALUES(258,258,'Users - Dealers - Delete');
        INSERT INTO map04_entitlements_v04 
        VALUES(257,253,'Users - Dealers - Edit');
        INSERT INTO map04_entitlements_v04 
        VALUES(1429,1081,'Users - Dealers - Edit - Authorization Limits');
        INSERT INTO map04_entitlements_v04 
        VALUES(1429,1082,'Users - Dealers - Edit - Authorization Limits - Save');
        INSERT INTO map04_entitlements_v04 
        VALUES(568,1021,'Users - Dealers - Edit - Notification Groups');
        INSERT INTO map04_entitlements_v04 
        VALUES(570,1023,'Users - Dealers - Edit - Notification Groups - Approve');
        INSERT INTO map04_entitlements_v04 
        VALUES(570,1026,'Users - Dealers - Edit - Notification Groups - Delete');
        INSERT INTO map04_entitlements_v04 
        VALUES(569,1028,'Users - Dealers - Edit - Notification Groups - Grant');
        INSERT INTO map04_entitlements_v04 
        VALUES(569,1025,'Users - Dealers - Edit - Notification Groups - Mark For Delete');
        INSERT INTO map04_entitlements_v04 
        VALUES(570,1024,'Users - Dealers - Edit - Notification Groups - Reject');
        INSERT INTO map04_entitlements_v04 
        VALUES(570,1027,'Users - Dealers - Edit - Notification Groups - Restore');
        INSERT INTO map04_entitlements_v04 
        VALUES(570,1022,'Users - Dealers - Edit - Notification Groups - Save');
        INSERT INTO map04_entitlements_v04 
        VALUES(213,1031,'Users - Dealers - Edit - Trading Groups');
        INSERT INTO map04_entitlements_v04 
        VALUES(214,1032,'Users - Dealers - Edit - Trading Groups - Save');
        INSERT INTO map04_entitlements_v04 
        VALUES(213,1032,'Users - Dealers - Edit - Trading Groups - Save');
        INSERT INTO map04_entitlements_v04 
        VALUES(257,259,'Users - Dealers - Grant');
        INSERT INTO map04_entitlements_v04 
        VALUES(257,257,'Users - Dealers - Mark For Delete');
        INSERT INTO map04_entitlements_v04 
        VALUES(258,256,'Users - Dealers - Reject');
        INSERT INTO map04_entitlements_v04 
        VALUES(78,262,'Users - Dealers - Reset Password');
        INSERT INTO map04_entitlements_v04 
        VALUES(258,255,'Users - Dealers - Restore');
        INSERT INTO map04_entitlements_v04 
        VALUES(388,261,'Users - Dealers - Unlock Account');
        INSERT INTO map04_entitlements_v04 
        VALUES(138,1293,'Users - Online Users');
        INSERT INTO map04_entitlements_v04 
        VALUES(218,350,'Users - User Group');
        INSERT INTO map04_entitlements_v04 
        VALUES(218,351,'Users - User Group - User Groups');
        INSERT INTO map04_entitlements_v04 
        VALUES(208,352,'Users - User Group - User Groups - Add');
        INSERT INTO map04_entitlements_v04 
        VALUES(633,354,'Users - User Group - User Groups - Approve');
        INSERT INTO map04_entitlements_v04 
        VALUES(633,358,'Users - User Group - User Groups - Delete');
        INSERT INTO map04_entitlements_v04 
        VALUES(208,353,'Users - User Group - User Groups - Edit');
        INSERT INTO map04_entitlements_v04 
        VALUES(209,388,'Users - User Group - User Groups - Entitlements - Add ');
        INSERT INTO map04_entitlements_v04 
        VALUES(210,389,'Users - User Group - User Groups - Entitlements - Approve ');
        INSERT INTO map04_entitlements_v04 
        VALUES(210,393,'Users - User Group - User Groups - Entitlements - Delete ');
        INSERT INTO map04_entitlements_v04 
        VALUES(209,394,'Users - User Group - User Groups - Entitlements - Grant ');
        INSERT INTO map04_entitlements_v04 
        VALUES(209,392,'Users - User Group - User Groups - Entitlements - Mark For Delete ');
        INSERT INTO map04_entitlements_v04 
        VALUES(210,391,'Users - User Group - User Groups - Entitlements - Reject ');
        INSERT INTO map04_entitlements_v04 
        VALUES(210,390,'Users - User Group - User Groups - Entitlements - Restore ');
        INSERT INTO map04_entitlements_v04 
        VALUES(208,359,'Users - User Group - User Groups - Grant');
        INSERT INTO map04_entitlements_v04 
        VALUES(208,357,'Users - User Group - User Groups - Mark For Delete');
        INSERT INTO map04_entitlements_v04 
        VALUES(633,356,'Users - User Group - User Groups - Reject');
        INSERT INTO map04_entitlements_v04 
        VALUES(633,355,'Users - User Group - User Groups - Restore');
        INSERT INTO map04_entitlements_v04 
        VALUES(215,381,'Users - User Group - User Groups - Users - Add');
        INSERT INTO map04_entitlements_v04 
        VALUES(216,382,'Users - User Group - User Groups - Users - Approve ');
        INSERT INTO map04_entitlements_v04 
        VALUES(216,386,'Users - User Group - User Groups - Users - Delete ');
        INSERT INTO map04_entitlements_v04 
        VALUES(215,387,'Users - User Group - User Groups - Users - Grant ');
        INSERT INTO map04_entitlements_v04 
        VALUES(215,385,'Users - User Group - User Groups - Users - Mark For Delete ');
        INSERT INTO map04_entitlements_v04 
        VALUES(216,384,'Users - User Group - User Groups - Users - Reject ');
        INSERT INTO map04_entitlements_v04 
        VALUES(216,383,'Users - User Group - User Groups - Users - Restore ');
        INSERT INTO map04_entitlements_v04 
        VALUES(1787,4291,'Trading - OTC Trading - Money Market - Money Market Contract List');
		INSERT INTO map04_entitlements_v04 (MAP04_OMS_ID,MAP04_NTP_ID,MAP04_DESCRIPTION) 
		VALUES(42,33,'X Admin');
		INSERT INTO map04_entitlements_v04 (MAP04_OMS_ID,MAP04_NTP_ID,MAP04_DESCRIPTION) 
		VALUES(276,1122,'AT/DT - Trading - Order List - Expire Order');
		INSERT INTO map04_entitlements_v04 (MAP04_OMS_ID,MAP04_NTP_ID,MAP04_DESCRIPTION) 
		VALUES(536,1759,'Reports - Orders - Orders For Dealers');
		INSERT INTO map04_entitlements_v04 (MAP04_OMS_ID,MAP04_NTP_ID,MAP04_DESCRIPTION) 
		VALUES(1449,474,'Customer - Customers - Edit - Beneficiary Account - Approve');
		INSERT INTO map04_entitlements_v04 (MAP04_OMS_ID,MAP04_NTP_ID,MAP04_DESCRIPTION) 
		VALUES(1452,3090,'Reports - Holdings - Custodian/Customer Wise Holdings');
		INSERT INTO map04_entitlements_v04 (MAP04_OMS_ID,MAP04_NTP_ID,MAP04_DESCRIPTION) 
		VALUES(1509,941,'Finance - Charges Group');
		INSERT INTO map04_entitlements_v04 (MAP04_OMS_ID,MAP04_NTP_ID,MAP04_DESCRIPTION) 
		VALUES(1534,427,'Customer - Customers - Edit - Cash Accounts - Mark For Delete');
		INSERT INTO map04_entitlements_v04 (MAP04_OMS_ID,MAP04_NTP_ID,MAP04_DESCRIPTION) 
		VALUES(1545,1117,'DT - Trading');
		INSERT INTO map04_entitlements_v04 (MAP04_OMS_ID,MAP04_NTP_ID,MAP04_DESCRIPTION) 
		VALUES(1556,1117,'DT - Trading');
		INSERT INTO map04_entitlements_v04 (MAP04_OMS_ID,MAP04_NTP_ID,MAP04_DESCRIPTION) 
		VALUES(1715,270,'Customer - Account Closure');
		INSERT INTO map04_entitlements_v04 (MAP04_OMS_ID,MAP04_NTP_ID,MAP04_DESCRIPTION) 
		VALUES(1728,1342,'Reports - Orders - Custodian Trade');
		INSERT INTO map04_entitlements_v04 (MAP04_OMS_ID,MAP04_NTP_ID,MAP04_DESCRIPTION) 
		VALUES(1731,4391,'Reports - Finance Inquiries - Tax Report - Vat Invoice');
		INSERT INTO map04_entitlements_v04 (MAP04_OMS_ID,MAP04_NTP_ID,MAP04_DESCRIPTION) 
		VALUES(1783,301,'Finance - Cash Management - Cash Requests');
    END IF;
END;
/