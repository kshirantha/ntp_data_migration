DECLARE
    l_count   NUMBER := 0;
BEGIN
    SELECT COUNT (*) INTO l_count FROM map02_audit_activity_m82;

    IF l_count = 0
    THEN
        INSERT INTO map02_audit_activity_m82
             VALUES (3, 325, 'Customer Created');

        INSERT INTO map02_audit_activity_m82
             VALUES (4, 326, 'Customer Modified');

        INSERT INTO map02_audit_activity_m82
             VALUES (6, 334, 'Customer Cash Account Created');

        INSERT INTO map02_audit_activity_m82
             VALUES (7, 335, 'Customer Cash Account Modified');

        INSERT INTO map02_audit_activity_m82
             VALUES (9, 338, 'Customer Trading Account Created');

        INSERT INTO map02_audit_activity_m82
             VALUES (10, 339, 'Customer Trading Account Modified');

        INSERT INTO map02_audit_activity_m82
             VALUES (12, 338, 'Customer Trading Account Created');

        INSERT INTO map02_audit_activity_m82
             VALUES (13, 339, 'Customer Trading Account Modified');

        INSERT INTO map02_audit_activity_m82
             VALUES (15, 342, 'Enable Trading');

        INSERT INTO map02_audit_activity_m82
             VALUES (16, 343, 'Customer Trading Account Trading Disabled');

        INSERT INTO map02_audit_activity_m82
             VALUES (20, 405, 'Set Power of Attorney');

        INSERT INTO map02_audit_activity_m82
             VALUES (38, 327, 'Customer Suspend');

        INSERT INTO map02_audit_activity_m82
             VALUES (39, 378, 'User Status Changed');

        INSERT INTO map02_audit_activity_m82
             VALUES (40, 50, 'Symbol Created');

        INSERT INTO map02_audit_activity_m82
             VALUES (41, 51, 'Symbol Modified');

        INSERT INTO map02_audit_activity_m82
             VALUES (42, 52, 'Symbol Status Changed');

        INSERT INTO map02_audit_activity_m82
             VALUES (44, 42, 'Bank Added');

        INSERT INTO map02_audit_activity_m82
             VALUES (45, 43, 'Bank Modified');

        INSERT INTO map02_audit_activity_m82
             VALUES (46, 44, 'Bank Status Changed');

        INSERT INTO map02_audit_activity_m82
             VALUES (47, 14, 'Country Added');

        INSERT INTO map02_audit_activity_m82
             VALUES (48, 15, 'Country Modified');

        INSERT INTO map02_audit_activity_m82
             VALUES (49, 16, 'Country Status Changed');

        INSERT INTO map02_audit_activity_m82
             VALUES (53, 194, 'Charges and Refund Status Changed');

        INSERT INTO map02_audit_activity_m82
             VALUES (54, 195, 'Charges and Refund Modifed');

        INSERT INTO map02_audit_activity_m82
             VALUES (55, 196, 'Charges and Refund Created');

        INSERT INTO map02_audit_activity_m82
             VALUES (56, 20, 'Location Created');

        INSERT INTO map02_audit_activity_m82
             VALUES (57, 21, 'Location Modified');

        INSERT INTO map02_audit_activity_m82
             VALUES (58, 22, 'Location Status Changed');

        INSERT INTO map02_audit_activity_m82
             VALUES (59, 23, 'Trading Group Created');

        INSERT INTO map02_audit_activity_m82
             VALUES (60, 24, 'Trading Group Modified');

        INSERT INTO map02_audit_activity_m82
             VALUES (61, 25, 'Trading Group Status Changed');

        INSERT INTO map02_audit_activity_m82
             VALUES (65, 8, 'Currency Created');

        INSERT INTO map02_audit_activity_m82
             VALUES (66, 9, 'Currency Modified');

        INSERT INTO map02_audit_activity_m82
             VALUES (67, 10, 'Currency Status Changed');

        INSERT INTO map02_audit_activity_m82
             VALUES (77, 84, 'Executing Broker Routing Created');

        INSERT INTO map02_audit_activity_m82
             VALUES (78, 85, 'Executing Broker Routing Modified');

        INSERT INTO map02_audit_activity_m82
             VALUES (79, 86, 'Executing Broker Routing Status Changed');

        INSERT INTO map02_audit_activity_m82
             VALUES (80, 1, 'Exchange Created');

        INSERT INTO map02_audit_activity_m82
             VALUES (81, 2, 'Exchange Modified');

        INSERT INTO map02_audit_activity_m82
             VALUES (82, 3, 'Exchange Status Changed');

        INSERT INTO map02_audit_activity_m82
             VALUES (86, 138, 'Sector added');

        INSERT INTO map02_audit_activity_m82
             VALUES (87, 139, 'Sector Modified');

        INSERT INTO map02_audit_activity_m82
             VALUES (88, 140, 'Sector Status Changed');

        INSERT INTO map02_audit_activity_m82
             VALUES (114, 203, 'Exchange Broker Created');

        INSERT INTO map02_audit_activity_m82
             VALUES (115, 204, 'Exchange Broker Modified');

        INSERT INTO map02_audit_activity_m82
             VALUES (116, 205, 'Exchange Broker Status Changed');

        INSERT INTO map02_audit_activity_m82
             VALUES (126, 187, 'Brokerage Bank Account Created');

        INSERT INTO map02_audit_activity_m82
             VALUES (127, 188, 'Brokerage Bank Account Modified');

        INSERT INTO map02_audit_activity_m82
             VALUES (128, 189, 'Brokerage Bank Account Status Changed');

        INSERT INTO map02_audit_activity_m82
             VALUES (132, 162, 'Margin Interest Group Created');

        INSERT INTO map02_audit_activity_m82
             VALUES (133, 163, 'Margin Interest Group Modified');

        INSERT INTO map02_audit_activity_m82
             VALUES (134, 164, 'Margin Interest Group Status Changed');

        INSERT INTO map02_audit_activity_m82
             VALUES (138, 11, 'Currency Rate Created');

        INSERT INTO map02_audit_activity_m82
             VALUES (139, 12, 'Currency Rate Modified');

        INSERT INTO map02_audit_activity_m82
             VALUES (140, 13, 'Currency Rate Status Changed');

        INSERT INTO map02_audit_activity_m82
             VALUES (146, 174, 'Symbol Marginability Added');

        INSERT INTO map02_audit_activity_m82
             VALUES (147, 175, 'Symbol Marginability Modified');

        INSERT INTO map02_audit_activity_m82
             VALUES (152, 405, 'Customer POA Added');

        INSERT INTO map02_audit_activity_m82
             VALUES (153, 406, 'Customer POA Modified');

        INSERT INTO map02_audit_activity_m82
             VALUES (154, 407, 'Customer POA Status Changed');

        INSERT INTO map02_audit_activity_m82
             VALUES (156, 87, 'Executing Broker Routing Set Status');

        INSERT INTO map02_audit_activity_m82
             VALUES (159, 236, 'Titles Added');

        INSERT INTO map02_audit_activity_m82
             VALUES (160, 237, 'Titles Edit');

        INSERT INTO map02_audit_activity_m82
             VALUES (161, 238, 'Titles status update');

        INSERT INTO map02_audit_activity_m82
             VALUES (191, 340, 'Customer Trading Account Status changed');

        INSERT INTO map02_audit_activity_m82
             VALUES (197, 339, 'Customer Trading Account Modified');

        INSERT INTO map02_audit_activity_m82
             VALUES (208, 340, 'Customer Trading Account Status changed');

        INSERT INTO map02_audit_activity_m82
             VALUES (213, 376, 'Employee Created');

        INSERT INTO map02_audit_activity_m82
             VALUES (214, 377, 'Employee modified');

        INSERT INTO map02_audit_activity_m82
             VALUES (216, 378, 'Employee Status Changed');

        INSERT INTO map02_audit_activity_m82
             VALUES (223, 118, 'Location assigned to Employee');

        INSERT INTO map02_audit_activity_m82
             VALUES (224, 119, 'Location removed from Employee');

        INSERT INTO map02_audit_activity_m82
             VALUES (226, 122, 'Trading Limits Modified');

        INSERT INTO map02_audit_activity_m82
             VALUES (227, 191, 'Settlement Calender Generated');

        INSERT INTO map02_audit_activity_m82
             VALUES (228, 192, 'Holiday Created');

        INSERT INTO map02_audit_activity_m82
             VALUES (229, 193, 'Holiday Removed');

        INSERT INTO map02_audit_activity_m82
             VALUES (230, 74, 'Customer Grade Data Added');

        INSERT INTO map02_audit_activity_m82
             VALUES (232, 76, 'Customer Grade Data Status Changed');

        INSERT INTO map02_audit_activity_m82
             VALUES (233, 107, 'Permission Group Created');

        INSERT INTO map02_audit_activity_m82
             VALUES (234, 108, 'Permission Group Modified');

        INSERT INTO map02_audit_activity_m82
             VALUES (236, 56, 'Commission Group Created');

        INSERT INTO map02_audit_activity_m82
             VALUES (237, 57, 'Commission Group Modified');

        INSERT INTO map02_audit_activity_m82
             VALUES (238, 58, 'Commission Group Status Changed');

        INSERT INTO map02_audit_activity_m82
             VALUES (239, 61, 'Commission Group Structure Created');

        INSERT INTO map02_audit_activity_m82
             VALUES (240, 62, 'Commission Group Structure Modified');

        INSERT INTO map02_audit_activity_m82
             VALUES (241, 63, 'Commission Group Structure Status Changed');

        INSERT INTO map02_audit_activity_m82
             VALUES (242, 113, 'Permission Group User Created');

        INSERT INTO map02_audit_activity_m82
             VALUES (244, 115, 'Status of a User in a Group Changed');

        INSERT INTO map02_audit_activity_m82
             VALUES (254, 105, 'Entitlement Granted for Institution');

        INSERT INTO map02_audit_activity_m82
             VALUES (255, 106, 'Entitlement Removed from Institution');

        INSERT INTO map02_audit_activity_m82
             VALUES (256, 110, 'Entitlement Granted for User Group');

        INSERT INTO map02_audit_activity_m82
             VALUES (257, 111, 'Entitlement Removed from User Group');

        INSERT INTO map02_audit_activity_m82
             VALUES (
                        258,
                        112,
                        'Status of Entitlement for User Group Changed');

        INSERT INTO map02_audit_activity_m82
             VALUES (261, 346, 'Customer Beneficiary Account Created ');

        INSERT INTO map02_audit_activity_m82
             VALUES (262, 347, 'Customer Beneficiary Account Modified');

        INSERT INTO map02_audit_activity_m82
             VALUES (263, 348, 'Customer Beneficiary Account Status Changed');

        INSERT INTO map02_audit_activity_m82
             VALUES (264, 349, 'Customer Beneficiary Account Set as Default');

        INSERT INTO map02_audit_activity_m82
             VALUES (276, 124, 'User Trading Group Changed');

        INSERT INTO map02_audit_activity_m82
             VALUES (277, 372, 'Symbol restricted');

        INSERT INTO map02_audit_activity_m82
             VALUES (278, 373, 'Trading Symbol Restriction Removed');

        INSERT INTO map02_audit_activity_m82
             VALUES (281, 374, 'Instrument Type Restricted');

        INSERT INTO map02_audit_activity_m82
             VALUES (284, 327, 'Customer Status Changed');

        INSERT INTO map02_audit_activity_m82
             VALUES (288, 460, 'Deposit Money');

        INSERT INTO map02_audit_activity_m82
             VALUES (289, 461, 'WithDraw Money');

        INSERT INTO map02_audit_activity_m82
             VALUES (290, 463, 'Cash Charge');

        INSERT INTO map02_audit_activity_m82
             VALUES (291, 464, 'Refund Added to Customer Cash Account');

        INSERT INTO map02_audit_activity_m82
             VALUES (292, 462, 'Cash Transfer');

        INSERT INTO map02_audit_activity_m82
             VALUES (297, 405, 'Power of Attorney Assigned for Customer');

        INSERT INTO map02_audit_activity_m82
             VALUES (298, 407, 'Customer POA Status Changed');

        INSERT INTO map02_audit_activity_m82
             VALUES (299, 407, 'Power of Attorney Deleted');

        INSERT INTO map02_audit_activity_m82
             VALUES (300, 467, 'Holdings Transferred');

        INSERT INTO map02_audit_activity_m82
             VALUES (302, 467, 'Holding Transfer');

        INSERT INTO map02_audit_activity_m82
             VALUES (306, 36, 'Id Issue Location Created');

        INSERT INTO map02_audit_activity_m82
             VALUES (307, 37, 'Id Issue Location Modified');

        INSERT INTO map02_audit_activity_m82
             VALUES (308, 38, 'Id Issue Location Status Changed');

        INSERT INTO map02_audit_activity_m82
             VALUES (320, 292, 'Price User Status Changed');

        INSERT INTO map02_audit_activity_m82
             VALUES (321, 292, 'Price User Status Changed');

        INSERT INTO map02_audit_activity_m82
             VALUES (334, 109, 'Permission Group Status Changed');

        INSERT INTO map02_audit_activity_m82
             VALUES (341, 73, 'Executing Broker Custody Status Changed');

        INSERT INTO map02_audit_activity_m82
             VALUES (342, 71, 'Executing Broker Custody Added');

        INSERT INTO map02_audit_activity_m82
             VALUES (343, 72, 'Executing Broker Custody Modified');

        INSERT INTO map02_audit_activity_m82
             VALUES (359, 329, 'Customer Contact Modified');

        INSERT INTO map02_audit_activity_m82
             VALUES (365, 380, 'Trading Channel Restriction Added');

        INSERT INTO map02_audit_activity_m82
             VALUES (366, 381, 'Trading Channel Restriction Removed');

        INSERT INTO map02_audit_activity_m82
             VALUES (388, 145, 'FIX Logins Added');

        INSERT INTO map02_audit_activity_m82
             VALUES (389, 146, 'Fix Login Modified');

        INSERT INTO map02_audit_activity_m82
             VALUES (392, 177, 'Symbol Marginability Status Changed');

        INSERT INTO map02_audit_activity_m82
             VALUES (453, 3, 'Exchange Status Changed');

        INSERT INTO map02_audit_activity_m82
             VALUES (454, 176, 'Symbol Marginability Removed');

        INSERT INTO map02_audit_activity_m82
             VALUES (457, 276, 'Subscription Product Modified');

        INSERT INTO map02_audit_activity_m82
             VALUES (466, 354, 'Customer Document Added');

        INSERT INTO map02_audit_activity_m82
             VALUES (467, 355, 'Customer Document Modified');

        INSERT INTO map02_audit_activity_m82
             VALUES (468, 356, 'Customer Document Removed');

        INSERT INTO map02_audit_activity_m82
             VALUES (
                        474,
                        439,
                        'File Upload Share Txn Request Status Changed');

        INSERT INTO map02_audit_activity_m82
             VALUES (476, 123, 'Employee Trading Limits Status Changed');

        INSERT INTO map02_audit_activity_m82
             VALUES (477, 162, 'Margin Interest Group Created');

        INSERT INTO map02_audit_activity_m82
             VALUES (478, 163, 'Margin Interest Group Modified');

        INSERT INTO map02_audit_activity_m82
             VALUES (479, 164, 'Margin Interest Group Status Changed');

        INSERT INTO map02_audit_activity_m82
             VALUES (484, 30, 'Relationship Manager Created');

        INSERT INTO map02_audit_activity_m82
             VALUES (485, 31, 'Relationship Manager Modified');

        INSERT INTO map02_audit_activity_m82
             VALUES (486, 32, 'Relationship Manager Status Changed');

        INSERT INTO map02_audit_activity_m82
             VALUES (487, 39, 'Id Type Created');

        INSERT INTO map02_audit_activity_m82
             VALUES (488, 40, 'Id Type Modified');

        INSERT INTO map02_audit_activity_m82
             VALUES (489, 41, 'Id Type Status Changed');

        INSERT INTO map02_audit_activity_m82
             VALUES (490, 346, 'Customer Beneficiary Account Created ');

        INSERT INTO map02_audit_activity_m82
             VALUES (491, 347, 'Customer Beneficiary Account Modified');

        INSERT INTO map02_audit_activity_m82
             VALUES (492, 348, 'Customer Beneficiary Account Status Changed');

        INSERT INTO map02_audit_activity_m82
             VALUES (495, 159, 'Margin Product Created');

        INSERT INTO map02_audit_activity_m82
             VALUES (496, 160, 'Margin Product Modified');

        INSERT INTO map02_audit_activity_m82
             VALUES (497, 161, 'Margin Product L1 Approved');

        INSERT INTO map02_audit_activity_m82
             VALUES (498, 161, 'Margin Product Status Changed');

        INSERT INTO map02_audit_activity_m82
             VALUES (499, 388, 'Customer Margin Trading Created');

        INSERT INTO map02_audit_activity_m82
             VALUES (500, 389, 'Customer Margin Trading Modified');

        INSERT INTO map02_audit_activity_m82
             VALUES (501, 390, 'Customer Margin Trading Status Changed');

        INSERT INTO map02_audit_activity_m82
             VALUES (504, 432, 'Cash Block Added');

        INSERT INTO map02_audit_activity_m82
             VALUES (505, 432, 'Cash Block Added');

        INSERT INTO map02_audit_activity_m82
             VALUES (506, 447, 'Holding Block');

        INSERT INTO map02_audit_activity_m82
             VALUES (508, 448, 'Holding Block Release');

        INSERT INTO map02_audit_activity_m82
             VALUES (512, 473, 'International Corporate Action Created');

        INSERT INTO map02_audit_activity_m82
             VALUES (
                        513,
                        475,
                        'International Corporate Action Status Changed');

        INSERT INTO map02_audit_activity_m82
             VALUES (514, 455, 'Corporate Action File Processed');

        INSERT INTO map02_audit_activity_m82
             VALUES (519, 323, 'Customer Orders Viewed');

        INSERT INTO map02_audit_activity_m82
             VALUES (520, 239, 'Customer Inquiry Searched');

        INSERT INTO map02_audit_activity_m82
             VALUES (
                        521,
                        475,
                        'International Corporate Action Status Changed');

        INSERT INTO map02_audit_activity_m82
             VALUES (532, 322, 'Customer Summary Viewed ');

        INSERT INTO map02_audit_activity_m82
             VALUES (540, 94, 'Executing Broker Commission Created');

        INSERT INTO map02_audit_activity_m82
             VALUES (544, 124, 'User Trading Group Changed');

        INSERT INTO map02_audit_activity_m82
             VALUES (545, 124, 'User Trading Group Changed');

        INSERT INTO map02_audit_activity_m82
             VALUES (548, 215, 'Charges Group Added');

        INSERT INTO map02_audit_activity_m82
             VALUES (549, 335, 'Customer Cash Account Modified');

        INSERT INTO map02_audit_activity_m82
             VALUES (550, 10007, 'Customer Change Account Request Added');

        INSERT INTO map02_audit_activity_m82
             VALUES (551, 339, 'Customer Trading Account Modified');

        INSERT INTO map02_audit_activity_m82
             VALUES (553, 561, 'Murabaha Contract Created');

        INSERT INTO map02_audit_activity_m82
             VALUES (602, 230, 'Exchange Instrument Type');

        INSERT INTO map02_audit_activity_m82
             VALUES (603, 173, 'Symbol Marginability Group Status Changed');

        INSERT INTO map02_audit_activity_m82
             VALUES (604, 518, 'VAT Invoice Generated');

        INSERT INTO map02_audit_activity_m82
             VALUES (608, 308, 'Custody Charges Group Created');

        INSERT INTO map02_audit_activity_m82
             VALUES (609, 309, 'Custody Charges Group Modified');

        INSERT INTO map02_audit_activity_m82
             VALUES (611, 64, 'Commission Discount Group Created');

        INSERT INTO map02_audit_activity_m82
             VALUES (612, 65, 'Commission Discount Group Modified');

        INSERT INTO map02_audit_activity_m82
             VALUES (613, 66, 'Commission Discount Group Status Changed');

        INSERT INTO map02_audit_activity_m82
             VALUES (614, 68, 'Commission Discount Structure Created');

        INSERT INTO map02_audit_activity_m82
             VALUES (615, 69, 'Commission Discount Structure Modified');

        INSERT INTO map02_audit_activity_m82
             VALUES (616, 70, 'Commission Discount Structure Status Changed');

        INSERT INTO map02_audit_activity_m82
             VALUES (617, 312, 'Custody Charges Group Slab Created');

        INSERT INTO map02_audit_activity_m82
             VALUES (618, 313, 'Custody Charges Group Slab Modified');

        INSERT INTO map02_audit_activity_m82
             VALUES (619, 315, 'Custody Charges Group Slab Status Changed');

        INSERT INTO map02_audit_activity_m82
             VALUES (623, 314, 'Custody Charges Group Slab Deleted');

        INSERT INTO map02_audit_activity_m82
             VALUES (624, 243, 'Market Maker Group add');

        INSERT INTO map02_audit_activity_m82
             VALUES (626, 245, 'Market Maker Group status change');

        INSERT INTO map02_audit_activity_m82
             VALUES (632, 10004, 'Paying Agent Config Added');

        INSERT INTO map02_audit_activity_m82
             VALUES (633, 10005, 'Paying Agent Config Modified');
    END IF;
