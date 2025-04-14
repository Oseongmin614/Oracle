SELECT  TO_DATE(TO_CHAR(SYSDATE, 'YYYYMM') || LPAD(NO,2,'0'), 'YYYY-MM-DD') AS DAY
FROM    CS_NO
WHERE   NO <= TO_NUMBER(TO_CHAR(SYSDATE,'DD'));




SELECT  CASE    ROWNUM  WHEN 1 THEN 'TOP1'
                        WHEN 2 THEN 'TOP2'
                        ELSE 'etc'  END AS GRADE
        ,ITEM_CD, SUM_QTY
FROM    
        (SELECT  BRAND_CD, ITEM_CD, SUM(ORDER_QTY) AS SUM_QTY
        FROM    A_OUT_D
        GROUP   BY BRAND_CD, ITEM_CD
        HAVING  SUM(ORDER_QTY)>1
        ORDER   BY SUM_QTY DESC);
        
        
SELECT  M.BRAND_CD, M.INVOICE_NO , SUM(ORDER_QTY),I.ITEM_NM, QTY_IN_BOX
FROM    A_OUT_D D
JOIN    A_OUT_M M ON  M.BRAND_CD = D.BRAND_CD
                AND   M.INVOICE_NO = D.INVOICE_NO
JOIN    A_ITEM I ON   I.ITEM_CD = D.ITEM_CD
                AND   I.BRAND_CD =D.BRAND_CD
WHERE   M.OUTBOUND_DATE BETWEEN '2023-01-01' AND '2023-01-04'
GROUP   BY M.BRAND_CD, M.INVOICE_NO, I.ITEM_NM, QTY_IN_BOX; 
                    
SELECT  BRAND_CD, INVOICE_NO,SUM_QTY,QTY_IN_BOX
        ,TRUNC  (SUM_QTY/ QTY_IN_BOX) AS BBOX_CNT
        ,MOD    (SUM_QTY, QTY_IN_BOX) AS PSC_CNT 
FROM (
        SELECT  M.BRAND_CD, M.INVOICE_NO , SUM(ORDER_QTY) AS SUM_QTY,I.ITEM_NM, QTY_IN_BOX
        FROM    A_OUT_D D
        JOIN    A_OUT_M M ON  M.BRAND_CD = D.BRAND_CD
                        AND   M.INVOICE_NO = D.INVOICE_NO
        JOIN    A_ITEM I ON   I.ITEM_CD = D.ITEM_CD
                        AND   I.BRAND_CD =D.BRAND_CD
        WHERE   M.OUTBOUND_DATE BETWEEN '2023-01-01' AND '2023-01-04'
        GROUP   BY M.BRAND_CD, M.INVOICE_NO, I.ITEM_NM, QTY_IN_BOX 
                      );
                      
SELECT *
FROM (
        SELECT  BRAND_CD, INVOICE_NO,SUM_QTY,QTY_IN_BOX
                ,TRUNC  (SUM_QTY/ QTY_IN_BOX) AS BOX_CNT
                ,MOD    (SUM_QTY, QTY_IN_BOX) AS PSC_CNT 
        FROM (
                SELECT  M.BRAND_CD, M.INVOICE_NO , SUM(ORDER_QTY) AS SUM_QTY,I.ITEM_NM, QTY_IN_BOX
                FROM    A_OUT_D D
                JOIN    A_OUT_M M ON  M.BRAND_CD = D.BRAND_CD
                                AND   M.INVOICE_NO = D.INVOICE_NO
                JOIN    A_ITEM I ON   I.ITEM_CD = D.ITEM_CD
                                AND   I.BRAND_CD =D.BRAND_CD
                WHERE   M.OUTBOUND_DATE BETWEEN '2023-01-01' AND '2023-01-04'
                GROUP   BY M.BRAND_CD, M.INVOICE_NO, I.ITEM_NM, QTY_IN_BOX 
                          )
        ORDER   BY BOX_CNT DESC 
                          )
WHERE ROWNUM <= 3;
    
SELECT  *
FROM    LO_OUT_M;
