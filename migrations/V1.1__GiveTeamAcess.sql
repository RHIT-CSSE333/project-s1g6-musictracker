IF(NOT EXISTS (Select 1 FROM sys.syslogins WHERE USER = 'deckerct'))
BEGIN
CREATE USER deckerct FROM LOGIN deckerct; 
exec sp_addrolemember 'db_owner', 'deckerct'; 
END

IF(NOT EXISTS (Select 1 FROM sys.syslogins WHERE USER = 'steimlj'))
BEGIN
CREATE USER steimlj FROM LOGIN steimlj; 
exec sp_addrolemember 'db_owner', 'steimlj'; 
END

IF(NOT EXISTS (Select 1 FROM sys.syslogins WHERE USER = 'halseysh'))
BEGIN
CREATE USER halseysh FROM LOGIN halseysh; 
exec sp_addrolemember 'db_owner', 'halseysh'; 
END