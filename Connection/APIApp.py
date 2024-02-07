from flask import Flask, flash, g, render_template, redirect, request, session
from connection import coxn
from sqlalchemy import text
 
blogs = Flask(__name__)

#@blogs.before_request
#def load_logged_in_user():
 #   """If a user id is stored in the session, load the user object from
 #   the database into ``g.user``."""
 #   user_id = session.get("user_id")

 #   if user_id is None:
 #	   g.user = None
 #   else:
  #	  g.user = (
  #		 coxn.cursor().execute("SELECT * FROM Users WHERE UserID = ?", (user_id)).fetchone()
   #	 )
 
@blogs.route("/list")
def main():
    id = session['user_id']
    mssqltips = []
    user=[]

    user = coxn.execute("SELECT [Name] FROM dbo.Users WHERE UserID = ?",id).fetchone()
    coxn.commit()

    result = coxn.execute("SELECT * FROM dbo.Playlist WHERE UserID = ?", id)
    
    for row in result.fetchall():
        mssqltips.append({"PlaylistId": row[0], "PlaylistName": row[2], "PlaylistLength": row[3]})
    
    return render_template("PlaylistList.html", mssqltips = mssqltips,user=user)
 
@blogs.route("/addplaylist", methods = ['GET','POST'])
def addblog():
    if request.method == 'GET':
        return render_template("AddPlaylist.html")
    if request.method == 'POST':
        UserID = session['user_id']
        PlaylistName = request.form["PlaylistName"]
        cursor = coxn.cursor()
        cursor.execute("INSERT INTO dbo.Playlist(UserID, PlaylistName, PlaylistLength) VALUES (?, ?, ?)", UserID, PlaylistName, 0)
        cursor.commit()
       
        return redirect('/list')
 
@blogs.route('/updatePlaylist/<int:id>', methods = ['GET','POST'])
def updatePlaylist(id):
    cr = []
    cursor = coxn.cursor()
    if request.method == 'GET':
        cursor.execute("SELECT * FROM dbo.Playlist WHERE PlaylistId = ?", id)
        for row in cursor.fetchall():
            cr.append({"PlaylistId": row[0], "PlaylistName": row[2]})
        return render_template("UpdatePlaylist.html", tip =  cr[0])
    if request.method == 'POST':
        PlaylistName = request.form["PlaylistName"]
        cursor.execute("UPDATE dbo.Playlist SET PlaylistName = ? WHERE PlaylistId = ?", PlaylistName, id)
        coxn.commit()
        return redirect('/list')
    

@blogs.route('/songManage/<int:id>', methods = ['GET','POST'])
def manageSong(id):
    cr = []
    cursor = coxn.cursor()
    if request.method == 'GET':
        cursor.execute("SELECT p.[PlaylistID], s.SongID, s.SongTitle, s.Genre, s.BPM, p.PlaylistName FROM dbo.Playlist p JOIN SongInPlaylist sp on p.[PlaylistID] = sp.PlaylistID JOIN Song s on sp.SongID = s.SongID WHERE p.[PlaylistId] = ?", id)
        for row in cursor.fetchall():
            cr.append({"PlaylistID": row[0], "SongID": row[1], "SongTitle": row[2], "Genre": row[3], "BPM": row[4], "PlaylistName": row[5]})
        return render_template("SongList.html", cr = cr, play = id)
    if request.method == 'POST':
        PlaylistName = request.form["PlaylistName"]
        cursor.execute("UPDATE dbo.Playlist SET PlaylistName = ? WHERE PlaylistId = ?", PlaylistName, id)
        coxn.commit()
        return redirect('/list')
    
@blogs.route('/addSong/<int:id>', methods = ['GET','POST'])
def addSong(id):
    cursor = coxn.cursor()
    if request.method == 'GET':
        return render_template("AddSong.html", error = None)
    if request.method == 'POST':
        SongName = request.form["SongName"]
        error = None
        song = cursor.execute(
            "SELECT * FROM Song WHERE SongTitle = ?", (SongName)).fetchone()
        if song == None:
            print('ERROR')
            error = 'Song does not exist'
            flash(error)
            return render_template("AddSong.html", error=error)
        storedProc = 'exec [dbo].[AddSongToPlaylist] @PlaylistID = ?, @SongName = ?'
        params = (id, SongName)
        cursor.execute(storedProc, params)
        coxn.commit()
        return redirect('/list')

