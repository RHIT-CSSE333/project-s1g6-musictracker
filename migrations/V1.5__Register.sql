CREATE OR ALTER PROCEDURE Register
	@Username nvarchar(50),
	@Name nvarchar(100),
	-- @PasswordSalt varchar(60),
	@PasswordHash varchar(60)
AS
BEGIN
	if @Username is null or @Username = ''
	BEGIN
		Print 'Username cannot be null or empty.';
		RETURN 1
	END
	-- *do* allow the user's actual name to be empty just in case
	-- if @PasswordSalt is null or @PasswordSalt = ''
	-- BEGIN
		-- Print 'PasswordSalt cannot be null or empty.';
		-- RETURN 2
	-- END
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
	INSERT INTO [Users]
	VALUES (@Username, @Name)
	INSERT INTO [Login](UserID, Username,
		-- PasswordSalt,
	PasswordHash) VALUES (@@IDENTITY, @Username,
		-- @PasswordSalt,
		@PasswordHash)
	Return 0;
END
GO

CREATE PROCEDURE TempLogin
	@Username nvarchar(50),
	@PasswordHash varchar(60)
AS
BEGIN
	IF NOT EXISTS(SELECT * FROM [Login] WHERE Username = @Username AND PasswordHash = @PasswordHash)
	BEGIN
      PRINT 'Login failed!';
	  RETURN 1
	END
	RETURN 0
END
GO
