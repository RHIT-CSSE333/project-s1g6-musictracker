import sqlalchemy as sa
from sqlalchemy import create_engine
import urllib
import pyodbc

SERVER = 'golem.csse.rose-hulman.edu'
DATABASE = 'MusicTrackerS1G6'
USERNAME = 'MusicMan'
PASSWORD = 'rickroll'
TrustServerCertificate = 'yes'

connectionString = f'DRIVER={{ODBC Driver 18 for SQL Server}};SERVER={SERVER};DATABASE={DATABASE};UID={USERNAME};PWD={PASSWORD};TrustServerCertificate={TrustServerCertificate};'

coxn = pyodbc.connect(connectionString) 