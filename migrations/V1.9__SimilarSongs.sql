SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SimilarSongs] (@Count int, @PlaylistID int) AS SELECT TOP 64 ss.SongTitle, ss.Genre, ss.[Length], ss.BPM FROM dbo.Song ss JOIN dbo.Song ps ON ss.Genre = ps.Genre JOIN SongInPlaylist sip ON ps.SongID = sip.SongID WHERE sip.PlaylistID = @PlaylistID GROUP BY ss.SongID, ss.SongTitle, ss.Genre, ss.Length, ss.BPM ORDER BY MIN(ABS(ss.BPM - ps.BPM)*ABS(ss.Length - ps.Length)) ASC
GO
