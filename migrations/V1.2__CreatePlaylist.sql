USE [MusicTracker-halseysh]
GO

CREATE OR ALTER PROCEDURE [dbo].[CreatePlaylist]
	@userID int,
	@playlistName nvarchar(30)
AS
	if @userID is null OR @userID = ''
	BEGIN
		PRINT 'ERROR: User ID cannot be null or empty';
		RETURN (1)
	END
	if @playlistName is null OR @playlistName = ''
	BEGIN
		PRINT 'ERROR: Playlist name cannot be null or empty';
		RETURN (2)
	END

	IF (SELECT COUNT(*) FROM Playlist
          WHERE PlaylistName = @playlistName AND UserID = @userID) = 1
	BEGIN
      PRINT 'ERROR: Playlist name already exists.';
	  RETURN(2)
	END


	
	INSERT INTO Playlist
	VALUES(@userID, @playlistName, '00:00:00.0000000');

	GO
