CREATE OR ALTER PROCEDURE RemoveSongFromPlaylist(
	@PlaylistName varchar(500), @SongName varchar(200)
)
AS
BEGIN

	DECLARE @PlaylistID varchar(50)
	SELECT @PlaylistID = PlaylistID FROM Playlist WHERE PlaylistName = @PlaylistName

	DECLARE @SongID varchar(50)
	SELECT @SongID = SongID FROM Song WHERE SongTitle = @SongName


    if @PlaylistID is null OR @PlaylistID = ''
	BEGIN
		PRINT 'ERROR: Playlist cannot be null or empty';
		RETURN (1)
	END
	if @SongID is null OR @SongID = ''
	BEGIN
		PRINT 'ERROR: Song cannot be null or empty';
		RETURN (2)
	END

	DELETE FROM SongInPlaylist WHERE SongID = @SongID AND PlaylistID = @PlaylistID

	DECLARE @SongLength int
	SELECT @SongLength = [Length] FROM Song WHERE SongID = @SongID

	UPDATE Playlist 
	SET [PlaylistLength] = [PlaylistLength] - @SongLength
	WHERE PlaylistID = @PlaylistID

END