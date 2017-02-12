
function line() {

    var name = document.getElementById("name").value;

    var location = document.getElementById("location").value;

    var eta = document.getElementById("orders").value;

    // var buffer = document.getElementById("buffer").value;

    var code = document.getElementById("code").value;
    
    console.log("code");

    var count = 0;
    
    var buffer = count;

    var ref = firebase.database().ref("lines");
    ref.child(code).set({
        name: name,
        location: location,
        eta: eta,
        buffer: buffer,
        count: count,
        codename: code
    });
    
    window.location.href="https://lyne-thecurryman.c9users.io/Web/test.html";

}
