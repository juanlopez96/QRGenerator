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
        <script type="text/javascript" src="${pageContext.request.contextPath}/js/autenticate_page.js"></script>
        <script rel="stylesheet" src="${pageContext.request.contextPath}/css/style.css"></script>
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
            ArrayList<String> ids = db.id_person();
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
        <p><button onclick="enableforms()">Registrar vehículo</button></p>
        <form id="vehicle_info" >
            <div>
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
                <label>Placa:</label>
                <input id="placa" type="text" min="4" max="6" name="placa" onkeypress ="return checkinput(document.getElementById('placa'))" readonly=""/>
                
                <label>Marca:</label>
                <select name="marca" id="marca">
                    <option disabled selected></option>
                </select>
                <label>Modelo:</label>
                <select name="modelo" id="modelo">
                    <option disabled selected></option>

                </select>
                <label>Color:</label>
                <select name="color" id="color">
                    <option disabled selected></option>
                    <option value="Negro">Negro</option>
                </select>
                <!-- lista de vehiculos ingresados -->
            </div>

        </form>
        <div id="content_authorization">
            <textarea name="info_autorizados" rows="4" cols="50">Si desea autorizar a terceros para el ingreso y salida de este vehículo, ingrese el número de documento de la persona y de clic en añadir usuario</textarea>

            <div id="authorization" class="authorization">
                <label>Documento de identidad:</label>
                <input id="newID" type="number" onkeydown="search()" required/>

                <table id="table_user">
                    <tr>
                        <th>Documento</th>
                    </tr>
                </table>

            </div>
            <p><button onclick="validate_authorization()">Añadir usuario</button></p>
            <p><button onclick="add_vehicle()">Añadir vehiculo</button></p>
        </div>        
        <%
        } else {
        %>No se encontro el usuario<%
            }
        %>

    </body>
</html>

<script>
    var placa = document.getElementById("placa");
    placa.setAttribute("readonly", "readonly");
    document.getElementById("vehicle_info").style.display = "none";
    document.getElementById("content_authorization").style.display = "none";
    var placa_input = document.getElementById("placa");
    var select = document.getElementById("modelo");
    for (i = 1990; i <= new Date().getFullYear() + 1; i++) {
        var opt = document.createElement('option');
        opt.value = i;
        opt.innerHTML = i;
        select.appendChild(opt);
    }
    function setType() {
        placa.removeAttribute("readonly");
        type = document.getElementById("tipo").value;

        var select = document.getElementById('marca');
        for (i = select.length - 1; i >= 0; i--) {
            select.remove(i);
        }
        var first_opt = document.createElement('option');
        first_opt.value = "";
        first_opt.innerHTML = "";
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
            if (spl[0] === type) {
                var opt = document.createElement('option');
                opt.value = spl[1];
                opt.innerHTML = spl[2];
                select.appendChild(opt);
            }
        });

    }
    function search() {
        if (event.key === 'Enter') {
            validate_authorization();
        }

    }
    placa_input.onkeyup = function () {
        this.value = this.value.toUpperCase();

    };
    placa_input.onkeypress = function (e) {

        var placa_input_lenght = document.getElementById("placa").value.length;
        var x = e.which || e.keycode;
        if (placa_input_lenght < 6) {
            if (placa_input_lenght < 3) {
                if ((x > 64 && x < 91) || (x > 96 && x < 123)) {
                    return true;
                } else {
                    return false;
                }
            } else {
                if (document.getElementById("tipo").value !== '1') {
                    if (placa_input_lenght >= 3 && placa_input_lenght < 6) {
                        if ((x > 47 && x < 58)) {
                            return true;
                        } else {
                            return false;
                        }
                    }
                } else {
                    if (placa_input_lenght >= 3 && placa_input_lenght < 5) {
                        if ((x > 47 && x < 58)) {
                            return true;
                        } else {
                            return false;
                        }
                    }
                    else{
                        if ((x > 47 && x < 58)) {
                            return false;
                        } else {
                            return true;
                        }
                    }
                }
            }
        }else{
            return false;
        }
    };

    function validate_authorization() {
        var newID = document.getElementById("newID");
        var table = document.getElementById("table_user");
        var users = [];
        if (newID.value.length !== 0) {
            console.log(newID.value);
    <%for (String user : ids) {%>
            users.push("<%=user%>");
    <%
        }%>
            if (newID.value !== "<%=id%>") {

                var exist = false;
                var exist2 = false;
                users.forEach(element => {
                    if (element === newID.value.toString()) {
                        exist = true;
                    }
                });
                for (var i = 0, row; row = table.rows[i]; i++) {
                    if (table.rows[i].cells[0].innerHTML.toString() === newID.value.toString()) {
                        exist2 = true;
                    }
                }
                if (!exist) {
                    /**/
                    alert("El usuario ingresado no hace parte de la Universidad de Cundinamarca");

                } else {
                    if (!exist2) {
                        console.log("Agregar");

                        var newRow = table.insertRow(-1);
                        var newCell = newRow.insertCell(-1);
                        newCell.innerHTML = newID.value;
                        newID.value = "";
                    } else {
                        alert("El usuario ya se encuentra añadido a la lista");
                    }
                }
            } else {
                alert("No puede añadirse a si mismo como autorizado");
            }
        }

    }
    function add_vehicle() {
        var placa = document.getElementById("placa");
        var tipo = document.getElementById("tipo");
        var marca = document.getElementById("marca");
        var modelo = document.getElementById("modelo");
        var color = document.getElementById("color");
        var autorizados = [];
        var validate1 = false;
        
    }


</script>