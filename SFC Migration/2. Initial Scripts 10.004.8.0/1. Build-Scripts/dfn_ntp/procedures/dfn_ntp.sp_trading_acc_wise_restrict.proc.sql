CREATE OR REPLACE PROCEDURE dfn_ntp.sp_trading_acc_wise_restrict (
    pu07_id                  IN NUMBER,
    pm71_stock_trading       IN NUMBER,
    pm71_stock_transaction   IN NUMBER,
    pm71_stock_transfer      IN NUMBER,
    pm71_pledge              IN NUMBER,
    pnarration               IN VARCHAR,
    pnarration_lang          IN VARCHAR,
    prestriction_source      IN NUMBER)
IS
BEGIN
    IF (pm71_stock_trading <> 0)
    THEN
        IF pm71_stock_trading = 1
        THEN
            sp_add_trading_restrictions (
                pu12_restriction_type_id   => 1,                        -- buy
                pu07_id                    => pu07_id,
                pu12_narration             => pnarration,
                pu12_narration_lang        => pnarration_lang,
                pu12_restriction_source    => prestriction_source);
        ELSIF pm71_stock_trading = 2
        THEN
            sp_add_trading_restrictions (
                pu12_restriction_type_id   => 2,                       -- sell
                pu07_id                    => pu07_id,
                pu12_narration             => pnarration,
                pu12_narration_lang        => pnarration_lang,
                pu12_restriction_source    => prestriction_source);
        ELSIF pm71_stock_trading = 3
        THEN
            sp_add_trading_restrictions (
                pu12_restriction_type_id   => 1,                        -- buy
                pu07_id                    => pu07_id,
                pu12_narration             => pnarration,
                pu12_narration_lang        => pnarration_lang,
                pu12_restriction_source    => prestriction_source);
            sp_add_trading_restrictions (
                pu12_restriction_type_id   => 2,                       -- sell
                pu07_id                    => pu07_id,
                pu12_narration             => pnarration,
                pu12_narration_lang        => pnarration_lang,
                pu12_restriction_source    => prestriction_source);
        END IF;
    END IF;

    IF (pm71_stock_transaction <> 0)
    THEN
        IF (pm71_stock_transaction = 1)
        THEN
            sp_add_trading_restrictions (
                pu12_restriction_type_id   => 7,             -- Stock Withdraw
                pu07_id                    => pu07_id,
                pu12_narration             => pnarration,
                pu12_narration_lang        => pnarration_lang,
                pu12_restriction_source    => prestriction_source);
        ELSIF (pm71_stock_transaction = 2)
        THEN
            sp_add_trading_restrictions (
                pu12_restriction_type_id   => 6,              -- Stock Deposit
                pu07_id                    => pu07_id,
                pu12_narration             => pnarration,
                pu12_narration_lang        => pnarration_lang,
                pu12_restriction_source    => prestriction_source);
        ELSIF (pm71_stock_transaction = 3)
        THEN
            sp_add_trading_restrictions (
                pu12_restriction_type_id   => 7,             -- Stock Withdraw
                pu07_id                    => pu07_id,
                pu12_narration             => pnarration,
                pu12_narration_lang        => pnarration_lang,
                pu12_restriction_source    => prestriction_source);

            sp_add_trading_restrictions (
                pu12_restriction_type_id   => 6,              -- Stock Deposit
                pu07_id                    => pu07_id,
                pu12_narration             => pnarration,
                pu12_narration_lang        => pnarration_lang,
                pu12_restriction_source    => prestriction_source);
        END IF;
    END IF;

    IF (pm71_stock_transfer <> 0)
    THEN
        sp_add_trading_restrictions (
            pu12_restriction_type_id   => 8,                  --Stock Transfer
            pu07_id                    => pu07_id,
            pu12_narration             => pnarration,
            pu12_narration_lang        => pnarration_lang,
            pu12_restriction_source    => prestriction_source);
    END IF;

    IF (pm71_pledge <> 0)
    THEN
        sp_add_trading_restrictions (
            pu12_restriction_type_id   => 18,                         --Pledge
            pu07_id                    => pu07_id,
            pu12_narration             => pnarration,
            pu12_narration_lang        => pnarration_lang,
            pu12_restriction_source    => prestriction_source);
        NULL;
    END IF;
END;
/
/
