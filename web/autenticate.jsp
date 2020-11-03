<%-- 
    Document   : autenticate
    Created on : Nov 2, 2020, 6:44:58 PM
    Author     : Juan
--%>

<%@page import="java.util.Iterator"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="java_class.person"%>
<%@page import="java_class.database"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Registro</title>
    </head>
    <body>
        <h1>Universidad de Cundinamarca</h1>
        <% 
            database db = new database();
            String id = request.getParameter("identificacion");
            String name = "";
            String last_name = "";
            String rol = "";
            person p1 = db.getPerson(id);
            Map vehicle_type = db.getType();
            if(p1!=null){
                name = p1.getName();
                last_name = p1.getLastName();
                rol = db.getRol(id);
                %>
                <label>Documento de identidad:</label>
                <input readonly value="<%=p1.getId() %>"/>
                <label>Nombre:</label>
                <input readonly value="<%=p1.getName()%>"/>
                <label>Apellido:</label>
                <input readonly value="<%=p1.getLastName()%>"/>
                <label>Rol:</label>
                <input readonly value="<%=rol%>"/>
                <br>
                <p><button>Registrar vehículo</button></p>
                <form>
                    <div>
                        <label>Placa:</label>
                        <input type="text" min="4" max="6"/>
                        <label>Tipo:</label>
                        <select>
                            <%
                                Iterator iterator = vehicle_type.entrySet().iterator();
                                while(iterator.hasNext()){
                                    Map.Entry entry = (Map.Entry)iterator.next();%>
                                    <option value="<%=entry.getKey()%>"><%=entry.getValue()%></option>
                                <%} 
                            %>
                        </select>
                    </div>
                </form>
                <%
            }
            else{
                %>No se encontro el usuario<%
            }
        %>
        
    </body>
</html>
