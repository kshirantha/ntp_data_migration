UPDATE m39_broker_exec_broker_map m39
   SET m39.m39_exchange = 'KSE'
 WHERE m39.m39_exchange = 'KUW';

UPDATE m39_broker_exec_broker_map m39
   SET m39.m39_exchange = 'ADSM'
 WHERE m39.m39_exchange = 'ADX';

COMMIT;