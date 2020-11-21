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
import java.util.ArrayList;
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
    final private encryption crypto = new encryption();
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

        return p1;
    }

    public String getRol(String id) {

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

        return rol;
    }

    public Map getType() {

        Map<String, String> vehicle_type = new HashMap();
        try {
            String sql = "SELECT * FROM TIPO";
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                vehicle_type.put(rs.getString(1), rs.getString(2));
            }

        } catch (SQLException e) {
            System.out.println("Cannot get data from TIPO: " + e.getMessage());
        }

        return vehicle_type;
    }

    public ArrayList getMarca() {
        ArrayList<marca_vehiculo> marcas = new ArrayList();
        try {
            String sql = "SELECT * FROM MARCA";
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                marca_vehiculo aux = new marca_vehiculo();
                aux.setId_marca(rs.getString(1));
                aux.setId_tipo(rs.getString(2));
                aux.setNombre_marca(rs.getString(3));
                marcas.add(aux);
            }

        } catch (SQLException e) {
            System.out.println("Cannot get data from MARCA: " + e.getMessage());
        }

        return marcas;
    }

    public ArrayList<String> id_person() {
        ArrayList<String> ids = new ArrayList<>();
        try {
            String sql = "SELECT ID_PERSONA FROM PERSONA";
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ids.add(rs.getString(1));
            }
        } catch (Exception e) {
            System.out.println("Cannnot get all users " + e.getMessage());
        }
        return ids;
    }

    public ArrayList<persona_vehiculo> getVehicleByPersonId(String id_person) {
        ArrayList<persona_vehiculo> per_veh = new ArrayList<>();

        try {
            String sql = "SELECT * FROM PERSONA_VEHICULO WHERE ID_PERSONA = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, id_person);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                persona_vehiculo aux = new persona_vehiculo();
                aux.setId_persona(rs.getString(1));
                aux.setPlaca_vehiculo(crypto.decrypt(rs.getString(2)));
                aux.setPropietario(rs.getInt(3));
                per_veh.add(aux);
            }
        } catch (Exception e) {
            System.out.println("Error consultado persona_vehiculo " + e.getMessage());
        }
        return per_veh;
    }

    public boolean insertVehicle(vehicle veh, ArrayList<persona_vehiculo> autorized) {
        boolean insertVehicle = true;
        boolean insertPersona_vehiculo = true;
        try {
            String sql = "INSERT INTO VEHICULO VALUES (?,?,?,?,?,?)";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, crypto.encrypt(veh.getPlaca_vehiculo()));
            ps.setString(2, veh.getId_marca());
            ps.setString(3, veh.getId_tipo());
            ps.setString(4, veh.getModelo_vehiculo());
            ps.setString(5, veh.getColor_vehiculo());
            ps.setString(6, veh.getDescripcion_vehiculo());
            ps.executeUpdate();
            if (autorized.size() > 0) {
                for (persona_vehiculo x : autorized) {
                    String sql2 = "INSERT INTO PERSONA_VEHICULO VALUES (?,?,?)";
                    try {
                        PreparedStatement ps2 = con.prepareStatement(sql2);
                        ps2.setString(1, x.getId_persona());
                        ps2.setString(2, crypto.encrypt(x.getPlaca_vehiculo()));
                        ps2.setInt(3, x.getPropietario());
                        ps2.executeUpdate();
                    } catch (SQLException e) {
                        System.out.println("Algo salio mal al insertar el persona vehiculo " + e.getMessage());
                        insertPersona_vehiculo = false;
                    }
                }
            }
        } catch (SQLException e) {
            System.out.println("Algo salio mal al insertar el vehiculo " + e.getMessage());
            insertVehicle = false;
        }
        return insertVehicle && insertPersona_vehiculo;
    }

    public ArrayList<vehicle> getMyVehicle(String id) {
        ArrayList<vehicle> myvehicles = new ArrayList<>();
        try {
            String sql = "select vehiculo.placa_vehiculo,vehiculo.id_marca,vehiculo.id_tipo,"
                    + "vehiculo.modelo_vehiculo, vehiculo.color_vehiculo,vehiculo.descripcion_vehiculo "
                    + "from vehiculo inner join persona_vehiculo "
                    + "on vehiculo.placa_vehiculo = persona_vehiculo.placa_vehiculo "
                    + "where persona_vehiculo.id_persona = ? and persona_vehiculo.propietario = 1";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, id);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                vehicle aux = new vehicle();
                aux.setPlaca_vehiculo(crypto.decrypt(rs.getString(1)));
                aux.setId_marca(rs.getString(2));
                aux.setId_tipo(rs.getString(3));
                aux.setModelo_vehiculo(rs.getString(4));
                aux.setColor_vehiculo(rs.getString(5));
                aux.setDescripcion_vehiculo(rs.getString(6));
                myvehicles.add(aux);
            }
        } catch (Exception e) {
            System.out.println("Algo salio mal al consultar mis vehiculos " + e.getMessage());
        }
        return myvehicles;
    }

    public ArrayList<persona_vehiculo> getAuthorizedUser(String id) {
        ArrayList<persona_vehiculo> authorizedUser = new ArrayList<>();
        try {
            String sql = "SELECT * FROM PERSONA_VEHICULO WHERE ID_PERSONA = ? AND PROPIETARIO=0";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, id);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                persona_vehiculo aux = new persona_vehiculo();
                aux.setId_persona(rs.getString(1));
                aux.setPlaca_vehiculo(crypto.decrypt(rs.getString(2)));
                aux.setPropietario(rs.getInt(3));
                authorizedUser.add(aux);
            }
        } catch (Exception e) {
            System.out.println("Error al momento de consultar los vehiculos autorizados " + e.getMessage());
        }
        return authorizedUser;
    }

    public ArrayList<String> getAllVehicles() {
        ArrayList<String> placas = new ArrayList<>();
        try {
            String sql = "SELECT PERSONA_VEHICULO.PLACA_VEHICULO FROM PERSONA_VEHICULO";
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                placas.add(crypto.decrypt(rs.getString(1)));
            }
        } catch (SQLException e) {
            System.out.println("Error al consultar las placas registradas " + e.getMessage());
        }
        return placas;
    }

    public ArrayList<persona_vehiculo> getAllAthorized() {
        ArrayList<persona_vehiculo> ids = new ArrayList();

        try {
            String sql = "SELECT * FROM PERSONA_VEHICULO";
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                persona_vehiculo aux = new persona_vehiculo();
                aux.setId_persona(rs.getString(1));
                aux.setPlaca_vehiculo(crypto.decrypt(rs.getString(2)));
                aux.setPropietario(rs.getInt(3));
                ids.add(aux);
            }
        } catch (Exception e) {
            System.out.println("Hubo un error al consultar las personas que autoricé en mi vehiculo " + e.getMessage());
        }
        return ids;
    }

    public boolean updateVehicle(vehicle veh, ArrayList<persona_vehiculo> autorized) {
        boolean update1 = false;
        boolean update2 = false;
        try {
            String sql = "UPDATE VEHICULO SET ID_MARCA = ?, MODELO_VEHICULO=?, COLOR_VEHICULO=?, DESCRIPCION_VEHICULO = ?"
                    + " WHERE PLACA_VEHICULO = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, veh.getId_marca());
            ps.setString(2, veh.getModelo_vehiculo());
            ps.setString(3, veh.getColor_vehiculo());
            ps.setString(4, veh.getDescripcion_vehiculo());
            ps.setString(5, crypto.encrypt(veh.getPlaca_vehiculo()));
            int res1 = ps.executeUpdate();
            if (res1 == 1) {
                update1 = true;
            }
            sql = "DELETE PERSONA_VEHICULO WHERE PLACA_VEHICULO = ? AND PROPIETARIO = 0";
            ps = con.prepareStatement(sql);
            ps.setString(1, crypto.encrypt(veh.getPlaca_vehiculo()));
            ps.executeUpdate();
            int res3 = 0;
            if (autorized.size() > 1) {
                for (persona_vehiculo x : autorized) {
                    String sql2 = "INSERT INTO PERSONA_VEHICULO VALUES (?,?,?)";
                    try {
                        if (x.getPropietario() == 0) {
                            PreparedStatement ps2 = con.prepareStatement(sql2);
                            ps2.setString(1, x.getId_persona());
                            ps2.setString(2, crypto.encrypt(x.getPlaca_vehiculo()));
                            ps2.setInt(3, x.getPropietario());
                            res3 = ps2.executeUpdate();
                        }
                    } catch (SQLException e) {
                        System.out.println("Algo salio mal al insertar nuevamente el persona vehiculo " + e.getMessage());
                        update2 = false;
                    }
                }
            }else{
                res3 = 1;
            }
            if (res3 == 1) {
                update2 = true;
            }

        } catch (Exception e) {
            update1 = false;
            update2 = false;
        }
        return update1 && update2;
    }

    public boolean deleteVehicle(String placa) {
        String sql = "DELETE PERSONA_VEHICULO WHERE PLACA_VEHICULO = ?";
        try{
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, crypto.encrypt(placa));
            ps.executeQuery();
            sql = "DELETE VEHICULO WHERE PLACA_VEHICULO=?";
            ps = con.prepareStatement(sql);
            ps.setString(1, crypto.encrypt(placa));
            ps.executeQuery();
            return true;
                    
        }catch(Exception e){
            System.out.println("Algo salio mal a la hora de eliminar vehiculo " + e.getMessage());
            return false;
        }
    }

}
