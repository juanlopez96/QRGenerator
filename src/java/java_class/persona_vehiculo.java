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
public class persona_vehiculo {
    String id_persona;
    String placa_vehiculo;
    int propietario;
    public persona_vehiculo(){
        id_persona = placa_vehiculo = "";
        propietario = 0;
    }
    public persona_vehiculo(String id_persona, String placa_vehiculo, int propietario){
        this.id_persona = id_persona;
        this.placa_vehiculo = placa_vehiculo;
        this.propietario = propietario;
    }

    public String getId_persona() {
        return id_persona;
    }

    public void setId_persona(String id_persona) {
        this.id_persona = id_persona;
    }

    public String getPlaca_vehiculo() {
        return placa_vehiculo;
    }

    public void setPlaca_vehiculo(String placa_vehiculo) {
        this.placa_vehiculo = placa_vehiculo;
    }

    public int getPropietario() {
        return propietario;
    }

    public void setPropietario(int propietario) {
        this.propietario = propietario;
    }
    
}
