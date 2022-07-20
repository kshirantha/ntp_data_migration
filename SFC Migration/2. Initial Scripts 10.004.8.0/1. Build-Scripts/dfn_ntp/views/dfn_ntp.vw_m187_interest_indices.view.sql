CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_m187_interest_indices
(
    m187_rate_type,
    m187_duration,
    m187_name,
    m187_rate,
    m187_primary_institute_id_m02
)
AS
    SELECT m187.m187_rate_type,
           m187.m187_duration,
           m187.m187_name,
           m187.m187_rate,
           m187.m187_primary_institute_id_m02
      FROM m187_interest_indices m187
/
