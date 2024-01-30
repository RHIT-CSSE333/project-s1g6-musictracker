import sqlalchemy as sa
from sqlalchemy import create_engine
import urllib
import pyodbc

conn = urllib.parse.quote_plus(

    'Driver = {SQL Server};'
    'Server=golem.csse.rose-hulman.edu;'
    'Database=MssqlTipsDB;'
    'User Id=halseysh'
    'Password=Baconcat66'
    'Trusted_connection=yes;'

)

try:
    coxn = create_engine('mssql+pyodbc:///odbc_connect={}'.format(conn))
    print("Passed")

except:
    print("Failed")