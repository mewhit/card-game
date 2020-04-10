
'use strict';

const express = require('express');
const socketIO = require('socket.io');

const PORT = process.env.PORT || 3000;
const INDEX = '/index.html';

const server = express()
  .use(express.static("public"))
  .use((req, res) => res.sendFile(INDEX, { root: __dirname }))
  .listen(PORT, () => console.log(`Listening on ${PORT}`));

const io = socketIO(server);

io.on('connection', (socket) => {
  console.log('Client connected');


  socket.on('game', function (data) {
    console.log("emit the updated game", data)
    io.emit("update game", data)
  });

  io.in('game').clients((err, clients) => {
    console.log(clients); 
  });
  
  socket.on('disconnect', function () {
    io.emit('user disconnected');
  });
});



setInterval(() => io.emit('time', new Date().toTimeString()), 1000);