SET linesize 116
SET pagesize 40
 
ACCEPT i_year FORMAT 9999 PROMPT 'Enter year (yyyy): ';

COLUMN TimePeriod FORMAT A30 HEADING 'Time Period';
COLUMN State FORMAT A20 HEADING 'State';
COLUMN Rank FORMAT 99 HEADING 'Rank';
COLUMN TotalOrder FORMAT 9999 HEADING 'Total Order';
COLUMN Percent FORMAT 990.99 HEADING 'Order Share (%)';
COLUMN TotalRevenue FORMAT $99999.99 HEADING 'Total Revenue';
COLUMN RPercent FORMAT 990.99 HEADING 'Revenue Share (%)';
COLUMN AvgTotalOrder FORMAT 9999 HEADING 'Average Total Order|Per State in &i_year';
COLUMN AvgTotalRevenue FORMAT $99999.99 HEADING 'Average Total Revenue|Per State in &i_year';


TTITLE -
CENTER 'Lowest 15% Order Share States by Time Period in &i_year'- 
 SKIP 2 -
RIGHT 'Date: ' _DATE -
 SKIP 1 -
RIGHT 'Page ' FORMAT 999 SQL.PNO -
 SKIP 2 

BREAK ON TimePeriod SKIP 1
COMPUTE SUM LABEL 'Total: ' OF TotalOrder ON TimePeriod
COMPUTE SUM OF Percent ON TimePeriod
COMPUTE SUM OF TotalRevenue ON TimePeriod
COMPUTE SUM OF RPercent ON TimePeriod

CREATE OR REPLACE VIEW OrderTPState AS
WITH CTE_TP_State_Num_Order AS(
   SELECT 
      CASE
         WHEN TO_NUMBER(SUBSTR(SF.Order_Time, 1, 2)) BETWEEN 09 AND 11 THEN 'Morning(09:00 - 11:59)'
         WHEN TO_NUMBER(SUBSTR(SF.Order_Time, 1, 2)) BETWEEN 12 AND 14 THEN 'Afternoon(12:00 - 14:59)'
         WHEN TO_NUMBER(SUBSTR(SF.Order_Time, 1, 2)) BETWEEN 15 AND 17 THEN 'Evening(15:00 - 17:59)'
         WHEN TO_NUMBER(SUBSTR(SF.Order_Time, 1, 2)) BETWEEN 18 AND 21 THEN 'Night(18:00 - 21:00)' 
      END AS TimePeriod,
      C.State AS State,
      COUNT(DISTINCT(SF.orderid)) AS TotalOrder,
      SUM(SF.line_total) AS TotalRevenue
   FROM Sales_Fact SF   
   JOIN Date_Dim   D  ON D.Date_Key = SF.Date_Key
   JOIN Cust_Dim   C  ON C.Customer_Key = SF.Customer_Key
   WHERE D.cal_year = '&i_year'
   GROUP BY 
      CASE
         WHEN TO_NUMBER(SUBSTR(SF.Order_Time, 1, 2)) BETWEEN 09 AND 11 THEN 'Morning(09:00 - 11:59)'
         WHEN TO_NUMBER(SUBSTR(SF.Order_Time, 1, 2)) BETWEEN 12 AND 14 THEN 'Afternoon(12:00 - 14:59)'
         WHEN TO_NUMBER(SUBSTR(SF.Order_Time, 1, 2)) BETWEEN 15 AND 17 THEN 'Evening(15:00 - 17:59)'
         WHEN TO_NUMBER(SUBSTR(SF.Order_Time, 1, 2)) BETWEEN 18 AND 21 THEN 'Night(18:00 - 21:00)' 
      END, 
      C.State
),
CTE_Ranked_State AS(
   SELECT TimePeriod,
          State,
          13 - RANK() OVER (PARTITION BY TimePeriod ORDER BY TotalOrder ASC) + 1 AS Rank,
          TotalOrder,
          TotalRevenue
   FROM CTE_TP_State_Num_Order
),
CTE_TotalOrdersRevenue_TP AS(
   SELECT TimePeriod,
          SUM(TotalOrder) AS TotalOrderInTP,
          SUM(TotalRevenue) AS TotalRevenueInTP
   FROM CTE_TP_State_Num_Order
   GROUP BY TimePeriod
),
CTE_Cumulative_Share AS (
   SELECT RS.TimePeriod,
          RS.State,
          RS.Rank,
          RS.TotalOrder,
          ROUND(RS.TotalOrder / TT.TotalOrderInTP * 100, 2) AS Percent,
          RS.TotalRevenue, 
          ROUND(RS.TotalRevenue / TT.TotalRevenueInTP * 100, 2) AS RPercent,
          SUM(ROUND(RS.TotalOrder / TT.TotalOrderInTP * 100, 2)) 
             OVER (PARTITION BY RS.TimePeriod ORDER BY RS.Rank DESC) AS Cumulative_Share
   FROM CTE_Ranked_State RS 
   JOIN CTE_TotalOrdersRevenue_TP TT ON TT.TimePeriod = RS.TimePeriod
)
SELECT TimePeriod,
       State,
       Rank,
       TotalOrder,
       Percent,
       TotalRevenue,
       RPercent
