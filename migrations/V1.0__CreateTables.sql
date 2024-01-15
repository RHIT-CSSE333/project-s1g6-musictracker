CREATE TABLE Users(
	UserID int PRIMARY KEY,
	Username varchar(20),
	[Name] varchar(30),
)

CREATE TABLE Song(
	SongID int PRIMARY KEY,
	SongTitle varchar(20),
	AlbumID varchar(20),
	Genre varchar(20),
	SongReleaseDate DATE, 
	[Length] TIME,
	BPM int
)

CREATE TABLE Artist(
	ArtistID int PRIMARY KEY,
	[Name] varchar(30)
)

CREATE TABLE Album(
	AlbumID int PRIMARY KEY,
	AlbumName varchar(30),
	ReleaseDate date,
	[Length] time
)

CREATE TABLE Playlist(
	PlaylistID int PRIMARY KEY, 
	PlaylistName varchar(30),
	PlaylistLength time
)

CREATE TABLE PlaylistCreatedBy(
	UserID int REFERENCES Users(UserID),
	PlaylistID int REFERENCES Playlist(PlaylistID),
	PRIMARY KEY(UserID,PlaylistID)
)

CREATE TABLE SongMadeBy(
	ArtistID int REFERENCES Artist(ArtistID),
	SongID int REFERENCES Song(SongID),
	PRIMARY KEY(ArtistID, SongID)
)

CREATE TABLE AlbumReleasedBy(
	ArtistID int REFERENCES Artist(ArtistID),
	AlbumID int REFERENCES Album(AlbumID),
	PRIMARY KEY(ArtistID, AlbumID)
)

CREATE TABLE SongInPlaylist(
	SongID int REFERENCES Song(SongID),
	PlaylistID int REFERENCES Playlist(PlaylistID),
	PRIMARY KEY(SongID, PlaylistID)
)

CREATE USER halseysh FROM LOGIN halseysh;

exec sp_addrolemember 'db_owner', 'halseysh';

CREATE USER steimlj FROM LOGIN steimlj;

exec sp_addrolemember 'db_owner', 'steimlj';


GO
