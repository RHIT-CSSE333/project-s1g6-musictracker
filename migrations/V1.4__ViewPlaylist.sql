CREATE OR ALTER VIEW ViewPlaylist
AS


SELECT p.PlaylistName, p.PlaylistLength, s.SongTitle, a.AlbumName, s.[Length]
FROM Playlist p
JOIN SongInPlaylist sp ON p.PlaylistID = sp.PlaylistID
JOIN Song s ON s.SongID = sp.SongID
JOIN Album a ON s.AlbumID = a.AlbumID
--WHERE p.PlaylistName = 'Cool Music'



