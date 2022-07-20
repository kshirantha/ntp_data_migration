CREATE OR REPLACE PROCEDURE dfn_ntp.sp_reditribution_single_row (
    p_t09_audit_key t09_txn_single_entry_v3.t09_audit_key%TYPE)
IS
    i_last_seq                  NUMBER (20);
    i_temp_max_seq              NUMBER (20);
    i_temp_gen_rcount           NUMBER (20);
    i_start_time                TIMESTAMP;
    i_end_time                  TIMESTAMP;
    i_order_end_time            TIMESTAMP;
    i_chacc_end_time            TIMESTAMP;
    i_t09_end_time              TIMESTAMP;
    i_t02_end_time              TIMESTAMP;
    i_hold_end_time             TIMESTAMP;
    i_errorcode                 VARCHAR2 (4000);
    i_errormessage              VARCHAR2 (4000);
    i_errormessage2             VARCHAR2 (4000);
    i_return_value              NUMBER;
    i_start_db_seq              NUMBER (20);
    i_out_pending_trans_count   NUMBER (10);
    t09c_error                  t09_txn_single_entry_v3%ROWTYPE;
    p_tr_status                 NUMBER;
BEGIN
    i_return_value := 0;
    i_start_time := SYSTIMESTAMP;
    i_temp_gen_rcount := '0';

    i_errormessage2 := 'CURSOR STARTS';

    /* insert into dfn_ntp.bk2_t09_txn_single_entry_v3
    select *
    from  dfn_ntp.t09_txn_single_entry_v3
    where t09_audit_key = p_t09_audit_key;
    commit;
    */

    DECLARE
        CURSOR c_t09_txn_single_entry
        IS
            SELECT t09.*
              FROM (SELECT s.*
                      FROM dfn_ntp.t09_txn_single_entry_v3 s
                     WHERE t09_audit_key = p_t09_audit_key) t09;
    -- ORDER BY t09.t09_db_seq_id ASC; -- Comment by MJ 181217
    BEGIN
        i_t09_end_time := SYSTIMESTAMP;

        FOR t09c IN c_t09_txn_single_entry
        LOOP
            BEGIN
                t09c_error := t09c;
                i_start_db_seq := t09c.t09_db_seq_id;

                IF (t09c.t09_update_impact_code = '1')
                THEN
                    --------------------------ORDER GENERATE------------------------------------------------------------
                    BEGIN
                        i_errormessage := 'SINGLE ROW EXCEPTION - ORDER';

                        sp_redist_order_generate (t09c, p_tr_status);

                        i_order_end_time := SYSTIMESTAMP;
                    END;

                    --------------------------CASH ACCOUNT UPDATE ------------------------------------------------------
                    BEGIN
                        i_errormessage := 'SINGLE ROW EXCEPTION - CASH ACOUNT';

                        sp_redist_cash_acc_generate (t09c);

                        i_chacc_end_time := SYSTIMESTAMP;
                    END;

                    --------------------------HOLDINGS UPDATE ----------------------------------------------------------

                    BEGIN
                        i_errormessage :=
                            'SINGLE ROW EXCEPTION - CASH HOLDINGS';

                        sp_redist_holding_generate (t09c);

                        i_hold_end_time := SYSTIMESTAMP;
                    END;

                    --------------------------BASE HOLDINGS UPDATE ----------------------------------------------------------

                    IF (    t09c.t09_base_symbol_code_m20 IS NOT NULL
                        AND t09c.t09_base_sym_exchange_m01 IS NOT NULL /*AND t09c.t09_base_holding_block > 0*/
                                                                      )
                    THEN
                        BEGIN
                            i_errormessage :=
                                'SINGLE ROW EXCEPTION - BASE HOLDINGS';

                            sp_redist_base_hld_generate (t09c);
                        END;
                    END IF;

                    --------------------------DESK ORDER UPDATE ----------------------------------------------------------

                    IF (    t09c.t09_desk_order_ref_t52 IS NOT NULL
                        AND t09c.t09_desk_order_ref_t52 > 0)
                    THEN
                        BEGIN
                            i_errormessage :=
                                'SINGLE ROW EXCEPTION - DESK ORDER';

                            sp_redist_prnt_dsk_ord_genete (t09c);
                        END;
                    END IF;

                    ------------------------------ALGO ORDER UPDATE-----------------------------------------------------

                    IF (    t09c.t09_algo_order_ref_t54 IS NOT NULL
                        AND t09c.t09_algo_order_ref_t54 > 0)
                    THEN
                        BEGIN
                            sp_redist_prnt_algo_ord_genete (t09c);
                        END;
                    END IF;
                ----------------------------------------------------------------------------------------------------

                ELSIF (t09c.t09_update_impact_code IN ('2'))
                THEN
                    BEGIN
                        i_errormessage :=
                            'SINGLE ROW EXCEPTION - CASH_ACCOUNT(CASHTRANSFER)';

                        sp_redist_cash_acc_generate (t09c);
                    END;
                ----------------------------Holding TXN ----------------------------------------------------------------------------------------

                ELSIF (t09c.t09_update_impact_code IN ('3'))
                THEN
                    ---------------------------------HOLDINGS UPDATE -------------------------------------------------------------
                    BEGIN
                        i_errormessage :=
                            'SINGLE ROW EXCEPTION - CASH HOLDINGS';

                        sp_redist_holding_generate (t09c);
                    END;
                ------------------------------CASH + HOLDING UPDATE-----------------------------------------------------------------
                ELSIF (t09c.t09_update_impact_code IN ('6'))
                THEN
                    BEGIN
                        i_errormessage := 'SINGLE ROW EXCEPTION - CASH UPDATE';

                        sp_redist_cash_acc_generate (t09c);
                    END;

                    BEGIN
                        i_errormessage :=
                            'SINGLE ROW EXCEPTION - HOLDING UPDATE';

                        sp_redist_holding_generate (t09c);
                    END;
                --------------------------------------------------------------------------------------------------------------------
                ELSIF (t09c.t09_update_impact_code = '5')
                THEN
                    --------------------------DESK ORDER UPDATE ----------------------------------------------------------
                    BEGIN
                        i_errormessage :=
                            'SINGLE ROW EXCEPTION - DESK ORDER UPDAT';

                        sp_redist_desk_order_generate (t09c);
                    END;
                --------------------------------------------------------------------------------------------------------------------
                ELSIF (t09c.t09_update_impact_code = '4')
                THEN
                    --------------------------ALGO ORDER UPDATE ----------------------------------------------------------
                    BEGIN
                        i_errormessage :=
                            'SINGLE ROW EXCEPTION - ALGO ORDER UPDATE';

                        sp_redist_algo_order_generate (t09c);
                    END;
                --------------------------------------------------------------------------------------------------------------------
                ELSE
                    BEGIN
                        i_errormessage :=
                            'INVALID ERROR TRANSACTION IMPACT CODE;';
                        raise_application_error (-20101, i_errormessage);
                    END;
                END IF;

                --------------------------T02_TRANSACTION_LOG GENERATE----------------------------------------------
                BEGIN
                    i_errormessage :=
                        'SINGLE ROW EXCEPTION - T02_TRANSACTION_LOG';

                    sp_redist_t02_trans_generate (t09c,
                                                  t09c.t09_txn_code,
                                                  t09c.t09_amnt_in_txn_curr,
                                                  t09c.t09_amnt_in_stl_curr);

                    i_t02_end_time := SYSTIMESTAMP;
                END;
            -------------------------Single Row Error Exception-------------------------------------------------

            EXCEPTION
                WHEN OTHERS
                THEN
                    i_return_value := 2;
                    i_errorcode := SQLCODE;

                    i_errormessage :=
                           i_errormessage
                        || ' - '
                        || TO_CHAR (i_errorcode, '9999.9')
                        || SUBSTR (SQLERRM, 1, 200);

                    raise_application_error (-20101, i_errormessage);
            END;

            -----------------------------------------------------------------------------------------------

            i_temp_gen_rcount := i_temp_gen_rcount + 1;
            i_temp_max_seq := t09c.t09_db_seq_id;
        END LOOP;

        i_errormessage2 := 'PROCESS_SEQ INSERT';
        i_end_time := SYSTIMESTAMP;

        INSERT INTO dfn_ntp.redis_process_seq (dbseqid,
                                               created_date,
                                               start_date,
                                               end_date,
                                               process_time_in_sec,
                                               row_count,
                                               return_value,
                                               is_app_req,
                                               order_processed_time,
                                               chacc_processed_time,
                                               hold_processed_time,
                                               t02_processed_time,
                                               t01_trans_type)
             VALUES (NVL (i_temp_max_seq, -1),
                     SYSDATE,
                     i_start_time,
                     i_end_time,
                     (i_end_time - i_start_time),
                     i_temp_gen_rcount,
                     i_return_value,
                     1,
                     (i_order_end_time - i_t09_end_time),
                     (i_chacc_end_time - i_order_end_time),
                     (i_hold_end_time - i_chacc_end_time),
                     (i_t02_end_time - i_hold_end_time),
                     p_tr_status);
    ----------------------------------------Error Handling----------------------------------------------

    EXCEPTION
        WHEN OTHERS
        THEN
            IF (i_return_value = 2)
            THEN
                i_errormessage :=
                    i_errormessage || ' - Return Value:' || i_return_value;

                BEGIN
                    dfn_ntp.sp_redis_t09_error_values (t09c_error,
                                                       i_errormessage);
                END;

                raise_application_error (-20101, i_errormessage);
            ELSE
                i_return_value := 1;
                i_errorcode := SQLCODE;
                i_errormessage2 :=
                       i_errormessage2
                    || ' - '
                    || TO_CHAR (i_errorcode, '9999.9')
                    || SUBSTR (SQLERRM, 1, 200);
                i_errormessage2 :=
                    i_errormessage2 || ' - Return Value:' || i_return_value;

                BEGIN
                    dfn_ntp.sp_redis_t09_error_values (t09c_error,
                                                       i_errormessage);
                END;

                raise_application_error (-20101, i_errormessage2);
            END IF;
    END;
END;
/