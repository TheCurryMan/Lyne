
function line() {
    
    var name = document.getElementById("name").value;

    var location = document.getElementById("location").value;

    var eta = document.getElementById("orders").value;

    var deviation = document.getElementById("deviation").value;

    var lines = document.getElementById("lines").value;
    var buffer = document.getElementById("buffer").value;

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
    window.name = code;
    console.log("asdf");
    window.location.href="http://avinashj.com/Lyne/main.html";
    
    // xhr.open("POST","https://shielded-reef-48843.herokuapp.com/", true);
    // xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
    // xhr.send("?title=you are 3rd in line");

}
