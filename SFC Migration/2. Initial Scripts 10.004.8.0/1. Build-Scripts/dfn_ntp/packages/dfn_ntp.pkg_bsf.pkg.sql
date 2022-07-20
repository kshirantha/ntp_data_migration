/* Formatted on 26-Feb-2020 19:55:12 (QP5 v5.206) */
CREATE OR REPLACE PACKAGE dfn_ntp.pkg_bsf
IS
    PROCEDURE proc_fto_rsp (p_trn_typ   IN     VARCHAR2,
                            p_trn_nb    IN     NUMBER,
                            p_trn_sts   IN     NUMBER,
                            p_ret_sts      OUT NUMBER,
                            p_ret_msg      OUT VARCHAR2);


    PROCEDURE send_withdraw_to_bsf;
END;
/


CREATE OR REPLACE PACKAGE BODY dfn_ntp.pkg_bsf
IS
    PROCEDURE proc_fto_rsp (p_trn_typ   IN     VARCHAR2,
                            p_trn_nb    IN     NUMBER,
                            p_trn_sts   IN     NUMBER,
                            p_ret_sts      OUT NUMBER,
                            p_ret_msg      OUT VARCHAR2)
    IS
        l_t06_status            NUMBER;
        l_tmp_status            NUMBER;
        l_narration             VARCHAR2 (50);
        status                  NUMBER := 0;
        l_is_internal_process   NUMBER := 0;
    BEGIN
        IF (p_trn_sts = 0)
        THEN
            l_t06_status := 29;
            l_narration := 'APPROVED_BY_BANK(BSF)';
        ELSE
            l_t06_status := 31;
            l_narration := 'REJECTED_BY_BANK(BSF)';
        END IF;

        UPDATE t06_cash_transaction t06
           SET t06.t06_status_id = l_t06_status,
               t06.t06_narration = t06.t06_narration || ' ' || l_narration
         WHERE t06.t06_id = p_trn_nb;
    END;



    PROCEDURE send_withdraw_to_bsf
    IS
        t06_msg   VARCHAR2 (1000);
        l_count   NUMBER := 10;
        status    NUMBER := 0;
        ret_msg   VARCHAR2 (100);
    BEGIN
        FOR i
            IN (SELECT v29.v29_order_channel_category,
                       t06_id,
                       TO_CHAR (t06_date, 'dd/mm/yyyy HH:mm:ss') t06_date,
                       TO_CHAR (t06.t06_settlement_date, 'dd/mm/yyyy')
                           t06_settlement_date,
                       u01.u01_external_ref_no,
                       u06.u06_external_ref_no,
                       u08.u08_account_no,
                       m16.m16_external_ref,
                       t06.t06_amt_in_settle_currency,
                       u06.u06_currency_code_m03,
                       u08.u08_account_type_v01_id
                  FROM t06_cash_transaction t06
                       INNER JOIN u06_cash_account u06
                           ON     u06.u06_id = t06.t06_cash_acc_id_u06
                              AND t06.t06_code = 'WITHDR'
                              AND t06_status_id = 30
                       INNER JOIN u01_customer u01
                           ON u06.u06_customer_id_u01 = u01.u01_id
                       INNER JOIN u08_customer_beneficiary_acc u08
                           ON t06.t06_beneficiary_id_u08 = u08.u08_id
                       INNER JOIN m16_bank m16
                           ON u08.u08_bank_id_m16 = m16.m16_id
                       INNER JOIN v29_order_channel v29
                           ON     t06.t06_client_channel_id_v29 = v29.v29_id
                              AND ROWNUM < l_count)
        LOOP
            IF (i.v29_order_channel_category = 1)
            THEN
                t06_msg := 'CHNL=IDC;TRN_NB=';
            ELSE
                t06_msg := 'CHNL=BDC;TRN_NB=';
            END IF;

            t06_msg :=
                   t06_msg
                || i.t06_id
                || ';TRN_TYP=FTO;TRN_DT='
                || i.t06_date
                || ';VAL_DT='
                || i.t06_settlement_date;

            IF (i.u08_account_type_v01_id = 2)
            THEN
                t06_msg :=
                    t06_msg || ';TRN_CAT=BSF;BENF_BANK_LCN=BSF;CUST_NB=';
            ELSE
                t06_msg :=
                    t06_msg || ';TRN_CAT=LCL;BENF_BANK_LCN=LCL;CUST_NB=';
            END IF;

            t06_msg :=
                   t06_msg
                || i.u01_external_ref_no
                || ';ACC_NB='
                || i.u06_external_ref_no
                || ';BENF_ACC_NB='
                || i.u08_account_no
                || ';BENF_BANK_CD='
                || i.m16_external_ref
                || ';BENF_BANK_BRN_CD=22;TRN_AMT='
                || ABS (i.t06_amt_in_settle_currency)
                || ';CHRG_AMT=0;CREAT_USER_CD=0;CREAT_DT='
                || i.t06_date
                || ';REMARKS=TRF From: '
                || i.u06_external_ref_no
                || ' TRF To '
                || i.u08_account_no
                || ';FT_TRN_CURR='
                || i.u06_currency_code_m03
                || ';FT_TRN_AMT_IN_SAR='
                || ABS (i.t06_amt_in_settle_currency)
                || ';FT_DR_ACC_CURR='
                || i.u06_currency_code_m03
                || ';FT_DR_AMT='
                || ABS (i.t06_amt_in_settle_currency)
                || ';FT_DR_CURR_RATE=1;FT_CR_ACC_CURR='
                || i.u06_currency_code_m03
                || ';FT_CR_AMT='
                || ABS (i.t06_amt_in_settle_currency)
                || ';FT_CR_CURR_RATE=1;';

            UPDATE t06_cash_transaction t06_1
               SET t06_1.t06_b2b_message = t06_msg, t06_1.t06_status_id = 7
             WHERE t06_1.t06_id = i.t06_id;

            proc_fto_req (t06_msg, status, ret_msg);

            IF (status != 0)
            THEN
                UPDATE t06_cash_transaction t06_1
                   SET t06_1.t06_b2b_message = t06_msg,
                       t06_1.t06_status_id = 31
                 WHERE t06_1.t06_id = i.t06_id;
            END IF;
        END LOOP;
    END;
END;
/
