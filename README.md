# Indian_Stocks_Analysis
Analysing the performance of Ashok Leyland, Canara Bank, Emami,  Godrej Consumer Products Limited, M&amp;M, Raymond, Yes Bank, Wipro

**Step 1: Data Import and Preparation**
Data Source:
Obtain historical stock price data for multiple Indian companies and relevant market indices. You can find this data from financial data providers or APIs.
Source of data: https://www.nseindia.com/report-detail/eq_security

From above source you will be able to download data of single stock at a time with time restriction of 1 year.
Hence, we need to combine all csv into one. Here is the code to combine csv files in python.

**Python code to combine csv files:**

pip install pandas
import pandas as pd
import os
folder_path = "path_to_your_csv_files_folder"
csv_files = [file for file in os.listdir(folder_path) if file.endswith('.csv')]
combined_data = pd.concat([pd.read_csv(os.path.join(folder_path, file)) for file in csv_files], ignore_index=True)
combined_data.to_csv("combined.csv", index=False)


CSV to MySQL:
Import the CSV data into a MySQL database using the LOAD DATA INFILE or similar command.

**Step 2: MySQL Data Manipulation**

Data Cleansing:
Use MySQL queries to clean the data, handling missing values, and ensuring data consistency. In our case data is consistent, complete and reliable. So, we don't require to do data cleansing.

Calculating Metrics:
1. Calculate daily percentage returns for each stock.

2. Calculate the return or loss if I started intraday with CANBK daily with algorithm trading means buying at opening price and selling at closing price.

3. Calculate 50-day simple moving average for a YESBANK company's stock.

4. Top Performing Stocks: Identify the top-performing stocks based on their daily percent returns.

**Step 3: Tableau Visualization**

**Connecting Data:**
Import the exported CSV files into Tableau.

**Creating Visualizations:**

Create interactive visualizations like line charts, candlestick charts, and scatter plots to analyze stock price trends, correlations, and volume.

**Comparative Analysis:**

Use Tableau to compare the performance of multiple stocks, market indices, and sectors over time.




