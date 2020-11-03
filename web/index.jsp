<%-- 
    Document   : index
    Created on : 29/09/2020, 12:05:24 PM
    Author     : Juan
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>QR Generator</title>
    </head>
    <body>
        <h2>Registro para uso del parqueadero</h2>
        <form method="post" action="autenticate.jsp">
            <label>Número de identificación</label>
            <input name="identificacion" type="number"/>
            <input type ="submit" value="Ingresar"/>
        </form>
        
    </body>
</html>
