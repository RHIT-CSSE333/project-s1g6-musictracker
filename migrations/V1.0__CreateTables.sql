CREATE TABLE Users(
	UserID int IDENTITY(1, 1) PRIMARY KEY,
	Username varchar(20),
	[Name] varchar(30),
)

CREATE TABLE Login(
	UserID int PRIMARY KEY REFERENCES Users(UserID),
	Username varchar(20),
	PasswordHash varchar(60),
	IsAdmin int
	-- PasswordHash varchar(60)
)

CREATE TABLE Song(
	SongID nvarchar(50) PRIMARY KEY,
	SongTitle nvarchar(200),
	AlbumID nvarchar(50),
	Genre varchar(100), 
	[Length] int,
	BPM decimal(18,3)
)

CREATE TABLE Artist(
	ArtistID int PRIMARY KEY,
	[Name] nvarchar(100)
)

CREATE TABLE Album(
	AlbumID nvarchar(50) PRIMARY KEY ,
	AlbumName varchar(200),
	ReleaseDate varchar(20),
	[Length] int
)

CREATE TABLE Playlist(
	PlaylistID int IDENTITY(1, 1) PRIMARY KEY, 
	UserID int REFERENCES Users(UserID),
	PlaylistName varchar(200),
	PlaylistLength int
)

CREATE TABLE SongMadeBy(
	ArtistID int REFERENCES Artist(ArtistID),
	SongID nvarchar(50) REFERENCES Song(SongID),
	PRIMARY KEY(ArtistID, SongID)
)

CREATE TABLE AlbumReleasedBy(
	ArtistID int REFERENCES Artist(ArtistID),
	AlbumID nvarchar(50) REFERENCES Album(AlbumID),
	PRIMARY KEY(ArtistID, AlbumID)
)

CREATE TABLE SongInPlaylist(
	SongID nvarchar(50) REFERENCES Song(SongID),
	PlaylistID int REFERENCES Playlist(PlaylistID),
	PRIMARY KEY(SongID, PlaylistID)
)



GO
