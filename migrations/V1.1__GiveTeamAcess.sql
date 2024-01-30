IF(NOT EXISTS (SELECT su.name as DatabaseUser
FROM sys.sysusers su
join sys.syslogins sl on sl.sid = su.sid
where sl.name = 'deckerct'))
BEGIN
CREATE USER deckerct FROM LOGIN deckerct; 
exec sp_addrolemember 'db_owner', 'deckerct'; 
END

IF(NOT EXISTS (SELECT su.name as DatabaseUser
FROM sys.sysusers su
join sys.syslogins sl on sl.sid = su.sid
where sl.name = 'steimlj'))
BEGIN
CREATE USER steimlj FROM LOGIN steimlj; 
exec sp_addrolemember 'db_owner', 'steimlj'; 
END

IF(NOT EXISTS (SELECT su.name as DatabaseUser
FROM sys.sysusers su
join sys.syslogins sl on sl.sid = su.sid
where sl.name = 'halseysh'))
BEGIN
CREATE USER halseysh FROM LOGIN halseysh; 
exec sp_addrolemember 'db_owner', 'halseysh'; 
END

IF(NOT EXISTS (SELECT su.name as DatabaseUser
FROM sys.sysusers su
join sys.syslogins sl on sl.sid = su.sid
where sl.name = 'deckerct'))
BEGIN
CREATE USER MusicMan FROM LOGIN MusicMan; 
exec sp_addrolemember 'db_owner', 'MusicMan'; 
END

GO