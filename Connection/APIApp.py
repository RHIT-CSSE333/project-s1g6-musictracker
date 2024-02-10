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
    admin = session['admin']
    mssqltips = []
    user=[]

    user = coxn.execute("exec GetName ?",id).fetchone()
    coxn.commit()

    result = coxn.execute("exec GetUserPlaylists ?", id)
    
    for row in result.fetchall():
        mssqltips.append({"PlaylistId": row[0], "PlaylistName": row[2], "PlaylistLength": row[3]})
    
    return render_template("PlaylistList.html", mssqltips = mssqltips, user=user, admin=admin)
 
@blogs.route("/addplaylist", methods = ['GET','POST'])
def addblog():
    if request.method == 'GET':
        return render_template("AddPlaylist.html")
    if request.method == 'POST':
        UserID = session['user_id']
        PlaylistName = request.form["PlaylistName"]
        cursor = coxn.cursor()
        cursor.execute("EXEC CreatePlaylist ?,?", UserID, PlaylistName)
        cursor.commit()
       
        return redirect('/list')
 
@blogs.route('/updatePlaylist/<int:id>', methods = ['GET','POST'])
def updatePlaylist(id):
    cr = []
    cursor = coxn.cursor()
    if request.method == 'GET':
        cursor.execute("EXEC PlaylistInfo ?", id)
        for row in cursor.fetchall():
            cr.append({"PlaylistId": row[0], "PlaylistName": row[2]})
        return render_template("UpdatePlaylist.html", tip =  cr[0])
    if request.method == 'POST':
        PlaylistName = request.form["PlaylistName"]
        cursor.execute("EXEC UpdatePlaylistName ?,?", PlaylistName, id)
        coxn.commit()
        return redirect('/list')
    
@blogs.route('/suggestedSongs/<int:id>', methods = ['GET'])
def suggestedSongs(id):
    cr = []
    cursor = coxn.cursor()
    if request.method == 'GET':
        cursor.execute("SELECT TOP 64 ss.SongTitle, ss.Genre, ss.[Length], ss.BPM FROM dbo.Song ss JOIN dbo.Song ps ON ss.Genre = ps.Genre JOIN SongInPlaylist sip ON ps.SongID = sip.SongID WHERE sip.PlaylistID = ? GROUP BY ss.SongID, ss.SongTitle, ss.Genre, ss.Length, ss.BPM ORDER BY MIN(ABS(ss.BPM - ps.BPM)*ABS(ss.Length - ps.Length)) ASC" if True else "EXEC SimilarSongs @PlaylistID = ?", id)
        for row in cursor.fetchall():
            cr.append({"SongTitle": row[0], "Genre": row[1], "Length": row[2], "BPM": row[3]})
        return render_template("SimilarSongs.html", tip = cr)
    

@blogs.route('/songManage/<int:id>', methods = ['GET','POST'])
def manageSong(id):
    cr = []
    cursor = coxn.cursor()
    if request.method == 'GET':
        cursor.execute("EXEC SongList ?", id)
        for row in cursor.fetchall():
            cr.append({"PlaylistID": row[0], "SongID": row[1], "SongTitle": row[2], "Genre": row[3], "BPM": row[4], "PlaylistName": row[5]})
        return render_template("SongList.html", cr = cr, play = id)
    if request.method == 'POST':
        PlaylistName = request.form["PlaylistName"]
        cursor.execute("EXEC UpdatePlaylistName ?,?", PlaylistName, id)
        coxn.commit()
        return redirect('/list')
    
@blogs.route('/search/addSong/<int:id>/<string:title>', methods = ['GET','POST'])

def addSong(id,title):
    cursor = coxn.cursor()
    
    #     return render_template("AddSong.html", error = None)
    # if request.method == 'POST':
    #     SongName = request.form["SongName"]
    #     error = None
    #     song = cursor.execute(
    #         "SELECT * FROM Song WHERE SongTitle = ?", (SongName)).fetchone()
    #     if song == None:
    #         print('ERROR')
    #         error = 'Song does not exist'
    #         flash(error)
    #         return render_template("AddSong.html", error=error)
    storedProc = 'exec [dbo].[AddSongToPlaylist] @PlaylistID = ?, @SongName = ?'
    params = (id, title)
    cursor.execute(storedProc, params)
    coxn.commit()
    string='/songManage/'
    print(string)
    string+=str(id)
    print(string)
    return redirect(string)

@blogs.route('/albumView/<string:id>', methods = ['GET'])
def albumView(id):
    cr = []
    cursor = coxn.cursor()
    cursor.execute("EXEC AlbumView ?", id)
    for row in cursor.fetchall():
        cr.append({"AlbumID": row[0], "SongID": row[1], "SongTitle": row[2], "Genre": row[3], "BPM": row[4], "AlbumName": row[5], "ArtistID": row[6]})
    return render_template("AlbumView.html", cr = cr)
    
