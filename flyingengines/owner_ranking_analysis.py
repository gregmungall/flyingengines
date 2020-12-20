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
    with conn.cursor() as cur, open('owner_ranking.sql', 'r') as sql:
        cur.execute(sql.read())
        data_raw = cur.fetchall()

# Create dataframe from raw data.
data_df = pd.DataFrame(
    data_raw, columns=['Date', 'Owner', 'Daily flying hours', 'Ranking'])
data_df.to_csv('../csvs/owner_ranking_data.csv', encoding='utf-8')
print(data_df)

# Create, style, save, and display plot.
fig, ax = plt.subplots(figsize=(10, 5))
sns.set_theme(context='paper', style='white', palette='Dark2')
sns.scatterplot(data=data_df,
                x='Date',
                y='Daily flying hours',
                hue='Owner',
                s=10)
sns.despine()
ax.legend(loc='center left', bbox_to_anchor=(1, 0.5))
plt.xlabel('Date')
plt.ylabel('Flying hours')
plt.title(
    'Flying hours for top 3 owners per day between 2019-12-01 and 2020-11-30')
plt.tight_layout()
plt.savefig("../plots/owner_ranking_plot.png")
plt.show()
