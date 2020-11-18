<!-- W3.CSS Container -->
<div class="w3-container w3-padding" style="margin-top:75px;padding-right:58px; background:#4d4d4d; color: #ffffff; position: absolute; width: 100%">
  <a href="https://www.ucundinamarca.edu.co/"><p class="w3-right">wwww.ucundinamarca.edu.co</p></a>
</div>
<script>
    // Script to open and close sidebar
    function w3_open() {
        document.getElementById("mySidebar").style.display = "block";
        document.getElementById("myOverlay").style.display = "block";
    }

    function w3_close() {
        document.getElementById("mySidebar").style.display = "none";
        document.getElementById("myOverlay").style.display = "none";
    }

    function cerrarSesion() {
        w3_close();
        history.forward();
        window.location = "./logout.jsp";
    }

</script>
</body>
</html>
