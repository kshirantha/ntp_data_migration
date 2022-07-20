
CREATE OR REPLACE PROCEDURE DFN_PRICE.SP_INS_UPD_INDICIES (
   v_exchangecode                                 IN   VARCHAR2 DEFAULT NULL,
   v_symbol                                       IN   VARCHAR2 DEFAULT NULL,
   v_indexvalue                                   IN   NUMBER DEFAULT NULL,
   v_todayintindex                                IN   NUMBER DEFAULT NULL,
   v_prevcloseidxval                              IN   NUMBER DEFAULT NULL,
   v_adjprevcloseidxval                           IN   NUMBER DEFAULT NULL,
   v_netchange                                    IN   NUMBER DEFAULT NULL,
   v_perce_change                                 IN   NUMBER DEFAULT NULL,
   v_high                                         IN   NUMBER DEFAULT NULL,
   v_low                                          IN   NUMBER DEFAULT NULL,
   v_volume                                       IN   NUMBER DEFAULT NULL,
   v_turnover                                     IN   NUMBER DEFAULT NULL,
   v_lastsequenceno                               IN   NUMBER DEFAULT NULL,
   v_weightedindexvalue                           IN   NUMBER DEFAULT NULL,
                                            -- Added by Thilanga on 30-05-2006
   v_close                               --Added by Jagath 28-11-2006 for DGCX
                                                  IN   NUMBER DEFAULT NULL,
	v_nooftrades		IN   NUMBER DEFAULT NULL,
	v_noofups			IN   NUMBER DEFAULT NULL,
	v_noofdown			IN   NUMBER DEFAULT NULL,
	v_noofnochange		IN   NUMBER DEFAULT NULL,
	v_symbolstraded		IN   NUMBER DEFAULT NULL
)
AS
BEGIN
   UPDATE esp_indicies
      SET indexvalue = v_indexvalue,
          todayintindex = v_todayintindex,
          prevcloseidxval = v_prevcloseidxval,
          advprevcloseidxval = v_adjprevcloseidxval,
          netchange = v_netchange,
          perce_change = v_perce_change,
          high = v_high,
          low = v_low,
          volume = v_volume,
          turnover = v_turnover,
          lastsequenceno = v_lastsequenceno,
          weightedindexvalue = v_weightedindexvalue,
                                            -- Added by Thilanga on 30-05-2006
          CLOSE = v_close                --Added by Jagath 28-11-2006 for DGCX
    WHERE exchangecode = v_exchangecode AND symbol = v_symbol;

   IF (SQL%ROWCOUNT = 0)
   THEN                                         -- Primary Key Violation ERROR
      BEGIN
         INSERT INTO esp_indicies
                     (exchangecode, symbol, indexvalue,
                      todayintindex, prevcloseidxval,
                      advprevcloseidxval, netchange, perce_change,
                      high, low, volume, turnover, lastsequenceno,
                      weightedindexvalue    -- Added by Thilanga on 30-05-2006
                                        ,
                      CLOSE
                     )                   --Added by Jagath 28-11-2006 for DGCX
              VALUES (v_exchangecode, v_symbol, v_indexvalue,
                      v_todayintindex, v_prevcloseidxval,
                      v_adjprevcloseidxval, v_netchange, v_perce_change,
                      v_high, v_low, v_volume, v_turnover, v_lastsequenceno,
                      v_weightedindexvalue  -- Added by Thilanga on 30-05-2006
                                          ,
                      v_close
                     );                  --Added by Jagath 28-11-2006 for DGCX
      END;
   END IF;
END;
/
/