@blogs.route('/albumView/<string:id>', methods = ['GET'])
def albumView(id):
    cr = []
    cursor = coxn.cursor()
    cursor.execute("SELECT a.AlbumID, s.SongID, s.SongTitle, s.Genre, s.BPM, a.AlbumName, aa.ArtistID FROM dbo.Album a JOIN Song s on s.AlbumID = a.AlbumID JOIN AlbumReleasedBy aa on aa.AlbumID = a.AlbumID WHERE a.AlbumID = ?", id)
    for row in cursor.fetchall():
        cr.append({"AlbumID": row[0], "SongID": row[1], "SongTitle": row[2], "Genre": row[3], "BPM": row[4], "AlbumName": row[5], "ArtistID": row[6]})
    return render_template("AlbumView.html", cr = cr)
    
@blogs.route('/artistAlbums/<int:id>', methods = ['GET'])
def artistAlbums(id):
    cr = []
    cursor = coxn.cursor()
    cursor.execute("SELECT aa.AlbumID, a.AlbumName, a.ReleaseDate, a.[Length], aa.ArtistID FROM dbo.Album a JOIN AlbumReleasedBy aa ON aa.AlbumID = a.AlbumID WHERE aa.ArtistID = ?", id)
    for row in cursor.fetchall():
        cr.append({"AlbumID": row[0], "AlbumName": row[1], "ReleaseDate": row[2], "Length": row[3], "ArtistID": row[4]})
    return render_template("ArtistAlbums.html", cr = cr)

@blogs.route('/deleteSong/<string:songtitle>/<string:playlistname>/<int:playlistid>')
def deleteSong(songtitle, playlistname, playlistid):
    cursor = coxn.cursor()
    storedProc = 'exec [dbo].[RemoveSongFromPlaylist] @PlaylistName = ?, @SongName = ?'
    params = (playlistname, songtitle)
    cursor.execute(storedProc, params)
    coxn.commit()
    return redirect('/songManage/?', playlistid)

@blogs.route('/deletePlaylist/<int:id>')
def deletePlaylist(id):
    cursor = coxn.cursor()
    cursor.execute("DELETE FROM dbo.Playlist WHERE PlaylistId = ?", id)
   # cursor.execute("DELETE * FROM dbo.SongInPlaylist WHERE PlaylistId = ?", id)
    coxn.commit()
    return redirect('/list')



@blogs.route('/Login', methods = ['GET', 'POST'])
def loginUser():
    if request.method == 'POST':
        cursor = coxn.cursor()
        Username = request.form["Username"]
        Password = request.form["Password"]
        print("Posting " + Username + " " + Password)
        error = None
        user = cursor.execute(
            "SELECT * FROM Login WHERE username = ?", (Username)
        ).fetchone()
        if user is None:
            error = "Incorrect username."
       # elif not check_password_hash(user["password"], password):
        elif not user[2] == Password:
            error = "Incorrect password."
        if error is None:
            # store the user id in a new session and return to the index
            session.clear()
            session['user_id'] = user[0]
            return redirect('/list')
        flash(error)
        return render_template("Login.html", error=error)
    if request.method == 'GET':
        return render_template("Login.html")

@blogs.route('/Register', methods = ['GET', 'POST'])
def registerUser():
    if request.method == 'POST':
        cursor = coxn.cursor()
        RegisterUsername = request.form["registerUsername"]
        RegisterName = request.form["registerName"]
        RegisterPassword = request.form["registerPassword"]
       # result = cursor.execute('exec [dbo].[TempLogin](?, ?)', (Username, Password))
        error = None
        user = cursor.execute(
            "SELECT * FROM Login WHERE username = ?", (RegisterUsername)
        ).fetchone()
        if user is None:
            storedProc = 'exec [dbo].[Register] @Username = ?, @Name = ?, @PasswordHash = ?'
            params = (RegisterUsername, RegisterName, RegisterPassword)
            cursor.execute(storedProc, params)
            cursor.commit()
            return redirect('/Login')
           # if result != 0:
           #	  error = "Registration Error"

        #if error is None:
            # store the user id in a new session and return to the index
           # return redirect(url_for("index"))
         #   return redirect('/list')
        flash(error)
        return render_template("Register.html", error=None)
    if request.method == 'GET':
        return render_template("Register.html")
    
