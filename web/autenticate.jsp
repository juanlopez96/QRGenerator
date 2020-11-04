<%-- 
    Document   : autenticate
    Created on : Nov 2, 2020, 6:44:58 PM
    Author     : Juan
--%>

<%@page import="java.util.ArrayList"%>
<%@page import="java_class.marca_vehiculo"%>
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
            db.connect();
            if (request.getParameter("identificacion") != null) {
                session.setAttribute("id", request.getParameter("identificacion"));
            }
            String id = (String) session.getAttribute("id");
            String name = "";
            String last_name = "";
            String rol = "";
            person p1 = db.getPerson(id);
            Map vehicle_type = db.getType();
            ArrayList<marca_vehiculo> marcas = db.getMarca();

            if (p1 != null) {
                name = p1.getName();
                last_name = p1.getLastName();
                rol = db.getRol(id);
                db.disconnect();
        %>

        <label>Documento de identidad:</label>
        <input readonly value="<%=p1.getId()%>"/>
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
                <input type="text" min="4" max="6" name="placa"/>
                <label>Tipo:</label>
                <select id="tipo" name="tipo" onchange="setType()">
                    <option disabled selected></option>
                    <%
                        Iterator iterator = vehicle_type.entrySet().iterator();
                        while (iterator.hasNext()) {
                            Map.Entry entry = (Map.Entry) iterator.next();
                            if (entry.getKey().equals(request.getParameter("type"))) {%>
                    <option value="<%=entry.getKey()%>" selected><%=entry.getValue()%></option>
                    <%} else {%>
                    <option value="<%=entry.getKey()%>"><%=entry.getValue()%></option>
                    <%}

                        }
                    %>
                </select>
                <label>Marca:</label>
                <select name="marca" id="marca">
                    <option disabled selected></option>
                </select>
            </div>
        </form>
        <%
        } else {
        %>No se encontro el usuario<%
            }
        %>

    </body>
</html>

<script>

    function setType() {
    type = document.getElementById("tipo").value;
    
    var select = document.getElementById('marca');
    for(i = select.length-1; i>=0; i--){
        select.remove(i);
    }
    var first_opt = document.createElement('option');
    first_opt.value="";
    first_opt.innerHTML="";
    first_opt.selected = true;
    first_opt.disabled = true;
    select.appendChild(first_opt);
    var dict = [];
    //location.href = "autenticate.jsp?type=" + opt;
    <%for (marca_vehiculo marca : marcas) {%>
    dict.push(<%=marca.getId_tipo()%> + "-" +<%=marca.getId_marca()%> + "-" + "<%=marca.getNombre_marca()%>");
    <%
        }%>
    dict.forEach(element => {
        var spl = element.split("-");
        if(spl[0] === type){
            var opt = document.createElement('option');
            opt.value = spl[1];
            opt.innerHTML = spl[2];
            select.appendChild(opt);
        }
    });
    
    }
</script>