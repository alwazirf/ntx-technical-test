import pandas as pd
from datetime import datetime

# read data using pandas
original_data = pd.read_csv('./ecommerce-session-bigquery.csv')
# filter data where total transaction revenue not null
filter_revenue_data = original_data[original_data['totalTransactionRevenue'].notna()]

## Identify top products based on the total transaction revenue per day.
new_data = filter_revenue_data[['v2ProductName', 'totalTransactionRevenue', 'date']]
new_data['date'] = pd.to_datetime(new_data['date'], format='%Y%m%d')
daily_revenue = new_data.groupby(['date', 'v2ProductName'])['totalTransactionRevenue'].sum().reset_index()
top_products = daily_revenue.loc[daily_revenue.groupby('date')['totalTransactionRevenue'].idxmax()] #read data row and column
print(top_products)

## Detect any anomalies, such as a sharp decrease or increase in the number of transactions for a specific product.
#modify daily_revenue DataFrame, set date for index DataFrame
daily_revenue.set_index('date', inplace=True)
# using Rule-Based Methods to detect anomalies transaction
# Define thresholds (e.g., 3 standard deviations from the mean)
threshold_upper = daily_revenue['totalTransactionRevenue'].mean() + 3 * daily_revenue['totalTransactionRevenue'].std()
threshold_lower = daily_revenue['totalTransactionRevenue'].mean() - 3 * daily_revenue['totalTransactionRevenue'].std()

# Detect anomalies
anomalies_rules = daily_revenue[(daily_revenue['totalTransactionRevenue'] > threshold_upper) | (daily_revenue['totalTransactionRevenue'] < threshold_lower)]
print(anomalies_rules)

## Identify the most profitable city or province based on the total transaction revenue.
new_data_for_profitable = filter_revenue_data[['v2ProductName', 'totalTransactionRevenue', 'date', 'city']]
# clear row data where city column value is 'not available in demo dataset' and (not set)
new_data_for_profitable = new_data_for_profitable[
    (new_data_for_profitable['city'] != 'not available in demo dataset') & 
    (new_data_for_profitable['city'] != '(not set)')
]
most_profitable_city_or_province = new_data_for_profitable.nlargest(1, 'totalTransactionRevenue')
print(most_profitable_city_or_province['city'].values[0])