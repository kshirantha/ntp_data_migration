CREATE OR REPLACE PROCEDURE dfn_ntp.sp_notify_tradable_rights_sms
IS
    l_message      VARCHAR (2000);
    l_message_ar   VARCHAR (2000);
BEGIN
    --Tradable Rights First Trading Period Start
    FOR i
        IN (SELECT esp.symbol AS m20_symbol,
                   esp.first_subs_startdate AS m20_session_1_start_date,
                   esp.first_subs_expdate AS m20_session_1_end_date,
                   esp.sec_subs_startdate AS m20_subs_end_date,
                   u01.u01_preferred_lang_id_v01,
                   fn_get_hijri_gregorian_date (
                       TO_CHAR (esp.first_subs_startdate, 'dd/mm/yyyy'),
                       0)
                       AS m20_session_1_hijri_start_date,
                   fn_get_hijri_gregorian_date (
                       TO_CHAR (esp.first_subs_expdate, 'dd/mm/yyyy'),
                       0)
                       AS m20_session_1_hijri_end_date,
                   fn_get_hijri_gregorian_date (
                       TO_CHAR (esp.sec_subs_startdate, 'dd/mm/yyyy'),
                       0)
                       AS m20_subs_hijri_end_date,
                   u01.u01_account_category_id_v01,
                   u01.u01_institute_id_m02,
                   esp.exchange AS m20_exchange,
                   esp.symbolshortdescription_1 AS m20_short_description_en,
                   esp.symbolshortdescription_2
                       AS m20_short_description_other,
                   u01.u01_id,
                   m20_symbol_code
              FROM dfn_price.esp_symbolmap esp,
                   m20_symbol m20,
                   u07_trading_account u07,
                   u24_holdings u24,
                   u01_customer u01
             WHERE     u24.u24_symbol_code_m20 = m20.m20_symbol_code
                   AND u24.u24_exchange_code_m01 = m20.m20_exchange_code_m01
                   AND u24.u24_symbol_id_m20 = m20.m20_id
                   AND m20.m20_symbol_code = esp.symbol
                   AND m20.m20_exchange_code_m01 = esp.exchange
                   AND u24.u24_trading_acnt_id_u07 = u07.u07_id
                   AND u01.u01_id = u07.u07_customer_id_u01
                   AND esp.first_subs_startdate BETWEEN func_get_eod_date + 1
                                                    AND   func_get_eod_date
                                                        + 1
                                                        + 0.99999)
    LOOP
        l_message :=
               'CompanyName ='
            || TO_CHAR (i.m20_symbol_code)
            || UNISTR ('\0001')
            || 'SymSessionStrtDate ='
            || TO_CHAR (i.m20_session_1_start_date)
            || UNISTR ('\0001')
            || 'SymSesionStrtDateHij ='
            || TO_CHAR (
                      SUBSTR (i.m20_session_1_hijri_start_date, 0, 2)
                   || '/'
                   || SUBSTR (i.m20_session_1_hijri_start_date, 4, 2)
                   || '/'
                   || SUBSTR (i.m20_session_1_hijri_start_date, 7, 4))
            || UNISTR ('\0001')
            || 'SymSessionEndDate ='
            || TO_CHAR (i.m20_session_1_end_date)
            || UNISTR ('\0001')
            || 'SymSessionEndDateHij ='
            || TO_CHAR (
                      SUBSTR (i.m20_session_1_hijri_end_date, 0, 2)
                   || '/'
                   || SUBSTR (i.m20_session_1_hijri_end_date, 4, 2)
                   || '/'
                   || SUBSTR (i.m20_session_1_hijri_end_date, 7, 4))
            || UNISTR ('\0001')
            || 'SymSubsEndDate ='
            || TO_CHAR (i.m20_subs_end_date)
            || UNISTR ('\0001')
            || 'SymSubsEndDateHij ='
            || TO_CHAR (
                      SUBSTR (i.m20_subs_hijri_end_date, 0, 2)
                   || '/'
                   || SUBSTR (i.m20_subs_hijri_end_date, 4, 2)
                   || '/'
                   || SUBSTR (i.m20_subs_hijri_end_date, 7, 4));

        dfn_ntp.sp_send_customer_sms_email (
            pu01_id             => i.u01_id,
            pm103_sub_item      => 53,
            psms                => l_message,
            psms_ar             => l_message,
            pemail_subject      => 'Tradable Rights First Trading Period Start',
            pemail_subject_ar   => 'UNISTR (REPLACE (TO_CHAR (''\u062D\u0642\u0648\u0642 \u0627\u0644\u062A\u062C\u0627\u0631\u0629 \u0627\u0644\u0642\u0627\u0628\u0644\u0629 \u0644\u0644\u062A\u062F\u0627\u0648\u0644 \u0628\u062F\u0627\u064A\u0629 \u0627\u0644\u062A\u062F\u0627\u0648\u0644 \u0644\u0623\u0648\u0644 \u0645\u0631\u0629''), ''u''))',
            pemail_body         => l_message,
            pemail_body_ar      => l_message,
            p_event_id_m148     => 13);
    END LOOP;

    --Tradable Rights First Trading Period End
    FOR i
        IN (SELECT esp.symbol AS m20_symbol,
                   esp.first_subs_startdate AS m20_session_1_start_date,
                   esp.first_subs_expdate AS m20_session_1_end_date,
                   esp.sec_subs_startdate AS m20_subs_end_date,
                   fn_get_hijri_gregorian_date (
                       TO_CHAR (esp.first_subs_startdate, 'dd/mm/yyyy'),
                       0)
                       AS m20_session_1_hijri_start_date,
                   fn_get_hijri_gregorian_date (
                       TO_CHAR (esp.first_subs_expdate, 'dd/mm/yyyy'),
                       0)
                       AS m20_session_1_hijri_end_date,
                   fn_get_hijri_gregorian_date (
                       TO_CHAR (esp.sec_subs_startdate, 'dd/mm/yyyy'),
                       0)
                       AS m20_subs_hijri_end_date,
                   esp.exchange AS m20_exchange,
                   esp.symbolshortdescription_1 AS m20_short_description_en,
                   esp.symbolshortdescription_2
                       AS m20_short_description_other,
                   u07.u07_customer_id_u01,
                   symbol
              FROM dfn_price.esp_symbolmap esp,
                   u07_trading_account u07,
                   u24_holdings u24,
                   m20_symbol m20
             WHERE     u24.u24_symbol_code_m20 = m20.m20_symbol_code
                   AND u24.u24_exchange_code_m01 = m20.m20_exchange_code_m01
                   AND u24.u24_symbol_id_m20 = m20.m20_id
                   AND m20.m20_symbol_code = esp.symbol
                   AND m20.m20_exchange_code_m01 = esp.exchange
                   AND u24.u24_trading_acnt_id_u07 = u07.u07_id
                   AND esp.first_subs_expdate BETWEEN func_get_eod_date + 1
                                                  AND   func_get_eod_date
                                                      + 1
                                                      + 0.99999)
    LOOP
        l_message :=
               'CompanyName ='
            || TO_CHAR (i.symbol)
            || UNISTR ('\0001')
            || 'SymSessionStrtDate ='
            || TO_CHAR (i.m20_session_1_start_date)
            || UNISTR ('\0001')
            || 'SymSesionStrtDateHij ='
            || TO_CHAR (
                      SUBSTR (i.m20_session_1_hijri_start_date, 0, 2)
                   || '/'
                   || SUBSTR (i.m20_session_1_hijri_start_date, 4, 2)
                   || '/'
                   || SUBSTR (i.m20_session_1_hijri_start_date, 7, 4))
            || UNISTR ('\0001')
            || 'SymSessionEndDate ='
            || TO_CHAR (i.m20_session_1_end_date)
            || UNISTR ('\0001')
            || 'SymSessionEndDateHij ='
            || TO_CHAR (
                      SUBSTR (i.m20_session_1_hijri_end_date, 0, 2)
                   || '/'
                   || SUBSTR (i.m20_session_1_hijri_end_date, 4, 2)
                   || '/'
                   || SUBSTR (i.m20_session_1_hijri_end_date, 7, 4))
            || UNISTR ('\0001')
            || 'SymSubsEndDate ='
            || TO_CHAR (i.m20_subs_end_date)
            || UNISTR ('\0001')
            || 'SymSubsEndDateHij ='
            || TO_CHAR (
                      SUBSTR (i.m20_subs_hijri_end_date, 0, 2)
                   || '/'
                   || SUBSTR (i.m20_subs_hijri_end_date, 4, 2)
                   || '/'
                   || SUBSTR (i.m20_subs_hijri_end_date, 7, 4));



        dfn_ntp.sp_send_customer_sms_email (
            pu01_id             => i.u07_customer_id_u01,
            pm103_sub_item      => 54,
            psms                => l_message,
            psms_ar             => l_message,
            pemail_subject      => 'Tradable Rights First Trading Period End',
            pemail_subject_ar   => 'UNISTR (REPLACE (TO_CHAR (''\u0646\u0647\u0627\u064A\u0629 \u0627\u0644\u062D\u0642\u0648\u0642 \u0642\u0627\u0628\u0644\u0629 \u0644\u0644\u062A\u062F\u0627\u0648\u0644 \u0627\u0644\u0641\u062A\u0631\u0629 \u0627\u0644\u0623\u0648\u0644\u0649 \u0644\u0644\u062A\u062C\u0627\u0631\u0629''), ''u''))',
            pemail_body         => l_message,
            pemail_body_ar      => l_message,
            p_event_id_m148     => 14);
    END LOOP;

    COMMIT;

    --  Last Day of Subscription
    FOR i
        IN (SELECT esp.symbol AS m20_symbol,
                   esp.first_subs_startdate AS m20_session_1_start_date,
                   esp.first_subs_expdate AS m20_session_1_end_date,
                   esp.sec_subs_startdate AS m20_subs_end_date,
                   fn_get_hijri_gregorian_date (
                       TO_CHAR (esp.first_subs_startdate, 'dd/mm/yyyy'),
                       0)
                       AS m20_session_1_hijri_start_date,
                   fn_get_hijri_gregorian_date (
                       TO_CHAR (esp.first_subs_expdate, 'dd/mm/yyyy'),
                       0)
                       AS m20_session_1_hijri_end_date,
                   fn_get_hijri_gregorian_date (
                       TO_CHAR (esp.sec_subs_startdate, 'dd/mm/yyyy'),
                       0)
                       AS m20_subs_hijri_end_date,
                   esp.exchange AS m20_exchange,
                   esp.symbolshortdescription_1 AS m20_short_description_en,
                   esp.symbolshortdescription_2
                       AS m20_short_description_other,
                   u07.u07_customer_id_u01,
                   symbol
              FROM dfn_price.esp_symbolmap esp,
                   u07_trading_account u07,
                   u24_holdings u24,
                   m20_symbol m20
             WHERE     u24.u24_symbol_code_m20 = m20.m20_symbol_code
                   AND u24.u24_exchange_code_m01 = m20.m20_exchange_code_m01
                   AND u24.u24_symbol_id_m20 = m20.m20_id
                   AND m20.m20_symbol_code = esp.symbol
                   AND m20.m20_exchange_code_m01 = esp.exchange
                   AND u24.u24_trading_acnt_id_u07 = u07.u07_id
                   AND esp.first_subs_expdate BETWEEN func_get_eod_date + 1
                                                  AND   func_get_eod_date
                                                      + 1
                                                      + 0.99999)
    LOOP
        l_message :=
               'CompanyName ='
            || TO_CHAR (i.symbol)
            || UNISTR ('\0001')
            || 'SymSessionStrtDate ='
            || TO_CHAR (i.m20_session_1_start_date)
            || UNISTR ('\0001')
            || 'SymSesionStrtDateHij ='
            || TO_CHAR (
                      SUBSTR (i.m20_session_1_hijri_start_date, 0, 2)
                   || '/'
                   || SUBSTR (i.m20_session_1_hijri_start_date, 4, 2)
                   || '/'
                   || SUBSTR (i.m20_session_1_hijri_start_date, 7, 4))
            || UNISTR ('\0001')
            || 'SymSessionEndDate ='
            || TO_CHAR (i.m20_session_1_end_date)
            || UNISTR ('\0001')
            || 'SymSessionEndDateHij ='
            || TO_CHAR (
                      SUBSTR (i.m20_session_1_hijri_end_date, 0, 2)
                   || '/'
                   || SUBSTR (i.m20_session_1_hijri_end_date, 4, 2)
                   || '/'
                   || SUBSTR (i.m20_session_1_hijri_end_date, 7, 4))
            || UNISTR ('\0001')
            || 'SymSubsEndDate ='
            || TO_CHAR (i.m20_subs_end_date)
            || UNISTR ('\0001')
            || 'SymSubsEndDateHij ='
            || TO_CHAR (
                      SUBSTR (i.m20_subs_hijri_end_date, 0, 2)
                   || '/'
                   || SUBSTR (i.m20_subs_hijri_end_date, 4, 2)
                   || '/'
                   || SUBSTR (i.m20_subs_hijri_end_date, 7, 4));


        dfn_ntp.sp_send_customer_sms_email (
            pu01_id             => i.u07_customer_id_u01,
            pm103_sub_item      => 55,
            psms                => l_message,
            psms_ar             => l_message,
            pemail_subject      => 'Tradable Rights Last Day of Subscription',
            pemail_subject_ar   => 'UNISTR (REPLACE (TO_CHAR (''\u0627\u0644\u062D\u0642\u0648\u0642 \u0627\u0644\u0642\u0627\u0628\u0644\u0629 \u0644\u0644\u062A\u062F\u0627\u0648\u0644 \u0622\u062E\u0631 \u064A\u0648\u0645 \u0644\u0644\u0627\u0634\u062A\u0631\u0627\u0643''), ''u''))',
            pemail_body         => l_message,
            pemail_body_ar      => l_message,
            p_event_id_m148     => 15);
    END LOOP;
END;
/