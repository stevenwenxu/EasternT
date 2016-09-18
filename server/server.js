var http = require('http')
var url = require('url')
var ws = require('ws')

var server = http.createServer();
    server.listen(5366, function () {
    console.log((new Date()) + ' Server is listening on port 5366');
});

var wss = new ws.Server({
    server: server
});

wss.on('connection', function (ws) {
    ws.on('message', function incoming(message) {
        console.log(message);
        wss.clients.forEach(function (ws) {
            ws.send(message);
        });
    });
    ws.send("Hello Hack the North");
});
