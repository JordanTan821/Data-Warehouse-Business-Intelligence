SET linesize 85
SET pagesize 85

ACCEPT i_category CHAR PROMPT 'Enter menu category: ';
ACCEPT i_fromyear FORMAT 9999 PROMPT 'Enter the start year (yyyy): ';
ACCEPT i_toyear FORMAT 9999 PROMPT 'Enter the end year (yyyy): ';
ACCEPT i_quarter FORMAT A02 PROMPT 'Enter the quarter (Q1/Q2/Q3/Q4): ';

COLUMN ItemName FORMAT A27 HEADING 'Item Name';
COLUMN Year FORMAT 9999 HEADING 'Year';
COLUMN QuantitySold FORMAT 9990 HEADING 'Total Quantity';
COLUMN Amount_Changes FORMAT 9990 HEADING 'Quantity Change';
COLUMN Percentage_Change FORMAT 990.99 HEADING 'Percentage Change(%)';

TTITLE -
CENTER 'Sales Trends Analysis &i_category Items in &i_quarter (&i_fromyear-&i_toyear) '-
 SKIP 2 -
RIGHT 'Date: ' _DATE -
 SKIP 1 -
RIGHT 'Page ' FORMAT 999 SQL.PNO -
 SKIP 2 

BREAK ON ItemName SKIP 1
COMPUTE AVG LABEL 'Average: ' OF Percentage_Change ON ItemName

CREATE OR REPLACE VIEW PastYearsAnalysis AS
WITH CTE_Item_Sales AS (
    SELECT 
        M.ItemName AS ItemName,
        D.cal_year AS Year,
        SUM(SF.Quantity) AS QuantitySold
    FROM Sales_Fact SF
    JOIN Menu_Dim M ON M.Menu_Key = SF.Menu_Key
    JOIN Date_Dim D ON D.Date_Key = SF.Date_Key
    WHERE D.Cal_Year BETWEEN '&i_fromyear' AND '&i_toyear'
    AND D.cal_quarter = '&i_quarter'
    AND M.Category = '&i_category'
    GROUP BY M.ItemName, D.cal_year
),
CTE_With_Prev AS (
    SELECT 
        ItemName,
        Year,
        QuantitySold,
        LAG(QuantitySold) OVER (PARTITION BY ItemName ORDER BY Year) AS PrevYearQty
    FROM CTE_Item_Sales
)
SELECT 
    ItemName,
    Year,
    QuantitySold,
    COALESCE(QuantitySold - PrevYearQty, NULL) AS Amount_Changes,
    CASE
        WHEN PrevYearQty IS NULL OR PrevYearQty = 0 THEN NULL
        ELSE ROUND((QuantitySold - PrevYearQty) / PrevYearQty * 100, 2)
    END AS Percentage_Change
FROM CTE_With_Prev
ORDER BY ItemName, Year
WITH READ ONLY CONSTRAINT read_only_PastYearsAnalysis;

SELECT * FROM PastYearsAnalysis;

CLEAR COLUMNS
CLEAR BREAKS
TTITLE OFF
