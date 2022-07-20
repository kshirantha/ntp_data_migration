
CREATE OR REPLACE PROCEDURE DFN_PRICE.SP_INS_UPD_SNAPSHOTS (
   v_exchangecode                   IN   VARCHAR2 DEFAULT NULL,
   --1  Newly indexed by eran--1
   v_symbol                         IN   VARCHAR2 DEFAULT NULL,
   --2        Newly indexed by eran--2
   v_symbolstatus                   IN   VARCHAR2 DEFAULT NULL,
   --3  Newly indexed by eran--3
   v_turnover                       IN   FLOAT DEFAULT NULL,
   --4 Newly indexed by eran--4
   v_volume                         IN   NUMBER DEFAULT NULL,
   --5  Newly indexed by eran--5
   v_market_id                      IN   VARCHAR2 DEFAULT NULL,
   --6       Newly indexed by eran--6
   v_lasttradetime                  IN   DATE DEFAULT NULL,
   --7     Newly indexed by eran--7
   v_lasttradeprice                 IN   NUMBER DEFAULT NULL,
   --8  Newly indexed by eran--8
   v_lasttradequantity              IN   NUMBER DEFAULT NULL,
   --9       Newly indexed by eran--9
   v_tradetick                      IN   VARCHAR2 DEFAULT NULL,
   --10    Newly indexed by eran--10
   v_nooftrades                     IN   NUMBER DEFAULT NULL,
   --11     Newly indexed by eran--11
   v_high                           IN   NUMBER DEFAULT NULL,
   --12   Newly indexed by eran--12
   v_low                            IN   NUMBER DEFAULT NULL,
   --13    Newly indexed by eran--13
   v_change                         IN   NUMBER DEFAULT NULL,
   --14 Newly indexed by eran--14
   v_percentchanged                 IN   NUMBER DEFAULT NULL,
   --15 Newly indexed by eran--15
   v_previousclosed                 IN   NUMBER DEFAULT NULL,
   --16 Newly indexed by eran--16
   v_todaysopen                     IN   NUMBER DEFAULT NULL,
   --17     Newly indexed by eran--17
   v_avgtradeprice                  IN   NUMBER DEFAULT NULL,
   --18  Newly indexed by eran--18
   v_avgtradevolume                 IN   NUMBER DEFAULT NULL,
   --19 Newly indexed by eran--19
   v_minprice                       IN   NUMBER DEFAULT NULL,
   --20       Newly indexed by eran--20
   v_maxprice                       IN   NUMBER DEFAULT NULL,
   --21       Newly indexed by eran--21
   v_highpriceof52weeks             IN   NUMBER DEFAULT NULL,
   --21     Newly indexed by eran--22
   v_highpriceof52weeksdate         IN   DATE DEFAULT NULL,
   --22   Newly indexed by eran--23
   v_lowpriceof52weeks              IN   NUMBER DEFAULT NULL,
   --23      Newly indexed by eran--24
   v_lowpriceof52weeksdate          IN   DATE DEFAULT NULL,
   --24    Newly indexed by eran--25
   v_is52weeksconsistsoflasttrade   IN   NUMBER DEFAULT NULL,
   --25   Newly indexed by eran--26
   v_per                            IN   NUMBER DEFAULT NULL,
   --26    Newly indexed by eran--27
   v_pbr                            IN   NUMBER DEFAULT NULL,
   --27    Newly indexed by eran--28
   v_marketcap                      IN   NUMBER DEFAULT NULL,
   --28      Newly indexed by eran--29
   v_yeild                          IN   NUMBER DEFAULT NULL,
   --29  Newly indexed by eran--30
   v_bestaskprice                   IN   NUMBER DEFAULT NULL,
   --30   Newly indexed by eran--31
   v_bestaskquantity                IN   NUMBER DEFAULT NULL,
   --31        Newly indexed by eran--32
   v_bestbidprice                   IN   NUMBER DEFAULT NULL,
   --32   Newly indexed by eran--33
   v_bestbidquantity                IN   NUMBER DEFAULT NULL,
   --33        Newly indexed by eran--34
   v_noofbids                       IN   NUMBER DEFAULT NULL,
   --34       Newly indexed by eran--35
   v_noofasks                       IN   NUMBER DEFAULT NULL,
   --35       Newly indexed by eran--36
   v_totalbidquantity               IN   NUMBER DEFAULT NULL,
   --36       Newly indexed by eran--37
   v_totalaskquantity               IN   NUMBER DEFAULT NULL,
   --37       Newly indexed by eran--38
   v_highask                        IN   NUMBER DEFAULT NULL,
   --38        Newly indexed by eran--39
   v_lowbid                         IN   NUMBER DEFAULT NULL,
   --39 Newly indexed by eran--40
   v_lastaskprice                   IN   NUMBER DEFAULT NULL,
   --40   Newly indexed by eran--41
   v_lastbidprice                   IN   NUMBER DEFAULT NULL,
   --41   Newly indexed by eran--42
   v_bidaskratio                    IN   NUMBER DEFAULT NULL,
   --42    Newly indexed by eran--43
   v_simpleavgask                   IN   NUMBER DEFAULT NULL,
   --43   Newly indexed by eran--44
   v_weightedavgask                 IN   NUMBER DEFAULT NULL,
   --44 Newly indexed by eran--45
   v_simpleavgbid                   IN   NUMBER DEFAULT NULL,
   --45   Newly indexed by eran--46
   v_weightedavgbid                 IN   NUMBER DEFAULT NULL,
   --46 Newly indexed by eran--47
   v_todaysclosed                   IN   NUMBER DEFAULT NULL,
   --47   Newly indexed by eran--48
   v_lasttradedtime                 IN   DATE DEFAULT NULL,
   --48   Newly indexed by eran--49
   v_lasttradedprice                IN   NUMBER DEFAULT NULL,
   --49        Newly indexed by eran--50
   v_updated                        IN   NUMBER DEFAULT NULL,
   --50        Newly indexed by eran--51
   v_lastsequenceno                 IN   NUMBER DEFAULT NULL,
   --51 Newly indexed by eran--52
   v_referenceprice                 IN   NUMBER DEFAULT NULL,
   --52 -- Added by Thilanga on 08/05/2006      Newly indexed by eran--53
   v_strikeprice                    IN   NUMBER DEFAULT NULL,
   --53--Added by Jagath 28-11-2006 for DGCX       Newly indexed by eran--54
   v_openinterest                   IN   NUMBER DEFAULT NULL,
   --54   Newly indexed by eran--55
   v_expirydate                     IN   VARCHAR2 DEFAULT NULL,
   --55   Newly indexed by eran--56
   v_optiontype                     IN   NUMBER DEFAULT NULL,
   --56     Newly indexed by eran--57
   v_instrumenttype                 IN   NUMBER DEFAULT NULL,
   --57 Newly indexed by eran--58
   v_equitysymbol                   IN   VARCHAR2 DEFAULT NULL,
   --58 Newly indexed by eran--59
   v_cashinnooforders               IN   NUMBER DEFAULT NULL,
   --59 -- Added by Suneth 12/07/2007 Newly indexed by eran--60
   v_cashinturnover                 IN   NUMBER DEFAULT NULL,
   --60-- Added by Suneth 12/07/2007    Newly indexed by eran--61
   v_cashinvolume                   IN   NUMBER DEFAULT NULL,
   --61 -- Added by Suneth 12/07/2007     Newly indexed by eran--62
   v_cashoutnooforders              IN   NUMBER DEFAULT NULL,
   --62-- Added by Suneth 12/07/2007 Newly indexed by eran--63
   v_cashoutturnover                IN   NUMBER DEFAULT NULL,
   --63-- Added by Suneth 12/07/2007   Newly indexed by eran--64
   v_cashoutvolume                  IN   NUMBER DEFAULT NULL,
--64 -- Added by Suneth 12/07/2007     Newly indexed by eran--65
	v_eps                           IN NUMBER DEFAULT NULL,
    --66 added by pathmasiri 8/09/2011 for NGP
    v_listed_shares                   IN   NUMBER DEFAULT NULL,
    --67 added by pathmasiri 12/03/2012
	v_intrinsic_value IN NUMBER DEFAULT NULL,
	--68 added by dilan 20/12/2012
	v_float_shares IN   NUMBER DEFAULT NULL,
	--69 added by dilan 07/01/2013
	v_settle_type IN VARCHAR DEFAULT NULL,
  --70 added by roshan
  	v_twap   IN NUMBER DEFAULT NULL,
    --71 added by sahan 10/02/2014
    v_closing_vwap  IN NUMBER DEFAULT NULL,
    --72 added by sahan 10/02/2014
	 v_loosing_cat                    IN NUMBER DEFAULT -1,
    --73 added by satheeq 04/06/2014
    v_shariah_st                     IN NUMBER DEFAULT -1,
    --74 added by satheeq 04/06/2014
    v_nominal_val                    IN NUMBER DEFAULT -1,
	--75 added by dennis 12/09/2014
    v_month_high                     IN NUMBER DEFAULT -1,
    v_month_low                      IN NUMBER DEFAULT -1,
    v_year_high                      IN NUMBER DEFAULT -1,
    v_year_low                       IN NUMBER DEFAULT -1,
    -- 76,77. 78. 79 added by Nibras 02/05/2016 for TDWL
    v_toprice                         IN NUMBER DEFAULT NULL,  --theoritical Open Price
    v_tovolume                        IN NUMBER DEFAULT NULL,  --theoritical Open Volume
    v_tcprice                         IN NUMBER DEFAULT NULL,  --theoritical Close Price
    v_tcvolume                        IN NUMBER DEFAULT NULL,   --theoritical Close Volume
	v_TwapPrm                         IN NUMBER DEFAULT NULL,
    v_AvgTrdPrcPrm                        IN NUMBER DEFAULT NULL,
    v_MarketCapital                        IN NUMBER DEFAULT NULL,
    v_ShareCapital                         IN NUMBER DEFAULT NULL,
    v_dayCountMethod                          IN NUMBER DEFAULT NULL,
	v_calculated_vwap				IN NUMBER DEFAULT NULL
)
AS
BEGIN
   UPDATE esp_todays_snapshots
      SET symbolstatus = v_symbolstatus,
          turnover = v_turnover,
          volume = v_volume,
          lasttradetime = v_lasttradetime,
          lasttradeprice = v_lasttradeprice,
          lasttradequantity = v_lasttradequantity,
          tradetick = v_tradetick,
          nooftrades = v_nooftrades,
          high = v_high,
          low = v_low,
          CHANGE = v_change,
          percentchanged = v_percentchanged,
          previousclosed = v_previousclosed,
          todaysopen = v_todaysopen,
          vwap = v_avgtradeprice,
          avgvolume = v_avgtradevolume,
          minprice = v_minprice,
          maxprice = v_maxprice,
          highpriceof52weeks = v_highpriceof52weeks,
          highpriceof52weeksdate = v_highpriceof52weeksdate,
          lowpriceof52weeks = v_lowpriceof52weeks,
          lowpriceof52weeksdate = v_lowpriceof52weeksdate,
          is52weeksconsistsoflasttrade = v_is52weeksconsistsoflasttrade,
          per = v_per,
          pbr = v_pbr,
          marketcap = (CASE
                          WHEN v_marketcap > 0
                             THEN v_marketcap
                          ELSE marketcap
                       END),
          yield = v_yeild,
          bestaskprice = v_bestaskprice,
          bestaskquantity = v_bestaskquantity,
          bestbidprice = v_bestbidprice,
          bestbidquantity = v_bestbidquantity,
          lastupdatedtime = SYSDATE,
          noofbids = v_noofbids,
          noofasks = v_noofasks,
          totalbidqty = v_totalbidquantity,
          totalaskqty = v_totalaskquantity,
          highask = v_highask,
          lowbid = v_lowbid,
          lastaskprice = v_lastaskprice,
          lastbidprice = v_lastbidprice,
          bidaskratio = v_bidaskratio,
          simpleavgask = v_simpleavgask,
          weightedavgask = v_weightedavgask,
          simpleavgbid = v_simpleavgbid,
          weightedavgbid = v_weightedavgbid,
          todaysclosed = v_todaysclosed,
          lasttradeddate = v_lasttradedtime,
          lasttradedprice = v_lasttradedprice,
          updated = v_updated,
          lastsequenceno = v_lastsequenceno,
          ref_price = v_referenceprice,     -- Added by Thilanga on 08/05/2006
          strikeprice = v_strikeprice,   --Added by Jagath 28-11-2006 for DGCX
          openinterest = v_openinterest,
          expirydate = v_expirydate,
          optiontype = CASE v_exchangecode        -- Changed by Amila M to support the new symbology (29/12/2010)
                         WHEN 'OPRA'
                            THEN CASE
                                   WHEN SUBSTR (v_symbol, INSTR (v_symbol, '\') + 3,
                                                1
                                               ) > 'L'
                                      THEN 0
                                   ELSE 1
                                END
                         ELSE v_optiontype
                      END,
          instrumenttype = v_instrumenttype,
          equitysymbol = v_equitysymbol,
          cashinnooforders = v_cashinnooforders,
          cashinturnover = v_cashinturnover,
          cashinvolume = v_cashinvolume,
          cashoutnooforders = v_cashoutnooforders,
          cashoutturnover = v_cashoutturnover,
          cashoutvolume = v_cashoutvolume,
          eps = v_eps,
          listed_shares = v_listed_shares,
		  intrinsic_value = v_intrinsic_value,
		  float_shares = v_float_shares,
		  SETTLE_TYPE = v_settle_type,
		  TWAP=v_twap,
          closing_vwap = v_closing_vwap,
          loosing_category = v_loosing_cat,
           shariah_status = v_shariah_st,
           nominal_value = v_nominal_val,
           monthly_high = v_month_high,
           monthly_low = v_month_low,
           yearly_high = v_year_high,
           yearly_low = v_year_low,
           toprice = v_toprice,
           tovolume = v_tovolume,
           tcprice = v_tcprice,
           tcvolume = v_tcvolume,
		   Twap_Prm = v_TwapPrm,
           Avg_Trd_Prc_Prm = v_AvgTrdPrcPrm,
           MARKET_CAPITAL = v_MarketCapital,
           SHARE_CAPITAL = v_ShareCapital,
           DAY_COUNT_METHOD = v_dayCountMethod,
		   CALCULATED_VWAP = v_calculated_vwap
    WHERE exchangecode = v_exchangecode AND symbol = v_symbol;

   IF (SQL%ROWCOUNT = 0)
   THEN
      BEGIN
         INSERT INTO esp_todays_snapshots
                     (companycode, exchangecode, symbol, symbolstatus,
                      turnover, volume, lasttradetime,
                      lasttradeprice, lasttradequantity, tradetick,
                      nooftrades, high, low, assetclass, CHANGE,
                      percentchanged, previousclosed, todaysopen,
                      vwap, avgvolume, minprice,
                      maxprice, highpriceof52weeks,
                      highpriceof52weeksdate, lowpriceof52weeks,
                      lowpriceof52weeksdate,
                      is52weeksconsistsoflasttrade, per, pbr,
                      marketcap, yield, bestaskprice,
                      bestaskquantity, bestbidprice, bestbidquantity,
                      noofbids, noofasks, totalbidqty,
                      totalaskqty, highask, lowbid,
                      lastaskprice, lastbidprice, bidaskratio,
                      simpleavgask, weightedavgask, simpleavgbid,
                      weightedavgbid, todaysclosed, lasttradeddate,
                      lasttradedprice, updated, lastsequenceno,
                      ref_price, strikeprice, openinterest,
                      expirydate,
                      optiontype,
                      instrumenttype, equitysymbol, cashinnooforders,
                      cashinturnover, cashinvolume, cashoutnooforders,
                      cashoutturnover, cashoutvolume, lastupdatedtime, eps, listed_shares, intrinsic_value, float_shares, 
                      SETTLE_TYPE,TWAP,closing_vwap,
                                              loosing_category,
                                              shariah_status,
                                              nominal_value,
                                              monthly_high,
                                              monthly_low,
                                              yearly_high,
                                              yearly_low,
                                              toprice,
                                              tovolume,
                                              tcprice,
                                              tcvolume,
											  Twap_Prm,
											  Avg_Trd_Prc_Prm,
											  MARKET_CAPITAL,
											  SHARE_CAPITAL,
											  DAY_COUNT_METHOD,
											  CALCULATED_VWAP
                     )
              VALUES ('N/A', v_exchangecode, v_symbol, v_symbolstatus,
                      v_turnover, v_volume, v_lasttradetime,
                      v_lasttradeprice, v_lasttradequantity, v_tradetick,
                      v_nooftrades, v_high, v_low, v_market_id, v_change,
			v_percentchanged, v_previousclosed, v_todaysopen,
 			v_avgtradeprice, v_avgtradevolume, v_minprice,
 			v_maxprice, v_highpriceof52weeks,
                      v_highpriceof52weeksdate, v_lowpriceof52weeks,v_lowpriceof52weeksdate,
                      v_is52weeksconsistsoflasttrade, v_per, v_pbr,
                      v_marketcap, v_yeild, v_bestaskprice,
                      v_bestaskquantity, v_bestbidprice, v_bestbidquantity,
                      v_noofbids, v_noofasks, v_totalbidquantity,
                      v_totalaskquantity, v_highask, v_lowbid,
                      v_lastaskprice, v_lastbidprice, v_bidaskratio,
                      v_simpleavgask, v_weightedavgask, v_simpleavgbid,
                      v_weightedavgbid, v_todaysclosed, v_lasttradedtime,
                      v_lasttradedprice, v_updated, v_lastsequenceno,
                      v_referenceprice, v_strikeprice, v_openinterest,
                      v_expirydate,
                      CASE v_exchangecode        -- Changed by Amila M to support the new symbology (29/12/2010)
                         WHEN 'OPRA'
                            THEN CASE
                                   WHEN SUBSTR (v_symbol,
                                                INSTR (v_symbol, '\') + 3,
                                                1
                                               ) > 'L'
                                      THEN 0
                                   ELSE 1
                                END
                         ELSE v_optiontype
                      END,
                      v_instrumenttype, v_equitysymbol, v_cashinnooforders,
                      v_cashinturnover, v_cashinvolume, v_cashoutnooforders,
                      v_cashoutturnover, v_cashoutvolume, SYSDATE, v_eps, v_listed_shares, v_intrinsic_value, v_float_shares, 
                      v_settle_type,v_twap,v_closing_vwap,
                            v_loosing_cat,
                            v_shariah_st,
                            v_nominal_val,
                            v_month_high,
                            v_month_low,
                            v_year_high,
                            v_year_low,
                            v_toprice,
                            v_tovolume,
                            v_tcprice,
                            v_tcvolume,
							v_TwapPrm,
							v_AvgTrdPrcPrm,
							v_MarketCapital,
							v_ShareCapital,
							v_dayCountMethod,
							v_calculated_vwap
                     );
      END;
   END IF;

   COMMIT;
END;
/
/
