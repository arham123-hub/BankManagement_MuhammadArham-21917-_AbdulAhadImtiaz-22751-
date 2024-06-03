import schedule
import time
from sqlalchemy import create_engine, text
from sqlalchemy.engine import URL
import pandas as pd
import os
from datetime import datetime, timedelta

#get password from environment var
pwd = os.environ['PGPASS']
uid = os.environ['PGUID']

#sql db details
driver = "{ODBC Driver 17 for SQL Server}"
server = "DESKTOP-LHECLCF\\SQLEXPRESS"
database = "DataWarehousingProject"

#extract data from sql server
def extract():
    try:
        # Using Windows Authentication to connect
        connection_string = f'DRIVER={driver};SERVER={server};DATABASE={database};Trusted_Connection=yes;'
        connection_url = URL.create("mssql+pyodbc", query={"odbc_connect": connection_string})
        src_engine = create_engine(connection_url)
        src_conn = src_engine.connect()

        print("Connection successful!")
        
        tables_to_extract = ['LoanTable', 'AccountTable', 'CustomerTable', 'TransactionTable', 'BranchTable']
        data_frames = {}

        for table in tables_to_extract:
            df = pd.read_sql_query(f'SELECT * FROM {table}', src_conn)
            print(f"Extracted {table} with columns: {df.columns.tolist()}")
            data_frames[table] = df

        return data_frames

    except Exception as e:
        print("Data extract error: " + str(e))

# Generate Date Dimension Table
def generate_date_dim(start_date, end_date):
    date_range = pd.date_range(start=start_date, end=end_date)
    date_dim = pd.DataFrame(date_range, columns=['Date'])
    
    date_dim['Date_Key'] = date_dim['Date'].dt.strftime('%Y%m%d').astype(int)
    date_dim['Year'] = date_dim['Date'].dt.year
    date_dim['Quarter'] = date_dim['Date'].dt.quarter
    date_dim['Month'] = date_dim['Date'].dt.month
    date_dim['Day'] = date_dim['Date'].dt.day
    date_dim['Day_of_Week'] = date_dim['Date'].dt.dayofweek
    date_dim['Day_Name'] = date_dim['Date'].dt.day_name()
    date_dim['Month_Name'] = date_dim['Date'].dt.month_name()
    date_dim['Is_Weekend'] = date_dim['Day_of_Week'] >= 5
    
    date_dim = date_dim[['Date_Key', 'Date', 'Year', 'Quarter', 'Month', 'Day', 'Day_of_Week', 'Day_Name', 'Month_Name', 'Is_Weekend']]
    date_dim.set_index('Date_Key', inplace=True)
    
    return date_dim

#transform data into star schema
def transform(data_frames):
    try:
        # Debug print statements to verify columns
        for table, df in data_frames.items():
            print(f"Transforming {table} with columns: {df.columns.tolist()}")

        # Account Dimension
        account_dim = data_frames['AccountTable'][['Account_Number', 'Account_Type', 'Open_Date', 'Close_Date', 'Status', 'Customer_ID', 'Currency', 'Last_Transaction_Date']].drop_duplicates()
        account_dim.set_index('Account_Number', inplace=True)

        # Customer Dimension
        customer_dim = data_frames['CustomerTable'][['Customer_ID', 'First_Name', 'Last_Name', 'Date_of_Birth', 'Phone', 'Email', 'Address']].drop_duplicates()
        customer_dim.set_index('Customer_ID', inplace=True)

        # Branch Dimension
        branch_dim = data_frames['BranchTable'][['Branch_ID', 'Branch_Name', 'Location', 'Manager_ID']].drop_duplicates()
        branch_dim.set_index('Branch_ID', inplace=True)

        # Fact Table
        fact_table = data_frames['TransactionTable'][['Transaction_ID', 'Account_Number', 'Transaction_Type', 'Amount', 'Transaction_Date', 'Description', 'Transaction_Time', 'Transaction_Branch_ID']].copy()
        fact_table.rename(columns={'Transaction_Branch_ID': 'Branch_ID'}, inplace=True)
        
        # Ensure Transaction_Date is datetime type
        fact_table['Transaction_Date'] = pd.to_datetime(fact_table['Transaction_Date'])

        # Generate Date Dimension Table
        min_date = fact_table['Transaction_Date'].min()
        max_date = fact_table['Transaction_Date'].max()
        date_dim = generate_date_dim(min_date, max_date)

        # Join Date Dimension Key
        fact_table = fact_table.merge(date_dim[['Date']], left_on='Transaction_Date', right_on='Date', how='left').drop(columns=['Date'])
        fact_table['Date_ID'] = fact_table['Transaction_Date'].dt.strftime('%Y%m%d').astype(int)

        # Merge with Account Dimension to get Customer_ID
        # fact_table = fact_table.merge(account_dim[['Customer_ID']], left_on='Account_Number', right_index=True, how='left')
        
        fact_table = fact_table[['Account_Number','Transaction_Type' ,'Branch_ID', 'Date_ID', 'Amount']]
        
        # Ensure integrity constraints by checking FK relationships
        fact_table = fact_table.merge(branch_dim[['Branch_Name']], left_on='Branch_ID', right_index=True, how='left')
        fact_table.drop(columns=['Branch_Name'], inplace=True)
        
        return {
            'account_dim': account_dim,
            'customer_dim': customer_dim,
            'branch_dim': branch_dim,
            'date_dim': date_dim,
            'fact_table': fact_table
        }
    except Exception as e:
        print("Data transform error: " + str(e))