END;
/

-- 1 Login [Not Available]
-- 2 Logout [Not Available]
-- 17, 219 Unlock [Not Available]
-- 21 Update Authentication Details [Not Available]
-- 22 Print Authentication Details [ Not Available]
-- 202 Customer Holdings - Set Avg. Cost [Not Available]
-- 217 Employee Password Changed [Not Available]
-- 218 Employee Password Reset [Not Available]
-- 225 Trading Limits Added [Not Available]
-- 294 Cash Transaction Approval Status Changed [Not Available]
-- 295 Pledge Added [Not Available]
-- 296 Pledg Release [Not Available]
-- 301 Pledge Request Status Changed [Not Available]
-- 303 Stock Transfer Approval Status Changed [Not Available]
-- 376 Report Generated [Not Available]
-- 376 Report Generated [Not Available]
-- 400 Margin Call Reminder Sent [Not Available]
-- 620 Holdings Bulk Transferred [Not Available]
-- 621 Holdings Bulk Transfer Approval Status Changed [Not Available]
-- 630 Offline Symols Price Update (Data Scope) [Not Available]
-- 640 Customer Investor Id Updated from Exchange [Not Available]

-- 19 Upgrade to Joint A/C [Feature Not Implemented]
-- 108 Book Keeper [Feature Not Implemented]
-- 170 Check PrintRequest Added [Feature Not Implemented]
-- 203 Buy Pending Removed [Feature Not Implemented]
-- 204 Sell Pending Removed [Feature Not Implemented]
-- 212 Entitlement Sensitive Level Changed [Feature Not Implemented]
-- 259 Family Member Added Feature Not Implemented]
-- 278 Symbol Allowed [Feature Not Implemented]
-- 279 Sector Restricted [Feature Not Implemented]
-- 280 Sector Allowed [Feature Not Implemented]
-- 283 Symbol Restriction Updated [Feature Not Implemented]
-- 377 Portfolio Details Viewed [Feature Not Implemented]
-- 378 Portfolio Details Exported to Excel [Feature Not Implemented]
-- 379 Lock Account [Feature Not Implemented]
-- 380 View High Grade Customers Portfolio [Feature Not Implemented]
-- 393 Margin Trading Collateral Type Added [Feature Not Implemented]
-- 395 Margin Trading Collateral Type Status Changed [Feature Not Implemented]
-- 314 Trading Limit Request Approval Status Changed [Feature Not Implemented]
-- 503 Trade Symbol Mapped with Price Symbol [Feature Not Implemented]
-- 533 Deposit Withdraw Status [Feature Not Implemented]
-- 547 Approval Reject [Feature Not Implemented]
-- 552 Customer Information System (CIS) Request [Feature Not Implemented]
-- 554 Create / Edit IPO Symbol Restriction [Feature Not Implemented]

