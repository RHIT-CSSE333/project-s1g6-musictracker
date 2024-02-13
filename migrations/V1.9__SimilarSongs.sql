SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SimilarSongs] (@PlaylistID int) AS
	SELECT TOP 64 ss.SongTitle, ss.Genre, ss.[Length], ss.BPM, ss.AlbumID, SongMadeBy.ArtistID FROM dbo.Song ss JOIN dbo.Song ps ON ss.Genre = ps.Genre JOIN SongInPlaylist sip ON ps.SongID = sip.SongID JOIN SongMadeBy ON SongMadeBy.SongID = ss.SongID WHERE sip.PlaylistID = @PlaylistID GROUP BY ss.SongID, ss.SongTitle, ss.Genre, ss.Length, ss.BPM, ss.AlbumID, SongMadeBy.ArtistID ORDER BY MIN(ABS(ss.BPM - ps.BPM)*ABS(ss.Length - ps.Length)) ASC
GO
