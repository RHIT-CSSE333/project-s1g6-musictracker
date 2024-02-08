/****** Object:  StoredProcedure [dbo].[InsertSongArtist]    Script Date: 2/1/2024 7:27:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [dbo].[InsertSong](
	@ArtistID int,
	@SongID nvarchar(50),
	@SongTitle nvarchar(200),
	@AlbumID nvarchar(50),
	@Genre varchar(100),
	@Length int,
	@BPM decimal(18,3)
)
AS
BEGIN

	--DECLARE @ArtistID int
	--SELECT @ArtistID = ArtistID FROM Artist WHERE [Name] = @ArtistName

		INSERT INTO Song VALUES(@SongID, @SongTitle, @AlbumID, @Genre, @Length, @BPM)
		INSERT INTO SongMadeBy VALUES(@ArtistID, @SongID)
END
