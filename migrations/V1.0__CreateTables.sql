CREATE TABLE Users(
	UserID int PRIMARY KEY,
	Username varchar(20),
	[Name] varchar(30),
)

CREATE TABLE Login(
	UserID int PRIMARY KEY,
	Username varchar(20),
	PasswordHash varchar(60),
	PasswordSalt varchar(60)
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

GO
