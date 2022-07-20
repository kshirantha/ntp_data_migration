CREATE OR REPLACE FUNCTION dfn_ntp.fn_get_txn_code_id (
    p_txn_code IN VARCHAR2)
    RETURN NUMBER
IS
    l_txn_id   NUMBER;
BEGIN
    SELECT m97_id
      INTO l_txn_id
      FROM m97_transaction_codes
     WHERE m97_code = p_txn_code;

    RETURN l_txn_id;
END;
/
/
