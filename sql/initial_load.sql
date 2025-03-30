-- Script for Initial Loading

-- Date Dimension Table
DROP SEQUENCE date_seq;
CREATE SEQUENCE date_seq
START WITH 100001
INCREMENT BY 1;

SET SERVEROUTPUT ON;

DECLARE
    startDate DATE := TO_DATE('01/01/2014', 'DD/MM/YYYY');
    endDate DATE := TO_DATE('31/12/2024', 'DD/MM/YYYY');
    v_cal_date DATE;
    v_full_desc VARCHAR(40);
    v_day_of_week NUMBER(1);
    v_day_number_month NUMBER(2);
    v_day_number_year NUMBER(3);
    v_cal_week_year NUMBER(2);
    v_month_name VARCHAR(9);
    v_cal_month_year CHAR(7);
    v_cal_year_month CHAR(2);
    v_cal_quarter CHAR(2);
    v_cal_year_quarter CHAR(7);
    v_cal_year NUMBER(4);
    v_weekday_ind CHAR(1);
    v_event VARCHAR(25);
BEGIN
    WHILE (startDate <= endDate) LOOP
        v_cal_date := startDate;
        v_full_desc := TO_CHAR(startDate, 'Year') || ' ' ||
                       TO_CHAR(startDate, 'Month') || ' ' ||
                       TO_CHAR(startDate, 'DD');
        v_day_of_week := TO_CHAR(startDate, 'D');
        v_day_number_month := TO_CHAR(startDate, 'DD');
        v_day_number_year := TO_CHAR(startDate, 'DDD');
        v_cal_week_year := TO_CHAR(startDate, 'IW');
        v_month_name := TO_CHAR(startDate, 'MONTH');
        v_cal_month_year := TO_CHAR(startDate, 'MM');
        v_cal_year_month := v_cal_year || '-' || v_cal_month_year;
        v_cal_quarter := 'Q' || TO_CHAR(startDate, 'Q');
        v_cal_year_quarter := v_cal_year || '-' || v_cal_quarter;
        v_cal_year := TO_CHAR(startDate, 'YYYY');
        
        IF (v_day_of_week BETWEEN 2 AND 6) THEN
            v_weekday_ind := 'Y';
        ELSE
            v_weekday_ind := 'N';
        END IF;

        v_event := NULL;

        INSERT INTO Date_dim VALUES (
            date_seq.NEXTVAL,
            v_cal_date,
            v_full_desc,
            v_day_of_week,
            v_day_number_month,
            v_day_number_year,
            v_cal_week_year,
            v_month_name,
            v_cal_month_year,
            v_cal_year_month,
            v_cal_quarter,
            v_cal_year_quarter,
            v_cal_year,
            v_weekday_ind,
            v_event
        );

        startDate := startDate + 1;
    END LOOP;
END;
/    
  
-- Menu Dimension Table
DROP SEQUENCE menu_dim_seq;
CREATE SEQUENCE menu_dim_seq
START WITH 1001;

INSERT INTO menu_dim
SELECT menu_dim_seq.NEXTVAL,
       menuid,
       UPPER(itemName),
       itemPrice,
       UPPER(category),
       UPPER(cuisineType)
FROM menu;

-- Customer Dimension Table 
DROP SEQUENCE cust_dim_seq;
CREATE SEQUENCE cust_dim_seq
START WITH 100001
INCREMENT BY 1;

INSERT INTO cust_dim
SELECT cust_dim_seq.NEXTVAL,
       customerID,
       UPPER(customerName),
       UPPER(State),
       UPPER(City)
FROM new_cust;

-- Sales Fact Table -- Loading record into sales_fact
INSERT INTO Sales_Fact
SELECT C.DATE_KEY,
       D.CUSTOMER_KEY,
       E.MENU_KEY,
       A.ORDERTIME,
       UPPER(A.PAYMENTMETHOD),
       COALESCE(F.DeliveryCompanyName, 'NONE') AS delivery,
       E.ITEMPRICE AS UNITPRICE,
       B.QUANTITY,
       E.ITEMPRICE * B.QUANTITY AS line_total,
       COALESCE(B.RATING, 9) AS rating,
       A.ORDERID
FROM new_orders A
JOIN new_order_details B ON A.orderID = B.orderID
JOIN date_dim C ON A.orderDate = C.cal_date
JOIN cust_dim D ON A.customerID = D.customerID
JOIN menu_dim E ON B.menuID = E.menuID
LEFT JOIN new_delivery G ON A.deliveryID = G.deliveryID
LEFT JOIN deliveryCompany F ON G.companyID = F.deliveryCompanyID
WHERE C.cal_date BETWEEN E.effective_date AND E.expiration_date
ORDER BY C.DATE_KEY;
