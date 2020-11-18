<%-- 
    Document   : index
    Created on : 29/09/2020, 12:05:24 PM
    Author     : Juan
--%>
<jsp:include page="head.jsp" />
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
    <div class="w3-content" style="min-height: 100%">
         <div class="w3-container w3-padding-24" style="margin-top:80px" id="showcase">
            <h1 class="w3-xxxlarge w3-center" style="color: #00482b"><b>Bienvenido: Registro para uso del parqueadero</b></h1>
            <hr style="width:50px;border:5px solid; color: #00482b" class="w3-round">
         </div>
        <form class="w3-container w3-card-4" method="post" action="autenticate.jsp">
          <br>
          <p>      
          <label class="w3-text-grey">Ingrese el número de su documento de identidad</label>
          <input class="w3-input w3-border" type="text" name="identificacion" type="number" required>
           <p><button type="submit" class="w3-btn w3-padding" style="background:#00482b; color: #ffffff"><i class="fa fa-check-square-o" value="Ingresar"></i>&nbsp; Ingresar &nbsp; </button></p>
          </p>
        </form>
    </div>

<jsp:include page="footer.jsp" />
