UPDATE t17_pending_pledge t17
   SET t17.t17_transaction_number = NULL
 WHERE UPPER (t17.t17_transaction_number) = 'NULL';

COMMIT;