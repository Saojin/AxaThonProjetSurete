'use strict';

var config = require('./config');
var os = require("os");
var http = require('http');

// call the packages we need
var express    = require('express');        // call express
var app        = express();                 // define our app using express
var bodyParser = require('body-parser');
var cors = require('cors');

// configure app to use bodyParser()
// this will let us get the data from a POST
app.use(bodyParser.text({ extended: true }));
app.use(bodyParser.json());
app.use(cors());

var server = http.createServer(app);
var io = require('socket.io').listen(server);

var port = process.env.PORT || config.app.port;        // set our port

// ROUTES FOR OUR API
// =============================================================================
var router = express.Router();              // get an instance of the express Router

// API
require('./api/signalements')(router, io);
require('./api/signalements-positions')(router);
require('./api/utilisateurs')(router);

// test route to make sure everything is working (accessed at GET http://localhost:8080/api)
app.get('/', function(_, res) {
  res.json({ message: 'API is up! :)' });
});

// sockets

// REGISTER OUR ROUTES -------------------------------
// all of our routes will be prefixed with /api
app.use('/api', router);

// START THE SERVER
// =============================================================================
server.listen(port);
console.log('Server started on: http://' + os.hostname().toLowerCase() + ':' + port);