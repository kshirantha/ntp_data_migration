
CREATE OR REPLACE PROCEDURE DFN_PRICE.SP_INSERT_UPDATE_INVESTORS (
    p_exchangecode   IN esp_investors.exchangecode%TYPE,
    p_investortype   IN esp_investors.investor_type%TYPE,
    p_buyval         IN esp_investors.buy_val%TYPE,
    p_sellval        IN esp_investors.sell_val%TYPE,
    p_netval         IN esp_investors.net_val%TYPE,
    p_buyperc        IN esp_investors.buy_perc%TYPE,
    p_sellperc       IN esp_investors.sell_perc%TYPE,
    p_totperc        IN esp_investors.tot_perc%TYPE,
    p_updatetime     IN DATE)
/*---------------------------------------------------------------------------
Description     : To Insert & update investors
Author           : Tharindu
Date          : 19/07/2010
Used In          : Mubasher Pro
Modification History :
     Date          Author          Reason for change
=======================================================
     2010-07-19    Tharindu          Convert T/SQL to PL/SQL
---------------------------------------------------------------------------*/
AS
BEGIN
    UPDATE esp_investors
       SET exchangecode = p_exchangecode,
           investor_type = p_investortype,
           buy_val = p_buyval,
           sell_val = p_sellval,
           net_val = p_netval,
           buy_perc = p_buyperc,
           sell_perc = p_sellperc,
           tot_perc = p_totperc,
           updatetime = p_updatetime
     WHERE     (exchangecode = p_exchangecode)
           AND (investor_type = p_investortype);

    IF (SQL%ROWCOUNT = 0)
    THEN
        INSERT INTO esp_investors (exchangecode,
                                   investor_type,
                                   buy_val,
                                   sell_val,
                                   net_val,
                                   buy_perc,
                                   sell_perc,
                                   tot_perc,
                                   updatetime)
             VALUES (p_exchangecode,
                     p_investortype,
                     p_buyval,
                     p_sellval,
                     p_netval,
                     p_buyperc,
                     p_sellperc,
                     p_totperc,
                     p_updatetime);
    END IF;
EXCEPTION
    WHEN OTHERS
    THEN
        RAISE;
END;
/
/
