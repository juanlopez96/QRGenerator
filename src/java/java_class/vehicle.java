/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package java_class;

/**
 *
 * @author Juan
 */
public class vehicle {
    String placa_vehiculo;
    String id_marca;
    String id_tipo;
    String modelo_vehiculo;
    String color_vehiculo;
    String descripcion_vehiculo;
    
    public vehicle(){
        placa_vehiculo = id_marca = id_tipo = modelo_vehiculo = color_vehiculo = descripcion_vehiculo = "";
    }

    public vehicle(String placa_vehiculo, String id_marca, String id_tipo, String modelo_vehiculo, String color_vehiculo, String descripcion_vehiculo) {
        this.placa_vehiculo = placa_vehiculo;
        this.id_marca = id_marca;
        this.id_tipo = id_tipo;
        this.modelo_vehiculo = modelo_vehiculo;
        this.color_vehiculo = color_vehiculo;
        this.descripcion_vehiculo = descripcion_vehiculo;
    }
    

    public String getPlaca_vehiculo() {
        return placa_vehiculo;
    }

    public void setPlaca_vehiculo(String placa_vehiculo) {
        this.placa_vehiculo = placa_vehiculo;
    }

    public String getId_marca() {
        return id_marca;
    }

    public void setId_marca(String id_marca) {
        this.id_marca = id_marca;
    }

    public String getId_tipo() {
        return id_tipo;
    }

    public void setId_tipo(String id_tipo) {
        this.id_tipo = id_tipo;
    }

    public String getModelo_vehiculo() {
        return modelo_vehiculo;
    }

    public void setModelo_vehiculo(String modelo_vehiculo) {
        this.modelo_vehiculo = modelo_vehiculo;
    }

    public String getColor_vehiculo() {
        return color_vehiculo;
    }

    public void setColor_vehiculo(String color_vehiculo) {
        this.color_vehiculo = color_vehiculo;
    }

    public String getDescripcion_vehiculo() {
        return descripcion_vehiculo;
    }

    public void setDescripcion_vehiculo(String descripcion_vehiculo) {
        this.descripcion_vehiculo = descripcion_vehiculo;
    }
    
}
