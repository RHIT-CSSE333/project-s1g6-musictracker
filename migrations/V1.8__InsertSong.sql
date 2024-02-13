/****** Object:  StoredProcedure [dbo].[InsertSongArtist]    Script Date: 2/1/2024 7:27:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [dbo].[InsertSong](
	@ArtistName nvarchar(100),
	@SongTitle nvarchar(200),
	@AlbumName nvarchar(50),
	@Genre varchar(100),
	@Length int,
	@BPM decimal(18,3)
)
AS
BEGIN

	DECLARE @ArtistID int
	SELECT @ArtistID = ArtistID FROM Artist WHERE [Name] = @ArtistName

	DECLARE @SongID nvarchar(50)
	DECLARE @newValue int
	SET @newValue = 1

	WHILE EXISTS (SELECT 1 FROM Song WHERE SongID = CONVERT(NVARCHAR(50), @newValue))
	BEGIN
		SET @newValue = @newValue + 1;
	END

	DECLARE @AlbumID nvarchar(50)
	SELECT @AlbumID = AlbumID FROM Album WHERE AlbumName = @AlbumName

		INSERT INTO Song VALUES(@newValue, @SongTitle, @AlbumID, @Genre, @Length, @BPM)
		INSERT INTO SongMadeBy VALUES(@ArtistID, @newValue)
END