@blogs.route('/artistAlbums/<int:id>', methods = ['GET'])
def artistAlbums(id):
    cr = []
    cursor = coxn.cursor()
    cursor.execute("EXEC ArtistView ?", id)
    for row in cursor.fetchall():
        cr.append({"AlbumID": row[0], "AlbumName": row[1], "ReleaseDate": row[2], "Length": row[3], "ArtistID": row[4]})
    return render_template("ArtistAlbums.html", cr = cr)

@blogs.route('/songManage/deleteSong/<string:songtitle>/<string:playlistname>/<int:playlistid>')
def deleteSong(songtitle, playlistname, playlistid):
    cursor = coxn.cursor()
    storedProc = 'exec [dbo].[RemoveSongFromPlaylist] @PlaylistName = ?, @SongName = ?'
    params = (playlistname, songtitle)
    cursor.execute(storedProc, params)
    coxn.commit()
    string='/songManage/'
    string+=str(playlistid)
    return redirect(string)

@blogs.route('/deletePlaylist/<int:id>')
def deletePlaylist(id):
    cursor = coxn.cursor()
    # cursor.execute("DELETE FROM dbo.SongInPlaylist WHERE PlaylistId = ?", id)
    # coxn.commit()
    #cursor.execute("DELETE FROM dbo.Playlist WHERE PlaylistId = ?", id)
    cursor.execute("EXEC DeletePlaylist ?", id)
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
            "EXEC GetUserInfo ?", (Username)
        ).fetchone()
        login = cursor.execute(
            "EXEC GetAdmin ?", (Username)
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
            session['admin'] = login[0]
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
            "EXEC GetUserInfo ?", (RegisterUsername)
        ).fetchone()
        if user is None:
            storedProc = 'exec [dbo].[Register] @Username = ?, @Name = ?, @PasswordHash = ?, @IsAdmin = ?'
            params = (RegisterUsername, RegisterName, RegisterPassword, 0)
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
        ArtistName = request.form["ArtistName"] # ArtistName
        SongTitle = request.form["SongTitle"]
        AlbumName = request.form["AlbumName"] #AlbumName
        Genre = request.form["Genre"]
        Length = request.form["Length"]
        BPM = request.form["BPM"]
        

        storedProc = 'exec [dbo].[InsertSong] @ArtistName = ?, @SongTitle = ?, @AlbumName = ?, @Genre = ?, @Length = ?, @BPM = ?'
        params = (ArtistName, SongTitle, AlbumName, Genre, Length, BPM)
        cursor.execute(storedProc, params)
        cursor.commit()
        return render_template("AdminAddSong.html")
        
    if request.method == 'GET':
        return render_template("AdminAddSong.html")

@blogs.route('/AddAlbumsToDB', methods = ['GET', 'POST'])
def AdminAddAlbum():
    if request.method == 'POST':
        cursor = coxn.cursor()
        AlbumName = request.form["AlbumName"]
        ReleaseDate = request.form["ReleaseDate"]
        ArtistName = request.form["ArtistName"]
        
        storedProc = 'exec [dbo].[InsertAlbumAdmin] @AlbumName = ?, @ArtistName = ?, @ReleaseDate = ?'
        params = (AlbumName, ArtistName, ReleaseDate)
        cursor.execute(storedProc, params)
        
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
        result = cursor.execute("EXEC SearchResults ?",ItemName)
        for row in result.fetchall():
            mssqltips.append({"SongTitle":row[0], "ArtistName":row[1], "ArtistID":row[2], "AlbumName":row[3], 
                              "AlbumID":row[4],"Genre": row[5], "Length":row[6],"SongID":row[6]})      
            coxn.commit()
    return render_template("Search.html",mssqltips=mssqltips,id=id)

@blogs.route('/search2',methods = ['GET', 'POST'])
def search2():
    mssqltips = []
    if request.method == 'GET':
        return render_template("Search.html",mssqltips=mssqltips)
    if request.method == 'POST':
        cursor = coxn.cursor()
        ItemName = request.form["ItemName"]

        result = cursor.execute("EXEC SearchResults ?",ItemName)
        for row in result.fetchall():
            mssqltips.append({"SongTitle":row[0], "ArtistName":row[1], "ArtistID":row[2], "AlbumName":row[3], 
                              "AlbumID":row[4],"Genre": row[5], "Length":row[6],"SongID":row[6]})      
            coxn.commit()
    return render_template("Search2.html",mssqltips=mssqltips,)
 
if(__name__ == "__main__"):

    blogs.secret_key = 'super secret key'
    blogs.debug = True
    blogs.run()
