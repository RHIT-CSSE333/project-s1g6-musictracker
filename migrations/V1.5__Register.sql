CREATE PROCEDURE Register
	@Username nvarchar(50),
	@Name nvarchar(100),
	@PasswordSalt varchar(60),
	@PasswordHash varchar(60)
AS
BEGIN
	if @Username is null or @Username = ''
	BEGIN
		Print 'Username cannot be null or empty.';
		RETURN 1
	END
	-- *do* allow the user's actual name to be empty just in case
	if @PasswordSalt is null or @PasswordSalt = ''
	BEGIN
		Print 'PasswordSalt cannot be null or empty.';
		RETURN 2
	END
	if @PasswordHash is null or @PasswordHash = ''
	BEGIN
		Print 'PasswordHash cannot be null or empty.';
		RETURN 3
	END
	IF EXISTS(SELECT * FROM [Login] WHERE Username = @Username)
	BEGIN
      PRINT 'Error: Username already exists.';
	  RETURN 4
	END
	INSERT INTO [User](Username, [Name])
	VALUES (@Username, @Name)
	INSERT INTO [Login](UserID, Username, PasswordSalt, PasswordHash)
	VALUES (@@IDENTITY, @Username, @PasswordSalt, @PasswordHash)
END
GO