#load data to postgres
def load(df_dict):
    try:
        engine = create_engine(f'postgresql://{uid}:{pwd}@localhost:5432/ETL')
        
        # Drop existing tables
        with engine.connect() as conn:
            conn.execute(text("DROP TABLE IF EXISTS fact_table CASCADE"))
            conn.execute(text("DROP TABLE IF EXISTS account_dim CASCADE"))
            conn.execute(text("DROP TABLE IF EXISTS customer_dim CASCADE"))
            conn.execute(text("DROP TABLE IF EXISTS branch_dim CASCADE"))
            conn.execute(text("DROP TABLE IF EXISTS date_dim CASCADE"))
        
        # Creating tables with integrity constraints
        with engine.connect() as conn:
            conn.execute(text("""
                CREATE TABLE IF NOT EXISTS account_dim (
                    Account_Number INTEGER PRIMARY KEY,
                    Account_Type TEXT,
                    Open_Date DATE,
                    Close_Date DATE,
                    Status TEXT,
                    Customer_ID INTEGER,
                    Currency TEXT,
                    Last_Transaction_Date DATE
                )
            """))
            conn.execute(text("""
                CREATE TABLE IF NOT EXISTS customer_dim (
                    Customer_ID INTEGER PRIMARY KEY,
                    First_Name TEXT,
                    Last_Name TEXT,
                    Date_of_Birth DATE,
                    Phone TEXT,
                    Email TEXT,
                    Address TEXT
                )
            """))
            conn.execute(text("""
                CREATE TABLE IF NOT EXISTS branch_dim (
                    Branch_ID INTEGER PRIMARY KEY,
                    Branch_Name TEXT,
                    Location TEXT,
                    Manager_ID INTEGER
                )
            """))
            conn.execute(text("""
                CREATE TABLE IF NOT EXISTS date_dim (
                    Date_Key INTEGER PRIMARY KEY,
                    Date DATE,
                    Year INTEGER,
                    Quarter INTEGER,
                    Month INTEGER,
                    Day INTEGER,
                    Day_of_Week INTEGER,
                    Day_Name TEXT,
                    Month_Name TEXT,
                    Is_Weekend BOOLEAN
                )
            """))
            conn.execute(text("""
                CREATE TABLE IF NOT EXISTS fact_table (
                    Transaction_ID INTEGER PRIMARY KEY,
                    Account_Number INTEGER,
                    Branch_ID INTEGER,
                    Date_ID INTEGER,
                    Amount FLOAT,
                    FOREIGN KEY (Account_Number) REFERENCES account_dim (Account_Number),
                    
                    FOREIGN KEY (Branch_ID) REFERENCES branch_dim (Branch_ID),
                    FOREIGN KEY (Date_ID) REFERENCES date_dim (Date_Key)
                )
            """))

        for tbl_name, df in df_dict.items():
            print(f'importing data into {tbl_name}')
            df.to_sql(tbl_name, engine, if_exists='replace', index=True, chunksize=100000)
            print(f'Data imported successfully into {tbl_name}')

    except Exception as e:
        print("Data load error: " + str(e))

def etl_process():
    try:
        # Extract data
        data_frames = extract()
        
        # Transform data
        if data_frames:
            transformed_data = transform(data_frames)
            
            # Load data
            if transformed_data:
                load(transformed_data)
    except Exception as e:
        print("Error in ETL process: " + str(e))

# Schedule the ETL process to run every 30 seconds
schedule.every(10).seconds.do(etl_process)

while True:
    schedule.run_pending()
    time.sleep(1)
