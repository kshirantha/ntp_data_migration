CREATE TABLE dfn_ntp.m1002_cum_annual_perf_b
(
    m1002_id                     NUMBER (10, 0),
    m1002_type                   NUMBER (1, 0),
    m1002_fund_code              VARCHAR2 (25 BYTE),
    m1002_as_of_date             DATE ,
    m1002_mnt                    NUMBER (25, 10) DEFAULT 0,
    m1002_ytd                    NUMBER (25, 10) DEFAULT 0,
    m1002_lst_yr                 NUMBER (25, 10) DEFAULT 0,
    m1002_lst_3yr                NUMBER (25, 10) DEFAULT 0,
    m1002_lst_5yr                NUMBER (25, 10) DEFAULT 0,
    m1002_lst_10yr               NUMBER (25, 10) DEFAULT 0,
    m1002_incep                  NUMBER (25, 10) DEFAULT 0,
    m1002_benchmark_mnt          NUMBER (25, 10) DEFAULT 0,
    m1002_benchmark_ytd          NUMBER (25, 10) DEFAULT 0,
    m1002_lst_benchmark_yr       NUMBER (25, 10) DEFAULT 0,
    m1002_lst_benchmark_3yr      NUMBER (25, 10) DEFAULT 0,
    m1002_lst_benchmark_5yr      NUMBER (25, 10) DEFAULT 0,
    m1002_lst_benchmark_10yr     NUMBER (25, 10) DEFAULT 0,
    m1002_benchmark_incep        NUMBER (25, 10) DEFAULT 0
)
/

ALTER TABLE dfn_ntp.m1002_cum_annual_perf_b
ADD CONSTRAINT m1002_pk PRIMARY KEY (m1002_type, m1002_fund_code)
USING INDEX
/

COMMENT ON COLUMN dfn_ntp.m1002_cum_annual_perf_b.m1002_type IS '1=CUMULATIVE | 2=ANNUAL'
/