CREATE OR REPLACE 
PROCEDURE dfn_ntp.sp_oms_log_entry_persist (txn_id        IN VARCHAR,
                                    impact_type   IN VARCHAR,
                                    txn_type      IN NUMBER,
                                    select_type   IN VARCHAR,
                                    action_type   IN VARCHAR)
IS
    audit_type       NUMBER (7) := 0;
    description      VARCHAR2 (2000);
    l_reference_no   VARCHAR2 (200);
BEGIN
    DECLARE
        CURSOR c_txn_single_entry
        IS
            SELECT t09.*
              FROM (SELECT t12.t12_id AS id,
                           t12.t12_status_id_v01 AS status,
                           t12.t12_last_changed_by_id_u17
                               AS last_changed_by_id_u17,
                           t12.t12_narration AS narration,
                           t12.t12_reject_reason AS reject_reason,
                           t12.t12_channel_id_v29 AS channel_id_v29,
                           t12.t12_function_id_m88 AS functiona_id,
                           t12.t12_code_m97 AS function_name,
                           t12.t12_customer_id_u01 AS customer_id_u01,
                           0 AS customer_login_u09,
                           t12.t12_ip AS user_ip,
                           '' AS connected_machine,
                           t12.t12_inst_id_m02 AS inst_id_m02,
                           u07_acc_name.u07_display_name AS acc_name,
                           u07_to_acc_name.u07_display_name AS to_acc_name,
                           NULL AS benificiary_name
                      FROM t12_share_transaction t12
                           LEFT JOIN u07_trading_account u07_acc_name
                               ON u07_acc_name.u07_id =
                                      t12.t12_trading_acc_id_u07
                           LEFT JOIN u07_trading_account u07_to_acc_name
                               ON u07_to_acc_name.u07_id =
                                      t12.t12_trading_acc_id_u07
                     WHERE t12.t12_id = txn_id AND select_type = '1'
                    UNION ALL
                    SELECT t06.t06_id AS id,
                           t06.t06_status_id AS status,
                           t06.t06_last_changed_by_id_u17
                               AS last_changed_by_id_u17,
                           t06.t06_narration AS narration,
                           t06.t06_reject_reason AS reject_reason,
                           t06.t06_client_channel_id_v29 AS channel_id_v29,
                           t06_function_id_m88 AS functiona_id,
                           t06.t06_code AS function_name,
                           '' AS customer_id_u01,
                           t06.t06_sub_login_id_u09 AS customer_login_u09,
                           t06.t06_ip AS user_ip,
                           '' AS connected_machine,
                           t06.t06_institute_id_m02 AS inst_id_m02,
                           u06_acc_name.u06_display_name AS acc_name,
                           u06_to_acc_name.u06_display_name AS to_acc_name,
                           u08_beneficiary.u08_account_name
                               AS benificiary_name
                      FROM t06_cash_transaction t06
                           LEFT JOIN u06_cash_account u06_acc_name
                               ON u06_acc_name.u06_id =
                                      t06.t06_cash_acc_id_u06
                           LEFT JOIN u06_cash_account u06_to_acc_name
                               ON u06_to_acc_name.u06_id =
                                      t06.t06_to_cash_acc_id
                           LEFT JOIN u08_customer_beneficiary_acc u08_beneficiary
                               ON u08_beneficiary.u08_id =
                                      t06.t06_beneficiary_id_u08
                     WHERE t06.t06_id = txn_id AND select_type = '2'
                    UNION ALL
                    SELECT t20.t20_id AS id,
                           t20.t20_status_id_v01 AS status,
                           t20.t20_last_changed_by_id_u17
                               AS last_changed_by_id_u17,
                           t20.t20_narration AS narration,
                           t20.t20_reject_reason AS reject_reason,
                           t20.t20_channel_id_v29 AS channel_id_v29,
                           t20.t20_function_id_m88 AS functiona_id,
                           t20.t20_code_m97 AS function_name,
                           t20.t20_customer_id_u01 AS customer_id_u01,
                           0 AS customer_login_u09,
                           t20_ip AS user_ip,
                           '' AS connected_machine,
                           t20.t20_institution_id AS inst_id_m02,
                           NULL AS acc_name,
                           NULL AS to_acc_name,
                           NULL AS benificiary_name
                      FROM t20_pending_pledge t20
                     WHERE t20.t20_id = txn_id AND select_type = '3') t09;
    BEGIN
        FOR i IN c_txn_single_entry
        LOOP
            --------------------------- GENERATE A09 LOG ENTRY --------------------------------------
            -----------------------------------------------------------------------------------------

            INSERT INTO a09_function_approval_log (a09_id,
                                                   a09_function_id_m88,
                                                   a09_function_name_m88,
                                                   a09_request_id,
                                                   a09_status_id_v01,
                                                   a09_action_by_id_u17,
                                                   a09_action_date,
                                                   a09_created_by_id_u17,
                                                   a09_created_date,
                                                   a09_narration,
                                                   a09_reject_reason)
                 VALUES (0, --a09_id (OMS Persisting Entries Set As 0),
                         i.functiona_id, --a09_function_id_m88,
                         i.function_name, --a09_function_name_m88,
                         i.id, --a09_request_id,
                         i.status, --a09_status_id_v01,
                         i.last_changed_by_id_u17, --a09_action_by_id_u17,
                         SYSDATE, --a09_action_date,
                         i.last_changed_by_id_u17, --a09_created_by_id_u17,
                         SYSDATE, --a09_created_date,
                         i.narration, --a09_narration,
                         i.narration --a09_reject_reason
                                    );


            --------------------------- GENERATE A06 LOG ENTRY (ONLY FOR NON BULK OPERATIONS)--------
            -----------------------------------------------------------------------------------------

            IF action_type = '2'
            THEN
                ----------------------------AUDIT TYPE FOR A06 ENTRY----------------------------------

                ----------------------------- FOR HOLDING RELATED TRANSACTION ------------------------
                IF (impact_type IN ('3'))
                THEN
                    l_reference_no := 't12_id:' || i.id;

                    IF txn_type = 1
                    THEN
                        audit_type := 465; -- HOLDING DEPOSIT
                    ELSIF txn_type = 2
                    THEN
                        audit_type := 466; -- HOLDING WITHDRAW
                    ELSIF txn_type = 3
                    THEN
                        audit_type := 467; -- HOLDING TRANSFER
                    ELSIF txn_type = 6
                    THEN
                        audit_type := 507; -- HOLDING EDIT
                    ELSE
                        audit_type := -1;
                    END IF;
                ----------------------------- FOR CASH RELATED TRANSACTION ---------------------------------
                ELSIF (impact_type IN ('2'))
                THEN
                    l_reference_no := 't06_id:' || i.id;

                    IF txn_type = 1
                    THEN
                        audit_type := 460; -- CASH DEPOSIT
                    ELSIF txn_type = 2
                    THEN
                        audit_type := 461; -- CASH WITHDRAW
                    ELSIF txn_type = 3
                    THEN
                        audit_type := 462; -- CASH TRANSFER
                    ELSIF txn_type = 4
                    THEN
                        audit_type := 463; -- CASH CHARGE
                    ELSIF txn_type = 5
                    THEN
                        audit_type := 464; -- CASH REFUND
                    ELSIF txn_type = 6
                    THEN
                        audit_type := 484; -- MONEY MARKET
                    ELSIF txn_type = 7
                    THEN
                        audit_type := 487; -- BOND CONTRACT
                    ELSIF txn_type = 8
                    THEN
                        audit_type := 506; -- CASH EDIT
                    ELSE
                        audit_type := -1;
                    END IF;
                END IF;



                ------------------------- SATRT DESCRIPTION PREPARE FOR TRANSACTIONS---------------------

                ---------------- HOLDING DEPOSIT (460) / CASH DEPOSIT (465) / CASH REFUND (464) ---------------------------
                IF audit_type = 460 OR audit_type = 465 OR audit_type = 464
                THEN
                    description := 'To Accnt [' || i.acc_name || ']';
                ---------------- HOLDING WITHDRAW (461) / CASH WITHDRAW (466) / CASH CHARGE (463) -------------------------
                ELSIF    audit_type = 466
                      OR audit_type = 461
                      OR audit_type = 463
                THEN
                    description := 'From Accnt [' || i.acc_name || ']';
                ---------------- HOLDING TRANSFER  (467) / CASH TRANSFER (462) ----------------------------------------
                ELSIF audit_type = 467 OR audit_type = 462
                THEN
                    description :=
                           'From Accnt ['
                        || i.acc_name
                        || ']'
                        || 'To Accnt ['
                        || i.to_acc_name
                        || ']';
                ---------------- HOLDING TXN EDIT (507) / CASH TXN EDIT (506) ----------------------------------------
                ELSIF audit_type = 507 OR audit_type = 506
                THEN
                    ---------------- HOLDING DEPOSIT EDIT  / CASH DEPOSIT EDIT ----------------------------
                    IF (i.function_name IN ('DEPOST', 'HLDDEPOST'))
                    THEN
                        description :=
                               'Deposit Txn Edit, To Accnt ['
                            || i.acc_name
                            || ']';
                    ---------------- HOLDING WITHDRAW EDIT / CASH WITHDRAW EDIT ---------------------------
                    ELSIF (i.function_name IN
                               ('WITHDR',
                                'HLDWITHDR',
                                'CTRFEE_INT',
                                'STPFEE',
                                'CTRFEE',
                                'CTRFEE_BNK',
                                'CTRFEE_OTR','STPFEE_INT'))
                    THEN
                        description :=
                               'Withdrawal/Fee Txn Edit, From Accnt ['
                            || i.acc_name
                            || ']';
                    ---------------- HOLDING TRANSFER EDIT / CASH TRANSFER EDIT ---------------------------
                    ELSIF (i.function_name IN ('CSHTRN', 'HLDTRN'))
                    THEN
                        description :=
                               'Transfer Edit, From Accnt ['
                            || i.acc_name
                            || ']'
                            || 'To Accnt ['
                            || i.to_acc_name
                            || ']';
                    END IF;
                END IF;

                --------------------------- END DESCRIPTION PREPARE FOR TRANSACTIONS----------------------------------------

                --------------------------- INSERT ONLY IF PROCESS AUDIT TYPE IS GREATER THAN ZERO -------------------------

                IF audit_type > 0
                THEN
                    INSERT INTO a06_audit (a06_id,
                                           a06_date,
                                           a06_user_id_u17,
                                           a06_activity_id_m82,
                                           a06_description,
                                           a06_reference_no,
                                           a06_channel_v29,
                                           a06_customer_id_u01,
                                           a06_login_id_u09,
                                           a06_user_login_id_u17,
                                           a06_ip,
                                           a06_connected_machine,
                                           a06_institute_id_m02)
                         VALUES (0, --a06_id,
                                 SYSDATE, --a06_date,
                                 i.last_changed_by_id_u17, --a06_user_id_u17,
                                 audit_type, --a06_activity_id_m82,
                                 description, --a06_description,
                                 l_reference_no, --a06_reference_no,
                                 i.channel_id_v29, --a06_channel_v29,
                                 i.customer_id_u01, --a06_customer_id_u01,
                                 i.customer_login_u09, --a06_login_id_u09,
                                 i.last_changed_by_id_u17, --a06_user_login_id_u17,
                                 i.user_ip, --a06_ip,
                                 i.connected_machine, --a06_connected_machine,
                                 i.inst_id_m02 --a06_institute_id_m02
                                              );
                END IF;
            END IF;
        END LOOP;
    END;
END;
/