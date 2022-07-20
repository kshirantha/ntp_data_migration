DECLARE
    l_count   NUMBER := 0;
BEGIN
    SELECT COUNT (*) INTO l_count FROM map01_approval_status_v01;

    IF l_count = 0
    THEN
        INSERT INTO map01_approval_status_v01
             VALUES (0, 1, 'PENDING');

        INSERT
          INTO map01_approval_status_v01 (map01_oms_id,
                                          map01_ntp_id,
                                          map01_description)
        VALUES (1, 1, 'PENDING');

        INSERT
          INTO map01_approval_status_v01 (map01_oms_id,
                                          map01_ntp_id,
                                          map01_description)
        VALUES (2, 2, 'APPROVED');

        INSERT
          INTO map01_approval_status_v01 (map01_oms_id,
                                          map01_ntp_id,
                                          map01_description)
        VALUES (3, 3, 'REJECTED');

        INSERT
          INTO map01_approval_status_v01 (map01_oms_id,
                                          map01_ntp_id,
                                          map01_description)
        VALUES (4, 4, 'MARKED AS DELETED');

        INSERT
          INTO map01_approval_status_v01 (map01_oms_id,
                                          map01_ntp_id,
                                          map01_description)
        VALUES (5, 5, 'DELETED');

        INSERT
          INTO map01_approval_status_v01 (map01_oms_id,
                                          map01_ntp_id,
                                          map01_description)
        VALUES (22, 6, 'SENT TO EXCHANGE');

        INSERT
          INTO map01_approval_status_v01 (map01_oms_id,
                                          map01_ntp_id,
                                          map01_description)
        VALUES (8, 8, 'SUSPENDED');

        INSERT
          INTO map01_approval_status_v01 (map01_oms_id,
                                          map01_ntp_id,
                                          map01_description)
        VALUES (9, 9, 'EXPIRED');

        INSERT
          INTO map01_approval_status_v01 (map01_oms_id,
                                          map01_ntp_id,
                                          map01_description)
        VALUES (10, 10, 'ACTIVE');

        INSERT
          INTO map01_approval_status_v01 (map01_oms_id,
                                          map01_ntp_id,
                                          map01_description)
        VALUES (11, 11, 'INACTIVE');

        INSERT
          INTO map01_approval_status_v01 (map01_oms_id,
                                          map01_ntp_id,
                                          map01_description)
        VALUES (12, 12, 'DORMANT');

        INSERT
          INTO map01_approval_status_v01 (map01_oms_id,
                                          map01_ntp_id,
                                          map01_description)
        VALUES (13, 13, 'INACTIVE APPROVED L1');

        INSERT
          INTO map01_approval_status_v01 (map01_oms_id,
                                          map01_ntp_id,
                                          map01_description)
        VALUES (14, 14, 'DORMANT APPROVED L1');

        INSERT
          INTO map01_approval_status_v01 (map01_oms_id,
                                          map01_ntp_id,
                                          map01_description)
        VALUES (15, 15, 'INACTIVE REJECTED');

        INSERT
          INTO map01_approval_status_v01 (map01_oms_id,
                                          map01_ntp_id,
                                          map01_description)
        VALUES (16, 16, 'DORMANT REJECTED');

        INSERT
          INTO map01_approval_status_v01 (map01_oms_id,
                                          map01_ntp_id,
                                          map01_description)
        VALUES (17, 17, 'PROCESSED');

        INSERT
          INTO map01_approval_status_v01 (map01_oms_id,
                                          map01_ntp_id,
                                          map01_description)
        VALUES (18, 18, 'PROCESSING');

        INSERT
          INTO map01_approval_status_v01 (map01_oms_id,
                                          map01_ntp_id,
                                          map01_description)
        VALUES (19, 19, 'CANCELED');

        INSERT
          INTO map01_approval_status_v01 (map01_oms_id,
                                          map01_ntp_id,
                                          map01_description)
        VALUES (20, 20, 'INVALIDATED');

        INSERT
          INTO map01_approval_status_v01 (map01_oms_id,
                                          map01_ntp_id,
                                          map01_description)
        VALUES (21, 22, 'CLOSED');

        INSERT
          INTO map01_approval_status_v01 (map01_oms_id,
                                          map01_ntp_id,
                                          map01_description)
        VALUES (23, 23, 'MARKED AS CLOSED');

        INSERT
          INTO map01_approval_status_v01 (map01_oms_id,
                                          map01_ntp_id,
                                          map01_description)
        VALUES (6, 101, 'APPROVED L1');

        INSERT
          INTO map01_approval_status_v01 (map01_oms_id,
                                          map01_ntp_id,
                                          map01_description)
        VALUES (7, 2, 'APPROVED L2');

        -- SFC UAT Related
        
        INSERT
          INTO map01_approval_status_v01 (map01_oms_id,
                                          map01_ntp_id,
                                          map01_description)
        VALUES (24, 2, 'APPROVED L2');
    END IF;
END;
/