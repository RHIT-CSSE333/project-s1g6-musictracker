CREATE USER steimlj FROM LOGIN steimlj; 

exec sp_addrolemember 'db_owner', 'steimlj'; 

GO 

CREATE USER halseysh FROM LOGIN halseysh; 

exec sp_addrolemember 'db_owner', 'halseysh'; 

GO