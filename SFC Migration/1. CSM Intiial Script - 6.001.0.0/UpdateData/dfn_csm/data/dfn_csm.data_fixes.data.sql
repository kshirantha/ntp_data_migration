INSERT INTO dfn_csm.s01_db_jobs (S01_ID,S01_JOB_NAME,S01_JOB_DESCRIPTION,S01_DEPENDANCY_JOB_ID,S01_LAST_SUCCESS_DATE) 
VALUES(1,'POPULATE_EXECUTION_TABLE','Populate execution table at 3.45 p.m',-1,NULL);

INSERT INTO dfn_csm.m02_margin_types (M02_ID,M02_MARGIN_TYPE,M02_DESCRIPTION) 
VALUES(201,'adjustedCollateralCash',NULL);
INSERT INTO dfn_csm.m02_margin_types (M02_ID,M02_MARGIN_TYPE,M02_DESCRIPTION) 
VALUES(202,'cashCollateralLimit',NULL);
INSERT INTO dfn_csm.m02_margin_types (M02_ID,M02_MARGIN_TYPE,M02_DESCRIPTION) 
VALUES(203,'collateralCash',NULL);
INSERT INTO dfn_csm.m02_margin_types (M02_ID,M02_MARGIN_TYPE,M02_DESCRIPTION) 
VALUES(204,'collateralCashAfterSettlement',NULL);
INSERT INTO dfn_csm.m02_margin_types (M02_ID,M02_MARGIN_TYPE,M02_DESCRIPTION) 
VALUES(205,'collateralNoncash',NULL);
INSERT INTO dfn_csm.m02_margin_types (M02_ID,M02_MARGIN_TYPE,M02_DESCRIPTION) 
VALUES(206,'directCreditLimit',NULL);
INSERT INTO dfn_csm.m02_margin_types (M02_ID,M02_MARGIN_TYPE,M02_DESCRIPTION) 
VALUES(207,'extCreditDebitMargin',NULL);
INSERT INTO dfn_csm.m02_margin_types (M02_ID,M02_MARGIN_TYPE,M02_DESCRIPTION) 
VALUES(208,'extCreditDebitSettlement',NULL);
INSERT INTO dfn_csm.m02_margin_types (M02_ID,M02_MARGIN_TYPE,M02_DESCRIPTION) 
VALUES(209,'externalMarginReq',NULL);
INSERT INTO dfn_csm.m02_margin_types (M02_ID,M02_MARGIN_TYPE,M02_DESCRIPTION) 
VALUES(210,'marginDefaultFund',NULL);
INSERT INTO dfn_csm.m02_margin_types (M02_ID,M02_MARGIN_TYPE,M02_DESCRIPTION) 
VALUES(211,'marginDefaultFundAddon',NULL);
INSERT INTO dfn_csm.m02_margin_types (M02_ID,M02_MARGIN_TYPE,M02_DESCRIPTION) 
VALUES(212,'marginExtraordinary',NULL);
INSERT INTO dfn_csm.m02_margin_types (M02_ID,M02_MARGIN_TYPE,M02_DESCRIPTION) 
VALUES(213,'marginMaintenance',NULL);
INSERT INTO dfn_csm.m02_margin_types (M02_ID,M02_MARGIN_TYPE,M02_DESCRIPTION) 
VALUES(214,'marginMutualFund',NULL);
INSERT INTO dfn_csm.m02_margin_types (M02_ID,M02_MARGIN_TYPE,M02_DESCRIPTION) 
VALUES(215,'marginTotal',NULL);
INSERT INTO dfn_csm.m02_margin_types (M02_ID,M02_MARGIN_TYPE,M02_DESCRIPTION) 
VALUES(216,'marginTotalBaseCur',NULL);
INSERT INTO dfn_csm.m02_margin_types (M02_ID,M02_MARGIN_TYPE,M02_DESCRIPTION) 
VALUES(217,'settlementRequirement',NULL);
INSERT INTO dfn_csm.m02_margin_types (M02_ID,M02_MARGIN_TYPE,M02_DESCRIPTION) 
VALUES(218,'totalCollateralValue',NULL);
INSERT INTO dfn_csm.m02_margin_types (M02_ID,M02_MARGIN_TYPE,M02_DESCRIPTION) 
VALUES(219,'totalCollateralValueBaseCur',NULL);
INSERT INTO dfn_csm.m02_margin_types (M02_ID,M02_MARGIN_TYPE,M02_DESCRIPTION) 
VALUES(220,'totalExtCreditDebit',NULL);
INSERT INTO dfn_csm.m02_margin_types (M02_ID,M02_MARGIN_TYPE,M02_DESCRIPTION) 
VALUES(221,'totalMarginReq',NULL);
INSERT INTO dfn_csm.m02_margin_types (M02_ID,M02_MARGIN_TYPE,M02_DESCRIPTION) 
VALUES(222,'totalSurplusDeficit',NULL);
INSERT INTO dfn_csm.m02_margin_types (M02_ID,M02_MARGIN_TYPE,M02_DESCRIPTION) 
VALUES(223,'totalSurplusDeficitBaseCur',NULL);
INSERT INTO dfn_csm.m02_margin_types (M02_ID,M02_MARGIN_TYPE,M02_DESCRIPTION) 
VALUES(224,'totalSurplusDeficitBaseCurAfterFxHaircut',NULL);
INSERT INTO dfn_csm.m02_margin_types (M02_ID,M02_MARGIN_TYPE,M02_DESCRIPTION) 
VALUES(500,'fxPercentageAfterHaircut (information)',NULL);
INSERT INTO dfn_csm.m02_margin_types (M02_ID,M02_MARGIN_TYPE,M02_DESCRIPTION) 
VALUES(301,'extCreditDebitMinCashReq',NULL);
INSERT INTO dfn_csm.m02_margin_types (M02_ID,M02_MARGIN_TYPE,M02_DESCRIPTION) 
VALUES(302,'totalCollateralValueCashBaseCu',NULL);
INSERT INTO dfn_csm.m02_margin_types (M02_ID,M02_MARGIN_TYPE,M02_DESCRIPTION) 
VALUES(303,'totalRequiredCashBaseCur',NULL);
INSERT INTO dfn_csm.m02_margin_types (M02_ID,M02_MARGIN_TYPE,M02_DESCRIPTION) 
VALUES(304,'totalSurplusDeficitCashBaseCur',NULL);
INSERT INTO dfn_csm.m02_margin_types (M02_ID,M02_MARGIN_TYPE,M02_DESCRIPTION) 
VALUES(401,'grandTotalSurplusDeficitBaseCur',NULL);
INSERT INTO dfn_csm.m02_margin_types (M02_ID,M02_MARGIN_TYPE,M02_DESCRIPTION) 
VALUES(402,'grandTotalSurplusDeficitBaseCurAfterFxHaircut',NULL);
INSERT INTO dfn_csm.m02_margin_types (M02_ID,M02_MARGIN_TYPE,M02_DESCRIPTION) 
VALUES(601,'grandTotalAccRiskRatioBaseCur',NULL);
INSERT INTO dfn_csm.m02_margin_types (M02_ID,M02_MARGIN_TYPE,M02_DESCRIPTION) 
VALUES(602,'grandTotalCollateralValueBaseCur',NULL);
INSERT INTO dfn_csm.m02_margin_types (M02_ID,M02_MARGIN_TYPE,M02_DESCRIPTION) 
VALUES(603,'grandTotalMarginTotalBaseCur',NULL);
INSERT INTO dfn_csm.m02_margin_types (M02_ID,M02_MARGIN_TYPE,M02_DESCRIPTION) 
VALUES(701,'grandTotalCollateralValueCashBaseCur',NULL);
INSERT INTO dfn_csm.m02_margin_types (M02_ID,M02_MARGIN_TYPE,M02_DESCRIPTION) 
VALUES(702,'grandTotalRequiredCashBaseCur',NULL);
INSERT INTO dfn_csm.m02_margin_types (M02_ID,M02_MARGIN_TYPE,M02_DESCRIPTION) 
VALUES(703,'grandTotalSurplusDeficitCashBaseCur',NULL);
INSERT INTO dfn_csm.m02_margin_types (M02_ID,M02_MARGIN_TYPE,M02_DESCRIPTION) 
VALUES(801,'totalExtCreditDebit',NULL);

