## 1. Introduction
This document provides a detailed summary of the Data Warehouse Development & Business Intelligence (DWBI) project, focusing on data warehouse design, ETL processes, SQL query development, and data visualization.

## 2. Data Warehouse Design
• The schema_creation.sql(sql/initial_load.sql) script defines the structure of the data warehouse, including fact and dimension tables.     
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
 3. Inserting a new record with the updated price and effective date.

## 5. SQL Query Development and Result
### 5.1 Sales Trends Analysis Appetizer Items in Q4 (2021-2023)    
![image](https://github.com/user-attachments/assets/b9749953-77cd-447c-8eac-c7003e275f04)
![image](https://github.com/user-attachments/assets/140f52aa-da7b-49fe-8c78-a4d28c5f8618)   
![image](https://github.com/user-attachments/assets/dfce0a56-7f76-4add-bcc6-c7895ce91df7)

This report analyzes sales trends for a specific menu category over Q4 from 2021 to 2023, providing insights into total quantities sold, year-over-year changes, and percentage variations. It aids businesses in understanding past sales patterns and forecasting future performance to optimize menu offerings.    

Key Findings:    
- **Recovered Items**: Curry Puff (-11.51% to 20.84%) and Onion Rings (-4.85% to 11.13%) rebounded from previous declines.
- **Consistently Growing Items**: Otak-Otak, Spring Rolls, and Dumplings maintained steady growth, indicating strong consumer demand.
- **Fluctuating Items**: Garlic Bread, Popiah, and Sate Ayam showed inconsistent trends.
- **High Growth Opportunities**: Otak-Otak (10.79%), Takoyaki (8.31%), Spring Rolls (5.94%), and Wanton (5.11%) indicate strong demand.
- **Performance Concern**: Popiah (-5.9%) shows a declining trend.

Recommended Actions:
- **High Growth Items**: Increase inventory and invest in marketing to capitalize on demand.
- **Declining Item (Popiah)**: Improve quality, introduce discounts, or bundle with top-selling items.
- **Stable Performers (-5% to +5% change)**: Bundle with popular items to enhance visibility and drive sales.

### 5.2 2023-2024 Average Monthly Quantity and Order Changes for Appetizer Items
![image](https://github.com/user-attachments/assets/cca593d2-f95b-44fc-882e-6adb41db6db9)   
![image](https://github.com/user-attachments/assets/bd516907-3bae-4867-8e93-809e0dbd1423)
![image](https://github.com/user-attachments/assets/db89f327-c031-4eb0-8e22-fed131d4e845)    

This report compares average monthly sales quantity and order trends for appetizer items between 2023 and 2024, highlighting quantity changes, percentage variations, and customer ratings to assess demand shifts and inform strategic decisions.    

Key Findings:   
- **Strong Growth Items**: Garlic Bread (15.17% quantity, 18.42% orders), Sate Ayam (9.01% quantity, 10.00% orders), Gyoza (9.22% quantity, 15.79% orders), and Popiah (9.68% quantity, 7.50% orders) show rising demand.
- **Stable Performers (-5% to +5% change)**: Dumplings, Takoyaki, Onion Rings, Rojak, Tempura, Curry Puffs, and Spring Rolls maintain steady sales.

Recommended Actions: 
- **High Growth Items**: Leverage marketing and promotions to sustain momentum, increase inventory to meet demand.
- **Stable Performers**: Introduce add-on deals or bundle offers to boost visibility and encourage sales.    

### 5.3 Lowest 15% Order Share States by Time Period in 2024
![image](https://github.com/user-attachments/assets/71112c08-ecb0-44e3-b1ec-3cc157b96663)
![image](https://github.com/user-attachments/assets/08f3e1b4-92fa-4728-91fb-68cb74c656bd)
![image](https://github.com/user-attachments/assets/b3304dbb-b989-44ec-90a4-f6e227eafab2)
This report identifies states contributing the lowest 15% of total orders and revenue across different time periods in 2024.   
Key Findings:   
- Kelantan, Putrajaya, Terengganu, Kedah, and Pahang consistently rank among the lowest, with order shares between 13.53% - 14.79%.
- Kelantan and Putrajaya have the lowest shares in the morning period, while Putrajaya and Terengganu see further declines in the evening.
- Overall, these states' order and revenue figures remain significantly below the national average.

Recommended Actions:   
- Implement targeted promotions, such as breakfast deals and lunch combos, to boost morning and afternoon sales.
- Introduce evening and night-time discounts to attract post-work customers.
- Enhance outreach through local online ads and social media campaigns to increase awareness and drive engagement.   

## 6. Conclusion    
This report documents the SQL scripts and ETL workflows developed for the DWBI project. The implemented schema design, data loading strategies, and SCD Type 2 updates ensure efficient data processing and historical tracking. The SQL queries provide key business insights, supporting informed decision-making.
