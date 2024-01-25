

import java.io.*;
import java.sql.*;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Locale;
 
public class Main {
 
    public static void main(String[] args) throws ParseException {
        String jdbcURL = "jdbc:sqlserver://golem.csse.rose-hulman.edu;databaseName=MusicTracker-deckerct;user=deckerct;password={RedParade2023}";
 
        String csvFilePath = "Songs-short.txt";
 
        int batchSize = 20;
 
        Connection connection = null;
 
        try {
 
            connection = DriverManager.getConnection(jdbcURL);
            connection.setAutoCommit(false);
 
            String insertQuery = "INSERT INTO Song VALUES (?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement insertStatement = connection.prepareStatement(insertQuery);

            CallableStatement insertAlbum = connection.prepareCall("{CALL [InsertAlbum](?,?,?)}");
            CallableStatement insertArtist = connection.prepareCall("{CALL [InsertArtist](?)}");
            CallableStatement insertSongArtist = connection.prepareCall("{CALL [InsertSongArtist](?,?)}");
            CallableStatement insertAlbumArtist = connection.prepareCall("{CALL [InsertAlbumArtist](?,?)}");

            BufferedReader lineReader = new BufferedReader(new FileReader(csvFilePath));
            String lineText = null;

            int count = 0;
 
            lineReader.readLine(); // skip header line
 
            Integer id = 0;
            while ((lineText = lineReader.readLine()) != null) {
            	
                String[] data = lineText.split("\\t");
                String SongID = data[0];
                String SongTitle = data[1];
                String ArtistName = data[2];
                String AlbumID = data[4];
                String AlbumTitle = data[5];
                String Genre = data[9];
                String Date = data[6];
                Integer Length = Integer.valueOf(data[22]);
                Double BPM = Double.valueOf(data[21]);
 
                insertStatement.setString(1, SongID);
                insertStatement.setString(2, SongTitle);             
                insertStatement.setString(3, AlbumID);
                insertStatement.setString(4, Genre);
                insertStatement.setString(5, Date);
                insertStatement.setInt(6, Length);
                insertStatement.setDouble(7,BPM);

                insertAlbum.setString(1,AlbumID);
                insertAlbum.setString(2,AlbumTitle);
                insertAlbum.setString(3,Date);

                insertArtist.setString(1,ArtistName);

                insertSongArtist.setString(1,ArtistName);
                insertSongArtist.setString(2,SongID);

                insertAlbumArtist.setString(1,ArtistName);
                insertAlbumArtist.setString(2,AlbumID);

 
                insertStatement.addBatch();
                insertAlbum.addBatch();
                insertArtist.addBatch();
                insertSongArtist.addBatch();
                insertAlbumArtist.addBatch();
 
                if (count % batchSize == 0) {
                    insertStatement.executeBatch();
                    insertAlbum.executeBatch();
                    insertArtist.executeBatch();
                    insertSongArtist.executeBatch();
                    insertAlbumArtist.executeBatch();
                }
              id++;
            }
 
            lineReader.close();
 
            // execute the remaining queries
            insertStatement.executeBatch();
            insertAlbum.executeBatch();
            insertArtist.executeBatch();
            insertSongArtist.executeBatch();
            insertAlbumArtist.executeBatch();
 
            connection.commit();
            connection.close();
 
        } catch (IOException ex) {
            System.err.println(ex);
        } catch (SQLException ex) {
            ex.printStackTrace();
 
            try {
                connection.rollback();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
 
    }
}
