-- Creating Date Dimension Table
CREATE TABLE Date_dim (
    date_key NUMBER NOT NULL, -- Running number
    cal_date DATE NOT NULL, -- All dates in a calendar
    full_desc VARCHAR2(40), -- Spelling description of the date
    day_of_week NUMBER(1), -- 1 to 7 (Monday-Sunday)
    day_number_month NUMBER(2), -- 1 to 31
    day_number_year NUMBER(3), -- 1 to 365
    cal_week_year NUMBER(2), -- 1 to 53 (Week of the year)
    month_name VARCHAR2(9), -- 'January' to 'December'
    cal_month_year CHAR(7), -- e.g., '2024-07'
    cal_year_month NUMBER(2), -- 1 to 12
    cal_quarter CHAR(2), -- 'Q1' to 'Q4'
    cal_year_quarter CHAR(7), -- e.g., '2024-Q1'
    cal_year NUMBER(4), -- e.g., '2024'
    weekday_ind CHAR(1), -- 'Y'/'N'
    event VARCHAR2(25), -- e.g., 'Chinese New Year'
    CONSTRAINT PK_date_key PRIMARY KEY (date_key)
);

-- Creating Menu Dimension Table
CREATE TABLE menu_dim (
    menu_key NUMBER NOT NULL, 
    MENUID VARCHAR2(4) NOT NULL,
    ITEMNAME VARCHAR2(40) NOT NULL,
    ITEMPRICE NUMBER(5,2) NOT NULL,
    CATEGORY VARCHAR2(20) NOT NULL,
    CUISINETYPE VARCHAR2(15) NOT NULL,
    CONSTRAINT PK_menu_key PRIMARY KEY (menu_key)
);

-- Creating Customer Dimension Table
CREATE TABLE cust_dim (
    customer_key NUMBER NOT NULL,
    customerID VARCHAR2(8) NOT NULL,
    customerName VARCHAR2(9) NOT NULL,
    state VARCHAR2(15) NOT NULL,
    city VARCHAR2(16) NOT NULL,
    CONSTRAINT PK_cust_key PRIMARY KEY (customer_key)
);

-- Creating Sales Fact Table
CREATE TABLE Sales_Fact (
    date_key NUMBER NOT NULL,
    customer_key NUMBER NOT NULL,
    menu_key NUMBER NOT NULL,
    order_time CHAR(5) NOT NULL,
    paymentMethod VARCHAR2(15) NOT NULL,
    delivery VARCHAR2(30) NOT NULL,
    unitPrice NUMBER(6,2) NOT NULL,
    quantity NUMBER NOT NULL,
    line_total NUMBER(10,2) NOT NULL,
    rating NUMBER(1) NOT NULL,
    orderID VARCHAR2(7) NOT NULL,
    CONSTRAINT PK_sales_fact PRIMARY KEY (date_key, customer_key, menu_key, orderID),
    CONSTRAINT FK_date_key FOREIGN KEY (date_key) REFERENCES Date_dim (date_key),
    CONSTRAINT FK_customer_key FOREIGN KEY (customer_key) REFERENCES cust_dim (customer_key),
    CONSTRAINT FK_menu_key FOREIGN KEY (menu_key) REFERENCES menu_dim (menu_key)
);
