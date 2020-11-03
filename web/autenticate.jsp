<%-- 
    Document   : autenticate
    Created on : Nov 2, 2020, 6:44:58 PM
    Author     : Juan
--%>

<%@page import="java_class.person"%>
<%@page import="java_class.database"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <h1>Hello World!</h1>
        <% 
            database db = new database();
            String id = request.getParameter("identificacion");
            String name = "";
            String last_name = "";
            person p1 = db.getPerson(id);
            if(p1!=null){
                name = p1.getName();
                last_name = p1.getLastName();
                %>Bienvenido <%=name%> <%=last_name%>
                <%
            }
            else{
                %>No se encontro el usuario<%
            }
        %>
        
    </body>
</html>
