
function line() {
    
    var xhr = new XMLHttpRequest();
    
    var name = document.getElementById("name").value;

    var location = document.getElementById("location").value;

    var eta = document.getElementById("orders").value,10;

    var deviation = document.getElementById("deviation").value,10;

    var lines = document.getElementById("lines").value,10;

    var buffer = document.getElementById("buffer").value,10;

    var code = document.getElementById("code").value;
    
    console.log("code");

    var count = 0;

    var ref = firebase.database().ref("lines");
    ref.child(code).set({
        name: name,
        deviation: deviation,
        location: location,
        eta: eta/lines,
        buffer: buffer,
        count: count,
        codename: code
    });
    sessionStorage.setItem("storecode", code);
    
    window.location.href="main.html";
    
    // xhr.open("POST","https://shielded-reef-48843.herokuapp.com/", true);
    // xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
    // xhr.send("?title=you are 3rd in line");

}