INSERT INTO dfn_csm.m06_collateral_amount_type (M06_ID,M06_AMOUNT_TYPE,M06_DESCRIPTION) 
VALUES(1,'MarketValue',NULL);
INSERT INTO dfn_csm.m06_collateral_amount_type (M06_ID,M06_AMOUNT_TYPE,M06_DESCRIPTION) 
VALUES(2,'CollValueInsCurrBeforeLimitAdjust',NULL);
INSERT INTO dfn_csm.m06_collateral_amount_type (M06_ID,M06_AMOUNT_TYPE,M06_DESCRIPTION) 
VALUES(3,'CollValueInsCurrAfterLimitAdjust',NULL);
INSERT INTO dfn_csm.m06_collateral_amount_type (M06_ID,M06_AMOUNT_TYPE,M06_DESCRIPTION) 
VALUES(4,'CollValueBaseCurrBeforeLimitAdjust',NULL);
INSERT INTO dfn_csm.m06_collateral_amount_type (M06_ID,M06_AMOUNT_TYPE,M06_DESCRIPTION) 
VALUES(5,'CollValueBaseCurrAfterLimitAdjust',NULL);

MERGE INTO dfn_csm.m04_aud_activity
     USING DUAL
        ON (m04_id = 1)
WHEN NOT MATCHED
THEN
    INSERT     (m04_id,
                m04_activity_name)
        VALUES (1,
                'Margin Requirement Request Created')
