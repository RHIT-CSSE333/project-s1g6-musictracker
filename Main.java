

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
 
            String sql = "INSERT INTO Song VALUES (?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement statement = connection.prepareStatement(sql);
 
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
 
                statement.setString(1, id.toString());
                statement.setString(2, SongTitle);             
                statement.setString(3, AlbumID);
                statement.setString(4, Genre);
                statement.setDate(5, null);

                statement.setString(6, null);
                statement.setInt(7, 0);
 
                statement.addBatch();
 
                if (count % batchSize == 0) {
                    statement.executeBatch();
                }
              id++;
            }
 
            lineReader.close();
 
            // execute the remaining queries
            statement.executeBatch();
 
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
