CREATE OR REPLACE PROCEDURE dfn_ntp.sp_cash_acc_wise_restrict (
    pu06_id                  IN NUMBER,
    pm71_cash_transactions   IN NUMBER,
    pm71_cash_transfer       IN NUMBER,
    pnarration               IN VARCHAR,
    pnarration_lang          IN VARCHAR,
    prestriction_source      IN NUMBER)
IS
BEGIN
    IF (pm71_cash_transactions <> 0)
    THEN
        IF (pm71_cash_transactions = 1)                     -- Cash Withdrawal
        THEN
            sp_add_cash_restrictions (
                pu11_restriction_type_id   => 10,
                pu06_id                    => pu06_id,
                pu11_narration             => pnarration,
                pu11_narration_lang        => pnarration_lang,
                pu11_restriction_source    => prestriction_source);
        ELSIF (pm71_cash_transactions = 2)                      --Cash Deposit
        THEN
            sp_add_cash_restrictions (
                pu11_restriction_type_id   => 9,
                pu06_id                    => pu06_id,
                pu11_narration             => pnarration,
                pu11_narration_lang        => pnarration_lang,
                pu11_restriction_source    => prestriction_source);
        ELSIF (pm71_cash_transactions = 3)       --Cash Deposit and Withdrawal
        THEN
            sp_add_cash_restrictions (
                pu11_restriction_type_id   => 10,
                pu06_id                    => pu06_id,
                pu11_narration             => pnarration,
                pu11_narration_lang        => pnarration_lang,
                pu11_restriction_source    => prestriction_source);
            sp_add_cash_restrictions (
                pu11_restriction_type_id   => 9,
                pu06_id                    => pu06_id,
                pu11_narration             => pnarration,
                pu11_narration_lang        => pnarration_lang,
                pu11_restriction_source    => prestriction_source);
        END IF;
    END IF;

    IF (pm71_cash_transfer <> 0)
    THEN
        IF (pm71_cash_transfer = 1)                           -- Cash Transfer
        THEN
            sp_add_cash_restrictions (
                pu11_restriction_type_id   => 11,
                pu06_id                    => pu06_id,
                pu11_narration             => pnarration,
                pu11_narration_lang        => pnarration_lang,
                pu11_restriction_source    => prestriction_source);
        END IF;
    END IF;
END;
/
/
