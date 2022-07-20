CREATE OR REPLACE 
PROCEDURE dfn_ntp.sp_oms_txn_entry_persist_bulk (
    p_t09_audit_key      t09_txn_single_entry_v3.t09_audit_key%TYPE,
    action_type       IN VARCHAR)
IS
    p_tr_status    NUMBER;
    tranid         VARCHAR (20);
    is_red_async   VARCHAR (5);
BEGIN
    DECLARE
        CURSOR c_t09_txn_single_entry
        IS
            SELECT t09.*
              FROM (SELECT s.*
                      FROM dfn_ntp.t09_txn_single_entry_v3 s
                     WHERE t09_bulk_id = p_t09_audit_key) t09;
    BEGIN
        ---------------------------------------PROCESS BULK OPERATION--------------------------------------------
        IF action_type IN ('1')
        THEN
            FOR t09c IN c_t09_txn_single_entry
            LOOP
                BEGIN
                    --------------------------BULK CASH TRANSACTION UPDATE---------------------------------------
                    IF (t09c.t09_update_impact_code IN ('2'))
                    THEN
                        --------------------------CALL FOR REDISTRIBUTION----------------------------------------
                        BEGIN
                            sp_reditribution_single_row (t09c.t09_audit_key);
                        END;

                        --------------------------T06 CASH TRANSACTION ENTRY GENERATE----------------------------
                        BEGIN
                            sp_cash_transaction_generate (t09c);
                        END;

                        --------------------------AO9/A06 AUDIT ENTRY GENERATE-----------------------------------
                        BEGIN
                            IF (   t09c.t09_txn_code != 'CSHTRN'
                                OR (    t09c.t09_txn_code = 'CSHTRN'
                                    AND t09c.t09_transfer_side = '1'))
                            THEN
                                sp_oms_log_entry_persist (
                                    t09c.t09_cash_txn_id,
                                    t09c.t09_update_impact_code,
                                    t09c.t09_txn_type,
                                    '2',
                                    action_type);
                            END IF;
                        END;

                        --------------------------BULK TRANSACTION STATUS UPDATE---------------------------------
                        BEGIN
                            sp_bulk_status_update (
                                t09c.t09_update_impact_code,
                                t09c.t09_reference_type,
                                t09c.t09_txn_refrence_id,
                                t09c.t09_approved_by_id_u17);
                        END;
                    --------------------------BULK HOLDING TRANSACTION UPDATE------------------------------------
                    ELSIF (t09c.t09_update_impact_code IN ('3'))
                    THEN
                        --------------------------CALL FOR REDISTRIBUTION----------------------------------------
                        BEGIN
                            sp_reditribution_single_row (t09c.t09_audit_key);
                        END;

                        --------------------------T06 CASH TRANSACTION ENTRY GENERATE----------------------------
                        BEGIN
                            IF (   t09c.t09_txn_code = 'PLGIN'
                                OR t09c.t09_txn_code = 'PLGOUT')
                            THEN
                                sp_pledge_transaction_generate (t09c);
                            ELSE
                                sp_stock_transaction_generate (t09c);
                            END IF;
                        END;

                        --------------------------AO9/A06 AUDIT ENTRY GENERATE-----------------------------------

                        BEGIN
                            IF (   t09c.t09_txn_code = 'PLGIN'
                                OR t09c.t09_txn_code = 'PLGOUT')
                            THEN
                                sp_oms_log_entry_persist (
                                    t09c.t09_holding_txn_id,
                                    t09c.t09_update_impact_code,
                                    t09c.t09_txn_type,
                                    '3',
                                    action_type);
                            ELSE
                                IF (   t09c.t09_txn_code != 'HLDTRN'
                                    OR (    t09c.t09_txn_code = 'HLDTRN'
                                        AND t09c.t09_transfer_side = '1'))
                                THEN
                                    sp_oms_log_entry_persist (
                                        t09c.t09_holding_txn_id,
                                        t09c.t09_update_impact_code,
                                        t09c.t09_txn_type,
                                        '1',
                                        action_type);
                                END IF;
                            END IF;
                        END;


                        --------------------------BULK TRANSACTION STATUS UPDATE----------------------------------
                        BEGIN
                            sp_bulk_status_update (
                                t09c.t09_update_impact_code,
                                t09c.t09_reference_type,
                                t09c.t09_txn_refrence_id,
                                t09c.t09_approved_by_id_u17);
                        END;
                    END IF;
                END;
            END LOOP;
        ---------------------------------------PROCESS NON BULK OPERATION-----------------------------------------
        ELSIF action_type IN ('2')
        THEN
            FOR t09c IN c_t09_txn_single_entry
            LOOP
                BEGIN
                    sp_reditribution_single_row (t09c.t09_audit_key);
                END;
            END LOOP;
        END IF;
    END;
END;
/

