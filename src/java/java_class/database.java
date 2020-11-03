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
import java.util.Dictionary;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.Map;

/**
 *
 * @author Juan
 */
public final class database {

    final private String url = "jdbc:oracle:thin:@localhost:1521:xe";
    final private String user = "system";
    final private String password = "123";
    Connection con;

    //CONVERT TO FUNCTION AND CALL IT IN THE CONSTRUCTOR
    public database() {

    }

    public void connect() {
        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            con = DriverManager.getConnection(url, user, password);
        } catch (ClassNotFoundException | SQLException e) {
            System.out.println("Something went wrong!: " + e.getMessage());
        }
    }

    public void disconnect() {
        try {
            con.close();
        } catch (SQLException e) {
            System.out.println("Cannot disconnet from database " + e.getMessage());
        }
    }

    public person getPerson(String id) {
        connect();
        person p1 = null;
        try {
            String sql = "SELECT * FROM PERSONA WHERE ID_PERSONA = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, id);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                p1 = new person();
                p1.setId(id);
                p1.setName(rs.getString(2));
                p1.setLastName(rs.getString(3));
            }

        } catch (SQLException e) {
            System.out.println("Error when try to get person: " + e.getMessage());
            p1 = null;
        }
        disconnect();
        return p1;
    }

    public String getRol(String id) {
        connect();
        String rol = null;
        try {
            String sql = "SELECT NOMBRE_ROL FROM ROL "
                    + "INNER JOIN PERSONA_ROL ON PERSONA_ROL.ID_ROL = ROL.ID_ROL "
                    + "WHERE PERSONA_ROL.ID_PERSONA=?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, id);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                rol = rs.getString(1);
            }
            return rol;
        } catch (SQLException e) {
            System.out.println("Cannot get rol " + e.getMessage());
            rol = null;
        }
        disconnect();
        return rol;
    }

    public Map getType() {
        connect();
        Map<String,String>vehicle_type = new HashMap();
        try {
            String sql = "SELECT * FROM TIPO";
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while(rs.next()){
                vehicle_type.put(rs.getString(1), rs.getString(2));
            }
            
        } catch (SQLException e) {
            System.out.println("Cannot get data from TIPO: " + e.getMessage());
        }
        disconnect();
        return vehicle_type;
    }
}
