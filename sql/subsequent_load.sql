-- Script for Subsequently Loading

-- Customer Dimension
INSERT INTO new_cust VALUES (
    'CUS' || TO_CHAR(customerID_seq.NEXTVAL, 'FM000'),
    'Harry', 
    '018-1223444', 
    TO_DATE('02/08/1996', 'DD/MM/YYYY'), 
    'Female', 
    'Selangor',
    'Ampang'
);

INSERT INTO new_cust VALUES (
    'CUS' || TO_CHAR(customerID_seq.NEXTVAL, 'FM000'), 
    'Loh Tan', 
    '018-131347', 
    TO_DATE('01/07/1996', 'DD/MM/YYYY'), 
    'Female', 
    'Selangor',
    'Kajang'
);

CREATE OR REPLACE PROCEDURE prod_insert_cust_dim IS
BEGIN
    INSERT INTO cust_dim
    SELECT cust_dim_seq.NEXTVAL,
           customerID,
           UPPER(customerName),
           UPPER(State),
           UPPER(City),
           UPPER(Gender),
           customerBirthday
    FROM new_cust
    WHERE customerID NOT IN (
        SELECT customerID FROM cust_dim
    );
END;
/
EXEC prod_insert_cust_dim;

--  Menu Dimension
INSERT INTO Menu VALUES ('M056', '100 Plus', 2.0, 'Beverage', 'Local Malaysian');
INSERT INTO Menu VALUES ('M057', 'Big Breakfast', 15.0, 'Main Course', 'Western');

CREATE OR REPLACE PROCEDURE prod_insert_menu_dim IS
BEGIN
    INSERT INTO menu_dim
    SELECT menu_dim_seq.NEXTVAL,
           menuID,
           itemName,
           itemPrice,
           category,
           cuisineType,
           SYSDATE,
           TO_DATE('31/12/9999', 'DD/MM/YYYY'),
           1
    FROM menu
    WHERE menuID NOT IN (
        SELECT menuID FROM menu_dim
    );
END;
/
EXEC prod_insert_menu_dim;

-- Date Dimension
CREATE OR REPLACE PROCEDURE prod_insert_date_dim IS
    startDate DATE;
    endDate DATE;
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
    SELECT MAX(cal_date) INTO startDate FROM date_dim;
    startDate := startDate + 1;
    endDate := SYSDATE;

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
ALTER SESSION SET NLS_DATE_FORMAT = 'DD/MM/YYYY';
EXEC prod_insert_date_dim;

-- Sales Fact
INSERT INTO new_orders VALUES (
    'O' || TO_CHAR(order_seq.NEXTVAL, 'FM000000'),
    '01/09/2024', 
    '12:23', 
    'E-wallet', 
    'CUS00002', 
    NULL
);

INSERT INTO new_orders VALUES (
    'O' || TO_CHAR(order_seq.NEXTVAL, 'FM000000'),
    '01/09/2024', 
    '15:32', 
    'Online Banking', 
    'CUS00021', 
    NULL
);

INSERT INTO new_order_details VALUES ('O109141', 'M004', 1.7, 2, NULL);
INSERT INTO new_order_details VALUES ('O109142', 'M023', 11, 1, NULL);

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
AND A.orderID NOT IN (
    SELECT orderID FROM sales_fact
)
ORDER BY C.DATE_KEY;
