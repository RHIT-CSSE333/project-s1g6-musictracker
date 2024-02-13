CREATE OR ALTER PROCEDURE GetName (
	@UserID int
)
AS
BEGIN
	SELECT [Name] FROM Users WHERE UserID = @UserID
END
GO
CREATE OR ALTER PROCEDURE GetUserPlaylists (
	@UserID int
)
AS
BEGIN
	SELECT * FROM dbo.Playlist WHERE UserID = @UserID
END
GO
CREATE OR ALTER PROCEDURE CreatePlaylist (
	@UserID int, 
	@PlaylistName varchar(200)
)
AS
BEGIN
	INSERT INTO dbo.Playlist(UserID, PlaylistName, PlaylistLength) 
	VALUES (@UserID, @PlaylistName, 0)
END
GO
CREATE OR ALTER PROCEDURE PlaylistInfo (
	@PlaylistID int
)
AS
BEGIN
	SELECT * FROM dbo.Playlist WHERE PlaylistId = @PlaylistID
END
GO
CREATE OR ALTER PROCEDURE UpdatePlaylistName (
	@PlaylistName varchar(200),
	@PlaylistID int
)
AS
BEGIN
	UPDATE dbo.Playlist SET PlaylistName = @PlaylistName WHERE PlaylistId = @PlaylistID
END
GO
CREATE OR ALTER PROCEDURE SongList (
	@PlaylistID int
)
AS
BEGIN
	SELECT p.[PlaylistID], s.SongID, s.SongTitle, s.Genre, s.BPM, p.PlaylistName 
	FROM dbo.Playlist p 
	JOIN SongInPlaylist sp on p.[PlaylistID] = sp.PlaylistID 
	JOIN Song s on sp.SongID = s.SongID
	WHERE p.[PlaylistId] = @PlaylistID
END
GO
CREATE OR ALTER PROCEDURE AlbumView (
	@AlbumID nvarchar(50)
)
AS
BEGIN
	SELECT a.AlbumID, s.SongID, s.SongTitle, s.Genre, s.BPM, a.AlbumName, aa.ArtistID 
	FROM dbo.Album a 
	JOIN Song s on s.AlbumID = a.AlbumID 
	JOIN AlbumReleasedBy aa on aa.AlbumID = a.AlbumID 
	WHERE a.AlbumID = @AlbumID
END
GO
CREATE OR ALTER PROCEDURE ArtistView (
	@ArtistID int
)
AS
BEGIN
	SELECT aa.AlbumID, a.AlbumName, a.ReleaseDate, a.[Length], aa.ArtistID, aaa.[Name] as ArtistName
	FROM dbo.Album a
	JOIN AlbumReleasedBy aa ON aa.AlbumID = a.AlbumID
	JOIN Artist aaa ON aaa.ArtistID = aa.ArtistID
	WHERE aa.ArtistID = @ArtistID
END
GO
CREATE OR ALTER PROCEDURE DeletePlaylist (
	@PlaylistID int
)
AS
BEGIN
	DELETE FROM dbo.SongInPlaylist WHERE PlaylistId = @PlaylistID
	DELETE FROM dbo.Playlist WHERE PlaylistId = @PlaylistID
END
GO
CREATE OR ALTER PROCEDURE GetUserInfo (
	@Username varchar(20)
)
AS
BEGIN
	SELECT * FROM Login WHERE username = @Username	
END
GO
CREATE OR ALTER PROCEDURE GetAdmin (
	@Username varchar(20)
)
AS
BEGIN
	SELECT IsAdmin FROM Login WHERE username = @Username	
END
GO
CREATE OR ALTER PROCEDURE SearchResults (
	@ItemName nvarchar(200)
)
AS
BEGIN
	SELECT Song.SongTitle, Artist.Name, SongMadeBy.ArtistID, AlbumName, Song.AlbumID, Genre, Song.Length, Song.SongID 
	FROM Song 
	JOIN Album ON Song.AlbumID = Album.AlbumID 
	JOIN SongMadeBy ON Song.SongID = SongMadeBy.SongID 
	JOIN Artist ON SongMadeBy.ArtistID = Artist.ArtistID 
	WHERE SongTitle LIKE '%'+@ItemName+'%' OR AlbumName LIKE '%'+@ItemName+'%' OR Artist.Name LIKE '%'+@ItemName+'%'
END
GO

