var width;
var height;
var pad = 20;
var context;
var length;
var array;
var items = document.getElementsByTagName("li");
var vertScale;
var speed = 10;
var rafID = null;


function init(){
    array = new Array();
    var canvas = document.getElementById("myCanvas");
    context = canvas.getContext("2d");
    context.strokeStyle = "#f2f2f2";
    context.fillStyle = "#f2f2f2";
    width = canvas.width - 2 * pad;
    height = canvas.height - 2 * pad;
    length = width/speed;
    draw();
    setInterval(draw, 10000)
}

function draw(time){
    array.push(items.length - 1);
    if(array.length > length)
    {
        array = array.splice(1, array.length);
    }
    var max = 0;
    for(i = 0; i < array.length; i++)
    {
        if(array[i] > max)
        {
            max = array[i];
        }
    }
    vertScale = (height-pad)/max;
    //console.log(vertScale);
    context.clearRect(0, 0, width + 2 * pad, height + 2 * pad);
    //console.log(width + " " + height);
    drawAxis();
    drawGraph();
    //context.fillRect(pad,pad,200, 200);
    //console.log(array);
}

function drawAxis(){
    context.lineWidth = 2;
    context.beginPath();
    context.moveTo(pad, pad);
    context.lineTo(pad, pad + height);
    context.lineTo(pad + width, pad + height);
    context.stroke();
}

function drawGraph(){
    context.lineWidth = 4;
    context.moveTo(pad, pad + height - array[array.length - 1] * vertScale);
    for(i = array.length - 2; i >= 0; i--)
    {
        context.lineTo(pad + (array.length - i - 1) * speed, pad + height - array[i] * vertScale);
    }
    context.stroke();
}

init();