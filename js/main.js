var arrayLine = [];
var storecode = "PapaJohns345"
var list = document.getElementById("line");
var items = document.getElementsByTagName("li");
var buffer = 0;
var top = document.getElementById("top");
var first = 1;
var array = [];
//var aMap = {};
//var standard = 0;
var counter = 0;
var vcontext = 0;
var starttime;




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
 //array.push(event.timeStamp);
 //draw();
 //drawpeople();
 starttime = event.timeStamp;
    arrayLine.push(snapshotValue);
    var li = document.createElement("li");
    var user = firebase.database().ref('users/' + snapshotValue);
    if(user == null)
    {
            li.appendChild(document.createTextNode("+1(" + snapshotValue.substring(0,3) + ") " + snapshotValue.substring(3, 6) + "-" + snapshotValue.substring(6, snapshotValue.length)));
    }
    else
    {
        user.child('name').once("value").then(function(snapshot) {
            var a = document.createElement("h4");
            var b = document.createElement("h5");
            var c = document.createTextNode(snapshot.val());
            var d = document.createTextNode("+1(" + snapshotValue.substring(0,3) + ") " + snapshotValue.substring(3, 6) + "-" + snapshotValue.substring(6, snapshotValue.length));
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
            var d = document.createTextNode("+1(" + snapshotValue.substring(0,3) + ") " + snapshotValue.substring(3, 6) + "-" + snapshotValue.substring(6, snapshotValue.length));
            a.appendChild(c);
            b.appendChild(d);
            lis.appendChild(a);
            lis.appendChild(b);
           // console.log(lis);
            document.getElementById("top").removeChild(items[0]);
            document.getElementById("top").appendChild(lis);
            document.getElementById("name").innerHTML=snapshot.val();
            document.getElementById("phone").innerHTML="+1(" + snapshotValue.substring(0,3) + ") " + snapshotValue.substring(3, 6) + "-" + snapshotValue.substring(6, snapshotValue.length);
            first = 0;
        });
        
    }
    updateNumber();
    
}
function storeInfo(snapshotValue) {
   // console.log(snapshotValue);
    buffer = snapshotValue.buffer;
    document.getElementById("storeName").innerHTML = snapshotValue.name;
    document.getElementById("storeAddress").innerHTML = snapshotValue.location;
    updateNumber();
}
function getTime(){
    var tied = (event.timeStamp-starttime)/counter;
    tied = tied/1000;
    var eta = document.getElementById("timer").innerHTML;
    eta = "ETA: "+tied;
    console.log(tied);
}

function next() {
    counter+=1;
    getTime();
    if(items.length>1)
    {
        list.removeChild(items[1]);
    }
    var ref = firebase.database().ref('lines/' + storecode + '/Users/');
    arrayLine = arrayLine.splice(1, items.length);
    if(items.length > 1)
    {
        var clone = items[1].cloneNode(true);
       // console.log(clone);
        document.getElementById("top").removeChild(items[0]);
        document.getElementById("top").appendChild(clone);
        document.getElementById("name").innerHTML=clone.childNodes[0].innerHTML;
        document.getElementById("phone").innerHTML=clone.childNodes[1].innerHTML;
    }
    else
    {
        var clone = document.createElement("li");
        document.getElementById("top").removeChild(items[0]);
        document.getElementById("top").appendChild(clone);
    }
    
    ref.set(arrayLine);
    updateNumber();
    if(items.length > 1)
    {
        var name = items[1].childNodes[0].innerHTML;
        var number = arrayLine[0];
        console.log(name);
        console.log(number);

        var message = "Dear" + name + ", you are first in line! Please make your way to the register!";
        makeCorsRequest(number, message);
    }
    
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



//////
function drawpeople(){
    var c = document.getElementById("myCanvas2");

var ctx = c.getContext("2d");
ctx.clearRect(0, 0, c.width, c.height);
var context = 500/(array[array.length-1]+1-array[0]);
ctx.fillStyle = "white";
if(items.length-1>vcontext){
    vcontext = (items.length-1);
}
  //  console.log(200/vcontext*(items.length-1));

for(var i = 0; i< items.length-1; i++) {
    ctx.fillStyle = "white";
ctx.beginPath();
for(var j = 0; j < array.length;j++){
ctx.arc(context*(array[j]-array[0]),200-200/vcontext*(items.length-1),15,0,2*Math.PI);
//ctx.moveTo(context*(array[j]-array[0]), 200)
//ctx.lineTo(context*(array[j]-array[0]), 50+15);
ctx.fill();
ctx.stroke();}
}}

function draw(){

      var c = document.getElementById("myCanvas");
      c.set
      
var ctx = c.getContext("2d");
ctx.clearRect(0, 0, c.width, c.height);
var context = 500/(array[array.length-1]+1-array[0]);
ctx.fillStyle = "white";
//console.log(array.length);
for(var i = 0; i< array.length; i++) {
 //   console.log(context*(array[i]-array[0]));
    ctx.fillStyle = "white";
ctx.beginPath();
ctx.arc(context*(array[i]-array[0]),50,15,0,2*Math.PI);
ctx.moveTo(context*(array[i]-array[0]), 200)
ctx.lineTo(context*(array[i]-array[0]), 50+15);
ctx.fill();
ctx.stroke();


}
  }
init(); 
