-- Table DFN_NTP.M79_PENDING_SYMBL_MRG_REQUEST

CREATE TABLE dfn_ntp.m79_pending_symbl_mrg_request
(
    m79_id                         NUMBER (10, 0),
    m79_sym_margin_group           NUMBER (5, 0),
    m79_last_updated_date          DATE,
    m79_symbol_id_m20              NUMBER (10, 0),
    m79_symbol_code_m20            VARCHAR2 (10),
    m79_institution_m02            NUMBER (10, 0),
    m79_mariginability             NUMBER (1, 0),
    m79_marginable_per             NUMBER (6, 3),
    m79_status_id_v01              NUMBER (20, 0),
    m79_status_changed_by_id_u17   NUMBER (20, 0),
    m79_status_changed_date        DATE,
    m79_exchange_code_m01          VARCHAR2 (10)
)
/

-- Constraints for  DFN_NTP.M79_PENDING_SYMBL_MRG_REQUEST


  ALTER TABLE dfn_ntp.m79_pending_symbl_mrg_request ADD CONSTRAINT m79_id_pk PRIMARY KEY (m79_id)
  USING INDEX  ENABLE
/

  ALTER TABLE dfn_ntp.m79_pending_symbl_mrg_request MODIFY (m79_id NOT NULL ENABLE)
/



-- Comments for  DFN_NTP.M79_PENDING_SYMBL_MRG_REQUEST

COMMENT ON COLUMN dfn_ntp.m79_pending_symbl_mrg_request.m79_sym_margin_group IS
    'Symbol marginability group, fk from m77'
/
COMMENT ON COLUMN dfn_ntp.m79_pending_symbl_mrg_request.m79_mariginability IS
    '1=YES, 0=NO'
/
-- End of DDL Script for Table DFN_NTP.M79_PENDING_SYMBL_MRG_REQUEST

alter table dfn_ntp.M79_PENDING_SYMBL_MRG_REQUEST
	add M79_CUSTOM_TYPE varchar2(50) default 1
/

alter table dfn_ntp.M79_PENDING_SYMBL_MRG_REQUEST 
  drop column M79_LAST_UPDATED_DATE
/

alter table dfn_ntp.M79_PENDING_SYMBL_MRG_REQUEST
	add M79_EXCHANGE_ID_M01 number(5)
/

ALTER TABLE dfn_ntp.M79_PENDING_SYMBL_MRG_REQUEST 
 ADD (
  M79_UPDATE_SOURCE NUMBER (1, 0) DEFAULT 0
 )
/
COMMENT ON COLUMN M79_PENDING_SYMBL_MRG_REQUEST.M79_UPDATE_SOURCE IS '0=App, 1=File'
/

ALTER TABLE dfn_ntp.m79_pending_symbl_mrg_request
 MODIFY (
  m79_symbol_code_m20 VARCHAR2 (15 BYTE)

 )
/
