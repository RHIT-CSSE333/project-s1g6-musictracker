CREATE OR ALTER PROCEDURE InsertAlbum(
	@AlbumID nvarchar(50),
	@AlbumName nvarchar(200),
	@ReleaseDate nvarchar(20)
)
AS
BEGIN

	IF ( NOT EXISTS(SElECT AlbumID FROM Album WHERE AlbumID = @AlbumID))
		BEGIN

			INSERT INTO Album VALUES(@AlbumID,@AlbumName,@ReleaseDate,NULL)

		END

END

GO

CREATE OR ALTER PROCEDURE InsertAlbumAdmin(
	@AlbumName nvarchar(200),
	@ArtistName nvarchar(100),
	@ReleaseDate nvarchar(20)
)
AS
BEGIN

	DECLARE @AlbumID int
	SET @AlbumID = 1

	WHILE EXISTS (SELECT 1 FROM Album WHERE AlbumID = CONVERT(NVARCHAR(50), @AlbumID))
	BEGIN
		SET @AlbumID = @AlbumID + 1;
	END

	--SET @AlbumID = CONVERT(NVARCHAR(50), @AlbumID)

	INSERT INTO Album VALUES(@AlbumID,@AlbumName,@ReleaseDate,NULL)


	DECLARE @ArtistID int
	SELECT @ArtistID = ArtistID FROM Artist WHERE [Name] = @ArtistName

			INSERT INTO AlbumReleasedBy VALUES(@ArtistID,@AlbumID)

END

GO

CREATE OR ALTER PROCEDURE InsertArtist(
	@ArtistName nvarchar(20)
)
AS
BEGIN

	IF ( NOT EXISTS(SElECT [Name] FROM Artist WHERE [Name] = @ArtistName))
		BEGIN

			declare @id int
			SELECT @id = count([Name]) FROM Artist
			INSERT INTO Artist VALUES(@id+1,@ArtistName)

		END

END

GO

CREATE OR ALTER PROCEDURE InsertSongArtist(
	@ArtistName nvarchar(100),
	@SongID nvarchar(50)
)
AS
BEGIN

	DECLARE @ArtistID int
	SELECT @ArtistID = ArtistID FROM Artist WHERE [Name] = @ArtistName

	IF (NOT EXISTS(SElECT * FROM SongMadeBy WHERE ArtistID = @ArtistID AND SongID = @SongID) AND @ArtistID IS NOT NULL)
	BEGIN
		INSERT INTO SongMadeBy VALUES(@ArtistID,@SongID)
	END
END

GO

CREATE OR ALTER PROCEDURE InsertAlbumArtist(
	@ArtistName nvarchar(100),
	@AlbumID nvarchar(50)
)
AS
BEGIN


	DECLARE @ArtistID int
	SELECT @ArtistID = ArtistID FROM Artist WHERE [Name] = @ArtistName

IF (NOT EXISTS(SElECT * FROM AlbumReleasedBy WHERE ArtistID = @ArtistID AND AlbumID = @AlbumID)AND @ArtistID IS NOT NULL)
BEGIN
	INSERT INTO AlbumReleasedBy VALUES(@ArtistID,@AlbumID)
END

END




