CREATE OR ALTER PROCEDURE AddSongToPlaylist(
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

INSERT INTO [SongInPlaylist] 
VALUES(@SongID,@PlaylistID)

END
