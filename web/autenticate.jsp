<%-- 
    Document   : autenticate
    Created on : Nov 2, 2020, 6:44:58 PM
    Author     : Juan
--%>

<%@page import="java.awt.image.BufferedImage"%>
<%@page import="java_class.qrgenerator"%>
<%@page import="java_class.persona_vehiculo"%>
<%@page import="java_class.vehicle"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java_class.marca_vehiculo"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="java_class.person"%>
<%@page import="java_class.database"%>
<jsp:include page="head.jsp" />

<script type="text/javascript" src="${pageContext.request.contextPath}/js/autenticate_page.js"></script>

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
    ArrayList<vehicle> myvehicles = db.getMyVehicle(id);
    ArrayList<persona_vehiculo> authorizedUser = db.getAuthorizedUser(id);
    ArrayList<persona_vehiculo> allPersonAuthorized = db.getAllAthorized();
    ArrayList<String> getAllVehicle = db.getAllVehicles();
    qrgenerator qr = new qrgenerator();
    BufferedImage image = qr.createQR(id);
    if (p1 != null) {
        name = p1.getName();
        last_name = p1.getLastName();
        rol = db.getRol(id);
        db.disconnect();
%>

<nav class="w3-sidebar w3-white w3-collapse w3-large w3-padding-24" style="z-index:0;width:300px;font-weight:bold; background:#4d4d4d;  border-right-color:#4d4d4d" id="mySidebar"><br>
    <a href="javascript:void(0)" onclick="w3_close()" class="w3-button w3-hide-large w3-display-topleft" style="width:100%;font-size:22px">Close Menu</a>
    <div class="w3-bar-block" style="    padding-top: 40px">
        <div class="w3-container w3-padding">
            <p>
                <input readonly value="<%=p1.getName()%>" style="border: 0"/>
                <input readonly value="<%=p1.getLastName()%>" style="border: 0"/>
            </p>
            <p>
                <input readonly value="<%=p1.getId()%>" style="border: 0"/>
            </p>
            <p>
                <input readonly value="<%=rol%>" style="border: 0"/>
            </p> 
        </div>
        <button onclick="generarQR()" class="w3-bar-item w3-button w3-hover-white" style="background: #00482b; color: #ffffff" disabled id="generarPrint">Generar código QR</button>
        <div id="popup" class="overlay">
            <div id="popupBody">
                <div class="popupContent" id="popupContent">
                    <input type="button" value="Imprimir QR" onclick="imprimir()" class="w3-bar-item w3-button w3-hover-white" style="background: #00482b; color: #ffffff" disabled id="print"/>
                </div>
            </div>
        </div>

        <a  onclick="cerrarSesion()" class="w3-bar-item w3-button w3-hover-white" style="background: #00482b ; color: #ffffff">Cerrar sesión</a>
    </div>
</nav>

<header class="w3-container w3-top w3-hide-large w3-xlarge w3-padding" style="background:#4d4d4d">
    <img class="w3-left" src="img/logo-nuevo-70.png">
    <a href="https://www.ucundinamarca.edu.co/" class="w3-right" style="line-height: 50px; font-style:italic; color: #ffffff; font-size: 15px; text-decoration:none">  Ir a UCundinamarca</a>
    <div class="w3-container"
         <a href="javascript:void(0)" class="w3-button w3-margin-right" onclick="w3_open()" style="background:#4d4d4d; color: #ffffff">&#9776;</a>
    </div>
</header>

<div class="w3-overlay w3-hide-large" onclick="w3_close()" style="cursor:pointer" title="close side menu" id="myOverlay"></div>

<!-- !PAGE CONTENT! -->
<div class="w3-main" style="margin-left:340px;margin-right:40px">

    <!-- Header -->
    <div class="w3-container w3-padding-24" style="margin-top:80px" id="showcase">
        <h1 class="w3-jumbo"><b>Hola, Bienvenid@</b></h1>
        <h1 class="w3-xxxlarge" style="color: #00482b"><b>Listado de vehículos</b></h1>
        <hr style="width:50px;border:5px solid; color: #00482b" class="w3-round">
    </div>

    <!-- Listado de usuarios -->
    <div class="w3-container" id="services" style="margin-top:10px; display: inline">


        <div class="w3-row">
            <div class="w3-light-grey w3-container w3-twothird" style="display: table">
                <%if ((myvehicles.size() >= 0) || (authorizedUser.size() > 0)) {%>
                <table class="w3-table w3-striped">
                    <tr>
                        <th></th>
                        <th></th>
                        <th>Placa o N° de registro</th>
                        <th>Tipo</th>
                        <th>Marca</th>
                        <th>Modelo</th>
                        <th>Color</th>
                        <th>Descripción</th>
                    </tr>
                    <%for (vehicle x : myvehicles) {%>
                    <tr>
                        <td onclick="vehiculoSeleccionado(<%=x.getId_tipo()%>, '<%=x.getPlaca_vehiculo()%>', '<%=x.getId_marca()%>', '<%=x.getModelo_vehiculo()%>', '<%=x.getColor_vehiculo()%>', '<%=x.getDescripcion_vehiculo()%>');"><i class="fa fa-edit"></i></td>
                        <td onclick="delete_vehicle"><i class="fa fa-trash-o"></i></td>
                        <td><%=x.getPlaca_vehiculo()%></td>
                        <%Iterator iterator2 = vehicle_type.entrySet().iterator();
                            while (iterator2.hasNext()) {
                                Map.Entry entry = (Map.Entry) iterator2.next();
                                if (entry.getKey().equals(x.getId_tipo())) {%>
                        <td><%=entry.getValue()%></td>
                        <%          }
                            }
                            for (marca_vehiculo marca : marcas) {
                                if (marca.getId_marca().equals(x.getId_marca())) {%>
                        <td><%=marca.getNombre_marca()%></td>
                        <%      }
                            }
                        %>
                        <td><%=x.getModelo_vehiculo()%></td>
                        <td><%=x.getColor_vehiculo()%></td>
                        <td><%=x.getDescripcion_vehiculo()%></td>
                    </tr>
                    <%}%>
                    <%}%>
                    <%for (persona_vehiculo x : authorizedUser) {%>
                    <tr>
                        <td><i class="fa fa-eye"></i></td>
                        <td></td>
                        <td>
                            <%=x.getPlaca_vehiculo()%>
                        </td>
                    </tr>
                    <%}%>
                </table>
            </div>

            <div class="w3-container w3-third" onload="enableforms()">
                <div class="w3-container" style=" background:#00482b; display: flex">
                    <h2 style="color: #ffffff">Vehículo</h2>
                </div>
                <div class="w3-container w3-card-4" >
                    <form id="vehicle_info" action="upload_data.jsp" method="post" >
                        <br>
                        <p>      
                            <label class="w3-text-grey">Tipo</label>
                            <select class="w3-input w3-border" id="tipo" name="tipo" onchange="setType()">
                                <option disabled selected value=""></option>
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
                        </p>
                        <p>      
                            <label class="w3-text-grey">Placa o N° de registro</label>
                            <!--<input type="text">-->
                            <input id="placa" class="w3-input w3-border" type="text" min="4" max="6" name="placa" onfocusout="verifyIfExist()" onkeypress ="return checkinput(document.getElementById('placa'))" readonly="" />

                        </p>
                        <p>      
                            <label class="w3-text-grey">Marca</label>
                            <select class="w3-input w3-border" name="marca" id="marca">
                                <option disabled selected value=""></option>
                            </select>
                        </p>
                        <p>      
                            <label class="w3-text-grey">Modelo</label>
                            <select class="w3-input w3-border" name="modelo" id="modelo">
                                <option selected value=""></option>
                            </select>
                        </p>
                        <p>      
                            <label class="w3-text-grey">Color</label>
                            <select class="w3-input w3-border" name="color" id="color">
                                <option selected value=""></option>
                                <option value="Negro">Negro</option>
                            </select>
                        </p>
                        <p>      
                            <label class="w3-text-grey">Si considera necesario, añada una descipción acerca de su vehículo</label>
                            <textarea id="descripcion" name="descripcion" rows="4" cols="50" placeholder="Ejemplo: Linea: Spark... Tiene un número en el capó" style="width: 100%"></textarea>
                            <input type="hidden" name="all_authorized_users" id="all_authorized_users"/>
                        <div id="content_authorization">
                            <label class="w3-text-grey" name="info_autorizados">Si desea autorizar a terceros para el ingreso y salida de este vehículo, ingrese el número de documento de la persona y de clic en añadir usuario</label>

                            <p id="authorization" class="authorization">   
                                <label class="w3-text-grey">Documento de identidad</label>
                                <input class="w3-input w3-border" id="newID" type="number" onkeydown="search()" />
                            <lablel>Documento</lablel>   
                            <table id="table_user" name="table_user">

                            </table>
                            </p>
                        </div>

                        <div class="w3-btn w3-padding w3-center" style="background:#00482b; padding: 7px 20px!important;" >
                            <i class="fa fa-user-plus" style="color: #ffffff""/></i>
                        <input type="button" onclick="validate_authorization()" style="background:#00482b; color: #ffffff; border: 0; outline: none;" value="Añadir">
                        </div>
                        <p><button type="submit" form="vehicle_info" onclick="return add_vehicle()" class="w3-btn w3-padding w3-center" style="background:#00482b; color: #ffffff"><i class="fa fa-save"></i>&nbsp; Guardar &nbsp; </button></p>
                    </form>
                    <p><button class="w3-btn w3-padding w3-light-gray w3-center" onclick="refrescar();"><i class="fa fa-refresh"></i>&nbsp; Refrescar</button></p>
                </div>
            </div>
        </div>
    </div>


    <!-- End page content -->
</div>    

<%} else {%>
<div class="w3-content" style="min-height: 100%">
    <div class="w3-container w3-padding-24" style="margin-top:80px" id="showcase">
        <h1 class="w3-xxxlarge w3-center" style="color: #00482b"><b>No se encontró al usuario</b></h1>
    </div>
</div>
<%}%>        

