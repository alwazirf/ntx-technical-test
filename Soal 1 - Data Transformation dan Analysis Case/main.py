import pandas as pd
from datetime import datetime

# read data using pandas
original_data = pd.read_csv('./ecommerce-session-bigquery.csv')
# filter data where total transaction revenue not null
filter_revenue_data = original_data[original_data['totalTransactionRevenue'].notna()]

# Identify top products based on the total transaction revenue per day.
new_data = filter_revenue_data[['v2ProductName', 'totalTransactionRevenue', 'date']]
new_data['date'] = pd.to_datetime(new_data['date'], format='%Y%m%d')
daily_revenue = new_data.groupby(['date', 'v2ProductName'])['totalTransactionRevenue'].sum().reset_index()
top_products = daily_revenue.loc[daily_revenue.groupby('date')['totalTransactionRevenue'].idxmax()] #read data row and column
print(top_products)