/

MERGE INTO dfn_csm.m04_aud_activity
     USING DUAL
        ON (m04_id = 2)
WHEN NOT MATCHED
THEN
    INSERT     (m04_id,
                m04_activity_name)
        VALUES (2,
                'Collateral Inquiry Request Created')
/

MERGE INTO dfn_csm.m04_aud_activity
     USING DUAL
        ON (m04_id = 3)
WHEN NOT MATCHED
THEN
    INSERT     (m04_id,
                m04_activity_name)
        VALUES (3,
                'Collateral Assignment Request Created')
/

MERGE INTO dfn_csm.m04_aud_activity
     USING DUAL
        ON (m04_id = 4)
WHEN NOT MATCHED
THEN
    INSERT     (m04_id,
                m04_activity_name)
        VALUES (4,
                'Settlement Position Request Created')
/

MERGE INTO dfn_csm.m04_aud_activity
     USING DUAL
        ON (m04_id = 5)
WHEN NOT MATCHED
THEN
    INSERT     (m04_id,
                m04_activity_name)
        VALUES (5,
                'Trade Rectification Updated')
/

MERGE INTO dfn_csm.m04_aud_activity
     USING DUAL
        ON (m04_id = 6)
WHEN NOT MATCHED
THEN
    INSERT     (m04_id,
                m04_activity_name)
        VALUES (6,
                'Trade Capture Request Created')
/

MERGE INTO dfn_csm.m04_aud_activity
     USING DUAL
        ON (m04_id = 7)
WHEN NOT MATCHED
THEN
    INSERT     (m04_id,
                m04_activity_name)
        VALUES (7,
                'Margin Requirement Request Status Changed')
/

MERGE INTO dfn_csm.m04_aud_activity
     USING DUAL
        ON (m04_id = 8)
WHEN NOT MATCHED
THEN
    INSERT     (m04_id,
                m04_activity_name)
        VALUES (8,
                'Collateral Inquiry Request Status Changed')
/

MERGE INTO dfn_csm.m04_aud_activity
     USING DUAL
        ON (m04_id = 9)
WHEN NOT MATCHED
THEN
    INSERT     (m04_id,
                m04_activity_name)
        VALUES (9,
                'Collateral Assignment Request Status Changed')
/

MERGE INTO dfn_csm.m04_aud_activity
     USING DUAL
        ON (m04_id = 10)
WHEN NOT MATCHED
THEN
    INSERT     (m04_id,
                m04_activity_name)
        VALUES (10,
                'Settlement Position Request Status Changed')
/

MERGE INTO dfn_csm.m04_aud_activity
     USING DUAL
        ON (m04_id = 11)
WHEN NOT MATCHED
THEN
    INSERT     (m04_id,
                m04_activity_name)
        VALUES (11,
                'Trade Rectification Status Changed')
/

MERGE INTO dfn_csm.m04_aud_activity
     USING DUAL
        ON (m04_id = 12)
WHEN NOT MATCHED
THEN
    INSERT     (m04_id,
                m04_activity_name)
        VALUES (12,
                'Trade Capture Request Status Changed')
/

INSERT INTO dfn_csm.m01_trading_sessions (M01_ID,M01_SESSION_CODE,M01_LAST_EOD_DATE,M01_ACTIVE_SESSION_ID,M01_LAST_OPEN_DATE,M01_SESSION_CONNECT_STATUS,M01_SESSION_LOGIN_STATUS) 
VALUES(1,'EDDA',NULL,NULL,NULL,-1,-1);

INSERT INTO dfn_csm.m01_trading_sessions (M01_ID,M01_SESSION_CODE,M01_LAST_EOD_DATE,M01_ACTIVE_SESSION_ID,M01_LAST_OPEN_DATE,M01_SESSION_CONNECT_STATUS,M01_SESSION_LOGIN_STATUS) 
VALUES(2,'MUQASSA',NULL,NULL,NULL,-1,-1);


MERGE INTO dfn_csm.m04_aud_activity
     USING DUAL
        ON (m04_id = 13)
WHEN NOT MATCHED
THEN
    INSERT     (m04_id, m04_activity_name)
        VALUES (13, 'Pledge Request')
/

 COMMIT; 
 