-- 29  New Order [Should go to Order Audit]
-- 30  Amend Order [Should go to Order Audit]
-- 31  Cancel Order [Should go to Order Audit]
-- 32  Approve Order [Should go to Order Audit]
-- 33  Expire Order [Should go to Order Audit]
-- 34  Reverse Order [Should go to Order Audit]
-- 35  Reject Order [Should go to Order Audit]
-- 304 Order Status Changed [Should go to Order Audit]
-- 381 Manual Order Execution [Should go to Order Audit]
-- 509 Update Order Internal Status [Should go to Order Audit]
-- 510 Order Value Adjustment [Should go to Order Audit]
-- 517 Exercise Order [Should go to Order Audit]
-- 518 Assign Order [Should go to Order Audit]
-- 524 Order Value Adjustment - Price [Should go to Order Audit]
-- 525 Order Value Adjustment - Commision [Should go to Order Audit]
-- 527 Order Value Adjustment - Broker Commision [Should go to Order Audit]
-- 528 Order Value Adjustment - FX Rate [Should go to Order Audit]
-- 529 Order Value Adjustment - Trade Date [Should go to Order Audit]
-- 530 Order Value Adjustment - Settlement Date [Should go to Order Audit]
-- 543 Order Value Adjustment - Accrued Interest [Should go to Order Audit]