FROM CTE_Cumulative_Share
WHERE Cumulative_Share <= 15  -- Cumulative order share less than or equal to 15%
ORDER BY 
   CASE
       WHEN TimePeriod = 'Morning(09:00 - 11:59)' THEN 1
       WHEN TimePeriod = 'Afternoon(12:00 - 14:59)' THEN 2
       WHEN TimePeriod = 'Evening(15:00 - 17:59)' THEN 3
       WHEN TimePeriod = 'Night(18:00 - 21:00)' THEN 4
    END, 
    Rank DESC
WITH READ ONLY CONSTRAINT read_only_OrderTPState;

SELECT * FROM OrderTPState;


CLEAR BREAKS
CLEAR COMPUTES
TTITLE OFF;

--Average Total Order and Average Total Revenue by Time Period 
SELECT
    TimePeriod,
    ROUND(AVG(TotalOrders)) AS AvgTotalOrder,
    ROUND(AVG(TotalRevenue), 2) AS AvgTotalRevenue
FROM (
    SELECT
        CASE
            WHEN TO_NUMBER(SUBSTR(SF.Order_Time, 1, 2)) BETWEEN 9 AND 11 THEN 'Morning(09:00 - 11:59)'
            WHEN TO_NUMBER(SUBSTR(SF.Order_Time, 1, 2)) BETWEEN 12 AND 14 THEN 'Afternoon(12:00 - 14:59)'
            WHEN TO_NUMBER(SUBSTR(SF.Order_Time, 1, 2)) BETWEEN 15 AND 17 THEN 'Evening(15:00 - 17:59)'
            WHEN TO_NUMBER(SUBSTR(SF.Order_Time, 1, 2)) BETWEEN 18 AND 21 THEN 'Night(18:00 - 21:00)'
        END AS TimePeriod,
        COUNT(DISTINCT SF.OrderID) AS TotalOrders,
        SUM(Line_Total) AS TotalRevenue
    FROM Sales_Fact SF
    JOIN Date_Dim D ON D.Date_Key = SF.Date_Key
    JOIN Cust_Dim C ON C.Customer_Key = SF.Customer_Key
    WHERE D.Cal_Year = '&i_year'
    GROUP BY
        CASE
            WHEN TO_NUMBER(SUBSTR(SF.Order_Time, 1, 2)) BETWEEN 9 AND 11 THEN 'Morning(09:00 - 11:59)'
            WHEN TO_NUMBER(SUBSTR(SF.Order_Time, 1, 2)) BETWEEN 12 AND 14 THEN 'Afternoon(12:00 - 14:59)'
            WHEN TO_NUMBER(SUBSTR(SF.Order_Time, 1, 2)) BETWEEN 15 AND 17 THEN 'Evening(15:00 - 17:59)'
            WHEN TO_NUMBER(SUBSTR(SF.Order_Time, 1, 2)) BETWEEN 18 AND 21 THEN 'Night(18:00 - 21:00)'
        END,
        C.State
)
GROUP BY TimePeriod
ORDER BY 
   CASE
       WHEN TimePeriod = 'Morning(09:00 - 11:59)' THEN 1
       WHEN TimePeriod = 'Afternoon(12:00 - 14:59)' THEN 2
       WHEN TimePeriod = 'Evening(15:00 - 17:59)' THEN 3
       WHEN TimePeriod = 'Night(18:00 - 21:00)' THEN 4
    END
;

CLEAR COLUMNS
