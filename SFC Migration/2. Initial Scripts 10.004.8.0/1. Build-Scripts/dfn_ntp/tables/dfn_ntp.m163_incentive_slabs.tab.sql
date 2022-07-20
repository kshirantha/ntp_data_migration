CREATE TABLE dfn_ntp.m163_incentive_slabs
(
    m163_id                         NUMBER (5, 0) NOT NULL,
    m163_incentive_group_id_m162    NUMBER (5, 0) NOT NULL,
    m163_from                       NUMBER (18, 5) NOT NULL,
    m163_to                         NUMBER (18, 5) NOT NULL,
    m163_percentage                 NUMBER (18, 5) NOT NULL,
    m163_currency_code_m03          CHAR (3 BYTE),
    m163_currency_id_m03            NUMBER (5, 0) NOT NULL,
    m163_created_by_id_u17          NUMBER (20, 0),
    m163_created_date               DATE,
    m163_modified_by_id_u17         NUMBER (20, 0),
    m163_modified_date              DATE,
    m163_status_id_v01              NUMBER (20, 0),
    m163_status_changed_by_id_u17   NUMBER (20, 0),
    m163_status_changed_date        DATE,
    m163_custom_type                VARCHAR2 (50 BYTE),
    m163_exchange_id_m01            NUMBER (5, 0) NOT NULL,
    m163_exchange_code_m01          VARCHAR2 (10 BYTE)
)
/