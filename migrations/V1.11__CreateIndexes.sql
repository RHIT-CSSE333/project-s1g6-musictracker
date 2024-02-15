CREATE INDEX AlbumNameInd 
ON Album (AlbumName)
GO

CREATE INDEX SongTitleInd
ON Song (SongTitle)
GO

CREATE INDEX ArtistNameInd
ON Artist ([Name]) 
GO

CREATE INDEX UsernameInd
ON Users (Username)
GO

CREATE INDEX PasswordInd
ON [Login] (PasswordHash)
GO