@blogs.route('/', methods = ['GET', 'POST'])
def landing():
    if request.method == 'GET' or request.method == 'POST':
        return render_template("Landing.html")
      
@blogs.route('/AdminPage', methods = ['GET', 'POST'])
def AdminPage():
     if request.method == 'GET' or request.method == 'POST':
        return render_template("AdminPage.html")
      
@blogs.route('/AddSongToDB', methods = ['GET', 'POST'])
def AdminAddSong():
    if request.method == 'POST':
        cursor = coxn.cursor()
        ArtistID = request.form["ArtistID"]
        SongID = request.form["SongID"]
        SongTitle = request.form["SongTitle"]
        AlbumID = request.form["AlbumID"]
        Genre = request.form["Genre"]
        Length = request.form["Length"]
        BPM = request.form["BPM"]
        

        storedProc = 'exec [dbo].[InsertSong] @ArtistID = ?, @SongID = ?, @SongTitle = ?, @AlbumID = ?, @Genre = ?, @Length = ?, @BPM = ?'
        params = (ArtistID, SongID, SongTitle, AlbumID, Genre, Length, BPM)
        cursor.execute(storedProc, params)
        cursor.commit()
        return render_template("AdminAddSong.html")
        
    if request.method == 'GET':
        return render_template("AdminAddSong.html")

@blogs.route('/AddAlbumsToDB', methods = ['GET', 'POST'])
def AdminAddAlbum():
    if request.method == 'POST':
        cursor = coxn.cursor()
        AlbumID = request.form["AlbumID"]
        AlbumName = request.form["AlbumName"]
        ReleaseDate = request.form["ReleaseDate"]
        ArtistName = request.form["ArtistName"]
        

        storedProc = 'exec [dbo].[InsertAlbum] @AlbumID = ?, @AlbumName = ?, @ReleaseDate = ?'
        params = (AlbumID, AlbumName, ReleaseDate)
        cursor.execute(storedProc, params)
        storedProc2 = 'exec [dbo].[InsertAlbumArtist] @ArtistName = ?, @AlbumID = ?'
        params2 = (ArtistName, AlbumID)
        cursor.execute(storedProc2, params2)
        
        cursor.commit()
        return render_template("AdminAddAlbum.html")
    if request.method == 'GET':
        return render_template("AdminAddAlbum.html")


@blogs.route("/logout")
def logout():
    """Clear the current session, including the stored user id."""
    session.clear()
    return redirect('/')

@blogs.route('/search/<int:id>',methods = ['GET', 'POST'])
def search(id):
    mssqltips = []
    if request.method == 'GET':
        return render_template("Search.html",mssqltips=mssqltips)
    if request.method == 'POST':
        cursor = coxn.cursor()
        ItemName = request.form["ItemName"]
    
        result = cursor.execute("SELECT Song.SongTitle, Artist.Name, SongMadeBy.ArtistID, AlbumName, Song.AlbumID, Genre, Song.Length FROM Song JOIN Album ON Song.AlbumID = Album.AlbumID JOIN SongMadeBy ON Song.SongID = SongMadeBy.SongID JOIN Artist ON SongMadeBy.ArtistID = Artist.ArtistID WHERE SongTitle LIKE ? OR AlbumName LIKE ? OR Artist.Name LIKE ?", "%"+ItemName+"%","%"+ItemName+"%","%"+ItemName+"%" )
        for row in result.fetchall():
            mssqltips.append({"SongTitle":row[0], "ArtistName":row[1], "ArtistID":row[2], "AlbumName":row[3], "AlbumID":row[4],"Genre": row[5], "Length":row[6]})      
            coxn.commit()
    return render_template("Search.html",mssqltips=mssqltips,id=id)
 
if(__name__ == "__main__"):

    blogs.secret_key = 'super secret key'
    blogs.debug = True
    blogs.run()