-- 534 Non-Margin Interest Rate Created [Not Required]
-- 535 Non-Margin Interest Rate Updated [Not Required]
-- 536 Non-Margin Interest Rate Status Changed [Not Required]
-- 541 Commission Type Added [Not Required]
-- 542 Commission Type Modified [Not Required]
-- 556 Symbol Suspend Price Updates [Not Required]
-- 605 Broker Account Add [Not Required]
-- 606 Broker Account Edit [Not Required]
-- 622 Broker Account Status Changed [Not Required]
-- 627 ASL Group Added [Not Required]
-- 628 ASL Group Edited [Not Required]
-- 629 ASL Group Deleted [Not Required]
-- 635 Bank Account currency Set as Default [Not Required]
-- 636 OMS Servers for Customer [Not Required]
-- 637 CCP Account Number Created [Not Required]
-- 639 CCP Account Number Set as Default [Not Required]

  /* Query to chck any missed items other than above
  
  SELECT *
    FROM mubasher_oms.m57_aud_activity@mubasher_db_link m57
   WHERE     m57_id IN
                 (SELECT DISTINCT t22.t22_activity_id
                    FROM mubasher_oms.t22_audit@mubasher_db_link t22,
                         map02_audit_activity_m82 map02
                   WHERE     t22.t22_activity_id = map02.map02_oms_id(+)
                         AND map02.map02_ntp_id IS NULL)
         AND m57_id NOT IN
                 (1,
                  2,
                  17,
                  219,
                  21,
                  22,
                  202,
                  217,
                  218,
                  225,
                  294,
                  295,
                  296,
                  301,
                  303,
                  376,
                  376,
                  400,
                  620,
                  621,
                  630,
                  640,
                  19,
                  108,
                  170,
                  203,
                  204,
                  212,
                  259,
                  278,
                  279,
                  280,
                  283,
                  377,
                  378,
                  379,
                  380,
                  393,
                  395,
                  314,
                  503,
                  533,
                  547,
                  552,
                  554,
                  29,
                  30,
                  31,
                  32,
                  33,
                  34,
                  35,
                  304,
                  381,
                  509,
                  510,
                  517,
                  518,
                  524,
                  525,
                  527,
                  528,
                  529,
                  530,
                  543,
                  534,
                  535,
                  536,
                  541,
                  542,
                  556,
                  605,
                  606,
                  622,
                  627,
                  628,
                  629,
                  635,
                  636,
                  637,
                  639)
ORDER BY m57_id;
*/