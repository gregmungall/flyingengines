import os

import matplotlib.pyplot as plt
import pandas as pd
import psycopg2 as pg2
import seaborn as sns

# Connect to GCP SQL database.
with pg2.connect(
        dbname='flyingengines',
        user='postgres',
        password=os.environ['PASSWORD'],
        host=os.environ['HOST'],
        port='5432',
        sslmode='verify-ca',
        sslcert='/home/gregm/Certs/flyingengines/client-cert.pem',
        sslkey='/home/gregm/Certs/flyingengines/client-key.pem',
        sslrootcert='/home/gregm/Certs/flyingengines/server-ca.pem') as conn:

    # Execute query from file and fetch data.
    with conn.cursor() as cur, open('daily_total.sql', 'r') as sql:
        cur.execute(sql.read())
        data_raw = cur.fetchall()

# Create dataframe from raw data and calculate 7 day rolling average.
data_df = pd.DataFrame(data_raw, columns=['Date', 'Daily flying hours'])
data_df['7 day rolling average'] = (
    data_df['Daily flying hours'].rolling(7, min_periods=1, center=True).mean())
data_df.set_index('Date', inplace=True)
data_df.to_csv('../csvs/daily_total_data.csv', encoding='utf-8')
print(data_df)

# Create, style, save, and display plot.
fig, ax = plt.subplots(figsize=(10, 5))
sns.set_theme(context='paper', style='white', palette='Dark2')
sns.lineplot(data=data_df)
sns.despine()
ax.legend(loc='center left', bbox_to_anchor=(1, 0.5))
plt.xlabel('Date')
plt.ylabel('Flying hours')
plt.title(
    'Total flying hours per day between 2019-12-01 and 2020-11-30')
plt.tight_layout()
plt.savefig("../plots/daily_total_plot.png")
plt.show()
