CREATE OR REPLACE PROCEDURE dfn_ntp.sp_reset_trade_confirmation_no
IS
    l_val number;
BEGIN
    execute immediate
    'select TRADE_CONFIRMATION_NO_SEQ.nextval from dual' INTO l_val;

    execute immediate
    'alter sequence TRADE_CONFIRMATION_NO_SEQ increment by -' || l_val || 
                                                          ' minvalue 0';

    execute immediate
    'select TRADE_CONFIRMATION_NO_SEQ.nextval from dual' INTO l_val;

    execute immediate
    'alter sequence TRADE_CONFIRMATION_NO_SEQ increment by 1 minvalue 0';
END;
/