<jsp:include page="footer.jsp" />

<script>
    var overlay = document.getElementById("popup");
    var authorized_users = [];
    var printI = document.getElementById("print");
    var generatePrint = document.getElementById("generarPrint");
    generatePrint.disabled = false;
    var placa = document.getElementById("placa");
    placa.setAttribute("readonly", "readonly");
    //document.getElementById("vehicle_info").style.display = "none";
    //document.getElementById("content_authorization").style.display = "none";
    var placa_input = document.getElementById("placa");
    var select = document.getElementById("modelo");
    for (i = 1990; i <= new Date().getFullYear() + 1; i++) {
        var opt = document.createElement('option');
        opt.value = i;
        opt.innerHTML = i;
        select.appendChild(opt);
    }
    function preventBack() {
        window.history.forward();
    }
    setTimeout("preventBack()", 0);
    window.onunload = function () {
        null
    };
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
    function verifyIfExist() {
        var allvehicles = [];
    <%for (String x : getAllVehicle) {
    %>
        allvehicles.push("<%=x%>");
    <%} %>
        console.log(allvehicles);
        for (var i = 0; i < allvehicles.length; i++) {
            if (allvehicles[i] === placa_input.value) {
                alert("El vehículo de placas " + placa_input.value + " ya existe en el sistema");
                placa_input.value = "";
            }
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
                    } else {
                        if ((x > 47 && x < 58)) {
                            return false;
                        } else {
                            return true;
                        }
                    }
                }
            }
        } else {
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
                for (var i = 0; i < authorized_users.length; i++) {
                    if (authorized_users[i].toString() === newID.value.toString()) {
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
                        newCell.innerHTML = newID.value + "  <td><i class='fa fa-trash-o'></i></td>";
                        authorized_users.push(newID.value);
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
        if (placa.value !== "" && tipo.value > '0' && marca.value > '0' && modelo.value !== "" && color.value !== "") {
            validate1 = true;
            var table = document.getElementById("table_user");
            autorizados = authorized_users;
            if (autorizados.length > 0) {
                document.getElementById("all_authorized_users").value = autorizados;
            }
            console.log(document.getElementById("all_authorized_users").value);
        }

        if (validate1) {
            return true;
        } else {
            alert("Faltan campos por completar");
            return false;
        }

    }
    
    function delete_vehicle() {
        
    }
    
    function vehiculoSeleccionado(tipoV, placaV, marcaV, modeloV, colorV, descripcionV) {
        authorized_users = [];
        document.getElementById('vehicle_info').reset();

        document.getElementById("tipo").readOnly = true;
        document.getElementById("placa").readOnly = true;

        document.getElementById("tipo").value = '' + tipoV;
        document.getElementById("placa").value = '' + placaV;
        console.log(marcaV);
        setType();
        document.getElementById("marca").value = '' + marcaV;
        document.getElementById("modelo").value = '' + modeloV;
        document.getElementById("color").value = '' + colorV;
        document.getElementById("descripcion").value = '' + descripcionV;
        //Revisar
        var all_autho = [];
        var showAllAuthoByPlaca = [];
    <%for (persona_vehiculo x : allPersonAuthorized) {%>
        all_autho.push("<%=x.getId_persona()%>" + "-" + "<%=x.getPlaca_vehiculo()%>" + "-" + "<%=x.getPropietario()%>");
    <%
        }%>


        for (var i = 0; i < all_autho.length; i++) {

            var spl = all_autho[i].split("-");
            if (spl[1] === placaV && spl[2] === '0') {
                showAllAuthoByPlaca.push(spl[0]);
                console.log(spl[0]);
            }
        }
        var table = document.getElementById("table_user");
        for(var i = 0; i<table.rows.length;i++){
            table.deleteRow(i);
        }
        if (showAllAuthoByPlaca.length > 0) {
            for (var i = 0; i < showAllAuthoByPlaca.length; i++) {
                var newRow = table.insertRow(-1);
                var newCell = newRow.insertCell(-1);
                newCell.innerHTML = showAllAuthoByPlaca[i] +"  <td><i class='fa fa-trash-o'></i></td>" ;
                authorized_users.push(showAllAuthoByPlaca[i]);
            }
        }
    }
    
    function refrescar() {
        window.open("autenticate.jsp", "_self");
    }

    function generarQR() {
        var myvehicles = false;
        var authorized = false;
        generatePrint.disabled = true;
        printI.disabled = false;
    <%if (myvehicles.size() > 0) {%>
        myvehicles = true;
    <%}%>

    <%if (authorizedUser.size() > 0) {%>
        authorized = true;
    <%}%>

        if (myvehicles || authorized) {
            var image = document.createElement("img");
            image.setAttribute("id", "qrcode");
            image.setAttribute("src", "<%=qr.convertToBase64(image)%>");
            image.setAttribute("width", "300");
            image.setAttribute("height", "300");
            document.getElementById("popupContent").appendChild(image);

            overlay.style.display = "block";

        }
    }
    function imprimir() {
        var image = document.getElementById("qrcode");
        printw = window.open("", "_blank");
        printw.document.write("<html>");
        printw.document.write("<body><img src='");
        printw.document.write(image.src);
        printw.document.write("'/></body></html>");
        printw.document.close();
        printw.print();
        printw.close();

    }
</script>