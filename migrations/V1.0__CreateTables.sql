CREATE TABLE Users(
	UserID int IDENTITY(1, 1) PRIMARY KEY,
	Username varchar(20),
	[Name] varchar(30),
	PasswordSalt varchar(60),
	PasswordHash varchar(60)
)

CREATE TABLE Song(
	SongID nvarchar(50) PRIMARY KEY,
	SongTitle nvarchar(200),
	AlbumID nvarchar(50),
	Genre varchar(20),
	SongReleaseDate DATE, 
	[Length] TIME,
	BPM int
)

CREATE TABLE Artist(
	ArtistID int PRIMARY KEY,
	[Name] nvarchar(100)
)

CREATE TABLE Album(
	AlbumID int IDENTITY(1, 1) PRIMARY KEY ,
	UserID int REFERENCES Users(UserID),
	AlbumName varchar(30),
	ReleaseDate date,
	[Length] time
)

CREATE TABLE Playlist(
	PlaylistID int IDENTITY(1, 1) PRIMARY KEY, 
	UserID int REFERENCES Users(UserID),
	PlaylistName varchar(30),
	PlaylistLength time
)

CREATE TABLE SongMadeBy(
	ArtistID int REFERENCES Artist(ArtistID),
	SongID nvarchar(50) REFERENCES Song(SongID),
	PRIMARY KEY(ArtistID, SongID)
)

CREATE TABLE AlbumReleasedBy(
	ArtistID int REFERENCES Artist(ArtistID),
	AlbumID int REFERENCES Album(AlbumID),
	PRIMARY KEY(ArtistID, AlbumID)
)

CREATE TABLE SongInPlaylist(
	SongID nvarchar(50) REFERENCES Song(SongID),
	PlaylistID int REFERENCES Playlist(PlaylistID),
	PRIMARY KEY(SongID, PlaylistID)
)

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
	IF EXISTS(SELECT * FROM [User] WHERE Username = @Username)
	BEGIN
      PRINT 'Error: Username already exists.';
	  RETURN 4
	END
	INSERT INTO [User](Username, [Name], PasswordSalt, PasswordHash)
	VALUES (@Username, @Name, @PasswordSalt, @PasswordHash)
END
GO

GO
