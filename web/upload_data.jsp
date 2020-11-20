<%-- 
    Document   : upload_data
    Created on : Nov 14, 2020, 9:50:52 PM
    Author     : Juan
--%>

<%@page import="java.util.List"%>
<%@page import="java.util.Arrays"%>
<%@page import="java.sql.Array"%>
<%@page import="java_class.database"%>
<%@page import="java_class.vehicle"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java_class.persona_vehiculo"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <%
            String id = (String) session.getAttribute("id");
            String placa = request.getParameter("placa");
            String marca = request.getParameter("marca");
            String tipo = request.getParameter("tipo");
            String modelo = request.getParameter("modelo");
            String color = request.getParameter("color");
            String descripcion = request.getParameter("descripcion");
            if (descripcion.isEmpty()) {
                descripcion = "Ninguna";
            }
            ArrayList<persona_vehiculo> authorized = new ArrayList();
            authorized.add(new persona_vehiculo(id, placa, 1));
            String[] autho = (request.getParameterValues("all_authorized_users"));
            String[] spl_autho = autho[0].split(",");
            List<String> auhorized_person = new ArrayList(Arrays.asList(spl_autho));
            auhorized_person.removeAll(Arrays.asList("", null));
            System.out.println(autho.length);

            for (String x : auhorized_person) {
                System.out.println(x);
                authorized.add(new persona_vehiculo(x, placa, 0));
            }

            vehicle veh = new vehicle(placa, marca, tipo, modelo, color, descripcion);
            database db = new database();
            db.connect();
            if (db.insertVehicle(veh, authorized)) {
        %> <script>alert("Se ha añadido un vehículo correctamente");</script><%
            out.println("<meta http-equiv='refresh' content='0;URL=autenticate.jsp'>");
        } else {
        %> <script>alert("Ha ocurrido un error");</script><%
            out.println("<meta http-equiv='refresh' content='0;URL=autenticate.jsp'>");
     }
     db.disconnect();
        %>

    </body>
</html>
