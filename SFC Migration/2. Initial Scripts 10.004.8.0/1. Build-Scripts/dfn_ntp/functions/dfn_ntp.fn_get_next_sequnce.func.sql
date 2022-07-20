CREATE OR REPLACE FUNCTION dfn_ntp.fn_get_next_sequnce (
    pseq_name IN VARCHAR2)
    RETURN NUMBER
IS
    next_sequnce   NUMBER DEFAULT -1;
    PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
    UPDATE app_seq_store
       SET app_seq_value = app_seq_value + 1
     WHERE app_seq_name = pseq_name;

    SELECT app_seq_value
      INTO next_sequnce
      FROM app_seq_store
     WHERE app_seq_name = pseq_name;

    COMMIT;

    RETURN next_sequnce;
END;
/