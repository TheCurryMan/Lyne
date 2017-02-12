var arrayLine = [];
var storecode = "PapaJohns345"
var list = document.getElementById("line");
var items = document.getElementsByTagName("li");
var buffer = 0;
var top = document.getElementById("top");
var first = 1;


function updateNumber()
{

    firebase.database().ref('lines/'+ storecode + '/count').set(items.length - 1);
    
    document.getElementById("num").innerHTML = items.length - 1;
    if(items.length - 1 < 2)
    {
        document.getElementById("numText").innerHTML = "Person In Line";
    }
    else
    {
        document.getElementById("numText").innerHTML = "People In Line";
    }
    /*for(var i = 0; i < items.length && i < buffer; i++)
    {
        console.log(i);
        //items[i].setAttribute("id", "buff");
        items[i].setAttribute("id", "buff");
    }*/
    if(items.length>1)
    {
        items[1].setAttribute("id", "first");
    }
   

}


function addToList(snapshotValue) {
    arrayLine.push(snapshotValue);
    var li = document.createElement("li");
    var user = firebase.database().ref('users/' + snapshotValue);
    if(user == null)
    {
            li.appendChild(document.createTextNode(" " + snapshotValue));
    }
    else
    {
        user.child('name').once("value").then(function(snapshot) {
            var a = document.createElement("h4");
            var b = document.createElement("h5");
            var c = document.createTextNode(snapshot.val());
            var d = document.createTextNode(snapshotValue);
            a.appendChild(c);
            b.appendChild(d);
            li.appendChild(a);
            li.appendChild(b);
        });
            
    }
    list.appendChild(li);
    if(first == 1 )
    {
        user.child('name').once("value").then(function(snapshot) {
            var lis = document.createElement("li");
            var a = document.createElement("h4");
            var b = document.createElement("h5");
            var c = document.createTextNode(snapshot.val());
            var d = document.createTextNode(snapshotValue);
            a.appendChild(c);
            b.appendChild(d);
            lis.appendChild(a);
            lis.appendChild(b);
            console.log(lis);
            document.getElementById("top").removeChild(items[0]);
            document.getElementById("top").appendChild(lis);
            first = 0;
        });
        
    }
    updateNumber();
    
}
function storeInfo(snapshotValue) {
    console.log(snapshotValue);
    buffer = snapshotValue.buffer;
    document.getElementById("storeName").innerHTML = snapshotValue.name;
    document.getElementById("storeAddress").innerHTML = snapshotValue.location;
    updateNumber();
}

function next() {
    if(items.length>1)
    {
        list.removeChild(items[1]);
    }
    var ref = firebase.database().ref('lines/' + storecode + '/Users/');
    arrayLine = arrayLine.splice(1, items.length);
    if(items.length > 1)
    {
        var clone = items[1].cloneNode(true);
        console.log(clone);
        document.getElementById("top").removeChild(items[0]);
        document.getElementById("top").appendChild(clone);
    }
    else
    {
        var clone = document.createElement("li");
        document.getElementById("top").removeChild(items[0]);
        document.getElementById("top").appendChild(clone);
    }
    
    ref.set(arrayLine);
    updateNumber()
    var number = arrayLine[0];
    var name = firebase.database().ref('users/' + number).child(name);
    var eta = firebase.database().ref('lines/' + storecode).child(eta);
    var message = "Dear" + name + ", you are first in line! Please arrive within the next" + eta + "minutes!"; 
    console.log(number);
    console.log(message);
    makeCorsRequest(number,message);
}
function init() {
    var config = {
        apiKey: "AIzaSyC3OuzXgf_xkhCsvo1saTPzILk6Xi0v1_k",
        authDomain: "lyne.firebaseapp.com",
        databaseURL: "https://lyne.firebaseio.com",
        storageBucket: "project-4313846950357733166.appspot.com",
        messagingSenderId: "912183264441"
    };
    firebase.initializeApp(config);
    var storeRef = firebase.database().ref().child("lines/" + storecode);
    storeRef.once("value").then(function(snapshot) {
        storeInfo(snapshot.val());
    });
    var ref = firebase.database().ref().child("lines/" + storecode + "/Users");
    ref.on('child_added', function(childSnapshot) {
        addToList(childSnapshot.val());
    });
    
    //document.getElementById("num").innerHTML = document.getElementsByTagName("li").length;
}
init();