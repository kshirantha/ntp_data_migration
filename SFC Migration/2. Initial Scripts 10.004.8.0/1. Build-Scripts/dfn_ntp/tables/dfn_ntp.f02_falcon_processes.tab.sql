CREATE TABLE dfn_ntp.f02_falcon_processes
(
    f02_id                       VARCHAR2 (50 BYTE),
    f02_process_name             VARCHAR2 (50 BYTE),
    f02_component_type           VARCHAR2 (50 BYTE),
    f02_tag                      VARCHAR2 (50 BYTE),
    f02_cpu_threshold            NUMBER,
    f02_memory_threshold         NUMBER,
    f02_run_controller_id_f03    VARCHAR2 (50 BYTE),
    f02_kill_controller_id_f03   VARCHAR2 (50 BYTE),
    f02_server_ip                VARCHAR2 (50 BYTE),
    f02_status                   VARCHAR2 (50 BYTE)
)
/

ALTER TABLE dfn_ntp.f02_falcon_processes
ADD CONSTRAINT pk_f02_id PRIMARY KEY (f02_id)
 ENABLE
 VALIDATE
/

COMMENT ON COLUMN DFN_NTP.f02_FALCON_PROCESSES.f02_STATUS IS '"active": process is available and "passive": process is removed'
/