SET linesize 115
SET pagesize 22
 
ACCEPT i_category CHAR PROMPT 'Enter menu category: ';
ACCEPT i_year1 FORMAT 9999 PROMPT 'Enter the first year (yyyy): ';
ACCEPT i_year2 FORMAT 9999 PROMPT 'Enter the second year (yyyy): ';

COLUMN ItemName FORMAT A27 HEADING 'Item Name';
COLUMN AvgQuantityY1 FORMAT 9999 HEADING 'Average Monthly|Quantity in &i_year1';
COLUMN AvgQuantityY2 FORMAT 9999 HEADING 'Average Monthly|Quantity in &i_year2';
COLUMN AvgPctChangesQty FORMAT 990.99 HEADING 'Percentage|Change(%)';
COLUMN AvgOrderY1 FORMAT 9999 HEADING 'Average Monthly|Order in &i_year1';
COLUMN AvgOrderY2 FORMAT 9999 HEADING 'Average Monthly|Order in &i_year2';
COLUMN AvgPctChangesOrder FORMAT 990.99 HEADING 'Percentage|Change(%)';


TTITLE -
CENTER 'Analysis of Average Monthly Quantity and Order Changes for &i_category Items(&i_year1-&i_year2)'-
SKIP 2 -
RIGHT 'Date: ' _DATE -
 SKIP 1 -
RIGHT 'Page ' FORMAT 999 SQL.PNO -
 SKIP 2 

CREATE OR REPLACE VIEW Avg_Qty_Order_Changes AS
WITH item_monthly_order_qty AS (
    -- Calculate total quantity sold per month first
    SELECT M.ItemName AS ItemName,
           D.Cal_Year AS year,
           D.Cal_Month_Year AS month,
           COUNT(SF.OrderID) AS TotalOrder,
           SUM(SF.Quantity) AS TotalQuantity
    FROM Sales_Fact SF
    JOIN Menu_Dim M ON M.Menu_Key = SF.Menu_Key
    JOIN Date_Dim D ON D.Date_Key = SF.Date_Key
    WHERE M.Category = '&i_category'
    GROUP BY M.ItemName, D.Cal_Year, D.Cal_Month_Year
),
item_avg_monthly_order_qty AS (
    -- Then calculate the average monthly quantity per year
    SELECT ItemName,
           year,
           ROUND(AVG(TotalOrder)) AS AvgOrder,
           ROUND(AVG(TotalQuantity)) AS AvgQuantity
    FROM item_monthly_order_qty
    GROUP BY ItemName, year
)
SELECT
    O.ItemName AS ItemName,
    Q.avg_qty_Y1 AS AvgQuantityY1,
    Q.avg_qty_Y2 AS AvgQuantityY2,
    ROUND((Q.avg_qty_Y2 - Q.avg_qty_Y1) * 100 / Q.avg_qty_Y1, 2) AS AvgPctChangesQty,
    O.avg_order_Y1 AS AvgOrderY1,
    O.avg_order_Y2 AS AvgOrderY2,
    ROUND((O.avg_order_Y2 - O.avg_order_Y1) * 100 / O.avg_order_Y1, 2) AS AvgPctChangesOrder
FROM (
    SELECT ItemName,
           AVG(CASE WHEN year = '&i_year1' THEN AvgQuantity END) AS avg_qty_Y1,
           AVG(CASE WHEN year = '&i_year2' THEN AvgQuantity END) AS avg_qty_Y2
    FROM item_avg_monthly_order_qty
    GROUP BY ItemName
) Q
JOIN (
    SELECT ItemName,
           AVG(CASE WHEN year = '&i_year1' THEN AvgOrder END) AS avg_order_Y1,
           AVG(CASE WHEN year = '&i_year2' THEN AvgOrder END) AS avg_order_Y2
    FROM item_avg_monthly_order_qty
    GROUP BY ItemName
) O ON Q.ItemName = O.ItemName
WITH READ ONLY CONSTRAINT read_only_Qty_Order_Changes;

SELECT * FROM Avg_Qty_Order_Changes;


CLEAR COLUMNS
TTITLE OFF
