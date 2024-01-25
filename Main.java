

import java.io.*;
import java.sql.*;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Locale;
 
public class Main {
 
    public static void main(String[] args) throws ParseException {
        String jdbcURL = "jdbc:sqlserver://golem.csse.rose-hulman.edu;databaseName=MusicTrackerS1G6;user=deckerct;password={RedParade2023}";
 
        String csvFilePath = "Songs-short.txt";
 
        int batchSize = 20;
 
        Connection connection = null;
 
        try {
 
            connection = DriverManager.getConnection(jdbcURL);
            connection.setAutoCommit(false);
 
            String insertQuery = "INSERT INTO Song VALUES (?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement insertStatement = connection.prepareStatement(insertQuery);
 
            BufferedReader lineReader = new BufferedReader(new FileReader(csvFilePath));
            String lineText = null;
            SimpleDateFormat formatter = new SimpleDateFormat("MM-dd-yy");

            int count = 0;
 
            lineReader.readLine(); // skip header line
 
            Integer id = 0;
            while ((lineText = lineReader.readLine()) != null) {
            	
                String[] data = lineText.split("\\t");
                String SongID = data[0];
                String SongTitle = data[1];
                //System.out.println(SongTitle);
                String AlbumID = data[4];
                //System.out.println(AlbumID);
                String Genre = data[9];
                //System.out.println(Genre);
                
              
                
//                java.sql.Date songReleaseDate = new java.sql.Date(formatter.parse(data[6]).getTime());
//                java.sql.Date sqlSongReleaseDate = new java.sql.Date(songReleaseDate.getTime());
                
           
                String Length = data[22];
                String BPM = data[21];
 
                insertStatement.setString(1, id.toString());
                insertStatement.setString(2, SongTitle);             
                insertStatement.setString(3, AlbumID);
                insertStatement.setString(4, Genre);
                insertStatement.setDate(5, null);
                insertStatement.setString(6, null);
                insertStatement.setInt(7, 0);
 
                insertStatement.addBatch();
 
                if (count % batchSize == 0) {
                    insertStatement.executeBatch();
                }
              id++;
            }
 
            lineReader.close();
 
            // execute the remaining queries
            insertStatement.executeBatch();
 
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
