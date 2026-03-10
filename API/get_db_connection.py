import os
import pyodbc
from dotenv import load_dotenv

load_dotenv()

def get_db_connection():
    server = os.getenv('DB_Server')
    database = os.getenv('DB_Name')
    username = os.getenv('DB_LOGIN')
    password = os.getenv('DB_PASSWORD')

    connection_string = f"driver={{ODBC Driver 18 for SQL Server}};SERVER={server};DATABASE={database};UID={username};PWD={password};Encrypt=yes;TrustServerCertificate=no;Connection Timeout=30;"
    return pyodbc.connect(connection_string)