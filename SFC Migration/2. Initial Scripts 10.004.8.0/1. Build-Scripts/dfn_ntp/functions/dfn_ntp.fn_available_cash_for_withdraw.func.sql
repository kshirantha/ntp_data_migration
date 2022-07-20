CREATE OR REPLACE FUNCTION dfn_ntp.fn_available_cash_for_withdraw (
    p_balance                    NUMBER,
    p_blocked                    NUMBER,
    p_manual_transfer_blocked    NUMBER,
    p_manual_full_blocked        NUMBER,
    p_loan_amount                NUMBER,
    p_net_receivable_include     NUMBER,
    p_net_receivable             NUMBER,
    p_open_buy_blocked           NUMBER,
    p_receivable_amount          NUMBER,
    p_receivable_include         NUMBER)
    RETURN NUMBER
IS
    l_cash_for_withdraw   NUMBER := 0;
    l_total_block         NUMBER := 0;
BEGIN
    l_total_block :=
        p_blocked + p_manual_transfer_blocked + p_manual_full_blocked;
    l_cash_for_withdraw := p_balance - (l_total_block + p_loan_amount);

    IF (    p_net_receivable_include = 1
        AND (p_net_receivable > p_open_buy_blocked))
    THEN
        l_cash_for_withdraw :=
            (l_cash_for_withdraw + p_open_buy_blocked) - p_net_receivable;
    ELSIF (p_receivable_include = 0)
    THEN
        l_cash_for_withdraw := l_cash_for_withdraw - p_receivable_amount;
    END IF;

    RETURN l_cash_for_withdraw;
END;
/