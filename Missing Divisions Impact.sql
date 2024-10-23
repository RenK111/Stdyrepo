/* Formatted on 10/2/2024 4:57:15 PM (QP5 v5.388) */
SELECT PO_ID,
       PO_RLSE_NO,
       CHANGE_ORDER_NUMBER,
       PO_VALUE,
     
       PROJECT,
       SUBSTR (PROJECT, 1, 5)    PROJ_ID,
       ORG_ID,
       BU_ID,
       CASE
           WHEN BU_ID IN ('01', '90', '91') THEN 'DSE'
           WHEN BU_ID IN ('03', '04', '13') THEN 'RS'
           WHEN BU_ID = '02' THEN 'SS'
           WHEN BU_ID = '09' THEN 'IHO'
           WHEN BU_ID = '07' THEN 'HS'
           WHEN BU_ID = '20' THEN 'CHO'
           WHEN BU_ID IN ('05', '06') THEN 'NSS'
       END                       BU_NAME,
       DIVISION,
       PROJECT_NAME
  FROM (SELECT DISTINCT K.ERP_NUMBER                       PO_ID,
                        K.PO_RLSE_NO,
                        K.CHANGE_ORDER_NUMBER,
                        P.ORD_DT,
                        P.PO_LN_NO,
                        P.TRN_PO_TOT_AMT                   PO_VALUE,
                        P.PO_LN_TOT_AMT PO_LN_TOT_AMT,
                        K.PROJECT,
                        K.PROFIT_CENTER                    ORG_ID,
                        SUBSTR (K.PROFIT_CENTER, 8, 2)     BU_ID,
                        K.LEVEL_4                          DIVISION,
                        K.LEVEL_5                          PROJECT_NAME
          FROM KBRDATAMARTS.GLOBAL_PO_LINE_DATA  K
               INNER JOIN
               (SELECT DISTINCT P1.PO_ID,
                                P1.PO_RLSE_NO,
                                P1.PO_CHNG_ORD_NO,
                                P1.TRN_PO_TOT_AMT,
                                
                                P2.PO_LN_NO,
                                P2.ORD_DT,
                                P2.PO_LN_TOT_AMT
                  FROM PSA.CP_PO_HDR_PSA  P1
                       INNER JOIN PSA.CP_PO_LN_PSA P2
                           ON P1.PO_ID = P2.PO_ID
                          AND P1.PO_RLSE_NO = P2.PO_RLSE_NO
                 WHERE P1.PO_ID = '4850049355'
                   AND P1.PO_RLSE_NO = 0
                   AND P1.PO_CHNG_ORD_NO = 14) P
                   ON K.ERP_NUMBER = P.PO_ID
                  AND K.PO_RLSE_NO = P.PO_RLSE_NO
                  AND K.CHANGE_ORDER_NUMBER = P.PO_CHNG_ORD_NO
                  AND K.PO_LINE = P.PO_LN_NO
         WHERE K.DATA_SOURCE = 'CP'
           AND K.PROFIT_CENTER IS NOT NULL
           AND K.PROFIT_CENTER LIKE '10.%'
           AND K.LEVEL_4 = 'ToBeMapped_Mgmt'
           
           AND K.ERP_NUMBER = '4850049355')
 WHERE PO_ID = '4850049355'