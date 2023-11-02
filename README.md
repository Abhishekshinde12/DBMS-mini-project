# DBMS-mini-project
This is a mini DBMS mini project in the domain of data analytics , where we analyze the data stored from a csv file or MySQL database and can connect it to a power bi application to create interactive dashboards.

Firstly the WalmartSalesData.csv.csv the data that we are going to use here and it represent the original data
Secondly inside the project folder we have generated another file named modified_sales_data.csv where we have added some new columns (metrics) which can be helpful for our analysis.

# Steps used to create this project
1. Firstly start your mysql server and connect your mysql workbench to it
2. Then we have to create a table having columns to store all data present in the .csv file (here we add a not null constraint to all the columns for simplicity)
3. After this you execute the queries in the .sql file inside (here at start we certain columns which can be useful to gather some insights)
4. After this we can store this mysql table data into a csv file or keep as it is in the database
5. Then firstly install the powerbi software and install the required drivers in order to connect to the mysql database
6. We might face some problem in connecting the mysql database directly to the power bi so here we have stored the processed data present in the mysql table into another .csv file (modified_sales_data.csv)
7. Then simply select the various fields already present , or we can also create some new fields using the DAX formulas present in the power bi to create interactive dashboards
