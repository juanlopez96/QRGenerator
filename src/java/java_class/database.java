/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package java_class;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 *
 * @author Juan
 */
public class database {

    final private String url = "jdbc:oracle:thin:@localhost:1521:xe";
    final private String user = "system";
    final private String password = "123";
    Connection con;

    public database() {
        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            con = DriverManager.getConnection(url, user, password);
        } catch (Exception e) {
            System.out.println("Something went wrong!: " + e.getMessage());
        }
    }

    public void diconnect() throws SQLException {
        con.close();
    }
    
    public person getPerson(String id){
        person p1 = null;
        try{
            String sql = "SELECT * FROM PERSONA WHERE ID_PERSONA = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, id);
            ResultSet rs = ps.executeQuery();
            while(rs.next()){
                p1 = new person();
                p1.setId(id);
                p1.setName(rs.getString(2));
                p1.setLastName(rs.getString(3));
            }
            return p1;
            
        }catch(SQLException e){
            System.out.println("Error when try to get person: " + e.getMessage());
            return null;
        }
        
    }
}