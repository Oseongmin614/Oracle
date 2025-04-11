


SELECT  OUTBOUND_DATE, TO_CHAR(OUTBOUND_DATE, 'DY'), INVOICE_NO
        ,CASE WHEN MOD(TO_NUMBER(SUBSTR(INVOICE_NO,2)),2) = 1 THEN '홀' 
                                                              ELSE '짝'
                                                              END AS EVENODD
FROM    A_OUT_M;

SELECT  OUTBOUND_DATE, TO_CHAR(OUTBOUND_DATE, 'DY') AS DY,
        INVOICE_NO,
        CASE  WHEN MOD(TO_NUMBER(SUBSTR(INVOICE_NO, 2)), 2) = 1 THEN '짝'
                                                                ELSE '홀'
                                                                END AS EVENODD,
        ORDER_NM,
        CASE WHEN SUBSTR(OUT_TYPE_DIV, 1, 2) = 'M1' THEN '상온'
             WHEN SUBSTR(OUT_TYPE_DIV, 1, 2) = 'M2' THEN '저온'
                                                      ELSE OUT_TYPE_DIV
        END AS TEMP
FROM    A_OUT_M 
ORDER   BY OUTBOUND_DATE, INVOICE_NO;

SELECT  BRAND_CD, INVOICE_NO, LINE_NO, ITEM_CD, ORDER_QTY,
        CASE
            WHEN ORDER_QTY BETWEEN 1 AND 2 THEN '하'
            WHEN ORDER_QTY BETWEEN 3 AND 4 THEN '중'
            WHEN ORDER_QTY >= 5            THEN '상'
                                           ELSE '분류없음'
        END AS GRADE
FROM    A_OUT_D 
ORDER   BY BRAND_CD, INVOICE_NO, LINE_NO;



SELECT  BRAND_CD,
        CASE
            WHEN SUBSTR(OUT_TYPE_DIV, 1, 2) = 'M1' THEN '상온'
            WHEN SUBSTR(OUT_TYPE_DIV, 1, 2) = 'M2' THEN '저온'
            ELSE '기타'
        END AS TEMP,
        COUNT(INVOICE_NO) AS INVOICE_COUNT
FROM    A_OUT_M 
GROUP   BY BRAND_CD,
        CASE
            WHEN SUBSTR(OUT_TYPE_DIV, 1, 2) = 'M1' THEN '상온'
            WHEN SUBSTR(OUT_TYPE_DIV, 1, 2) = 'M2' THEN '저온'
            ELSE '기타'
        END
ORDER   BY BRAND_CD, TEMP;



SELECT BRAND_CD,
        CASE
            WHEN SUM_QTY BETWEEN 1 AND 2 THEN '하'
            WHEN SUM_QTY BETWEEN 3 AND 4 THEN '중'
            ELSE '상'
        END AS GRADE
        ,COUNT(*) AS INV_CNT
FROM  (
        SELECT  BRAND_CD, INVOICE_NO, SUM(ORDER_QTY) AS SUM_QTY
        FROM    A_OUT_D
        GROUP   BY BRAND_CD,INVOICE_NO
        )
GROUP   BY BRAND_CD, CASE
                            WHEN SUM_QTY BETWEEN 1 AND 2 THEN '하'
                            WHEN SUM_QTY BETWEEN 3 AND 4 THEN '중'
                            ELSE '상' END;





SELECT BRAND_CD ,GRADE
FROM (
        SELECT  A.BRAND_CD,
                CASE
                    WHEN SUM(B.ORDER_QTY) BETWEEN 1 AND 2 THEN '하'
                    WHEN SUM(B.ORDER_QTY) BETWEEN 3 AND 4 THEN '중'
                    WHEN SUM(B.ORDER_QTY) >= 5 THEN '상'
                    ELSE '분류없음'
                END AS GRADE,
                COUNT(DISTINCT A.INVOICE_NO) AS INVOICE_COUNT
        FROM    A_OUT_M A
                JOIN A_OUT_D B 
                ON A.BRAND_CD = B.BRAND_CD AND A.INVOICE_NO = B.INVOICE_NO)

GROUP   BY BRAND_CD,GRADE;



SELECT SUM_QTY
FROM
    (SELECT  INVOICE_NO,SUM(ORDER_QTY)AS SUM_QTY
    FROM    A_OUT_D
    GROUP   BY ITEM_CD)
HAVING  ROWNUM >=2;




SELECT ITEM_GROUP,SUM(SUM_QTY) AS TOTAL_QTY
FROM (
        SELECT CASE 
                    WHEN RANKING <= 2 THEN ITEM_CD
                    ELSE 'ETC'
                END AS ITEM_GROUP,
                SUM_QTY
        FROM (
                SELECT ITEM_CD, SUM(ORDER_QTY) AS SUM_QTY,
                       RANK() OVER (ORDER BY SUM(ORDER_QTY) DESC) AS RANKING
                FROM A_OUT_D
                GROUP BY ITEM_CD
        )
    )
GROUP BY ITEM_GROUP;



SELECT  BRAND_CD, INVOICE_NO,LINE_NO,ITEM_CD,ORDER_QTY,
        CASE
            WHEN ORDER_QTY >= 2 THEN '하'
            WHEN ORDER_QTY >= 4 THEN '중'
            ELSE '상'
        END AS GRADE
FROM    A_OUT_D 
WHERE   BRAND_CD = '1001'
ORDER   BY    
        CASE WHEN ITEM_CD = 'C' THEN 0 ELSE 1 END,
        ITEM_CD,
        ORDER_QTY DESC;
        
SELECT  *
FROM    A_OUT_D
WHERE   (BRAND_CD, INVOICE_NO) IN (
                                    SELECT  BRAND_CD, INVOICE_NO
                                    FROM    A_OUT_M
                                    WHERE   OUTBOUND_DATE = '2023-01-03'
                                );


SELECT  D.BRAND_CD, D.ITEM_CD,(
                                    SELECT  ITEM_NM
                                    FROM    A_ITEM M
                                    WHERE   M.BRAND_CD  = D.BRAND_CD
                                    AND     M.ITEM_CD   = D.ITEM_CD
                                    )AS ITEM_NM
        ,SUM(D.ORDER_QTY)AS ORDER_QTY
FROM    A_OUT_D D
GROUP   BY D.BRAND_CD, D.ITEM_CD;



SELECT  *
FROM    A_OUT_D;

CREATE TABLE CS_NO
AS
SELECT  LEVEL AS NO
FROM    DUAL
CONNECT BY LEVEL <=100;

















