## 1. Introduction
This document provides a detailed summary of the Data Warehouse Development & Business Intelligence (DWBI) project, focusing on data warehouse design, ETL processes, SQL query development, and data visualization.

## 2. Data Warehouse Design
• The schema_creation.sql script defines the structure of the data warehouse, including fact and dimension tables.     
• The schema follows a star schema model for optimized analytical processing     

![image](https://github.com/user-attachments/assets/e80018c7-9cc5-4d15-bb9a-046b039b5550)

## 3. ETL Process      
### 3.1 Initial Data Load     
• The initial_load.sql script loads raw data into the staging tables and subsequently into fact and dimension tables.     
• Ensures data consistency and eliminates duplicates before final insertion.      

### 3.2 Subsequent Data Load
• The subsequent_load.sql script handles periodic data updates while maintaining integrity.    
• It ensures that only new or updated records are added to the warehouse.     

## 4. Slowly Changing Dimension (SCD) Type 2 Maintenance     
• The scd2_update.sql script implements SCD Type 2 to track historical changes in menu item prices.     
• This approach allows retaining past records while inserting updated versions with effective and expiration dates.      
• The process includes:      
    1. Identifying the current active record for a menu item.    
    2. Updating the expiration date of the old record.       
    3.Inserting a new record with the updated price and effective date.

## 5. SQL Query Development and Result
### 5.1 Sales Trends Analysis Appetizer Items in Q4 (2021-2023)    
![image](https://github.com/user-attachments/assets/b9749953-77cd-447c-8eac-c7003e275f04)
![image](https://github.com/user-attachments/assets/140f52aa-da7b-49fe-8c78-a4d28c5f8618)

### 5.2 2023-2024 Average Monthly Quantity and Order Changes for Appetizer Items


### 5.3 Lowest 15% Order Share States by Time Period in 2024



## 6. Conclusion    
This report documents the SQL scripts and ETL workflows developed for the DWBI project. The implemented schema design, data loading strategies, and SCD Type 2 updates ensure efficient data processing and historical tracking. The SQL queries provide key business insights, supporting informed decision-making.
