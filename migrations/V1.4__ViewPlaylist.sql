CREATE OR ALTER PROCEDURE ViewPlaylistProc(
	@PlaylistName varchar(200)
)
AS


SELECT p.PlaylistName, p.PlaylistLength/1000/60 as PlaylistLength, s.SongTitle, art.[Name] as ArtistName, a.AlbumName, s.[Length]/1000/60 as SongLengthMinutes
FROM Playlist p
JOIN SongInPlaylist sp ON p.PlaylistID = sp.PlaylistID
JOIN Song s ON s.SongID = sp.SongID
JOIN Album a ON s.AlbumID = a.AlbumID
JOIN SongMadeBy smb ON smb.SongID =s.SongID
JOIN Artist art ON smb.ArtistID = art.ArtistID
WHERE p.PlaylistName = @PlaylistName




