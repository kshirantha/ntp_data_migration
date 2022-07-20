---------------------- For 10.004.9.0 Patch Release ----------------------

DELETE FROM dfn_ntp.v01_system_master_data
      WHERE v01_type = 86 AND v01_id > 2000;

INSERT INTO dfn_ntp.v01_system_master_data (v01_id,v01_description,v01_description_lang,v01_type,v01_type_description,v01_feature_id_v14) 
VALUES(2001,'TYPE A','TYPE A',86,'Customer Category',NULL);
INSERT INTO dfn_ntp.v01_system_master_data (v01_id,v01_description,v01_description_lang,v01_type,v01_type_description,v01_feature_id_v14) 
VALUES(2002,'TYPE B','TYPE B',86,'Customer Category',NULL);
INSERT INTO dfn_ntp.v01_system_master_data (v01_id,v01_description,v01_description_lang,v01_type,v01_type_description,v01_feature_id_v14) 
VALUES(2003,'TYPE C','TYPE C',86,'Customer Category',NULL);
INSERT INTO dfn_ntp.v01_system_master_data (v01_id,v01_description,v01_description_lang,v01_type,v01_type_description,v01_feature_id_v14) 
VALUES(2004,'TYPE D','TYPE D',86,'Customer Category',NULL);
INSERT INTO dfn_ntp.v01_system_master_data (v01_id,v01_description,v01_description_lang,v01_type,v01_type_description,v01_feature_id_v14) 
VALUES(2005,'TYPE E','TYPE E',86,'Customer Category',NULL);
INSERT INTO dfn_ntp.v01_system_master_data (v01_id,v01_description,v01_description_lang,v01_type,v01_type_description,v01_feature_id_v14) 
VALUES(2006,'TYPE E','TYPE E',86,'Customer Category',NULL);
INSERT INTO dfn_ntp.v01_system_master_data (v01_id,v01_description,v01_description_lang,v01_type,v01_type_description,v01_feature_id_v14) 
VALUES(2007,'SWAP','SWAP',86,'Customer Category',NULL);
INSERT INTO dfn_ntp.v01_system_master_data (v01_id,v01_description,v01_description_lang,v01_type,v01_type_description,v01_feature_id_v14) 
VALUES(2008,'SWAP A','SWAP A',86,'Customer Category',NULL);
INSERT INTO dfn_ntp.v01_system_master_data (v01_id,v01_description,v01_description_lang,v01_type,v01_type_description,v01_feature_id_v14) 
VALUES(2009,'SWAP 15','SWAP 15',86,'Customer Category',NULL);
INSERT INTO dfn_ntp.v01_system_master_data (v01_id,v01_description,v01_description_lang,v01_type,v01_type_description,v01_feature_id_v14) 
VALUES(2010,'SWAP 15.5','SWAP 15.5',86,'Customer Category',NULL);
INSERT INTO dfn_ntp.v01_system_master_data (v01_id,v01_description,v01_description_lang,v01_type,v01_type_description,v01_feature_id_v14) 
VALUES(2011,'SWAP 16.5','SWAP 16.5',86,'Customer Category',NULL);
INSERT INTO dfn_ntp.v01_system_master_data (v01_id,v01_description,v01_description_lang,v01_type,v01_type_description,v01_feature_id_v14) 
VALUES(2012,'SWAP 17','SWAP 17',86,'Customer Category',NULL);
INSERT INTO dfn_ntp.v01_system_master_data (v01_id,v01_description,v01_description_lang,v01_type,v01_type_description,v01_feature_id_v14) 
VALUES(2013,'SWAP 17.5','SWAP 17.5',86,'Customer Category',NULL);
INSERT INTO dfn_ntp.v01_system_master_data (v01_id,v01_description,v01_description_lang,v01_type,v01_type_description,v01_feature_id_v14) 
VALUES(2014,'SWAP 18','SWAP 18',86,'Customer Category',NULL);
INSERT INTO dfn_ntp.v01_system_master_data (v01_id,v01_description,v01_description_lang,v01_type,v01_type_description,v01_feature_id_v14) 
VALUES(2015,'SWAP 19','SWAP 19',86,'Customer Category',NULL);
INSERT INTO dfn_ntp.v01_system_master_data (v01_id,v01_description,v01_description_lang,v01_type,v01_type_description,v01_feature_id_v14) 
VALUES(2016,'SWAP 20','SWAP 20',86,'Customer Category',NULL);
INSERT INTO dfn_ntp.v01_system_master_data (v01_id,v01_description,v01_description_lang,v01_type,v01_type_description,v01_feature_id_v14) 
VALUES(2017,'SWAP 22','SWAP 22',86,'Customer Category',NULL);
INSERT INTO dfn_ntp.v01_system_master_data (v01_id,v01_description,v01_description_lang,v01_type,v01_type_description,v01_feature_id_v14) 
VALUES(2018,'SWAP 22.5','SWAP 22.5',86,'Customer Category',NULL);
INSERT INTO dfn_ntp.v01_system_master_data (v01_id,v01_description,v01_description_lang,v01_type,v01_type_description,v01_feature_id_v14) 
VALUES(2019,'SWAP 24','SWAP 24',86,'Customer Category',NULL);
INSERT INTO dfn_ntp.v01_system_master_data (v01_id,v01_description,v01_description_lang,v01_type,v01_type_description,v01_feature_id_v14) 
VALUES(2020,'SWAP 30','SWAP 30',86,'Customer Category',NULL);
INSERT INTO dfn_ntp.v01_system_master_data (v01_id,v01_description,v01_description_lang,v01_type,v01_type_description,v01_feature_id_v14) 
VALUES(2021,'SWAP 80','SWAP 80',86,'Customer Category',NULL);
INSERT INTO dfn_ntp.v01_system_master_data (v01_id,v01_description,v01_description_lang,v01_type,v01_type_description,v01_feature_id_v14) 
VALUES(2022,'PASSPORT - SWAP','PASSPORT - SWAP',86,'Customer Category',NULL);
INSERT INTO dfn_ntp.v01_system_master_data (v01_id,v01_description,v01_description_lang,v01_type,v01_type_description,v01_feature_id_v14) 
VALUES(2023,'BLOMINVEST - SWAP','BLOMINVEST - SWAP',86,'Customer Category',NULL);
INSERT INTO dfn_ntp.v01_system_master_data (v01_id,v01_description,v01_description_lang,v01_type,v01_type_description,v01_feature_id_v14) 
VALUES(2024,'35 BPS','35 BPS',86,'Customer Category',NULL);
INSERT INTO dfn_ntp.v01_system_master_data (v01_id,v01_description,v01_description_lang,v01_type,v01_type_description,v01_feature_id_v14) 
VALUES(2025,'55 BPS','55 BPS',86,'Customer Category',NULL);
INSERT INTO dfn_ntp.v01_system_master_data (v01_id,v01_description,v01_description_lang,v01_type,v01_type_description,v01_feature_id_v14) 
VALUES(2026,'70 BPS','70 BPS',86,'Customer Category',NULL);
INSERT INTO dfn_ntp.v01_system_master_data (v01_id,v01_description,v01_description_lang,v01_type,v01_type_description,v01_feature_id_v14) 
VALUES(2027,'120 BPS','120 BPS',86,'Customer Category',NULL);
INSERT INTO dfn_ntp.v01_system_master_data (v01_id,v01_description,v01_description_lang,v01_type,v01_type_description,v01_feature_id_v14) 
VALUES(2028,'ALGO','ALGO',86,'Customer Category',NULL);
INSERT INTO dfn_ntp.v01_system_master_data (v01_id,v01_description,v01_description_lang,v01_type,v01_type_description,v01_feature_id_v14) 
VALUES(2029,'VIP','VIP',86,'Customer Category',NULL);
INSERT INTO dfn_ntp.v01_system_master_data (v01_id,v01_description,v01_description_lang,v01_type,v01_type_description,v01_feature_id_v14) 
VALUES(2030,'INB','INB',86,'Customer Category',NULL);
INSERT INTO dfn_ntp.v01_system_master_data (v01_id,v01_description,v01_description_lang,v01_type,v01_type_description,v01_feature_id_v14) 
VALUES(2031,'PWC','PWC',86,'Customer Category',NULL);
INSERT INTO dfn_ntp.v01_system_master_data (v01_id,v01_description,v01_description_lang,v01_type,v01_type_description,v01_feature_id_v14) 
VALUES(2032,'IBO','IBO',86,'Customer Category',NULL);
INSERT INTO dfn_ntp.v01_system_master_data (v01_id,v01_description,v01_description_lang,v01_type,v01_type_description,v01_feature_id_v14) 
VALUES(2033,'STAFF SFC','STAFF SFC',86,'Customer Category',NULL);
INSERT INTO dfn_ntp.v01_system_master_data (v01_id,v01_description,v01_description_lang,v01_type,v01_type_description,v01_feature_id_v14) 
VALUES(2034,'REFERRAL','REFERRAL',86,'Customer Category',NULL);

COMMIT;