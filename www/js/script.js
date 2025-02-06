document.addEventListener("DOMContentLoaded", function() {
    function checkScreenSize() {
        if (window.innerWidth < 1024) {  // Adjust threshold as needed (1024px is common for tablets)
            document.getElementById("app-content").style.display = "none";
            document.getElementById("mobile-warning").style.display = "block";
        } else {
            document.getElementById("app-content").style.display = "block";
            document.getElementById("mobile-warning").style.display = "none";
        }
    }

    checkScreenSize();
    window.addEventListener("resize", checkScreenSize);
});
